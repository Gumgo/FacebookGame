package level.weapons 
{
	import level.LevelState;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class BombBullet extends PlayerBullet
	{
		private var direction:Number;
		private var speed:Number;
		private var exploding:Boolean;

		public function BombBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int):BombBullet
		{
			super.resetMeSuper("bomb", 0, x, y, Context.getResources().getSprite("bombBullet"));
			// center the bullet
			this.x -= width / 2;
			this.y -= height / 2;
			direction = Math.random() * Math.PI * 2.0;
			speed = 12.0;
			exploding = false;
			return this;
		}

		override public function update():void
		{
			if (!exploding) {
				x += Math.cos(direction) * speed;
				y -= Math.sin(direction) * speed;
				speed -= 0.5;
				if (speed <= 0.0) {
					hit();
					speed = 0.0;
				}
			} else {
				damage = 0;
			}

			super.update();
			if (exploding && finished && exists) {
				super.hit();
			}
		}

		override public function hit():void
		{
			if (!exploding) {
				x += width / 2;
				y += height / 2;
				damage = 300;
				loadGraphic(Context.getResources().getSprite("explosion"), true);
				addAnimation("ex", [0, 1, 2, 3, 4, 5, 6, 7], 30, false);
				play("ex", true);
				exploding = true;
				x -= width / 2;
				y -= height / 2;
			}
		}
		
	}

}