package  
{
<<<<<<< HEAD
=======
	import menu.MenuState;
>>>>>>> a2eb891da20f355be7b2820a98d7f1dd0b137faf
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