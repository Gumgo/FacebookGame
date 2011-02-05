package  
{
	/**
	 * Extended math
	 * @author Ben
	 */
	public class MathExt 
	{
		
		public static function sign(value:Number):int {
			return value == 0 ? 0 : (value > 0 ? 1 : -1);
		}

		// lerps between a and b by c
		public static function lerp(a:Number, b:Number, c:Number):Number {
			return a + (b - a) * c;
		}
		
	}

}