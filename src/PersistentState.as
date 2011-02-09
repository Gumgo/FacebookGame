package  
{
	public class PersistentState 
	{
		public static const ELEM_UNENCOUNTERED:int = 0;
		public static const ELEM_ENCOUNTERED:int = 1;
		public static const ELEM_COLLECTED:int = 2;

		public static const HEALTH_MIN:int = 100;
		public static const HEALTH_MAX:int = 300;
		public static const SHIELDS_MIN:Number = 1.0;
		public static const SHIELDS_MAX:Number = 2.0;
		public static const DAMAGE_MIN:Number = 1.0;
		public static const DAMAGE_MAX:Number = 3.0;
		public static const SHOTRATE_MIN:Number = 1.0;
		public static const SHOTRATE_MAX:Number = 2.0;

		private static var currentHealth:int;
		private static var currentShields:Number;
		private static var currentDamage:Number;
		private static var currentShotRate:Number;

		private var elements:Array;

		public function PersistentState() 
		{
			elements = new Array();
			reset();
		}

		public function reset():void
		{
			for (var i:int = 0; i < 118; ++i) {
				elements[i] = ELEM_UNENCOUNTERED;
			}
		}

		public function setElementState(element:int, state:int):void
		{
			elements[element-1] = state;
		}

		public function getElementState(element:int):int
		{
			return elements[element-1];
		}

		public function computeStats():void
		{
			var currentHealthElements:int = 0;
			var maxHealthElements:int = 0;
			var currentShieldsElements:int = 0;
			var maxShieldsElements:int = 0;
			var currentDamageElements:int = 0;
			var maxDamageElements:int = 0;
			var currentShotRateElements:int = 0;
			var maxShotRateElements:int = 0;
			for (var i:int = 0; i < 118; ++i) {
				var inc:int = elements[i] == ELEM_COLLECTED ? 1 : 0;
				var group:String = Context.getGameData().getElementDefinition(i + 1).getGroup();
				if (		group == "Non-Metal" ||
							group == "Noble Gas") {
					++maxHealthElements;
					currentHealthElements += inc;
				} else if (	group == "Alkali Metal" ||
							group == "Alkali Earth Metal" ||
							group == "Halogen" ||
							group == "Actinide") {
					++maxDamageElements;
					currentDamageElements += inc;
				} else if (	group == "Other Metal" ||
							group == "Transition Metal") {
					++maxShieldsElements;
					currentShieldsElements += inc;
				} else if (	group == "Lanthanide") {
					++maxShotRateElements;
					currentShotRateElements += inc;
				} else if (	group == "Unknown") {
					// secret bonus
				} else {
					throw new Error("Unknown element group");
				}
			}

			currentHealth = int(MathExt.lerp(HEALTH_MIN, HEALTH_MAX, Number(currentHealthElements) / Number(maxHealthElements)));
			currentShields = MathExt.lerp(SHIELDS_MIN, SHIELDS_MAX, Number(currentShieldsElements) / Number(maxShieldsElements));
			currentDamage = MathExt.lerp(DAMAGE_MIN, DAMAGE_MAX, Number(currentDamageElements) / Number(maxDamageElements));
			currentShotRate = MathExt.lerp(SHOTRATE_MIN, SHOTRATE_MAX, Number(currentShotRateElements) / Number(maxShotRateElements));
		}

		public function getCurrentHealth():int
		{
			return currentHealth;
		}

		public function getCurrentShields():Number
		{
			return currentShields;
		}

		public function getCurrentDamage():Number
		{
			return currentDamage;
		}

		public function getCurrentShotRate():Number
		{
			return currentShotRate;
		}

	}

}