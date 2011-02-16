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

	public class Boss8Behavior extends Behavior 
	{

		private var xVel:Number;
		private var yVel:Number;
		private const MAX_VEL:Number = 3;
		private const ACCEL:Number = 0.4;

		private var attack:int;
		private var timer:int;
		private var phase:int;
		private const ATTACK_DONE:int = -2;
		private const ATTACK_WAITING:int = -1;
		private const ATTACK_STREAM:int = 0;
		private const ATTACK_LASER_BLAST:int = 1;
		private const ATTACK_DROP_BOMB:int = 2;
		private const ATTACK_SPEAR:int = 3;
		private const ATTACK_COUNT:int = 4;

		private var matrix:Matrix;
		private var point:Point;
		private var laserTex:BitmapData;
		private var laserVerts:Vector.<Number>;
		private var laserInds:Vector.<int>;
		private var laserUVs:Vector.<Number>;

		public function Boss8Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss8Behavior
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

			if (attack != ATTACK_SPEAR) {
				var avgX:Number = 0;
				var avgY:Number = 0;
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

				var velLength:Number = Math.sqrt(xVel * xVel + yVel * yVel);
				if (velLength > MAX_VEL) {
					var mul:Number = MAX_VEL / velLength;
					xVel *= mul;
					yVel *= mul;
				}
			} else {
				if (phase == 0) {
					if (xVel > 0) {
						xVel = Math.max(0, xVel - 0.2);
					} else if (xVel < 0) {
						xVel = Math.min(0, xVel + 0.2);
					}
					if (yVel > -4) {
						yVel -= 0.5;
					} else {
						phase = 1;
					}
				} else if (phase == 1) {
					if (xVel > 0) {
						xVel = Math.max(0, xVel - 0.2);
					} else if (xVel < 0) {
						xVel = Math.min(0, xVel + 0.2);
					}
					if (yVel < 16) {
						yVel += 1;
					}
					if (enemy.y > FlxG.height - enemy.height) {
						attack = ATTACK_DONE;
					}
				}
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
			} else if (attack == ATTACK_LASER_BLAST) {
				const LASER_GROW_SHRINK_TIME:int = 25;
				if (phase == 0) {
					phase = 1;
					timer = 0;
				} else if (phase == 1) {
					// laser "grows"
					drawLaser(enemy, Number(timer) / LASER_GROW_SHRINK_TIME);
					++timer;
					if (timer >= LASER_GROW_SHRINK_TIME) {
						phase = 2;
						timer = 20;
					}
				} else if (phase == 2) {
					drawLaser(enemy, 1.0 - 0.25 * ((timer % 12) / 11.0));
					if (timer > 0) {
						--timer;
					} else {
						timer = 0;
						phase = 3;
					}
					// player collision
					var pX:Number = player.x + player.width * 0.5;
					var pY:Number = player.y + player.height * 0.5;
					if (Math.abs(pX - (enemy.x + enemy.width * 0.5)) <= laserTex.width * 0.5 + 16 &&
						pY >= enemy.y + enemy.height) {
						player.adjustHealth( -6);
					}
				} else if (phase == 3) {
					// laser "shrinks"
					drawLaser(enemy, 1.0 - Number(timer) / LASER_GROW_SHRINK_TIME);
					++timer
					if (timer >= LASER_GROW_SHRINK_TIME) {
						attack = ATTACK_DONE;
					}
				}
			} else if (attack == ATTACK_DROP_BOMB) {
				attack = ATTACK_DONE;
				dict = new Dictionary();
				dict["x"] = String(enemy.x + enemy.width * 0.5);
				dict["y"] = String(enemy.y + enemy.height * 0.5);
				(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
					null,
					Context.getGameData().getEnemyDefinition("bullet_mine"),
					(Context.getRecycler().getNew(MineBehavior) as MineBehavior).resetMe(dict), false, false);
			} else if (attack == ATTACK_SPEAR) {
				// managed above
			}
		}

		override public function die(enemy:Enemy):void
		{
			var mines:Array = (FlxG.state as LevelState).getEnemyGroup().members;
			for (var i:int = 0; i < mines.length; ++i) {
				if (mines[i] != null && (mines[i] as Enemy).getBehavior() is MineBehavior) {
					((mines[i] as Enemy).getBehavior() as MineBehavior).disable();
					(mines[i] as Enemy).onDie();
				}
			}
		}

		private function drawLaser(enemy:Enemy, scaleX:Number):void
		{
			var effects:BitmapData = (FlxG.state as LevelState).getEffects();
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(laserTex);
			shape.graphics.drawTriangles(laserVerts, laserInds, laserUVs);
			matrix.identity();
			matrix.scale(scaleX, 1);
			matrix.translate(enemy.x + enemy.width * 0.5, enemy.y + enemy.height);
			effects.draw(shape, matrix);
		}
	}

}
