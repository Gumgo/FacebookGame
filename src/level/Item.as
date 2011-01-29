package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class Item extends FlxSprite
	{
		protected var strength:Number;

		public function Item(x:int, y:int, image:String, strength:Number) 
		{
			super(x, y, Context.getResources().getSprite(image));
			x -= width / 2;
			y -= height / 2;

			this.strength = strength;

			(FlxG.state as LevelState).getItemGroup().add(this);
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