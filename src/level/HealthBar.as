package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class HealthBar extends FlxSprite 
	{
		private var healthBarWidth:int;

		public function HealthBar() 
		{
			super(0, 0, Context.getResources().getSprite("healthBar"));
			alpha = 0.75;
			healthBarWidth = FlxG.width * Context.getPersistentState().getCurrentHealth() / PersistentState.HEALTH_MAX;
			x = FlxG.width * 0.5;
			updateHealth(1.0);
		}

		public function updateHealth(ratio:Number):void
		{
			scale.x = ratio * healthBarWidth;
			var amountGreen:uint = uint(0xFF * ratio);
			var amountRed:uint = uint(0xFF * (1.0 - ratio));
			color = ((amountRed << 16) | (amountGreen << 8));
		}
		
	}

}