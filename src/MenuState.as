package
{
	import level.LevelState;
	import org.flixel.*;
 
	public class MenuState extends FlxState
	{
		override public function create():void
		{
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "NUCLEOS");
			title.setFormat (null, 24, 0xFFFFFFFF, "center");
			add(title);
 
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 88, FlxG.width, "Press Space To Play");
			instructions.setFormat (null, 14, 0xFFFFFFFF, "center");
			add(instructions);
			
			
			// other menu options, like music, controls
			var menu_options:FlxText;
			menu_options = new FlxText(0, FlxG.height - 74, FlxG.width, "Press x To Enter Menu Options");
			menu_options.setFormat (null, 14, 0xFFFFFFFF, "center");
			add(menu_options);
			
			// Help state
			var help:FlxText;
			help = new FlxText(0, FlxG.height - 60, FlxG.width, "Press s To Enter Help Options");
			help.setFormat (null, 14, 0xFFFFFFFF, "center");
			add(help);
			
		} // end function create
 
		
	
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.state = new LevelState();
			}  /*else if ( FlxG.keys.justPressed("x")) {
				//FlxG.state = new FlxState();
			}  else {
				//FlxG.state = new FlxState();
			}
		*/
		} // end function update
 
 
		public function MenuState()
		{
			super();

		}  // end function MenuState
 
	} // end class
}// end package