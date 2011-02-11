package level.items
{
	import level.Item;
	import level.LevelState;
	import level.weapons.LaserWeapon;
	import org.flixel.FlxG;
	
	public class LaserItem extends Item
	{

		public function LaserItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):LaserItem
		{
			super.resetMeSuper(x, y, "laserItem");
			return this;
		}

		override public function collect():void
		{
			FlxG.play(Context.getResources().getSound("collect"));
			(FlxG.state as LevelState).getPlayer().setSecondaryWeapon(new LaserWeapon());
			(FlxG.state as LevelState).getLevelText().setText("Laser", 0x0000FF, 30);
			removeSelf();
		}
		
	}

}