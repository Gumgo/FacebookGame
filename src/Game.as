package  
{
	import org.flixel.*;
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]	

	public class Game extends FlxGame 
	{
		public function Game():void
		{
			super(640, 680, InitState, 1);
		}
	}

}