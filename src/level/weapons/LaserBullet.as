package level.weapons 
{
	import level.LevelState;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class LaserBullet extends PlayerBullet
	{

		public function LaserBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int):LaserBullet
		{
			super.resetMeSuper("laser", 200, x, y, Context.getResources().getSprite("laserBullet"));
			// center the bullet
			this.x -= width / 2;
			this.y -= height / 2;
			color = 0xFFFF00;
			return this;
		}

		override public function update():void
		{
			y -= 12;
			if (color == 0xFFFF00) {
				color = 0x00FFFF;
			} else if (color == 0x00FFFF) {
				color = 0xFFFF00;
			}
			super.update();
		}
		
	}

}