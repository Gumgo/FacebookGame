package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;

	public class Boss2Behavior extends Behavior 
	{

		private var phase:int;
		private const PHASE_DONE:int = -1;

		private var attack:int;
		private const ARRIVE:int = -2;
		private const THINKING:int = -1;
		private const ATTACK_CREATE_SHIELDS:int = 0;
		private const ATTACK_SHOOT:int = 1;
		private const ATTACK_COUNT:int = 2;

		private const Y_TOP:Number = 64;
		private var timer:int;

		private var tarX:Number;

		public function Boss2Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss2Behavior
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
			case ATTACK_CREATE_SHIELDS:
				createShields(enemy, player);
				break;
			case ATTACK_SHOOT:
				shoot(enemy, player);
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

		private function createShields(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				tarX = Math.random() * (FlxG.width - enemy.width * 0.5) + enemy.width * 0.5;
				phase = 1;
			} else if (phase < 5) {
				if (slideToX(enemy, tarX, 0.1, 10)) {
					++phase;
					tarX = Math.random() * (FlxG.width - enemy.width * 0.5) + enemy.width * 0.5;
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width * 0.5);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(0.5);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_shield"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), false, false);
				}
			} else if (phase == 5) {
				phase = PHASE_DONE;
			}
		}

		private function shoot(enemy:Enemy, player:Player):void
		{
			if (phase == 0) {
				timer = 0;
				phase = 1;
			} else if (phase == 1) {
				if (timer % 5 == 0) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width * 0.5 - 24);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(8);
					var xVec:Number = player.x + player.width * 0.5 - (enemy.x + enemy.width * 0.5 - 24);
					var yVec:Number = player.y + player.height * 0.5 - (enemy.y + enemy.height);
					if (xVec == 0 && yVec == 0) {
						yVec = 1;
					}
					dict["dir"] = String(Math.atan2( -yVec, xVec) * 180.0 / Math.PI);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					dict = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width * 0.5 + 24);
					dict["y"] = String(enemy.y + enemy.height);
					dict["speed"] = String(8);
					xVec = player.x + player.width * 0.5 - (enemy.x + enemy.width * 0.5 + 24);
					yVec = player.y + player.height * 0.5 - (enemy.y + enemy.height);
					if (xVec == 0 && yVec == 0) {
						yVec = 1;
					}
					dict["dir"] = String(Math.atan2( -yVec, xVec) * 180.0 / Math.PI);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_fire"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);

					FlxG.play(Context.getResources().getSound("bossBullet"), 0.25);
				}
				++timer;
				if (timer == 30) {
					phase = PHASE_DONE;
				}
			}
		}

		override public function die(enemy:Enemy):void
		{
			var shields:Array = (FlxG.state as LevelState).getEnemyGroup().members;
			for (var i:int = 0; i < shields.length; ++i) {
				// OK to check for BulletBehavior because this isn't the bullet group, it's the enemy group
				if (shields[i] != null && (shields[i] as Enemy).getBehavior() is BulletBehavior) {
					(shields[i] as Enemy).onDie();
				}
			}
		}
	}
}
