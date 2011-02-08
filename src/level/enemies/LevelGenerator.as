package level.enemies 
{
	import level.definitions.LevelDefinition;
	import level.LevelState;
	import org.flixel.FlxG;

	public class LevelGenerator 
	{
		private var half1Waves:Vector.<String>;	// the waves to appear before the miniboss
		private var half2Waves:Vector.<String>;	// the waves to appear after the miniboss
		private var waveCount:int;				// the number of waves to appear before/after miniboss
		private var boss:String;				// the boss wave

		private var currentWaveCount:int;	// the current number of waves that have appeared
		private var half:Boolean;			// true if the miniboss has been passed
		private var last:Boolean;			// true if this is the last wave

		private var prevWave1:int;	// the previous wave
		private var prevWave2:int;	// the wave before the previous wave

		private var currentWave:Wave;	// the currently active wave

		private var endTimer:int;	// counts down once the level is beaten

		public function LevelGenerator(level:int)
		{
			var levelDefinition:LevelDefinition = Context.getGameData().getLevelDefinition(level);

			half1Waves = levelDefinition.getFirstHalfWaves();
			half2Waves = levelDefinition.getSecondHalfWaves();
			waveCount = levelDefinition.getWaveCount();
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
		 */
		public function waveFinished():void
		{
			currentWave = getNextWave();
			if (currentWave == null) {
				endTimer = 120;
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
			} else {
				if (endTimer > 0) {
					--endTimer;
				} else if (endTimer == 0) {
					// don't end until ALL enemies are gone - we don't want you dying but completing the level
					if ((FlxG.state as LevelState).getEnemyBulletGroup().countLiving() <= 0 &&
						(FlxG.state as LevelState).getEnemyGroup().countLiving() <= 0) {
						(FlxG.state as LevelState).levelFinished();
						endTimer = -1;
					}
				}
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
				} else {
					last = true;
					if (boss != null) {
						return (Context.getRecycler().getNew(Wave) as Wave).resetMe(this, Context.getGameData().getWaveDefinition(boss));
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
				return (Context.getRecycler().getNew(Wave) as Wave).resetMe(this, Context.getGameData().getWaveDefinition(half1Waves[index]));
			} else {
				return (Context.getRecycler().getNew(Wave) as Wave).resetMe(this, Context.getGameData().getWaveDefinition(half2Waves[index]));
			}
		}
	}

}