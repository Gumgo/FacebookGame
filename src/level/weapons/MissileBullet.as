package level.weapons 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import level.enemies.Enemy;
	import level.PlayerBullet;
	import level.LevelState;
	import org.flixel.FlxG;

	/**
	 * ...
	 * @author Ben
	 */
	public class MissileBullet extends PlayerBullet
	{
		private var direction:Number;
		private var target:Enemy;
		private var exploding:Boolean;

		public function MissileBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int):MissileBullet
		{
			super.resetMeSuper("missile", 0, x, y, null);
			loadRotatedGraphic(Context.getResources().getSprite("missileBullet"));
			this.origin.x = width / 2;
			this.origin.y = height / 2;
			this.x -= width / 2;
			this.y -= height / 2;
			direction = 270;
			selectTarget();
			exploding = false;
			return this;
		}

		private function selectTarget():void
		{
			target = (FlxG.state as LevelState).getEnemyGroup().getRandom() as Enemy;
		}

		override public function update():void
		{
			if (!exploding) {
				if (target == null || target.isFinished()) {
					selectTarget();
				}
				if (target != null) {
					var xVec:Number = target.x + target.width / 2 - x - width / 2;
					var yVec:Number = target.y + target.height / 2 - y - height / 2;
					if (xVec != 0 && yVec != 0) {
						var dirTo:Number = Math.atan2(xVec, yVec) * 180.0 / Math.PI;
						if (dirTo < 0.0) {
							dirTo += 360.0;
						}

						var mul:Number = ((((direction - dirTo) % 360.0) + 540.0) % 360.0) - 180.0;
						if (mul > 0) {
							mul = 1.0;
						} else if (mul < 0) {
							mul = -1.0;
						}
						direction += 3.0 * mul;

						if (direction >= 360.0) {
							direction -= 360.0;
						} else if (direction < 0.0) {
							direction += 360.0;
						}
					}
				}
			}
			const SPEED:Number = 8.0;
			var xInc:Number = Math.cos(direction * Math.PI / 180.0);
			var yInc:Number = Math.sin(direction * Math.PI / 180.0);

			x += xInc * SPEED;
			y += yInc * SPEED;

			angle = direction + 90;

			super.update();

			if (exploding && finished) {
				super.hit();
			}
		}

		override public function hit():void
		{
			if (!exploding) {
				x += width / 2;
				y += height / 2;
				damage = 100;
				loadGraphic(Context.getResources().getSprite("explosion"), true);
				addAnimation("ex", [0, 1, 2, 3, 4, 5, 6, 7], 30, false);
				play("ex");
				exploding = true;
				x -= width / 2;
				y -= height / 2;
			}
		}
	}

}