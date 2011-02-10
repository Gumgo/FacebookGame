package level.items
{
	import level.Item;
	import level.LevelState;
	import level.weapons.BombWeapon;
	import org.flixel.FlxG;
	
	public class BombItem extends Item
	{

		public function BombItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):BombItem
		{
			super.resetMeSuper(x, y, "bombItem");
			return this;
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().setSecondaryWeapon(new BombWeapon());
			(FlxG.state as LevelState).getLevelText().setText("Bomb", 0x0000FF);
			removeSelf();
		}
		
	}

}