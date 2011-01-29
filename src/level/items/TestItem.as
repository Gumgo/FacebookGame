package level.items
{
	import level.behaviors.LineBehavior;
	import level.Item;
	import level.LevelState;
	import org.flixel.FlxG;
	
	public class TestItem extends Item
	{
		
		public function TestItem(x:int, y:int, strength:Number)
		{
			super(x, y, "testItem", strength);
			if (Context.getPersistentState().getElementState(1) == PersistentState.ELEM_UNENCOUNTERED) {
				Context.getPersistentState().setElementState(1, PersistentState.ELEM_ENCOUNTERED);
			}
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().adjustHealth(strength as int);
			(FlxG.state as LevelState).getLevelText().setText("health +" + strength, 0x00FF00);
			Context.getPersistentState().setElementState(1, PersistentState.ELEM_COLLECTED);
			//(FlxG.state as LevelState).getPlayer().setSecondaryWeapon("name_of_weapon_class");
			removeSelf();
		}
		
	}

}