package  
{
	public class PersistentState 
	{
		public static const ELEM_UNENCOUNTERED:int = 0;
		public static const ELEM_ENCOUNTERED:int = 1;
		public static const ELEM_COLLECTED:int = 2;

		private var elements:Array;

		public function PersistentState() 
		{
			elements = new Array();
			reset();
		}

		public function reset():void
		{
			for (var i:int = 0; i < 118; ++i) {
				//elements[i] = ELEM_UNENCOUNTERED;
				elements[i] = ELEM_COLLECTED;
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
		
	}

}