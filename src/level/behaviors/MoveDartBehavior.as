package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	public class MoveDartBehavior extends Behavior 
	{

		private var xTar:Number;
		private var yTar:Number;
		private var phase:int;
		private var timer:int;

		public function MoveDartBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):MoveDartBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			// direction relative to top center of screen
			var direction:Number = Number(getProperty("direction"));
			direction += 90;
			// find the x, y speed the enemy will be moving
			var xCast:Number = Math.cos(direction * Math.PI / 180.0);
			var yCast:Number = -Math.sin(direction * Math.PI / 180.0);
			// now we "cast" the enemy to the edge of the screen
			var xSize:Number = FlxG.width * 0.5 + enemy.width * 0.5;
			var ySize:Number = FlxG.height * 0.5 + enemy.height * 0.5;

			var castAxis:int = -1; // 0 = x, 1 = y
			var xMul:Number;
			var yMul:Number;
			if (xCast != 0) {
				xMul = xSize / Math.abs(xCast);
			}
			if (yCast != 0) {
				yMul = ySize / Math.abs(yCast);
			}

			if (xCast == 0) {
				enemy.x = 0.0;
				enemy.y = yCast * yMul;
			} else if (yCast == 0) {
				enemy.x = xCast * xMul;
				enemy.y = 0.0;
			} else {
				enemy.x = xCast * xMul;
				enemy.y = yCast * xMul;
				if (Math.abs(enemy.y) / ySize > 1.0) {
					enemy.x = xCast * yMul;
					enemy.y = yCast * yMul;
				}
			}

			enemy.x += FlxG.width * 0.5;
			enemy.y += FlxG.height * 0.5;
			enemy.x -= enemy.width * 0.5;
			enemy.y -= enemy.height * 0.5;

			var player:Player = (FlxG.state as LevelState).getPlayer();
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.height * 0.5;
			xTar = player.x + player.width * 0.5;
			yTar = player.y + player.height * 0.5;
			xTar = (xCtr + xTar) * 0.5;
			yTar = (yCtr + yTar) * 0.5;
			phase = 0;
		}

		override public function update(enemy:Enemy):void
		{
			var xCtr:Number = enemy.x + enemy.width * 0.5;
			var yCtr:Number = enemy.y + enemy.height * 0.5;
			if (phase == 0) {
				var mag:Number = Math.sqrt((xCtr - xTar) * (xCtr - xTar) + (yCtr - yTar) * (yCtr - yTar));
				if (mag < 1) {
					xCtr = xTar;
					yCtr = yTar;
					phase = 1;
				} else {
					const MOVE_SPEED:Number = 10;
					var magScaled:Number = Math.min(MOVE_SPEED, mag * 0.2);
					var magRatio:Number = magScaled / mag;
					xCtr = MathExt.lerp(xCtr, xTar, magRatio);
					yCtr = MathExt.lerp(yCtr, yTar, magRatio);
					timer = 45 + Math.floor(Math.random() * 10);
				}
			} else {
				if (timer > 0) {
					--timer;
				} else if (timer == 0) {
					var player:Player = (FlxG.state as LevelState).getPlayer();
					xTar = player.x + player.width - xCtr;
					yTar = player.y + player.height - yCtr;
					if (xTar == 0 && yTar == 0) {
						yTar = 1;
					} else {
						var iTarMag:Number = 1.0 / Math.sqrt(xTar * xTar + yTar * yTar);
						xTar *= iTarMag;
						yTar *= iTarMag;
					}
					timer = -1;
				} else {
					const RUSH_SPEED:Number = 14.0;
					xCtr += xTar * RUSH_SPEED;
					yCtr += yTar * RUSH_SPEED;
				}
				if (!enemy.onScreen()) {
					enemy.enemyFinished();
				}
			}
			enemy.x = xCtr - enemy.width * 0.5;
			enemy.y = yCtr - enemy.height * 0.5;
		}
	}

}