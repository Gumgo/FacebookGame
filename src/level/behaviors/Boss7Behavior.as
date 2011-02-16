package level.behaviors 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class Boss7Behavior extends Behavior 
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
		private const ATTACK_LASER_SPIN:int = 1;
		private const ATTACK_CHASE:int = 2;
		private const ATTACK_COUNT:int = 3;

		private var laserRot:Number;

		private var matrix:Matrix;
		private var point:Point;
		private var laserTex:BitmapData;
		private var laserVerts:Vector.<Number>;
		private var laserInds:Vector.<int>;
		private var laserUVs:Vector.<Number>;

		public function Boss7Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss7Behavior
		{
			super.resetMeSuper(properties);

			matrix = new Matrix();
			point = new Point();
			laserTex = FlxG.addBitmap(Context.getResources().getSprite("laser"));
			laserVerts = new Vector.<Number>();
			laserInds = new Vector.<int>();
			laserUVs = new Vector.<Number>();

			laserVerts.push(
			0, 0,
			0, 16,
			-laserTex.width * 0.5, 16,
			laserTex.width * 0.5, 16,
			-laserTex.width * 0.5, (FlxG.width + FlxG.height) * 1.5,
			laserTex.width * 0.5, (FlxG.width + FlxG.height) * 1.5);

			laserInds.push(
			0, 2, 1,
			0, 3, 1,
			2, 3, 4,
			3, 4, 5);

			laserUVs.push(
			0, 0,
			0.5, 1,
			0, 1,
			1, 1,
			0, 0,
			1, 0);

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
			if (bc > 0 && attack != ATTACK_CHASE) {
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
				if (attack == ATTACK_CHASE) {
					yTar = player.y + player.height * 0.5;
				}

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
							Context.getGameData().getEnemyDefinition("bullet_fire3"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
					--timer;
					if (timer == 0) {
						attack = ATTACK_DONE;
					}
				}
			} else if (attack == ATTACK_LASER_SPIN) {
				const LASER_GROW_SHRINK_TIME:int = 25;
				if (phase == 0) {
					laserRot = 45 - 22.5;
					phase = 1;
					timer = 0;
				} else if (phase == 1) {
					// lasers "grow"
					drawLasers(enemy, laserRot, Number(timer) / LASER_GROW_SHRINK_TIME);
					++timer;
					if (timer >= LASER_GROW_SHRINK_TIME) {
						phase = 2;
					}
				} else if (phase == 2) {
					// lasers rotate
					laserRot += 0.5;
					drawLasers(enemy, laserRot, 1.0 - 0.25 * ((laserRot % 6) / 5.0));
					if (laserRot >= 45 + 22.5) {
						laserRot = 45 + 22.5;
						timer = 0;
						phase = 3;
					}
					// player collision
					var pX:Number = player.x + player.width * 0.5;
					var pY:Number = player.y + player.height * 0.5;
					matrix.identity();
					matrix.rotate((laserRot + i * 90) * Math.PI / 180.0);
					matrix.translate(enemy.x + enemy.width * 0.5, enemy.y + enemy.height * 0.5);
					matrix.invert();
					point.x = pX;
					point.y = pY;
					point = matrix.transformPoint(point);
					// we've transformed the player by the inverse of the laser transformation
					// just check if player is on the axes (with a bit of padding)
					if (Math.abs(point.x) <= laserTex.width * 0.5 + 16 ||
						Math.abs(point.y) <= laserTex.width * 0.5 + 16) {
						player.adjustHealth( -3);
					}
				} else if (phase == 3) {
					// lasers "shrink"
					drawLasers(enemy, laserRot, 1.0 - Number(timer) / LASER_GROW_SHRINK_TIME);
					++timer
					if (timer >= LASER_GROW_SHRINK_TIME) {
						attack = ATTACK_DONE;
					}
				}
			} else if (attack == ATTACK_CHASE) {
				if (phase == 0) {
					timer = 60 * 2 + Math.random() * 60;
					phase = 1;
				} else if (phase == 1) {
					if (timer > 0) {
						--timer;
					} else {
						attack = ATTACK_DONE;
					}
				}
			}
		}

		private function drawLasers(enemy:Enemy, rot:Number, scaleX:Number):void
		{
			var effects:BitmapData = (FlxG.state as LevelState).getEffects();
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(laserTex);
			shape.graphics.drawTriangles(laserVerts, laserInds, laserUVs);
			for (var i:int = 0; i < 4; ++i) {
				matrix.identity();
				matrix.scale(scaleX, 1);
				matrix.translate(0, 16);
				matrix.rotate((rot + i * 90) * Math.PI / 180.0);
				matrix.translate(enemy.x + enemy.width * 0.5, enemy.y + enemy.height * 0.5);
				effects.draw(shape, matrix);
			}
		}
	}

}
