package level.definitions 
{
	/**
	 * ...
	 * @author Ben
	 */
	public class LevelDefinition 
	{

		private var waveCount:int;
		private var firstHalfWaves:Vector.<String>;
		private var secondHalfWaves:Vector.<String>;
		private var boss:String;

		public function LevelDefinition(waveCount:int, firstHalfWaves:Vector.<String>, secondHalfWaves:Vector.<String>, boss:String)
		{
			this.waveCount = waveCount;
			this.firstHalfWaves = firstHalfWaves;
			this.secondHalfWaves = secondHalfWaves;
			this.boss = boss;
		}

		public function getWaveCount():int
		{
			return waveCount;
		}

		public function getFirstHalfWaves():Vector.<String>
		{
			return firstHalfWaves;
		}

		public function getSecondHalfWaves():Vector.<String>
		{
			return secondHalfWaves;
		}

		public function getBoss():String
		{
			return boss;
		}
		
	}

}