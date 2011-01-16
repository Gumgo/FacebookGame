package level.items
{
	import level.Item;
	import level.LevelState;
	import org.flixel.FlxG;
	
	public class TestItem extends Item
	{
		
		public function TestItem(x:int, y:int, strength:Number)
		{
			super(x, y, "testItem", strength);
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().adjustHealth(strength as int);
			removeSelf();
		}
		
	}

}