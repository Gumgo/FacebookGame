package level.items
{
	import level.Item;
	import level.LevelState;
	import level.weapons.SpreadWeapon;
	import org.flixel.FlxG;
	
	public class SpreadItem extends Item
	{

		public function SpreadItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):SpreadItem
		{
			super.resetMeSuper(x, y, "spreadItem");
			return this;
		}

		override public function collect():void
		{
			FlxG.play(Context.getResources().getSound("collect"));
			(FlxG.state as LevelState).getPlayer().setSecondaryWeapon(new SpreadWeapon());
			(FlxG.state as LevelState).getLevelText().setText("Spread", 0x0000FF, 180);
			removeSelf();
		}
		
	}

}