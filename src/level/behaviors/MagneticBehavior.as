package level.behaviors 
{
	import level.enemies.Behavior;
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
			enemy.y = -enemy.height;
			enemy.x = Number(getProperty("offset")) + enemy.width * 0.5;
		}

		override public function update(enemy:Enemy):void
		{
			var playerX:Number = (FlxG.state as LevelState).getPlayer().x;
			var playerY:Number = (FlxG.state as LevelState).getPlayer().y;


			var xDiff:Number = playerX - enemy.x;
			var yDiff:Number = playerY - enemy.y;

			var distanceSqr:Number = xDiff * xDiff + yDiff * yDiff;

			// If distance > 150 enemy += 5
			// Else within radius and become attracted to player
			if (distanceSqr > 150*150) {
				enemy.y += 5;
			} else {
				var xDivide:Number;
				var yDivide:Number;
				if (distanceSqr <= 150*150 && distanceSqr > 50*50) {
					xDivide = 20;
					yDivide = 20;
				} else if (distanceSqr <= 50*50 && distanceSqr > 20*20) {
					xDivide = 20;
					yDivide = 15;
				} else {
					xDivide = 15;
					yDivide = 15;
				}
				var yDir:Number = Math.ceil(yDiff / xDivide);
				var xDir:Number = Math.ceil(xDiff / yDivide);
				enemy.y += yDir;
				enemy.x += xDir;
			}

			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}