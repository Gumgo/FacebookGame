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
		private var miniBoss:String;
		private var secondHalfWaves:Vector.<String>;
		private var boss:String;

		public function LevelDefinition(waveCount:int, firstHalfWaves:Vector.<String>, miniBoss:String, secondHalfWaves:Vector.<String>, boss:String)
		{
			this.waveCount = waveCount;
			this.firstHalfWaves = firstHalfWaves;
			this.miniBoss = miniBoss;
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

		public function getMiniBoss():String
		{
			return miniBoss;
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