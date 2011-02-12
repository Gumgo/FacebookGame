package level.behaviors 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	public class Boss1Behavior extends Behavior 
	{

		private var phase:int;
		private const PHASE_DONE:int = -1;

		private var attack:int;
		private const ARRIVE:int = -2;
		private const THINKING:int = -1;
		private const ATTACK_SWEEP_DOWN:int = 0;
		private const ATTACK_SWEEP_CIRCLE:int = 1;
		private const ATTACK_BOMBARD_BULLETS:int = 2;
		private const ATTACK_ZERO_IN:int = 3;
		private const ATTACK_DOWNWARD_SHIELD:int = 4;
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

		public function Boss1Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss1Behavior
		{
			super.resetMeSuper(properties);
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
					attack = ATTACK_ZERO_IN;
					attack = Math.floor(Math.random() * 4);
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
			case ATTACK_DOWNWARD_SHIELD:
				downwardShield(enemy, player);
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

		private function sweepDown(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				speedY = -4;
				phase = 1;
			} else if (phase == 1) {
				enemy.y += speedY;
				speedY += 0.5;
				if (speedY >= 0.0) {
					phase = 2;
				}
			} else if (phase == 2) {
				enemy.y += speedY;
				speedY += 2.0;
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
				rot += 0.01;
				if (rot >= 1) {
					phase = 3;
					speedX = -8;
				}
				enemy.x = FlxG.width * 0.5 + xPos - enemy.width * 0.5;
				enemy.y = FlxG.height * 0.5 + yPos - enemy.height * 0.5;
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
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2 + 24);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(12);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire"),
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
				var ang1:Number = rot + timer;
				var ang2:Number = rot - timer;
				var effects:BitmapData = (FlxG.state as LevelState).getEffects();
				var shape:Shape = new Shape();
				var green:uint = 0xFF * (timer / 45.0);
				shape.graphics.lineStyle(2.0, 0xFF0000 | green << 8, 0.9);
				for (var i:int = 0; i < 2; ++i) {
					var ang:Number = (i == 0) ? ang1 : ang2;
					var xDir:Number = Math.cos(ang * Math.PI / 180.0);
					var yDir:Number = Math.sin(ang * Math.PI / 180.0);
					var xTo:Number = xCtr + xDir * (FlxG.width + FlxG.height);
					var yTo:Number = yCtr + yDir * (FlxG.width + FlxG.height);
					shape.graphics.moveTo(xCtr, yCtr);
					shape.graphics.lineTo(xTo, yTo);
				}
				effects.draw(shape);
				--timer;
				if (timer == 0) {
					phase = PHASE_DONE;
				}
			}
		}

		private function downwardShield(enemy:Enemy, player:Player):void
		{
		}

		private function sprayBullets(enemy:Enemy, player:Player):void
		{
		}

		private function burstBullets(enemy:Enemy, player:Player):void
		{
		}

	}

}
