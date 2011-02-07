package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	public class DipFireBehavior extends Behavior 
	{

		private var targetY:Number;
		private var speed:Number;
		private var phase:int;
		private var shotTimer:int;
		private var shotsFired:int;

		public function DipFireBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):DipFireBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			// speed ranging from 0 to 1
			speed = Number(getProperty("speed"));
			targetY = Math.random() * FlxG.height * 0.25 - enemy.height * 0.5 + FlxG.height * 0.125;
			var player:Player = (FlxG.state as LevelState).getPlayer();
			enemy.x = player.x + player.width * 0.5 - enemy.width * 0.5 - 8 + Math.random() * 16.0;
			enemy.y = -enemy.height;

			phase = 0;
		}

		override public function update(enemy:Enemy):void
		{
			if (phase == 0) {
				enemy.y = MathExt.lerp(enemy.y, targetY, speed);
				if (Math.abs(enemy.y - targetY) < 1.0) {
					enemy.y = targetY;
					phase = 1;
					shotTimer = 0;
					shotsFired = 0;
				}
			} else if (phase == 1) {
				if (shotTimer == 0) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2);
					dict["y"] = String(enemy.y + enemy.height);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("BulletEnemy"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					shotTimer = 5;
					++shotsFired;
				} else {
					--shotTimer;
				}
				if (shotsFired == 3) {
					phase = 2;
					targetY = 1.0;
				}
			} else if (phase == 2) {
				enemy.y -= targetY;
				targetY += 1.0;
				if (!enemy.onScreen()) {
					enemy.enemyFinished();
				}
			}
		}
	}

}