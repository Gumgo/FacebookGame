package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class Boss4Behavior extends Behavior 
	{

		private var xVel:Number;
		private var yVel:Number;
		private const MAX_VEL:Number = 8;
		private const ACCEL:Number = 1.25;

		private var attack:int;
		private var timer:int;
		private var phase:int;
		private const ATTACK_DONE:int = -2;
		private const ATTACK_WAITING:int = -1;
		private const ATTACK_STREAM:int = 0;
		private const ATTACK_SEEK:int = 1;
		private const ATTACK_COUNT:int = 2;

		public function Boss4Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss4Behavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.y = -enemy.height;
			enemy.x = FlxG.width * 0.5 - enemy.width * 0.5;
			xVel = 0;
			yVel = 0;
			attack = ATTACK_DONE;
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
				var pBullet:PlayerBullet = bullets[i];
				if (pBullet != null) {
					if ((pBullet.x - xCtr) * (pBullet.x - xCtr) + (pBullet.y - yCtr) * (pBullet.y - yCtr) < 144 * 144) {
						avgX += pBullet.x + pBullet.width * 0.5;
						avgY += pBullet.y + pBullet.height * 0.5;
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
				var yTar:Number = Math.max(enemy.height * 0.5, player.y - enemy.height * 0.5 - 192);

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
			enemy.angle = xVel;

			if (attack == ATTACK_DONE) {
				timer = 45 + Math.floor(Math.random() * 60);
				attack = ATTACK_WAITING;
			} else if (attack == ATTACK_WAITING) {
				if (timer == 0) {
					attack = Math.floor(Math.random() * ATTACK_COUNT);
					phase = 0;
				} else {
					--timer;
				}
			} else if (attack == ATTACK_STREAM) {
				if (phase == 0) {
					timer = 45;
					phase = 1;
				} else if (phase == 1) {
					if (timer % 5 == 0) {
						var dict:Dictionary = new Dictionary();
						dict["x"] = String(enemy.x + enemy.width * 0.5);
						dict["y"] = String(enemy.y + enemy.height);
						dict["speed"] = "12";
						dict["dir"] = String( -90 - 10 + Math.random() * 20);
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("bullet_fire2"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
					--timer;
					if (timer == 0) {
						attack = ATTACK_DONE;
					}
				}
			} else if (attack == ATTACK_SEEK) {
				var skip:Boolean = false;
				bullets = (FlxG.state as LevelState).getEnemyGroup().members;
				for (i = 0; i < bullets.length; ++i) {
					if (bullets[i] != null) {
						var bullet:Enemy = bullets[i] as Enemy;
						if (bullet.getBehavior() is SeekBehavior) {
							skip = true;
							attack = ATTACK_WAITING;
						}
					}
				}
				if (!skip) {
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2 - 24);
					dict["y"] = String(enemy.y + enemy.height);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_seek"),
						(Context.getRecycler().getNew(SeekBehavior) as SeekBehavior).resetMe(dict), false, false);
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2 + 24);
					dict["y"] = String(enemy.y + enemy.height);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_seek"),
						(Context.getRecycler().getNew(SeekBehavior) as SeekBehavior).resetMe(dict), false, false);
					attack = ATTACK_DONE;
				}
			}
		}

		override public function die(enemy:Enemy):void
		{
			var seekers:Array = (FlxG.state as LevelState).getEnemyGroup().members;
			for (var i:int = 0; i < seekers.length; ++i) {
				if (seekers[i] != null && (seekers[i] as Enemy).getBehavior() is SeekBehavior) {
					(seekers[i] as Enemy).onDie();
				}
			}
		}
	}

}
