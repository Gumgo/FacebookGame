package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class LoopBehavior extends Behavior 
	{

		private var bullet:String;
		private var mirror:Boolean;
		private var dir:Number;
		private var shoot:int;
		private var shootTimer:int;
		private var dropMine:Boolean;

		public function LoopBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):LoopBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			bullet = getProperty("bullet");
			if (getProperty("mine") != null) {
				dropMine = getProperty("mine") == "true" ? true : false;
			}

			shoot = -1;
			dir = 5;

			var side:String = getProperty("side");
			if (side == "left") {
				mirror = false;
			} else if (side == "right") {
				mirror = true;
			} else {
				mirror = Math.random() < 0.5;
			}

			enemy.x = -enemy.width * 0.5;
			enemy.y = Number(getProperty("y"));

			if (mirror) {
				enemy.x = FlxG.width - enemy.x;
			}

			enemy.x -= enemy.width * 0.5;
			enemy.y -= enemy.height * 0.5;
		}

		override public function update(enemy:Enemy):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.health * 0.5;
			if (mirror) {
				xCtr = FlxG.width - xCtr;
			}

			xCtr += Math.cos(dir * Math.PI / 180.0) * 10;
			yCtr += Math.sin(dir * Math.PI / 180.0) * 10;

			var dirDiff:Number = (xCtr / FlxG.width) * 1.5;
			dirDiff *= dirDiff;
			dirDiff *= dirDiff;
			dirDiff *= dirDiff;
			dir -= dirDiff;
			enemy.angle = dir + 90;

			if (mirror) {
				xCtr = FlxG.width - xCtr;
				enemy.angle = -enemy.angle;
			}
			enemy.x = xCtr - enemy.width * 0.5;
			enemy.y = yCtr - enemy.health * 0.5;

			var player:Player = (FlxG.state as LevelState).getPlayer();
			if (shoot == -1 && Math.abs(enemy.x + enemy.width * 0.5 - player.x - player.width) < 80) {
				shoot = 3;
				shootTimer = 0;
			}
			if (shoot > 0) {
				if (shootTimer == 0) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2);
					dict["y"] = String(enemy.y + enemy.height);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition(bullet),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					shootTimer = 10;
					--shoot;
				} else {
					--shootTimer;
				}
			}

			if (dropMine && xCtr >= FlxG.width * 0.1 && xCtr < FlxG.width * 0.9) {
				if (Math.random() < 0.002) {
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width * 0.5);
					dict["y"] = String(enemy.y + enemy.height * 0.5);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_mine"),
						(Context.getRecycler().getNew(MineBehavior) as MineBehavior).resetMe(dict), false, false);
					dropMine = false;
				}
			}

			if (!enemy.onScreen()) {
				enemy.enemyFinished();
			}

		}
		
		

	}

}
