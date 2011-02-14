package level 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class HealthBar extends FlxSprite 
	{
		private var healthBarWidth:int;

		private var healthBarLeft:BitmapData;
		private var healthBarRight:BitmapData;
		private var healthBarTop:BitmapData;
		private var healthBarBottom:BitmapData;

		private var matrix:Matrix;
		private var colorTf:ColorTransform;
		private var colorTf2:ColorTransform;

		private static const PADDING:int = 4;

		public function HealthBar() 
		{
			super(0, 0, Context.getResources().getSprite("healthBar"));
			alpha = 0.75;
			healthBarLeft = FlxG.addBitmap(Context.getResources().getSprite("healthBarLeft"));
			healthBarRight = FlxG.addBitmap(Context.getResources().getSprite("healthBarRight"));
			healthBarTop = FlxG.addBitmap(Context.getResources().getSprite("healthBarTop"));
			healthBarBottom = FlxG.addBitmap(Context.getResources().getSprite("healthBarBottom"));

			healthBarWidth = (FlxG.width - PADDING * 2 - healthBarLeft.width - healthBarRight.width) *
				Context.getPersistentState().getCurrentHealth() / PersistentState.HEALTH_MAX;
			// align to 2 pixels
			healthBarWidth = (healthBarWidth + 1) & (~1);

			matrix = new Matrix();
			colorTf = new ColorTransform();
			colorTf2 = new ColorTransform(1, 1, 1, 0.25);
			x = FlxG.width * 0.5;
			updateHealth(1.0);
		}

		public function updateHealth(ratio:Number):void
		{
			scale.x = ratio * healthBarWidth;
			colorTf.greenMultiplier = ratio;
			colorTf.redMultiplier = 1.0 - ratio;
			colorTf.blueMultiplier = 0.0;
		}

		override public function render():void
		{
			matrix.identity();
			matrix.translate(FlxG.width * 0.5 - healthBarWidth * 0.5 - healthBarLeft.width, PADDING);
			FlxG.buffer.draw(healthBarLeft, matrix);

			matrix.tx = FlxG.width * 0.5 + healthBarWidth * 0.5;
			FlxG.buffer.draw(healthBarRight, matrix);

			matrix.identity();
			matrix.scale(healthBarWidth, 1);
			matrix.translate(FlxG.width * 0.5 - healthBarWidth * 0.5, PADDING);
			FlxG.buffer.draw(healthBarTop, matrix);
			matrix.translate(0, healthBarTop.height + height);
			FlxG.buffer.draw(healthBarBottom, matrix);

			matrix.identity();
			matrix.scale(scale.x, 1);
			matrix.translate(FlxG.width * 0.5 - healthBarWidth * 0.5, PADDING + healthBarTop.height);
			FlxG.buffer.draw(pixels, matrix, colorTf);

			matrix.identity();
			matrix.scale(healthBarWidth - scale.x, 1);
			matrix.translate(FlxG.width * 0.5 - healthBarWidth * 0.5 + scale.x, PADDING + healthBarTop.height);
			FlxG.buffer.draw(pixels, matrix, colorTf2);
		}
	}

}