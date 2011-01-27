package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Jennifer Yang
	 */
	public class ZigZagBehavior extends Behavior 
	{
		
		private var direction: int = 0;
		public function ZigZagBehavior(properties:Dictionary) 
		{
			super(properties);
		}
		

		override public function init(enemy:Enemy):void
		{
			enemy.y = -32;
			enemy.x = Number(getProperty("offset"));
		}

		override public function update(enemy:Enemy):void
		{
			if ( direction % 2 == 0 ) {
				zigRight();
				direction++;
			} else {
				zigLeft();
				direction++;
			}
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
		
		private function zigRight(enemy:Enemy) {
			enemy.x += 12;
			enemy.y += 12;

		}
		
		private function zigLeft(enemy:Enemy) {
			enemy.x -= 12;
			enemy.y += 12;	
		}
		
		
	}

}