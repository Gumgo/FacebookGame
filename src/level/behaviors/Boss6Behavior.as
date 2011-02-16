package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;

	public class Boss6Behavior extends Behavior 
	{

		private var damage:int;
		private var phase:int;
		private var timer:int;
		private var fig8:Number;
		private var actualX:Number;
		private var actualY:Number;

		public function Boss6Behavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):Boss6Behavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			phase = 0;
			enemy.x = actualX = FlxG.width * 0.5 - enemy.width * 0.5;
			enemy.y = actualY = 64;
			fig8 = 0;
			enemy.alpha = 0;
			damage = enemy.getDamage();
			enemy.setDamage(0);
			enemy.setInvincible(true);
		}

		override public function update(enemy:Enemy):void
		{
			const BLINK_RATE:int = 10;
			if (phase == 0) {
				timer = 0;
				phase = 1;
			} else if (phase == 1) {
				enemy.alpha = (Number(timer % BLINK_RATE) / BLINK_RATE);
				if (timer == 5 * BLINK_RATE) {
					phase = 2;
					enemy.alpha = 1;
					enemy.setDamage(damage);
					timer = 0;
					enemy.setInvincible(false);
				}
				++timer;
			} else if (phase == 2) {
				if (timer >= 60 * 4) {
					phase = 3;
					timer = 0;
					enemy.setInvincible(true);
				} else {
					if (timer < 20) {
						var dict:Dictionary = new Dictionary();
						dict["orbX"] = String(actualX + enemy.width * 0.5);
						dict["orbY"] = String(actualY + enemy.height * 0.5);
						dict["radius"] = "96";
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("bullet_orbit"),
							(Context.getRecycler().getNew(OrbitBehavior) as OrbitBehavior).resetMe(dict), false, false);
					}

					if (timer % 80 == 0) {
						dict = new Dictionary();
						dict["x"] = String(enemy.x + enemy.width * 0.5);
						dict["y"] = String(enemy.y + enemy.height * 0.5);
						var player:Player = (FlxG.state as LevelState).getPlayer();
						var xVec:Number = player.x + player.width * 0.5 - (enemy.x + enemy.width * 0.5);
						var yVec:Number = player.y + player.height * 0.5 - (enemy.y + enemy.height);
						if (xVec == 0 && yVec == 0) {
							yVec = 1;
						}
						dict["dir"] = String(Math.atan2( -yVec, xVec) * 180.0 / Math.PI);
						dict["speed"] = "12";
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition("bullet_fire3"),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), false, false);

						FlxG.play(Context.getResources().getSound("bossBullet"), 0.25);
					}

					++timer;
				}
			} else if (phase == 3) {
				enemy.alpha = 1.0 - (Number(timer % BLINK_RATE) / BLINK_RATE);
				if (timer == 5 * BLINK_RATE) {
					phase = 4;
					enemy.alpha = 0;
					enemy.setDamage(0);
					timer = 60 * 2;
				}
				++timer
			} else if (phase == 4) {
				var bullets:Array = (FlxG.state as LevelState).getEnemyGroup().members;
				for (var i:int = 0; i < bullets.length; ++i) {
					if (bullets[i] != null && (bullets[i] as Enemy).getBehavior() is OrbitBehavior) {
						((bullets[i] as Enemy).getBehavior() as OrbitBehavior).explode();
					}
				}
				if (timer == 0) {
					phase = 0;
					timer = 0;
					player = (FlxG.state as LevelState).getPlayer();
					actualX = enemy.width * 0.5 + Math.random() * (FlxG.width - enemy.width * 2);
					actualY = enemy.height * 0.5 + Math.random() * (FlxG.height * 0.25);
				} else {
					--timer;
				}
			}

			enemy.x = actualX + 5.0 * Math.cos(fig8 * Math.PI * 2.0);
			enemy.y = actualY + 5.0 * Math.sin(fig8 * Math.PI * 4.0);

			fig8 += 0.01;
			if (fig8 >= 1.0) {
				fig8 -= 1.0;
			}
		}

		override public function die(enemey:Enemy):void
		{
			var bullets:Array = (FlxG.state as LevelState).getEnemyGroup().members;
			for (var i:int = 0; i < bullets.length; ++i) {
				if (bullets[i] != null && (bullets[i] as Enemy).getBehavior() is OrbitBehavior) {
					((bullets[i] as Enemy).getBehavior() as OrbitBehavior).explode();
				}
			}
		}

	}

}
