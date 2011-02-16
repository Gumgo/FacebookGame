package menu
{
	import help.HelpState;
	import inventory.InventoryState;
	import org.flixel.*;
	import flash.display.MovieClip;
	import org.flixel.data.FlxFade;
 
	public class MenuState extends FlxState
	{
		private var background:MovieClip;
		private var timer:int;
		private var instructions:FlxText;
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

			instructions = new FlxText(0, FlxG.height * 0.75, FlxG.width, "Press space to play");
			instructions.setFormat(null, 20, 0xFFFFFFFF, "center");
			instructions.alpha = 0.0;
			add(instructions);

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
				if (FlxG.keys.justPressed("SPACE") && timer == 0) {
					timer = -1;
					var fadeOut:FlxFade = new FlxFade();
					fadeOut.start(0xFF000000, 1, function():void
					{
						parent.removeChild(background);
						if (Context.getPersistentState().isNewUser()) {
							Context.getPersistentState().setNewUser(false);
							FlxG.state = new HelpState();
						} else {
							FlxG.state = new InventoryState();
						}
					});
					defaultGroup.add(fadeOut);
				}
			}

			if (timer > 0) {
				--timer;
			} else if (timer > -10) {
				if (instructions.alpha < 1.0) {
					instructions.alpha += 0.05;
					if (instructions.alpha > 1.0) {
						instructions.alpha = 1.0;
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