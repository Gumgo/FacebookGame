package level.behaviors 
{
	import level.enemies.Behavior;
	import flash.utils.Dictionary;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class BulletBehavior extends Behavior 
	{

		private var xInc:Number;
		private var yInc:Number;
		private var speed:Number;

		public function BulletBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):BulletBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.x = Number(getProperty("x"));
			enemy.y = Number(getProperty("y"));
			enemy.x -= enemy.width * 0.5;
			enemy.y -= enemy.height * 0.5;

			if (getProperty("speed") == null) {
				speed = 6;
			} else {
				speed = Number(getProperty("speed"));
			}
			if (getProperty("dir") == null) {
				xInc = 0;
				yInc = speed;
			} else {
				var direction:Number = Number(getProperty("dir"));
				xInc = Math.cos(direction * Math.PI / 180.0) * speed;
				yInc = -Math.sin(direction * Math.PI / 180.0) * speed;
			}
		}

		override public function update(enemy:Enemy):void
		{
			enemy.y += yInc;
			enemy.x += xInc;
			if (!enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}

	}

}