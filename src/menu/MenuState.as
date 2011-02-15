package menu
{
	import controls.Controls;
	import inventory.InventoryState;
	import org.flixel.*;
	import flash.display.MovieClip;
	import org.flixel.data.FlxFade;
 
	public class MenuState extends FlxState
	{
		private var background:MovieClip;
		private var timer:int;
		private var instructions:FlxText;
		private var menu_options:FlxText;
		private var help:FlxText;
		private var fadeIn:FlxFadeIn;

		override public function create():void
		{

			FlxG.mouse.show();

			// set the background image for the menustate
			var bgNum:int = Math.floor(Math.random() * Resources.BACKGROUND_COUNT) + 1;
			var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "Anim");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;
			
			//var title:FlxText;
			//title = new FlxText(0, 16, FlxG.width, "NUCLEOS");
			//title.setFormat (null, 24, 0xFFFFFFFF, "center");
			//add(title);
 
			instructions = new FlxText(0, FlxG.height - 88, FlxG.width, "Press Space To Play");
			instructions.setFormat (null, 14, 0xFFFFFFFF, "center");
			instructions.alpha = 0.0;
			add(instructions);
			
			
			// other menu options, like music, controls
			menu_options = new FlxText(0, FlxG.height - 74, FlxG.width, "Press x To Enter Menu Options");
			menu_options.setFormat (null, 14, 0xFFFFFFFF, "center");
			menu_options.alpha = 0.0;
			add(menu_options);
			
			// Help state
			help = new FlxText(0, FlxG.height - 60, FlxG.width, "Press c To Enter Controls");
			help.setFormat (null, 14, 0xFFFFFFFF, "center");
			help.alpha = 0.0;
			add(help);

			timer = -20;
			fadeIn = new FlxFadeIn();
			fadeIn.start(0xFF000000, 3, function():void
			{
				timer = 30;
				defaultGroup.add(new Logo());
				fadeIn.stop();
			});
			defaultGroup.add(fadeIn);

			FlxG.playMusic(Context.getResources().getSound("menu"));
		}
		
		override public function update():void
		{
			if (instructions.alpha == 1.0) {
				if (FlxG.keys.justPressed("SPACE") && timer == 0)
				{
					timer = -1;
					var fadeOut:FlxFade = new FlxFade();
					fadeOut.start(0xFF000000, 1, function():void
					{
						parent.removeChild(background);
						FlxG.state = new InventoryState();
					});
					defaultGroup.add(fadeOut);
				}  
				if (FlxG.keys.justPressed("C"))
				{
					timer = -1;
					var fadeOut:FlxFade = new FlxFade();
					fadeOut.start(0xFF000000, 1, function():void
					{
						parent.removeChild(background);
						FlxG.state = new Controls();
					});
					defaultGroup.add(fadeOut);
				}
					
			}

			if (timer > 0) {
				--timer;
			} else if (timer > -10) {
				if (instructions.alpha < 1.0) {
					instructions.alpha += 0.05;
					menu_options.alpha += 0.05;
					help.alpha += 0.05;
					if (instructions.alpha > 1.0) {
						instructions.alpha = 1.0;
						menu_options.alpha = 1.0;
						help.alpha = 1.0;
					}
				}
			}

			super.update();
		}
 
 
		public function MenuState()
		{
			super();

		}
 
	}
}