package level.weapons 
{
	import level.LevelState;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class DefaultBullet extends PlayerBullet
	{
		private static const DAMAGE:int = 50;

		public function DefaultBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int):DefaultBullet
		{
			super.resetMeSuper("default", DAMAGE * (FlxG.state as LevelState).getPlayer().getDamageMultiplier(),
				x, y, Context.getResources().getSprite("defaultBullet"));
			// center the bullet
			this.x -= width / 2;
			this.y -= height / 2;
			FlxG.play(Context.getResources().getSound("gun1"), 0.25);
			return this;
		}

		override public function update():void
		{
			y -= 12;
			super.update();
		}
		
	}

}