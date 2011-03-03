package level 
{
	import level.definitions.ElementDefinition;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	public class ElementItem extends Item
	{

		private var number:int;
		private var applyEffect:Boolean;

		private const FLAG_TOXIC:String = "t";
		private const FLAG_LOW_DENSITY:String = "l";
		private const FLAG_HIGH_DENSITY:String = "h";
		private const FLAG_HIGH_BOILING_POINT:String = "b";
		private const FLAG_HIGH_REACTIVITY:String = "i";
		private const FLAG_LOW_REACTIVITY:String = "j";
		private const FLAG_RADIOACTIVE:String = "r";

		public function ElementItem()
		{
			super();
		}

		public function resetMe(x:int, y:int, number:int, applyEffect:Boolean):ElementItem
		{
			var def:ElementDefinition = Context.getGameData().getElementDefinition(number);
			this.resetMeSuper(x, y, def.getSprite());
			color = def.getColor();
			this.number = number;
			this.applyEffect = applyEffect;
			speed = 2;

			if (Context.getPersistentState().getElementState(number) == PersistentState.ELEM_UNENCOUNTERED) {
				(FlxG.state as LevelState).seeElement(number);
			}
			return this;
		}

		override public function collect():void
		{
			var player:Player = (FlxG.state as LevelState).getPlayer();
			var def:ElementDefinition = Context.getGameData().getElementDefinition(number);
			var text:String = def.getName() + " (" + number + ") collected!";
			if (applyEffect) {
				if (def.containsFlag(FLAG_TOXIC)) {
					text += "\nToxic: energy reduced";
					player.toxify();
				}
				if (def.containsFlag(FLAG_LOW_DENSITY)) {
					text += "\nLow density: temporary speed increase";
					player.speedUp();
				}
				if (def.containsFlag(FLAG_HIGH_DENSITY)) {
					text += "\nHigh density: temporary speed decrease";
					player.speedDown();
				}
				if (def.containsFlag(FLAG_HIGH_BOILING_POINT)) {
					text += "\nHigh boiling point: temporary shield increase";
					player.shieldUp();
				}
				if (def.containsFlag(FLAG_HIGH_REACTIVITY)) {
					text += "\nHigh reactivity: temporary firing rate increase";
					player.fastFire();
				}
				if (def.containsFlag(FLAG_LOW_REACTIVITY)) {
					text += "\nLow reactivity: temporary invulnerability";
					player.invulnerable();
				}
				if (def.containsFlag(FLAG_RADIOACTIVE)) {
					text += "\nRadioactive: temporary shield decrease";
					player.shieldDown();
				}
			}

			FlxG.play(Context.getResources().getSound("collect"));
			(FlxG.state as LevelState).getLevelText().setText(text, 0x00FF00, 180);
			(FlxG.state as LevelState).collectElement(number);

			removeSelf();
		}

	}

}