package level.behaviors 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	public class Boss5Behavior extends Behavior 
	{

		private var phase:int;
		private const PHASE_DONE:int = -1;

		private var attack:int;
		private const ARRIVE:int = -2;
		private const THINKING:int = -1;
		private const ATTACK_CREATE_SPARKS:int = 0;
		private const ATTACK_SWEEP_DOWN:int = 1;
		private const ATTACK_SWEEP_CIRCLE:int = 2;
		private const ATTACK_BOMBARD_BULLETS:int = 3;
		private const ATTACK_ZERO_IN:int = 4;
		private const ATTACK_SPRAY_BULLETS:int = 5;
		private const ATTACK_BURST_BULLETS:int = 6;
		private const ATTACK_COUNT:int = 7;

		private const Y_TOP:Number = 64;
		private const X_PAD:Number = 96;
		private var tarX:Number;
		private var speedY:Number;
		private var speedX:Number;
		private var rot:Number;
		private var timer:int;

		private var boltPixels:BitmapData;
		private var matrix:Matrix;
		private var colorTf:ColorTransform;
		private var point:Point;

		public function Boss5Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss5Behavior
		{
			super.resetMeSuper(properties);
			boltPixels = FlxG.addBitmap(Context.getResources().getSprite("bolt"));
			matrix = new Matrix();
			colorTf = new ColorTransform();
			point = new Point;
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			phase = 0;
			attack = ARRIVE;

			enemy.x = FlxG.width * 0.5 - enemy.width * 0.5;
			enemy.y = -enemy.height;
		}

		override public function update(enemy:Enemy):void
		{
			if (phase == PHASE_DONE) {
				if (attack == THINKING) {
					attack = Math.floor(Math.random() * ATTACK_COUNT);
				} else {
					attack = THINKING;
				}
				phase = 0;
			}

			var player:Player = (FlxG.state as LevelState).getPlayer();

			switch (attack) {
			case ARRIVE:
				arrive(enemy, player);
				break;
			case THINKING:
				think(enemy, player);
				break;
			case ATTACK_CREATE_SPARKS:
				createSparks(enemy, player);
				break;
			case ATTACK_SWEEP_DOWN:
				sweepDown(enemy, player);
				break;
			case ATTACK_SWEEP_CIRCLE:
				sweepCircle(enemy, player);
				break;
			case ATTACK_BOMBARD_BULLETS:
				bombardBullets(enemy, player);
				break;
			case ATTACK_ZERO_IN:
				zeroIn(enemy, player);
				break;
			case ATTACK_SPRAY_BULLETS:
				sprayBullets(enemy, player);
				break;
			case ATTACK_BURST_BULLETS:
				burstBullets(enemy, player);
				break;
			}
		}

		private function slideToX(enemy:Enemy, x:Number, speed:Number, maxSpeed:Number = -1):Boolean
		{
			var ret:Boolean = false;
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			if (maxSpeed < 0) {
				xCtr = MathExt.lerp(xCtr, x, speed);
			} else {
				var spd:Number = (x - xCtr) * speed;
				if (spd > maxSpeed) {
					spd = maxSpeed;
				} else if (spd < -maxSpeed) {
					spd = -maxSpeed;
				}
				xCtr += spd;
			}
			if (Math.abs(xCtr - x) < 1) {
				xCtr = x;
				ret = true;
			}

			enemy.x = xCtr - enemy.width * 0.5;
			return ret;
		}

		private function slideToY(enemy:Enemy, y:Number, speed:Number, maxSpeed:Number = -1):Boolean
		{
			var ret:Boolean = false;
			var yCtr:Number = enemy.y + enemy.height * 0.5;
			if (maxSpeed < 0) {
				yCtr = MathExt.lerp(yCtr, y, speed);
			} else {
				var spd:Number = (y - yCtr) * speed;
				if (spd > maxSpeed) {
					spd = maxSpeed;
				} else if (spd < -maxSpeed) {
					spd = -maxSpeed;
				}
				yCtr += spd;
			}
			if (Math.abs(yCtr - y) < 1) {
				yCtr = y;
				ret = true;
			}

			enemy.y = yCtr - enemy.height * 0.5;
			return ret;
		}

		private function arrive(enemy:Enemy, player:Player):void
		{
			if (slideToY(enemy, Y_TOP, 0.1)) {
				phase = PHASE_DONE;
			}
		}

		private function think(enemy:Enemy, player:Player):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var pXCtr:Number = player.x + player.width * 0.5;
			if (phase == 0) {
				tarX = pXCtr;
				phase = 1;
			} else {
				if (slideToX(enemy, tarX, 0.1, 10)) {
					phase = PHASE_DONE;
				}
			}
		}

		private function createSparks(enemy:Enemy, player:Player):void
		{
			var bullets:Array = (FlxG.state as LevelState).getEnemyGroup().members;
			for (var i:int = 0; i < bullets.length; ++i) {
				if (bullets[i] != null) {
					var bullet:Enemy = bullets[i] as Enemy;
					if (bullet.getBehavior() is SeekBehavior) {
						phase = PHASE_DONE;
						return;
					}
				}
			}
			var dict:Dictionary = new Dictionary();
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

			phase = PHASE_DONE;
		}

		private function sweepDown(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				speedY = -4;
				phase = 1;
			} else if (phase == 1) {
				enemy.y += speedY;
				speedY += 0.5;
				slideToX(enemy, player.x + player.width * 0.5, 0.1, 3);
				if (speedY >= 0.0) {
					phase = 2;
				}
			} else if (phase == 2) {
				enemy.y += speedY;
				speedY += 2.0;
				slideToX(enemy, player.x + player.width * 0.5, 0.1, 3);
				if (speedY > 16) {
					speedY = 16;
				}
				if (enemy.y + enemy.height >= FlxG.height) {
					enemy.y = FlxG.height - enemy.height;
					phase = 3;
					timer = 30;
				}
			} else if (phase == 3) {
				if (timer > 0) {
					--timer;
				} else {
					if (slideToY(enemy, Y_TOP, 0.1, 16)) {
						phase = PHASE_DONE;
					}
				}
			}
		}

		private function sweepCircle(enemy:Enemy, player:Player):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			if (phase == 0) {
				if (slideToX(enemy, FlxG.width * 0.5, 0.05)) {
					phase = 1;
					speedX = 8;
				}
			} else if (phase == 1) {
				enemy.x += speedX;
				speedX -= 0.5;
				if (enemy.x + enemy.width * 0.5 <= FlxG.width * 0.5) {
					phase = 2;
					rot = 0;
				}
			} else if (phase == 2) {
				var ang:Number = (rot + 0.25) * Math.PI * 2.0;
				var xPos:Number = Math.cos(ang);
				var yPos:Number = -Math.sin(ang);
				var xRad:Number = FlxG.width * 0.5 - X_PAD;
				var yRad:Number = FlxG.height * 0.5 - Y_TOP;
				xPos *= xRad;
				yPos *= yRad;
				var oldRot:Number = rot;
				rot += 0.01;
				if (rot >= 1) {
					phase = 3;
					speedX = -8;
				}
				enemy.x = FlxG.width * 0.5 + xPos - enemy.width * 0.5;
				enemy.y = FlxG.height * 0.5 + yPos - enemy.height * 0.5;

				if (oldRot < 0.5 && rot >= 0.5) {
					for (var i:int = -1; i <= 1; ++i) {
						var dict:Dictionary = new Dictionary();
						dict["x"] = String(FlxG.width * 0.5);
						dict["y"] = String(FlxG.height * 0.5 + yRad - enemy.height * 0.5);
						dict["speed"] = String(12);
						dict["dir"] = String(90 + i * 30);
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("bullet_d20"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
				}
			} else if (phase == 3) {
				enemy.x += speedX;
				speedX += 0.5;
				if (speedX >= 0.0) {
					phase = PHASE_DONE;
				}
			}
		}

		private function bombardBullets(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				timer = 0;
				phase = 1;
			} else if (phase == 1) {
				if (timer % 5 == 0) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2 - 24);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(12);
					dict["dir"] = String( -90 + 20 * (timer / 5 - 1));
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire2"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2 + 24);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(12);
					dict["dir"] = String( -90 - 20 * (timer / 5 - 1));
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire2"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);

				}
				++timer;
				if (timer == 15) {
					phase = PHASE_DONE;
				}
			}
		}

		private function zeroIn(enemy:Enemy, player:Player):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.height;
			if (phase == 0) {
				var pXCtr:Number = player.x + player.width * 0.5;
				var pYCtr:Number = player.y + player.height * 0.5;
				if (pXCtr == xCtr && pYCtr == yCtr) {
					rot = 90;
				} else {
					rot = Math.atan2(pYCtr - yCtr, pXCtr - xCtr) * 180.0 / Math.PI;
				}
				timer = 45;
				phase = 1;
			} else if (phase == 1) {
				var shape:Shape = new Shape();
				var green:uint = 0xFF * (timer / 45.0);
				shape.graphics.lineStyle(2.0, 0xFF0000 | green << 8, 0.9);
				for (var i:int = -1; i <= 1; ++i) {
					var ang1:Number = rot + i * 45 + timer * 0.5;
					var ang2:Number = rot + i * 45 - timer * 0.5;
					var effects:BitmapData = (FlxG.state as LevelState).getEffects();
					for (var t:int = 0; t < 2; ++t) {
						var ang:Number = (t == 0) ? ang1 : ang2;
						var xDir:Number = Math.cos(ang * Math.PI / 180.0);
						var yDir:Number = Math.sin(ang * Math.PI / 180.0);
						var xTo:Number = xCtr + xDir * (FlxG.width + FlxG.height);
						var yTo:Number = yCtr + yDir * (FlxG.width + FlxG.height);
						shape.graphics.moveTo(xCtr, yCtr);
						shape.graphics.lineTo(xTo, yTo);
					}
				}
				effects.draw(shape);
				--timer;
				if (timer == 0) {
					phase = 2;
					timer = 10;
				}
			} else if (phase == 2) {
				var boltShape:Shape = new Shape();
				colorTf.redMultiplier = colorTf.greenMultiplier = 1.0;
				colorTf.blueMultiplier = 0.0;
				colorTf.alphaMultiplier = timer / 10.0;
				for (i = -1; i <= 1; ++i) {
					boltShape.graphics.beginBitmapFill(boltPixels);
					boltShape.graphics.drawRect(0, 0, boltPixels.width, FlxG.width + FlxG.height);
					matrix.identity();
					matrix.translate( -boltPixels.width * 0.5, 0);
					matrix.rotate( -Math.PI * 0.5 + (rot + i * 45) * Math.PI / 180.0);
					matrix.translate(xCtr, yCtr);
					(FlxG.state as LevelState).getEffects().draw(boltShape, matrix, colorTf);

					if (timer == 10) {
						matrix.invert();
						point.x = player.x + player.width * 0.5;
						point.y = player.y + player.height * 0.5;
						point = matrix.transformPoint(point);
						if (point.y >= -32 && point.x >= 0.0 && point.x < boltPixels.width + 32) {
							player.adjustHealth( -40);
						}
					}
				}

				var fsShape:Shape = new Shape();
				fsShape.graphics.beginFill(0xFF8000, timer / 10.0);
				fsShape.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
				(FlxG.state as LevelState).getEffects().draw(fsShape);
				--timer;
				if (timer == 0) {
					phase = PHASE_DONE;
				}
			}
		}

		private function sprayBullets(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				timer = 0;
				phase = 1;
			} else if (phase == 1) {
				if (timer % 15 == 0) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(12);
					dict["dir"] = String(270.0 - 60.0 + 120.0 * (timer / 120.0));
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire2"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
				}
				timer += 3;
				if (timer == 120) {
					phase = PHASE_DONE;
				}
			}
		}

		private function burstBullets(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				if (slideToX(enemy, enemy.width * 0.5, 0.1, 12)) {
					phase = 1;
					timer = 15;
				}
			} else if (phase == 1) {
				enemy.x += 6;
				if (timer == 15) {
					timer = 0;
					for (var i:int = -1; i <= 1; ++i) {
						var dict:Dictionary = new Dictionary();
						dict["x"] = String(enemy.x + enemy.width * 0.5);
						dict["y"] = String(enemy.y + enemy.height);
						dict["speed"] = String(12);
						dict["dir"] = String(-90 + i * 2);
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("bullet_fire2"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
				} else {
					++timer;
				}
				if (enemy.x >= FlxG.width - enemy.width * 0.5) {
					enemy.x = FlxG.width - enemy.width * 0.5;
					phase = PHASE_DONE;
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
