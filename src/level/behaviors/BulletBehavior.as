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
		
		public function BulletBehavior(properties:Dictionary)
		{
			super(properties);
		}

		override public function init(enemy:Enemy):void
		{
			enemy.x = Number(getProperty("x"));
			enemy.y = Number(getProperty("y"));
			enemy.x -= enemy.width / 2;
			enemy.y -= enemy.height / 2;
		}

		override public function update(enemy:Enemy):void
		{
			enemy.y += 20;
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}

	}

}