package level.weapons 
{
	import level.LevelState;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class LaserBullet extends PlayerBullet
	{

		private static const DAMAGE:int = 75;

		public function LaserBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int):LaserBullet
		{
			super.resetMeSuper("laser", DAMAGE * (FlxG.state as LevelState).getPlayer().getDamageMultiplier(),
				x, y, Context.getResources().getSprite("laserBullet"));
			// center the bullet
			this.x -= width * 0.5;
			this.y -= height * 0.5;
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