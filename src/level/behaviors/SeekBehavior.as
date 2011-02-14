package level.behaviors 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;

	public class SeekBehavior extends Behavior 
	{

		private var xVel:Number;
		private var yVel:Number;
		private const MAX_VEL:Number = 2;
		private const ACCEL:Number = 0.25;
		private var tick:int;
		private var matrix:Matrix;

		public function SeekBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):SeekBehavior
		{
			super.resetMeSuper(properties);
			matrix = new Matrix();
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.x = Number(getProperty("x")) - enemy.width * 0.5;
			enemy.y = Number(getProperty("y")) - enemy.height * 0.5;
			xVel = 0;
			yVel = 0;
			tick = 0;
			enemy.visible = false;
		}

		override public function update(enemy:Enemy):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.height * 0.5;

			var player:Player = (FlxG.state as LevelState).getPlayer();

			var pX:Number = player.x + player.width * 0.5;
			var pY:Number = player.y + player.height * 0.5;

			var pxVec:Number = pX - xCtr;
			var pyVec:Number = pY - yCtr;
			var pVecMag:Number = Math.sqrt(pxVec * pxVec + pyVec * pyVec);
			if (pVecMag != 0) {
				pVecMag = 1.0 / pVecMag;
				xVel += pxVec * pVecMag * ACCEL;
				yVel += pyVec * pVecMag * ACCEL;
			}
			var velMag:Number = Math.sqrt(xVel * xVel + yVel * yVel);
			if (velMag != 0) {
				velMag = 1.0 / velMag;
				xVel *= velMag * MAX_VEL;
				yVel *= velMag * MAX_VEL;
			}

			enemy.x += xVel;
			enemy.y += yVel;

			var effects:BitmapData = (FlxG.state as LevelState).getEffects();

			matrix.identity();
			matrix.translate( -enemy.width * 0.5, -enemy.height * 0.5);
			matrix.rotate(2.0 * Math.PI * (tick % 180) / 180.0);
			matrix.translate( enemy.x + enemy.width * 0.5, enemy.y + enemy.height * 0.5);
			effects.draw(enemy.pixels, matrix);
			matrix.identity();
			matrix.translate( -enemy.width * 0.5, -enemy.height * 0.5);
			matrix.rotate( -2.0 * Math.PI * (tick % 180) / 180.0);
			matrix.translate( enemy.x + enemy.width * 0.5, enemy.y + enemy.height * 0.5);
			effects.draw(enemy.pixels, matrix);

			++tick;
		}
	}

}
