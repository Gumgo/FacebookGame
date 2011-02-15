package controls 
{

	import org.flixel.*;
	import menu.MenuState;
	import flash.display.MovieClip;

	public class Controls extends FlxState
	{
		private var menuMenu:FlxText;
		private var background:MovieClip;
		override public function create():void  
		{

			
			// set the background image for the menustate
			var bgNum:int = Math.floor(Math.random() * Resources.BACKGROUND_COUNT) + 1;
			var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "Anim");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;
			defaultGroup.add(new FlxSprite(100, 0, Context.getResources().getSprite("controls")));
			// return to menu 
			menuMenu = new FlxText(0, FlxG.height - 50, FlxG.width, "Press c To Return to Main Menu");
			menuMenu.setFormat (null, 14, 0xFFFFFFFF, "center");
			menuMenu.alpha = 1;
			add(menuMenu);
		}
		public function Controls() 
		{
			super();
		}
		
		override public function update():void
		{
					
				if (FlxG.keys.justPressed("C"))
				{
					parent.removeChild(background);
					FlxG.state = new MenuState();
					
				}

			super.update();
		}
		
	}

}