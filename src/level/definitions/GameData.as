package level.definitions 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import level.behaviors.*;
	import level.enemies.Enemy;
	import level.enemies.Wave;

	public class GameData
	{
		private var enemiesMap:Dictionary;
		private var fleetsMap:Dictionary;
		private var wavesMap:Dictionary;
		private var levels:Vector.<LevelDefinition>;

		private var elements:Vector.<ElementDefinition>;

		private var callback:Function;
		private var loaded:int;
		private static const filesToLoad:int = 5;

		// dummy variables: these must be here for each behavior
		private var lineDummy:LineBehavior;
		private var zigZagDummy:ZigZagBehavior;
		private var magneticDummy:MagneticBehavior;
		private var randomDummy:RandomBehavior;

		private var linearDummy:LinearBehavior;
		private var dipFireDummy:DipFireBehavior;
		private var bombDummy:BombBehavior;
		private var topSeekerDummy:TopSeekerBehavior;
		private var avoidDummy:AvoidBehavior;
		private var moveDartDummy:MoveDartBehavior;

		public function GameData()
		{
			enemiesMap = new Dictionary();
			fleetsMap = new Dictionary();
			wavesMap = new Dictionary();
			levels = new Vector.<LevelDefinition>();
			elements = new Vector.<ElementDefinition>();
			loaded = 0;
		}

		private function testCallback():void
		{
			++loaded;
			if (loaded == filesToLoad) {
				callback();
			}
		}

		public function load(callback:Function):void
		{
			this.callback = callback;

			var enemiesLoader:URLLoader = new URLLoader();
			enemiesLoader.addEventListener(Event.COMPLETE, processEnemies);
			enemiesLoader.load(new URLRequest("resources/enemies.xml"));
			function processEnemies(e:Event):void
			{
				var xml:XML = new XML(e.target.data);

				var xmlEnemies:XMLList = xml.children();
				for each (var xmlEnemy:XML in xmlEnemies) {
					if (xmlEnemy.name() != "enemy") {
						throw new Error("Unknown property " + xmlEnemy.name());
					}

					var name:String = xmlEnemy.attribute("name").toString();
					var sprite:String = xmlEnemy.attribute("sprite").toString();
					var deathSprite:String = xmlEnemy.attribute("deathSprite").toString();
					var deathSound:String = xmlEnemy.attribute("deathSound").toString();
					var health:int = int(xmlEnemy.attribute("health").toString());
					var color:uint = uint(xmlEnemy.attribute("color").toString());
					var deathColor:uint = uint(xmlEnemy.attribute("deathColor").toString());
					var damage:int = int(xmlEnemy.attribute("damage").toString());
					var deathOnPlayerCollision:Boolean = xmlEnemy.attribute("deathOnPlayerCollision").toString() == "true" ? true : false;
					var invincible:Boolean = xmlEnemy.attribute("invincible").toString() == "true" ? true : false;

					var newEnemy:EnemyDefinition = new EnemyDefinition(
						name,
						sprite,
						deathSprite,
						deathSound,
						health,
						color,
						deathColor,
						damage,
						deathOnPlayerCollision,
						invincible);
					enemiesMap[name] = newEnemy;
				}

				testCallback();
			}

			var fleetsLoader:URLLoader = new URLLoader();
			fleetsLoader.addEventListener(Event.COMPLETE, processFleets);
			fleetsLoader.load(new URLRequest("resources/fleets.xml"));
			function processFleets(e:Event):void
			{
				var xml:XML = new XML(e.target.data);

				var xmlFleets:XMLList = xml.children();
				for each (var xmlFleet:XML in xmlFleets) {
					if (xmlFleet.name() != "fleet") {
						throw new Error("Unknown property " + xmlFleet.name());
					}

					var name:String = xmlFleet.attribute("name").toString();

					var newFleet:FleetDefinition = new FleetDefinition(name);

					var xmlEnemies:XMLList = xmlFleet.children();
					for each (var xmlEnemy:XML in xmlEnemies) {
						if (xmlEnemy.name() != "enemy") {
							throw new Error("Unknown property " + xmlEnemy.name());
						}

						var enemy:String = xmlEnemy.attribute("name").toString();
						var behavior:String = xmlEnemy.attribute("behavior").toString();
						var time:int = int(xmlEnemy.attribute("time").toString());

						var index:int = newFleet.addEnemy(enemy, behavior, time);

						var xmlProperties:XMLList = xmlEnemy.children();
						for each (var xmlProperty:XML in xmlProperties) {
							if (xmlProperty.name() != "behaviorProperty") {
								throw new Error("Unknown property " + xmlProperty.name());
							}

							var key:String = xmlProperty.attribute("name").toString();
							var value:String = xmlProperty.attribute("value").toString();

							newFleet.addBehaviorProperty(index, key, value);
						}
					}

					fleetsMap[name] = newFleet;
				}

				testCallback();
			}

			var wavesLoader:URLLoader = new URLLoader();
			wavesLoader.addEventListener(Event.COMPLETE, processWaves);
			wavesLoader.load(new URLRequest("resources/waves.xml"));
			function processWaves(e:Event):void
			{
				var xml:XML = new XML(e.target.data);

				var xmlWaves:XMLList = xml.children();
				for each (var xmlWave:XML in xmlWaves) {
					if (xmlWave.name() != "wave") {
						throw new Error("Unknown property " + xmlWave.name());
					}

					var name:String = xmlWave.attribute("name").toString();

					var newWave:WaveDefinition = new WaveDefinition(name);

					var xmlFleets:XMLList = xmlWave.children();
					for each (var xmlFleet:XML in xmlFleets) {
						if (xmlFleet.name() != "fleet") {
							throw new Error("Unknown property " + xmlFleet.name());
						}

						var fleet:String = xmlFleet.attribute("name").toString();
						var time:int = int(xmlFleet.attribute("time").toString());

						newWave.addFleet(fleet, time);
					}

					wavesMap[name] = newWave;
				}

				testCallback();
			}

			var levelsLoader:URLLoader = new URLLoader();
			levelsLoader.addEventListener(Event.COMPLETE, processLevels);
			levelsLoader.load(new URLRequest("resources/levels.xml"));
			function processLevels(e:Event):void
			{
				var xml:XML = new XML(e.target.data);

				var xmlLevels:XMLList = xml.children();
				for each (var xmlLevel:XML in xmlLevels) {
					if (xmlLevel.name() != "level") {
						throw new Error("Unknown property " + xmlLevel.name());
					}

					var waveCount:int = int(xmlLevel.attribute("waveCount").toString());
					var xmlWave:XML;
					var wave:String;

					var xmlFirstHalf:XML = xmlLevel.firstHalf[0];
					var miniBoss:String = xmlFirstHalf.attribute("miniBoss").toString();
					var xmlFirstHalfWaves:XMLList = xmlFirstHalf.children();
					var firstHalfWaves:Vector.<String> = new Vector.<String>();
					for each (xmlWave in xmlFirstHalfWaves) {
						if (xmlWave.name() != "wave") {
							throw new Error("Unknown property " + xmlWave.name());
						}

						wave = xmlWave.attribute("name").toString();
						firstHalfWaves.push(wave);
					}

					var xmlSecondHalf:XML = xmlLevel.secondHalf[0];
					var boss:String = xmlSecondHalf.attribute("boss").toString();
					var xmlSecondHalfWaves:XMLList = xmlSecondHalf.children();
					var secondHalfWaves:Vector.<String> = new Vector.<String>();
					for each (xmlWave in xmlSecondHalfWaves) {
						if (xmlWave.name() != "wave") {
							throw new Error("Unknown property " + xmlWave.name());
						}

						wave = xmlWave.attribute("name").toString();
						secondHalfWaves.push(wave);
					}

					var newLevel:LevelDefinition = new LevelDefinition(waveCount, firstHalfWaves, miniBoss, secondHalfWaves, boss);
					levels.push(newLevel);
				}

				testCallback();
			}

			var elementsLoader:URLLoader = new URLLoader();
			elementsLoader.addEventListener(Event.COMPLETE, processElements);
			elementsLoader.load(new URLRequest("resources/elements.xml"));
			function processElements(e:Event):void
			{
				var xml:XML = new XML(e.target.data);

				var xmlElements:XMLList = xml.children();
				for each (var xmlElement:XML in xmlElements) {
					if (xmlElement.name() != "element") {
						throw new Error("Unknown property " + xmlElement.name());
					}

					var number:int = elements.length + 1;
					var symbol:String = xmlElement.attribute("symbol").toString();
					var name:String = xmlElement.attribute("name").toString();
					var group:String = xmlElement.attribute("group").toString();
					var sprite:String = xmlElement.attribute("sprite").toString();
					var color:uint = uint(xmlElement.attribute("color").toString());
					var description:String = xmlElement.attribute("description").toString();

					var newElement:ElementDefinition = new ElementDefinition(number, symbol, name, group, sprite, color, description);
					elements.push(newElement);
				}

				testCallback();
			}

		}

		public function getEnemyDefinition(name:String):EnemyDefinition
		{
			var ret:EnemyDefinition = enemiesMap[name];
			if (ret == null) {
				trace("Invalid enemy " + name);
			}
			return ret;
		}

		public function getFleetDefinition(name:String):FleetDefinition
		{
			var ret:FleetDefinition = fleetsMap[name];
			if (ret == null) {
				trace("Invalid fleet " + name);
			}
			return ret;
		}

		public function getWaveDefinition(name:String):WaveDefinition
		{
			var ret:WaveDefinition = wavesMap[name];
			if (ret == null) {
				trace("Invalid wave " + name);
			}
			return ret;
		}

		public function getLevelDefinition(level:int):LevelDefinition
		{
			if (level < 0 || level >= levels.length) {
				trace("Invalid level " + level);
			}
			return levels[level];
		}

		public function getElementDefinition(number:int):ElementDefinition
		{
			if (number < 1 || number >= elements.length+1) {
				trace("Invalid element " + number);
			}
			return elements[number-1];
		}

	}
}