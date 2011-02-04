package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Item extends FlxSprite
	{
		public function Item()
		{
			super();
		}

		protected function resetMeSuper(x:int, y:int, image:String):Item
		{
			this.x = x;
			this.y = y;
			loadGraphic(Context.getResources().getSprite(image));
			x -= width / 2;
			y -= height / 2;

			(FlxG.state as LevelState).getItemGroup().add(this);
			return this;
		}

		override public function update():void
		{
			y += 4;
			if (!onScreen()) {
				removeSelf();
			}
		}

		protected function removeSelf():void
		{
			(FlxG.state as LevelState).getItemGroup().remove(this);
			Context.getRecycler().recycle(this);
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