package level.behaviors 
{
	import level.enemies.Behavior;
	import flash.display.TriangleCulling;
	import flash.utils.Dictionary;
	import level.enemies.Enemy;
	import level.LevelState;
	import org.flixel.FlxU;	
	import org.flixel.FlxG;
	import level.LevelState;
	
	/**
	 * ...
	 * @author Jennifer Yang
	 */
	public class MagneticBehavior extends Behavior
	{

		public function MagneticBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):MagneticBehavior
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
			
			var playerX:Number = (FlxG.state as LevelState).getPlayer().x;
			var playerY:Number = (FlxG.state as LevelState).getPlayer().y;
			
			
			var xDiff:Number = playerX - enemy.x;
			var yDiff:Number = playerY - enemy.y;
			
			var distance:Number = Math.sqrt( (Math.pow(xDiff, 2) + Math.pow(yDiff, 2)));
			
			// If distance > 20 enemy += 12
			// Else within radius and become attracted to player
			if (distance > 150 ) {
				enemy.y += 5;
			} else {
				var xDivide:Number;
				var yDivide:Number;
				if ( distance <=150 && distance > 50 ) {
					xDivide = 20;
					yDivide = 20
				} else if ( distance <= 50 && distance > 20) {
					xDivide = 20;
					yDivide = 15;
				} else {
					xDivide = 15;
					yDivide = 15;
				}
				var yDir:Number = FlxU.ceil(yDiff / xDivide);
				var xDir:Number = FlxU.ceil(xDiff / yDivide);
				enemy.y += yDir;
				enemy.x += xDir;
			}
			
			
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}