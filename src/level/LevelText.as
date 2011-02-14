package level 
{
	import org.flixel.FlxText;
	import org.flixel.FlxG;

	public class LevelText extends FlxText
	{
		private var fade:int;

		public function LevelText() 
		{
			super(0, 64, FlxG.width);
			alignment = "center";
			size = 20;
			fade = 0;
		}

		override public function update():void
		{
			if (fade == 0 && alpha > 0.0) {
				alpha -= 0.0125;
				if (alpha < 0.0) {
					alpha = 0.0;
				}
			} else if (fade > 0) {
				--fade;
			}
		}

		public function setText(msg:String, color:uint, timeUntilFade:int = 0):void
		{
			text = msg;
			this.color = color;
			fade = timeUntilFade;
			alpha = 1.0;
		}
		
	}

}