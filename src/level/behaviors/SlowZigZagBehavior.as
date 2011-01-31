package level.behaviors 
{
	import flash.display.TriangleCulling;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Jennifer Yang
	 */
	public class SlowZigZagBehavior extends Behavior 
	{
		
		private var direction: int = 0;
		public function SlowZigZagBehavior(properties:Dictionary) 
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
			if ( direction <= 20 ) {
				zigRight(enemy);
				direction++;
			} else if ( direction > 20 && direction <= 40) {
				zigLeft(enemy);
				direction++;
			} else {
				direction = 0;
			}
			if (enemy.y > 0 && enemy.y > FlxG.height) {
				enemy.enemyFinished();
			}
		}
		
		
		// move to diagonally right
		private function zigRight(enemy:Enemy): void {
			enemy.x += 5;
			enemy.y += 5;

		}
		
		// move to diagonally left
		private function zigLeft(enemy:Enemy): void {
			enemy.x -= 5;
			enemy.y += 5;	
		}
		
		
	}

}