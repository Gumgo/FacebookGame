package level
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inventory.InventoryState;
	import level.enemies.Enemy;
	import level.enemies.LevelGenerator;
	import level.enemies.Wave;
	import level.Player;
	import level.Item;
	import org.flixel.data.FlxFade;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import flash.display.MovieClip;

	public class LevelState extends FlxState 
	{
		
		private var player:Player;
		private var healthBar:HealthBar;
		private var levelText:LevelText;
		private var levelGenerator:LevelGenerator;
		private var itemGenerator:ItemGenerator;

		private var enemyGroup:FlxGroup;
		private var enemyBulletGroup:FlxGroup;
		private var bulletGroup:FlxGroup;
		private var itemGroup:FlxGroup;
		private var overlayGroup:FlxGroup;

		private var endTimer:int;
		private var fade:FlxFade;

		private var background:MovieClip;

		private var effectsSprite:FlxSprite;

		private var scrollText:FlxText;
		private var scrollTextX:Number;
		private var startPhase:int;
		private var startTimer:int;

		private var seenElements:Vector.<int>;
		private var collectedElements:Vector.<int>;
		private var endPhase:int;
		private var completeText:FlxText;
		private var completeList1:FlxText;
		private var completeList2:FlxText;
		private var elemCounter:int;

		override public function create():void
		{
			FlxG.mouse.hide();
			var bgNum:int = Math.floor(Math.random() * Resources.BACKGROUND_COUNT) + 1;
			//TODO: Finish other moving backgrounds
			//var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "AnimMove");
			var BackgroundDef:Class = Context.getResources().getSprite("background2AnimMove");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;

			enemyGroup = new FlxGroup();
			enemyBulletGroup = new FlxGroup();
			bulletGroup = new FlxGroup();
			itemGroup = new FlxGroup();
			overlayGroup = new FlxGroup();

			effectsSprite = new FlxSprite(0, 0, null);
			effectsSprite.pixels = new BitmapData(FlxG.width, FlxG.height, true, 0);

			seenElements = new Vector.<int>();
			collectedElements = new Vector.<int>();

			startLevel();
		}

		override public function update():void
		{
			var px:BitmapData = effectsSprite.pixels;
			px.colorTransform(effectsSprite.pixels.rect, new ColorTransform(0, 0, 0, 0));
			effectsSprite.pixels = px;

			if (startPhase < 0) {
				levelGenerator.update();
			}
			super.update();

			if (!player.dead) {
				FlxU.overlap(player, enemyGroup, playerEnemyOverlap);
				FlxU.overlap(player, enemyBulletGroup, playerEnemyOverlap);
				function playerEnemyOverlap(player:FlxObject, enemy:FlxObject):void
				{
					(player as Player).onHit(enemy as Enemy);
					(enemy as Enemy).onHitPlayer();
				}
			}

			FlxU.overlap(player, itemGroup, playerItemOverlap);
			function playerItemOverlap(player:FlxObject, item:FlxObject):void
			{
				(item as Item).collect();
			}

			FlxU.overlap(enemyGroup, bulletGroup, enemyBulletOverlap);
			function enemyBulletOverlap(enemy:FlxObject, bullet:FlxObject):void
			{
				(enemy as Enemy).onHit(bullet as PlayerBullet);
			}

			if (endPhase == 0) {
				if (endTimer > 0) {
					--endTimer;
				} else {
					for (var e:int = 0; e < seenElements.length; ++e) {
						Context.getPersistentState().setElementState(seenElements[e], PersistentState.ELEM_ENCOUNTERED);
					}
					for (var c:int = 0; c < collectedElements.length; ++c) {
						Context.getPersistentState().setElementState(collectedElements[c], PersistentState.ELEM_COLLECTED);
					}

					endPhase = 1;
					completeText.text = "New Elements Collected:";
					completeText.size = 20;
					if (collectedElements.length == 0) {
						endTimer = 60;
						completeText.y = FlxG.height * 0.25;
						completeList1 = new FlxText(FlxG.width * 0.25, completeText.y + completeText.height + 48, FlxG.width * 0.5);
						completeList1.alignment = "center";
						completeList1.size = 16;
					} else {
						endTimer = 30;
						elemCounter = 0;
						var measure:String;
						var totalHeight:int;
						if (collectedElements.length <= 15) {
							measure = "";
							for (var j:int = 0; j < collectedElements.length - 1; ++j) {
								measure += "\n";
							}
							completeList1 = new FlxText(FlxG.width * 0.25, 0, FlxG.width * 0.5, measure);
							completeList1.alignment = "center";
							completeList1.size = 16;
							totalHeight = completeText.height + 8 + completeList1.height;
							completeText.y = FlxG.height * 0.5 - totalHeight * 0.5;
							completeList1.y = completeText.y + completeText.height + 8;
							completeList1.text = "";
						} else {
							measure = "";
							for (var t:int = 0; t < Math.floor((collectedElements.length + 1) / 2.0) - 1; ++t) {
								measure += "\n";
							}
							completeList1 = new FlxText(0, 0, FlxG.width * 0.5 - 16, measure);
							completeList1.alignment = "right";
							completeList1.size = 16;
							completeList2 = new FlxText(FlxG.width * 0.5 + 16, 0, FlxG.width * 0.5 - 16);
							completeList2.size = 16;
							totalHeight = completeText.height + 8 + completeList1.height;
							completeText.y = FlxG.height * 0.5 - totalHeight * 0.5;
							completeList1.y = completeText.y + completeText.height + 8;
							completeList2.y = completeList1.y;
							completeList1.text = "";
							defaultGroup.add(completeList2);
						}
					}
					defaultGroup.add(completeList1);
				}
			} else if (endPhase == 1) {
				if (endTimer > 0) {
					--endTimer;
				} else {
					if (collectedElements.length == 0) {
						completeList1.text = "None\n\nBetter luck next time!";
						endPhase = 10;
						endTimer = 120;
					} else if (elemCounter == collectedElements.length) {
						endPhase = 10;
						endTimer = 120;
						// CHANGE THIS TO REPORT STATS
					} else {
						// PLAY SOUND HERE
						if (collectedElements.length <= 15) {
							completeList1.text += Context.getGameData().getElementDefinition(collectedElements[elemCounter]).getName() + " (" + collectedElements[elemCounter] + ")\n";
						} else {
							if (elemCounter < collectedElements.length / 2) {
								completeList1.text += Context.getGameData().getElementDefinition(collectedElements[elemCounter]).getName() + " (" + collectedElements[elemCounter] + ")\n";
							} else {
								completeList2.text += Context.getGameData().getElementDefinition(collectedElements[elemCounter]).getName() + " (" + collectedElements[elemCounter] + ")\n";
							}
						}
						++elemCounter;
						endTimer = 10;
					}
				}
			} else if (endPhase == 10) {
				if (endTimer > 0) {
					--endTimer;
				} else if (endTimer == 0) {
					endPhase = 11;
					fade = new FlxFade();
					defaultGroup.add(fade);
					fade.start(0xFF000000, 1, function():void
					{
						parent.removeChild(background);
						FlxG.state = new InventoryState();
					});
				}
			}

			const SQUASH_SCALE:Number = 1.3;
			if (startPhase == 0) {
				if (startTimer > 0) {
					--startTimer;
				} else {
					startPhase = 1;
					scrollText = new FlxText(0, 0, 192, "READY");
					scrollText.size = 32;
					scrollText.alignment = "center";
					scrollText.scale.x = SQUASH_SCALE;
					scrollText.scale.y = 1.0 / SQUASH_SCALE;
					scrollTextX = -128;
					scrollText.x = scrollTextX - scrollText.width * 0.5;
					scrollText.y = FlxG.height * 0.5 - scrollText.height * scrollText.scale.y * 0.5;
					defaultGroup.add(scrollText);
				}
			} else if (startPhase == 1) {
				scrollTextX += 16;
				if (scrollTextX >= FlxG.width * 0.5) {
					scrollTextX = FlxG.width * 0.5;
					startPhase = 2;
					startTimer = 30;
					scrollText.scale.x = 1;
					scrollText.scale.y = 1;
				}
				scrollText.x = scrollTextX - scrollText.width * 0.5;
				scrollText.y = FlxG.height * 0.5 - scrollText.height * scrollText.scale.y * 0.5;
			} else if (startPhase == 2) {
				if (startTimer > 0) {
					--startTimer;
				} else {
					startPhase = 3;
					scrollText.scale.x = SQUASH_SCALE;
					scrollText.scale.y = 1.0 / SQUASH_SCALE;
					scrollText.x += 16;
					scrollText.x = scrollTextX - scrollText.width * 0.5;
					scrollText.y = FlxG.height * 0.5 - scrollText.height * scrollText.scale.y * 0.5;
				}
			} else if (startPhase == 3) {
				scrollTextX += 16;
				if (scrollTextX >= FlxG.width + 128) {
					startPhase = -1;
					defaultGroup.remove(scrollText);
					levelGenerator.start();
				}
				scrollText.x = scrollTextX - scrollText.width * 0.5;
				scrollText.y = FlxG.height * 0.5 - scrollText.height * scrollText.scale.y * 0.5;
			}
		}

		override public function render():void
		{
			effectsSprite.pixels = effectsSprite.pixels;
			super.render();
		}

		public function startLevel():void
		{
			player = new Player();
			healthBar = new HealthBar();
			levelText = new LevelText();

			defaultGroup.add(itemGroup);
			defaultGroup.add(enemyGroup);
			defaultGroup.add(enemyBulletGroup);
			defaultGroup.add(player);
			defaultGroup.add(bulletGroup);
			defaultGroup.add(effectsSprite);
			defaultGroup.add(overlayGroup);

			overlayGroup.add(healthBar);
			overlayGroup.add(levelText);

			var fadeIn:FlxFadeIn = new FlxFadeIn();
			fadeIn.start(0xFF000000, 0.5);
			defaultGroup.add(fadeIn);

			levelGenerator = new LevelGenerator(0);
			itemGenerator = new ItemGenerator();

			endTimer = -1;
			endPhase = -1;

			startPhase = 0;
			startTimer = 60;
		}

		public function levelFinished():void
		{
			if (!player.dead) {
				completeText = new FlxText(0, FlxG.height / 2, FlxG.width, "Level\nComplete!");
				completeText.size = 48;
				completeText.alignment = "center";
				completeText.y -= completeText.height / 2;
				overlayGroup.add(completeText);
				endTimer = 60 * 2;
				endPhase = 0;
			}
		}

		public function levelFailed():void
		{
			var failText:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, "Level\nFailed!");
			failText.size = 48;
			failText.alignment = "center";
			failText.y -= failText.height / 2;
			overlayGroup.add(failText);
			endTimer = 60 * 2;
			endPhase = 10;
		}

		public function getEnemyGroup():FlxGroup
		{
			return enemyGroup;
		}

		public function getEnemyBulletGroup():FlxGroup
		{
			return enemyBulletGroup;
		}

		public function getBulletGroup():FlxGroup
		{
			return bulletGroup;
		}

		public function getItemGroup():FlxGroup
		{
			return itemGroup;
		}

		public function getOverlayGroup():FlxGroup
		{
			return overlayGroup;
		}

		public function getPlayer():Player
		{
			return player;
		}

		public function getHealthBar():HealthBar
		{
			return healthBar;
		}

		public function getLevelText():LevelText
		{
			return levelText;
		}

		public function getEffects():BitmapData
		{
			return effectsSprite.pixels;
		}

		public function getItemGenerator():ItemGenerator
		{
			return itemGenerator;
		}

		public function seeElement(number:int):void
		{
			if (seenElements.indexOf(number, 0) < 0) {
				seenElements.push(number);
			}
		}

		public function collectElement(number:int):void
		{
			if (collectedElements.indexOf(number, 0) < 0) {
				collectedElements.push(number);
			}
		}

	}

}