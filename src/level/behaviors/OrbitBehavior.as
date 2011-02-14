package level.behaviors 
{
	import level.enemies.Behavior;
	import flash.utils.Dictionary;
	import level.enemies.Enemy;
	
	public class OrbitBehavior extends Behavior 
	{

		private var radius:Number;
		private var speed:Number;
		private var dir:Number;
		private var orbX:Number;
		private var orbY:Number;
		private var phase:int;
		private var xVec:Number;
		private var yVec:Number;
		private var radiusLocked:Boolean;

		public function OrbitBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):OrbitBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.x = orbX = Number(getProperty("orbX"));
			enemy.y = orbY = Number(getProperty("orbY"));
			enemy.x -= enemy.width * 0.5;
			enemy.y -= enemy.height * 0.5;
			radius = Number(getProperty("radius"));
			radiusLocked = false;

			speed = (0.25 + Math.random() * 0.75) / 60.0;
			dir = Math.random();

			phase = -1;
		}

		override public function update(enemy:Enemy):void
		{
			if (phase == -1) {
				phase = 0;
			} else if (phase == 0) {
				var xCtr:Number = enemy.x + enemy.width * 0.5;
				var yCtr:Number = enemy.y + enemy.height * 0.5;
				var currentRad:Number;
				if (!radiusLocked) {
					currentRad = Math.sqrt((xCtr - orbX) * (xCtr - orbX) + (yCtr - orbY) * (yCtr - orbY));
					var radInc:Number = Math.min(5, (radius - currentRad) * 0.1);
					currentRad += radInc;
					if (currentRad >= radius - 1.0) {
						radiusLocked = true;
					}
				} else {
					currentRad = radius;
				}
				xCtr = orbX + currentRad * Math.cos(dir * Math.PI * 2.0);
				yCtr = orbY + currentRad * Math.sin(dir * Math.PI * 2.0);
				enemy.x = xCtr - enemy.width * 0.5;
				enemy.y = yCtr - enemy.height * 0.5;
				dir += speed;
			} else if (phase == 1) {
				xVec = enemy.x + enemy.width * 0.5 - orbX;
				yVec = enemy.y + enemy.health * 0.5 - orbY;
				if (xVec == 0 && yVec == 0) {
					yVec = 1;
				} else {
					var iMag:Number = 1.0 / Math.sqrt(xVec * xVec + yVec * yVec);
					xVec *= iMag;
					yVec *= iMag;
				}
				phase = 2;
			}

			// no else if
			if (phase == 2) {
				enemy.x += xVec * 12;
				enemy.y += yVec * 12;
				if (!enemy.onScreen()) {
					enemy.enemyFinished();
				}
			}
		}

		public function explode():void
		{
			phase = 1;
		}

	}

}