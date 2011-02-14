package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Item extends FlxSprite
	{
		protected var speed:int;

		public function Item()
		{
			super();
		}

		protected function resetMeSuper(x:int, y:int, image:String):Item
		{
			exists = true;
			this.x = x;
			this.y = y;
			loadGraphic(Context.getResources().getSprite(image));
			this.x -= width * 0.5;
			this.y -= height * 0.5;
			speed = 3;

			Recycler.addToGroup((FlxG.state as LevelState).getItemGroup(), this);
			return this;
		}

		override public function update():void
		{
			y += speed;
			if (!onScreen()) {
				removeSelf();
			}
		}

		protected function removeSelf():void
		{
			(FlxG.state as LevelState).getItemGroup().remove(this);
			Context.getRecycler().recycle(this);
			exists = false;
		}

		/**
		 * Override this and call removeSelf at the end of the method.
		 */
		public function collect():void
		{
			throw new Error("collect was not overridden in a class derived from Item");
		}

	}

}