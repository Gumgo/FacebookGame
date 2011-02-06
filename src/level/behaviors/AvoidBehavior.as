package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class AvoidBehavior extends Behavior 
	{

		private var shotTimer:int;
		private var xVel:Number;
		private var yVel:Number;
		private const MAX_VEL:Number = 8;
		private const ACCEL:Number = 1;

		public function AvoidBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):AvoidBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.y = -enemy.width;
			enemy.x = Math.random() * (FlxG.width - enemy.width);
			shotTimer = 0;
			xVel = 0;
			yVel = 0;
		}

		override public function update(enemy:Enemy):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.height * 0.5;

			var player:Player = (FlxG.state as LevelState).getPlayer();

			var avgX:Number = 0;
			var avgY:Number = 0;
			var bullets:Array = (FlxG.state as LevelState).getBulletGroup().members;
			var bc:int = 0;
			for (var i:int = 0; i < bullets.length; ++i) {
				var bullet:PlayerBullet = bullets[i];
				if (bullet != null) {
					if ((bullet.x - xCtr) * (bullet.x - xCtr) + (bullet.y - yCtr) * (bullet.y - yCtr) < 96 * 96) {
						avgX += bullet.x + bullet.width * 0.5;
						avgY += bullet.y + bullet.height * 0.5;
						++bc;
					}
				}
			}
			if (bc > 0) {
				avgX /= bc;
				avgY /= bc;

				var xDir:Number = xCtr - avgX;
				var yDir:Number = yCtr - avgY;
				var dirLength:Number = Math.sqrt(xDir * xDir + yDir * yDir);
				if (dirLength != 0.0) {
					var iDirLength:Number = 1.0 / dirLength;
					xDir *= iDirLength;
					yDir *= iDirLength;
				}
				xVel += xDir * ACCEL;
				yVel += yDir * ACCEL;
			} else {
				var xTar:Number = player.x + player.width * 0.5;
				var yTar:Number = Math.max(enemy.height * 0.5, player.y - enemy.height * 0.5 - 96);

				var xVec:Number = xTar - xCtr;
				var yVec:Number = yTar - yCtr;
				var distMag:Number = Math.sqrt(xVec * xVec + yVec * yVec);
				if (distMag != 0.0) {
					var iDistMag:Number = 1.0 / distMag;
					xVec *= iDistMag;
					yVec *= iDistMag;
				}
				xVel += xVec * ACCEL;
				yVel += yVec * ACCEL;
			}

			var velLength:Number = Math.sqrt(xVel * xVel + yVel * yVel);
			if (velLength > MAX_VEL) {
				var mul:Number = MAX_VEL / velLength;
				xVel *= mul;
				yVel *= mul;
			}

			enemy.x += xVel;
			enemy.y += yVel;

			if (shotTimer == 0 && Math.abs(enemy.x + enemy.width * 0.5 - player.x - player.width * 0.5) < 12) {
				var dict:Dictionary = new Dictionary();
				dict["x"] = String(enemy.x + enemy.width / 2);
				dict["y"] = String(enemy.y + enemy.height);
				(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
					null,
					Context.getGameData().getEnemyDefinition("BulletEnemy"),
					(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
				shotTimer = 10;
			}

			if (shotTimer > 0) {
				--shotTimer;
			}
		}
	}

}
