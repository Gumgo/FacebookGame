package level
{
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

		private var enemyGroup:FlxGroup;
		private var bulletGroup:FlxGroup;
		private var itemGroup:FlxGroup;
		private var overlayGroup:FlxGroup;

		private var fadeTimer:int;
		private var fade:FlxFade;

		private var background:MovieClip;

		override public function create():void
		{
			var bgNum:int = Math.floor(Math.random() * 2.0) + 1;
			var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "Anim");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;

			enemyGroup = new FlxGroup();
			bulletGroup = new FlxGroup();
			itemGroup = new FlxGroup();
			overlayGroup = new FlxGroup();

			startLevel();
		}

		override public function update():void
		{
			levelGenerator.update();
			super.update();

			if (!player.dead) {
				FlxU.overlap(player, enemyGroup, playerEnemyOverlap);
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

			if (fadeTimer > 0) {
				--fadeTimer;
			} else if (fadeTimer == 0) {
				fade = new FlxFade();
				defaultGroup.add(fade);
				fade.start(0xFF000000, 1, goToInventory);
				fadeTimer = -1;
				function goToInventory():void
				{
					parent.removeChild(background);
					FlxG.state = new InventoryState();
				}
			}
		}

		public function startLevel():void
		{
			player = new Player();
			healthBar = new HealthBar();
			levelText = new LevelText();

			defaultGroup.add(itemGroup);
			defaultGroup.add(enemyGroup);
			defaultGroup.add(player);
			defaultGroup.add(bulletGroup);
			defaultGroup.add(overlayGroup);

			overlayGroup.add(healthBar);
			overlayGroup.add(levelText);

			levelGenerator = new LevelGenerator(0);
			levelGenerator.start();

			fadeTimer = -1;
		}

		public function levelFinished():void
		{
			if (!player.dead) {
				var completeText:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, "Level\nComplete!");
				completeText.size = 48;
				completeText.alignment = "center";
				completeText.y -= completeText.height / 2;
				overlayGroup.add(completeText);
				fadeTimer = 60 * 2;
			}
		}

		public function levelFailed():void
		{
			var failText:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, "Level\nFailed!");
			failText.size = 48;
			failText.alignment = "center";
			failText.y -= failText.height / 2;
			overlayGroup.add(failText);
			fadeTimer = 60 * 2;
		}

		public function getEnemyGroup():FlxGroup
		{
			return enemyGroup;
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

	}

}