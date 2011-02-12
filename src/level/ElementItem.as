package level 
{
	import level.definitions.ElementDefinition;
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
			var def:ElementDefinition = Context.getGameData().getElementDefinition(number);
			this.resetMeSuper(x, y, def.getSprite());
			color = def.getColor();
			this.number = number;
			speed = 2;

			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_UNENCOUNTERED) {
				(FlxG.state as LevelState).seeElement(number);
			}
			return this;
		}

		override public function collect():void
		{
			FlxG.play(Context.getResources().getSound("collect"));
			(FlxG.state as LevelState).getLevelText().setText(
				Context.getGameData().getElementDefinition(number).getName() + " (" + number + ") collected!", 0x00FF00, 180);
			(FlxG.state as LevelState).collectElement(number);
			removeSelf();
		}

	}

}