package level.definitions 
{

	public class WaveDefinition 
	{

		private var name:String;
		private var fleets:Vector.<String>;
		private var times:Vector.<int>;

		public function WaveDefinition(name:String)
		{
			this.name = name;
			fleets = new Vector.<String>();
			times = new Vector.<int>();
		}

		public function addFleet(fleet:String, time:int):void
		{
			fleets.push(fleet);
			times.push(time);
		}

		public function getFleets():Vector.<String>
		{
			return fleets;
		}

		public function getTimes():Vector.<int>
		{
			return times;
		}
		
	}

}