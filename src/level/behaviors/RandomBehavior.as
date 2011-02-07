package level.behaviors 
{
	import flash.display.TriangleCulling;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import org.flixel.FlxU;	
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Jennifer Yang
	 */
	
	
	public class RandomBehavior extends Behavior
	{
		private var generateNewDirection:Number = 0;
		private var randomX:Number = FlxU.random() * 10;
		private var randomY:Number = FlxU.random() * 10;
		public function RandomBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):RandomBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}
		
		override public function init(enemy:Enemy):void
		{
			enemy.y = -enemy.height;
			enemy.x = Number(getProperty("offset")) + enemy.width * 0.5;
		}

		override public function update(enemy:Enemy):void
		{
			//Get a random number between 0 and 10
			
				if (generateNewDirection < 20) {
					enemy.x += randomX;
					enemy.y += randomY;
					generateNewDirection++;
				} else {
					// generate new x and y directions
					randomY = FlxU.random() * 10;
					randomX = FlxU.random() * 10;
					randomX = FlxU.floor(randomX) + 1;
					randomY = FlxU.floor(randomY) + 1;
					if (Math.random() < 0.5) {
						randomX *= -1;
					}
					generateNewDirection = 0;
				}
		 
			
			
			if (enemy.y > 0 && enemy.y > FlxG.height) {
				enemy.enemyFinished();
			}
		}
	}

}