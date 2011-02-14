package level.enemies 
{
	import flash.utils.Dictionary;

	public class Behavior 
	{

		private var properties:Dictionary;

		public function Behavior()
		{
		}

		protected function resetMeSuper(properties:Dictionary):Behavior
		{
			this.properties = properties;
			return this;
		}

		public function init(enemy:Enemy):void
		{
			throw new Error("init was not overridden in a class derived from Behavior");
		}

		public function update(enemy:Enemy):void
		{
			throw new Error("update was not overridden in a class derived from Behavior");
		}

		// optional - triggered when enemy dies
		public function die(enemy:Enemy):void
		{
		}

		/**
		 * Used to access properties in derived classes.
		 * @param	key the property name.
		 * @return	the value associated with key.
		 */
		protected function getProperty(key:String):String
		{
			return properties[key] as String;
		}
		
	}

}