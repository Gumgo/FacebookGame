package level.definitions 
{
	/**
	 * ...
	 * @author Ben
	 */
	public class LevelDefinition 
	{

		private var fleetCount:int;
		private var firstHalfFleets:Vector.<String>;
		private var secondHalfFleets:Vector.<String>;
		private var boss:String;

		public function LevelDefinition(fleetCount:int, firstHalfFleets:Vector.<String>, secondHalfFleets:Vector.<String>, boss:String)
		{
			this.fleetCount = fleetCount;
			this.firstHalfFleets = firstHalfFleets;
			this.secondHalfFleets = secondHalfFleets;
			this.boss = boss;
		}

		public function getFleetCount():int
		{
			return fleetCount;
		}

		public function getFirstHalfFleets():Vector.<String>
		{
			return firstHalfFleets;
		}

		public function getSecondHalfFleets():Vector.<String>
		{
			return secondHalfFleets;
		}

		public function getBoss():String
		{
			return boss;
		}
		
	}

}