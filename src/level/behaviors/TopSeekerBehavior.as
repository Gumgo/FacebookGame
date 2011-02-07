package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;

	public class TopSeekerBehavior extends Behavior 
	{

		private var phase:int;
		private var shotTimer:int;

		public function TopSeekerBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):TopSeekerBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			phase = 0;
			enemy.x = Math.random() * (FlxG.width - enemy.width);
			enemy.y = -enemy.height;
			shotTimer = 0;
		}

		override public function update(enemy:Enemy):void
		{
			if (phase == 0) {
				enemy.y = MathExt.lerp(enemy.y, 16, 0.1);
				if (Math.abs(enemy.y - 16) < 0.25) {
					enemy.y = 16;
					phase = 1;
				}
			} else {
				var player:Player = (FlxG.state as LevelState).getPlayer();
				enemy.x = MathExt.lerp(enemy.x + enemy.width * 0.5, player.x + player.width * 0.5, 0.05) - enemy.width * 0.5;
				if (Math.abs(enemy.x + enemy.width * 0.5 - player.x - player.width * 0.5) < 12) {
					if (shotTimer == 0) {
						shotTimer = 10;
						var dict:Dictionary = new Dictionary();
						dict["x"] = String(enemy.x + enemy.width / 2);
						dict["y"] = String(enemy.y + enemy.height / 2);
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("BulletEnemy"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
				}
				if (shotTimer > 0) {
					--shotTimer;
				}
			}
		}
	}

}