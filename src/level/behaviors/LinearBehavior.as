package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import level.Player;
	import org.flixel.FlxG;
	
	public class LinearBehavior extends Behavior 
	{

		private var xInc:Number;
		private var yInc:Number;
		private var speed:Number;
		private var shot:Boolean;

		public function LinearBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):LinearBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			// direction relative to top center of screen
			var direction:Number = Number(getProperty("direction"));
			direction += 90;
			enemy.angle = -direction + 90;
			// find the x, y speed the enemy will be moving
			xInc = -Math.cos(direction * Math.PI / 180.0);
			yInc = Math.sin(direction * Math.PI / 180.0);
			// now we "cast" the enemy to the edge of the screen
			var xCast:Number = -xInc;
			var yCast:Number = -yInc;
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

			speed = Number(getProperty("speed"));
			shot = false;
		}

		override public function update(enemy:Enemy):void
		{
			var xPrev:Number = enemy.x;
			enemy.x += xInc * speed;
			enemy.y += yInc * speed;

			if (!shot) {
				var player:Player = (FlxG.state as LevelState).getPlayer();
				var pxPrev:Number = player.getXPrev();
				var before:Number = (xPrev + enemy.width * 0.5) - (pxPrev + player.width * 0.5);
				var after:Number = (enemy.x + enemy.width * 0.5) - (player.x + player.width * 0.5);
				var beforeSign:int = MathExt.sign(before);
				var afterSign:int = MathExt.sign(after);

				if (enemy.y <= player.y && beforeSign != afterSign) {
					// enemy is passing/has passed player; shoot!

					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width / 2);
					dict["y"] = String(enemy.y + enemy.height);
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("BulletEnemy"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					shot = true;
				}
			}

			if (!enemy.onScreen()) {
				var xCtr:Number = enemy.x - FlxG.width * 0.5 - enemy.width * 0.5;
				var yCtr:Number = enemy.y - FlxG.height * 0.5 - enemy.height * 0.5;

				// use OR to be safe around 0, since only one will ever be 0
				if (MathExt.sign(xInc) == MathExt.sign(xCtr) || MathExt.sign(yInc) == MathExt.sign(yCtr)) {
					enemy.enemyFinished();
				}
			}
		}
	}

}