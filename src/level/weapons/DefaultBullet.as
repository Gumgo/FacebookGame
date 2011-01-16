package level.weapons 
{
	import level.PlayerBullet;

	public class DefaultBullet extends PlayerBullet
	{
		
		public function DefaultBullet(x:int, y:int) 
		{
			super("default", 200, x, y, null);
			loadGraphic(Context.getResources().getSprite("defaultBullet"), true);
			addAnimation("anim", [0, 1], 12, true);
			play("anim");
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