package level.definitions 
{
	import flash.utils.Dictionary;

	public class FleetDefinition
	{

		private var name:String;
		private var enemies:Vector.<String>;
		private var behaviors:Vector.<String>;
		private var behaviorProperties:Vector.<Dictionary>
		private var times:Vector.<int>;

		public function FleetDefinition(name:String)
		{
			this.name = name;
			enemies = new Vector.<String>();
			behaviors = new Vector.<String>();
			behaviorProperties = new Vector.<Dictionary>();
			times = new Vector.<int>();
		}

		/**
		 * Returns the index of the enemy which is used to attach behavior properties.
		 */
		public function addEnemy(enemy:String, behavior:String, time:int):int
		{
			enemies.push(enemy);
			behaviors.push(behavior);
			behaviorProperties.push(new Dictionary());
			times.push(time);
			return enemies.length - 1;
		}

		public function addBehaviorProperty(enemyIndex:int, key:String, value:String):void
		{
			behaviorProperties[enemyIndex][key] = value;
		}

		public function getName():String
		{
			return name;
		}
		
		public function getEnemies():Vector.<String>
		{
			return enemies;
		}

		public function getBehaviors():Vector.<String>
		{
			return behaviors;
		}

		public function getBehaviorProperties():Vector.<Dictionary>
		{
			return behaviorProperties;
		}

		public function getTimes():Vector.<int>
		{
			return times;
		}
	}

}