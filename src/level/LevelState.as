package level
{
	import level.enemies.Enemy;
	import level.enemies.LevelGenerator;
	import level.enemies.Wave;
	import level.Player;
	import level.Item;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxU;

	public class LevelState extends FlxState 
	{
		
		private var player:Player;
		private var healthBar:HealthBar;
		private var levelText:LevelText;
		private var levelGenerator:LevelGenerator;

		private var enemyGroup:FlxGroup;
		private var bulletGroup:FlxGroup;
		private var itemGroup:FlxGroup;

		override public function create():void
		{
			enemyGroup = new FlxGroup();
			bulletGroup = new FlxGroup();
			itemGroup = new FlxGroup();
			startLevel();
		}

		override public function update():void
		{
			levelGenerator.update();
			super.update();

			FlxU.overlap(player, enemyGroup, playerEnemyOverlap);
			function playerEnemyOverlap(player:FlxObject, enemy:FlxObject):void
			{
				(player as Player).onHit(enemy as Enemy);
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
		}

		public function startLevel():void
		{
			player = new Player();
			healthBar = new HealthBar();
			levelText = new LevelText();
			defaultGroup.add(player);
			defaultGroup.add(healthBar);
			defaultGroup.add(levelText);
			levelGenerator = new LevelGenerator(0);
			levelGenerator.start();
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