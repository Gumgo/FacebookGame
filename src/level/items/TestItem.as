package level.items
{
	import level.behaviors.LineBehavior;
	import level.Item;
	import level.LevelState;
	import org.flixel.FlxG;
	
	public class TestItem extends Item
	{

		public function TestItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):TestItem
		{
			super.resetMeSuper(x, y, "testItem");
			return this;
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().adjustHealth(20);
			(FlxG.state as LevelState).getLevelText().setText("health +20", 0x00FF00);
			//(FlxG.state as LevelState).getPlayer().setSecondaryWeapon("name_of_weapon_class");
			removeSelf();
		}
		
	}

}