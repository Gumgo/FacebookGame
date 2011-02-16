package  
{

	import level.LevelState;
	import menu.MenuState;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import flash.display.LoaderInfo;

	public class InitState extends FlxState 
	{

		override public function create():void
		{
			var vars:Object = Object(LoaderInfo(loaderInfo).parameters);
			var uid:String = vars.user_id;
			var savestring:String = vars.savestring;
			Context.getPersistentState().setUserId(uid);
			Context.getPersistentState().setEncodedElements(savestring);
			Context.getGameData().load(doneLoading);
		}

		private function doneLoading():void
		{
			FlxG.state = new MenuState();
		}

	}

}