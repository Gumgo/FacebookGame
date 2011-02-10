package level.items
{
	import level.Item;
	import level.LevelState;
	import level.weapons.MissileWeapon;
	import org.flixel.FlxG;
	
	public class MissileItem extends Item
	{

		public function MissileItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):MissileItem
		{
			super.resetMeSuper(x, y, "missileItem");
			return this;
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().setSecondaryWeapon(new MissileWeapon());
			(FlxG.state as LevelState).getLevelText().setText("Missile", 0x0000FF);
			removeSelf();
		}
		
	}

}