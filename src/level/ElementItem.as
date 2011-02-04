package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class ElementItem extends Item
	{

		private var number:int;

		public function ElementItem()
		{
			super();
		}

		public function resetMe(x:int, y:int, number:int):ElementItem
		{
			this.resetMeSuper(x, y, "blob"); // TEMPORARY!!!!!
			// TODO: load graphic based on element!!!! read from an XML file of elements
			// color = LOOK_UP_COLOR_BASED_ON_ELEMENT_NUMBER
			this.number = number;

			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_UNENCOUNTERED) {
				Context.getPersistentState().setElementState(number, PersistentState.ELEM_ENCOUNTERED);
			}
			return this;
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getLevelText().setText(
				Context.getGameData().getElementDefinition(number).getName() + " (" + number + ") collected!", 0x00FF00, 60);
			Context.getPersistentState().setElementState(number, PersistentState.ELEM_COLLECTED);
			removeSelf();
		}

	}

}