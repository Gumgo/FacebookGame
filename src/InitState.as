package  
{
	import inventory.InventoryState;
	import level.LevelState;
	import org.flixel.FlxState;
	import org.flixel.FlxG;

	public class InitState extends FlxState 
	{

		override public function create():void
		{
			Context.getGameData().load(doneLoading);
		}

		private function doneLoading():void
		{
			FlxG.state = new MenuState();
		}

	}

}