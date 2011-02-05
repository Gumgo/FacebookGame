package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class SlowLineBehavior extends Behavior 
	{

		public function SlowLineBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):SlowLineBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.y = -32;
			enemy.x = Number(getProperty("offset"));
		}

		override public function update(enemy:Enemy):void
		{
			enemy.y += 5;

			if (Math.random() < 0.02) {
				var dict:Dictionary = new Dictionary();
				dict["x"] = String(enemy.x + enemy.width / 2);
				dict["y"] = String(enemy.y + enemy.height);
				(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
					null,
					Context.getGameData().getEnemyDefinition("BulletEnemy"),
					(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
			}
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}