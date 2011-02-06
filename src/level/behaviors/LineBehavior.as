package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class LineBehavior extends Behavior 
	{

		private var speed:Number;

		public function LineBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):LineBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.y = -enemy.height;
			enemy.x = Number(getProperty("offset")) - enemy.width * 0.5;
			if (getProperty("speed") == null) {
				speed = 5;
			} else {
				speed = Number(getProperty("speed"));
			}
		}

		override public function update(enemy:Enemy):void
		{
			
			enemy.y += speed;

			if (Math.random() < 0.02) {
				var dict:Dictionary = new Dictionary();
				dict["x"] = String(enemy.x + enemy.width / 2);
				dict["y"] = String(enemy.y + enemy.height);
				dict["speed"] = String(speed + 2);
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
