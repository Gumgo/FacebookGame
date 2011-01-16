package level.enemies 
{
	import level.definitions.LevelDefinition;

	public class LevelGenerator 
	{
		private var half1Waves:Vector.<String>;	// the waves to appear before the miniboss
		private var half2Waves:Vector.<String>;	// the waves to appear after the miniboss
		private var waveCount:int;				// the number of waves to appear before/after miniboss
		private var miniBoss:String;			// the miniboss wave
		private var boss:String;				// the boss wave

		private var currentWaveCount:int;	// the current number of waves that have appeared
		private var half:Boolean;			// true if the miniboss has been passed
		private var last:Boolean;			// true if this is the last wave

		private var prevWave1:int;	// the previous wave
		private var prevWave2:int;	// the wave before the previous wave

		private var currentWave:Wave;	// the currently active wave

		public function LevelGenerator(level:int)
		{
			var levelDefinition:LevelDefinition = Context.getGameData().getLevelDefinition(level);

			half1Waves = levelDefinition.getFirstHalfWaves();
			half2Waves = levelDefinition.getSecondHalfWaves();
			waveCount = levelDefinition.getWaveCount();
			miniBoss = levelDefinition.getMiniBoss();
			boss = levelDefinition.getBoss();

			currentWaveCount = 0;
			half = false;
			last = false;
			prevWave1 = -1;
			prevWave2 = -1;

			currentWave = null;
		}

		public function start():void
		{
			currentWave = getNextWave();
			currentWave.start();
		}

		/**
		 * Starts the next wave.
		 * @todo Make it so that after the last wave, something happens.
		 */
		public function waveFinished():void
		{
			currentWave = getNextWave();
			if (currentWave == null) {
				// do something
			} else {
				currentWave.start();
			}
		}

		/**
		 * Called each tick; propogates the update to the current wave
		 */
		public function update():void
		{
			if (currentWave != null) {
				currentWave.update();
			}
		}
		
		/**
		 * @return the next wave, or null if we're done.
		 */
		private function getNextWave():Wave
		{
			if (last) {
				return null;
			}

			if (currentWaveCount == waveCount) {
				currentWaveCount = 0;
				prevWave1 = -1;
				prevWave2 = -1;
				if (!half) {
					half = true;
					if (miniBoss != null) {
						return new Wave(this, Context.getGameData().getWaveDefinition(miniBoss));
					} // else continue on
				} else {
					last = true;
					if (boss != null) {
						return new Wave(this, Context.getGameData().getWaveDefinition(boss));
					} // else continue on
				}
			}

			++currentWaveCount;
			var index:int;
			var arrayLength:int = half ? half2Waves.length : half1Waves.length;

			if (prevWave1 != -1 && prevWave1 == prevWave2) {
				// make sure we don't get 3 of the same wave in a row
				// generate an index ranging from [0,n-1)
				index = Math.floor(Math.random() * (arrayLength - 1));
				// if the index falls on the one we don't want, select the last one instead
				if (index == prevWave1)
					index = arrayLength - 1;
			} else {
				index = Math.floor(Math.random() * arrayLength);
			}
			
			// back up the indices
			prevWave2 = prevWave1;
			prevWave1 = index;

			if (!half) {
				return new Wave(this, Context.getGameData().getWaveDefinition(half1Waves[index]));
			} else {
				return new Wave(this, Context.getGameData().getWaveDefinition(half2Waves[index]));
			}
		}
	}

}