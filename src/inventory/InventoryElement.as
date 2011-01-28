package inventory 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import level.definitions.ElementDefinition;

	public class InventoryElement extends FlxSprite 
	{
		private var number:int;
		
		public function InventoryElement(X:Number, Y:Number, number:int) 
		{
			super(X, Y, Context.getResources().getSprite("tableEntry"));
			var def:ElementDefinition = Context.getGameData().getElementDefinition(number);
			var symbolLabel:FlxText = new FlxText(X, Y + height / 2, width, number + "\n" + def.getSymbol());

			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_UNENCOUNTERED) {
				symbolLabel.text = "?";
			}

			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_COLLECTED) {
				color = (FlxG.state as InventoryState).groupColor(def.getGroup());
			} else {
				color = 0x808080;
			}
			symbolLabel.alignment = "center";
			symbolLabel.color = 0x000000;
			symbolLabel.size = 10;
			symbolLabel.y -= symbolLabel.height / 2;

			this.number = number;

			FlxG.state.defaultGroup.add(this);
			FlxG.state.defaultGroup.add(symbolLabel);
		}

		override public function update():void
		{
			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_COLLECTED) {
				if (FlxG.mouse.x >= x && FlxG.mouse.y >= y && FlxG.mouse.x < x + width && FlxG.mouse.y < y + height) {
					(FlxG.state as InventoryState).describe(number, (y + height / 2) < FlxG.height / 2);
				}
			}
		}

	}

}