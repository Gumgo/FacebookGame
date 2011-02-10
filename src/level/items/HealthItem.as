package level.items
{
	import level.Item;
	import level.LevelState;
	import org.flixel.FlxG;
	
	public class HealthItem extends Item
	{

		public function HealthItem()
		{
			super();
		}

		public function resetMe(x:int, y:int):HealthItem
		{
			super.resetMeSuper(x, y, "healthItem");
			return this;
		}

		override public function collect():void
		{
			(FlxG.state as LevelState).getPlayer().adjustHealth(20);
			(FlxG.state as LevelState).getLevelText().setText("Energy", 0x00FF00);
			removeSelf();
		}
		
	}

}