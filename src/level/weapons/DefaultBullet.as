package level.weapons 
{
	import level.LevelState;
	import level.PlayerBullet;
	import org.flixel.FlxG;

	public class DefaultBullet extends PlayerBullet
	{
		
		public function DefaultBullet(x:int, y:int) 
		{
			super("default", 200, x, y, Context.getResources().getSprite("defaultBullet"));
			// center the bullet
			this.x -= width / 2;
			this.y -= height / 2;
		}

		override public function update():void
		{
			y -= 12;
			super.update();
		}
		
	}

}