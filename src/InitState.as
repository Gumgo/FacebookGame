package  
{

	import level.LevelState;
	import menu.MenuState;
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
			FlxG.state = new LevelState();//temp
		}

	}

}