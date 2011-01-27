package level.behaviors 
{
	import flash.display.TriangleCulling;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import org.flixel.FlxU;	
	/**
	 * ...
	 * @author Jennifer Yang
	 */
	
	
	public class RandomBehavior extends Behavior
	{
		private var generateNewDirection:Number = 0;
		private var randomX:Number = FlxU.random() * 10;
		private var randomY:Number = FlxU.random() * 10;


		public function RandomBehavior(properties:Dictionary) 
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
			//Get a random number between 0 and 10
		
			
			if ( generateNewDirection < 10 ) {
				enemy.x += randomX;
				enemy.y += randomY;
				generateNewDirection++;
			} else {
				// generate new x and y directions
				randomY = FlxU.random() * 10;
				randomX = FlxU.random() * 10;
				randomX = FlxU.ceil(randomX);
				randomY = FlxU.ceil(randomY);
				var randomPosNegXDirection:Number = FlxU.random() * 10;
				if (randomPosNegXDirection >= 5) {
					randomX *= -1;
				}
				generateNewDirection = 0;
			}
			
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}