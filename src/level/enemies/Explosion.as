package level.enemies 
{
	import level.LevelState;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Explosion extends FlxSprite 
	{
		
		public function Explosion() 
		{
			super();
			loadGraphic(Context.getResources().getSprite("explosion"), true);
			addAnimation("boom", [0, 1, 2, 3, 4, 5, 6, 7], 30, false);
		}

		public function resetMe(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			play("boom", true);
			Recycler.addToGroup((FlxG.state as LevelState).getExplosionGroup(), this);
			this.x -= width * 0.5;
			this.y -= height * 0.5;
			FlxG.play(Context.getResources().getSound("exp#8"));
		}

		override public function update():void
		{
			super.update();
			if (finished) {
				(FlxG.state as LevelState).getExplosionGroup().remove(this);
				Context.getRecycler().recycle(this);
			}
		}
		
	}

}