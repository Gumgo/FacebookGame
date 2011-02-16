package  
{

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
			var saveString:String = vars.savestring;
			var newUser:String = vars.newUser;
			Context.getPersistentState().setUserId(uid);
			Context.getPersistentState().setEncodedElements(saveString);
			if (newUser == null || newUser == "true") {
				Context.getPersistentState().setNewUser(true);
			} else {
				Context.getPersistentState().setNewUser(false);
			}
			Context.getGameData().load(doneLoading);
		}

		private function doneLoading():void
		{
			FlxG.state = new MenuState();
		}

	}

}