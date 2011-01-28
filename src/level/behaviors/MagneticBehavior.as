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
		/*
		 * (FlxG.state as LevelState).getPlayer() 
		 * 
		 */
		
		public function MagneticBehavior(properties:Dictionary) 
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
			
			var playerX:Number = (FlxG.state as LevelState).getPlayer().x;
			var playerY:Number = (FlxG.state as LevelState).getPlayer().y;
			
			
			var xDiff:Number = playerX - enemy.x;
			var yDiff:Number = playerY - enemy.y;
			
			var xDir:Number = FlxU.ceil(xDiff / 25);
			var yDir:Number = FlxU.ceil(yDiff / 20);
			 
			if ((xDiff > 5 || xDiff < -5) && yDiff < -10 ) {
				enemy.y += 5; 
			} else {
				enemy.y += yDir;
				enemy.x += xDir;
			}
			
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}