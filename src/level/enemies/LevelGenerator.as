package level.enemies 
{
	import level.definitions.LevelDefinition;
	import level.LevelState;
	import org.flixel.FlxG;

	public class LevelGenerator 
	{
		private var half1Fleets:Vector.<String>;	// the fleets to appear before the miniboss
		private var half2Fleets:Vector.<String>;	// the fleets to appear after the miniboss
		private var fleetCount:int;					// the number of fleets to appear before/after miniboss
		private var boss:String;					// the boss fleet

		private var currentFleetCount:int;	// the current number of fleets that have appeared
		private var half:Boolean;			// true if the level halfway point has been passed
		private var last:Boolean;			// true if this is the last fleet

		private var prevFleet:String;	// the previous fleet

		private var currentFleets:Vector.<Fleet>;	// vector of current fleets
		private var nextFleetTimer:int;				// time until next fleet

		private var enemyCount:int;	// current enemy count

		private var endTimer:int;	// counts down once the level is beaten

		private var fleetCounter:int;	// the total fleet count

		private const FLEET_OVERLAP_TIME:int = 30;
		private const FLEET_OVERLAP_RANDOM:int = 60;
		private const FLEET_MIN_ENEMIES:int = 5;

		public function LevelGenerator(level:int)
		{
			var levelDefinition:LevelDefinition = Context.getGameData().getLevelDefinition(level);

			half1Fleets = levelDefinition.getFirstHalfFleets();
			half2Fleets = levelDefinition.getSecondHalfFleets();
			fleetCount = levelDefinition.getFleetCount();
			boss = levelDefinition.getBoss();

			currentFleetCount = 0;
			half = false;
			last = false;
			prevFleet = "";

			enemyCount = 0;

			endTimer = -10;

			currentFleets = new Vector.<Fleet>();
		}

		public function start():void
		{
			endTimer = -1;
			fleetCounter = 0;
		}

		public function decEnemies():void {
			--enemyCount;
		}

		public function fleetFinished(fleet:Fleet):void
		{
			var index:int = currentFleets.indexOf(fleet, 0);
			if (index >= 0) {
				currentFleets[index] = currentFleets[currentFleets.length - 1];
				currentFleets.pop();
			}
		}

		/**
		 * Called each tick; propogates the update to the current fleets
		 */
		public function update():void
		{
			if (endTimer == -1) {
				for (var i:int = 0; i < currentFleets.length; ++i) {
					currentFleets[i].update();
				}

				if (nextFleetTimer > 0) {
					--nextFleetTimer
				}

				if (enemyCount == 0 || (enemyCount < FLEET_MIN_ENEMIES && nextFleetTimer == 0 && !last)) {
					nextFleetTimer = FLEET_OVERLAP_TIME + Math.random() * FLEET_OVERLAP_RANDOM;
					var nextFleet:Fleet = getNextFleet();
					if (nextFleet == null) {
						endTimer = -2;
					} else {
						currentFleets.push(nextFleet);
						enemyCount += nextFleet.getRemainingEnemies();
					}
				}
			} else if (endTimer == -2) {
				if ((FlxG.state as LevelState).getEnemyGroup().countLiving() <= 0) {
					endTimer = 120;
				}
			} else if (endTimer > 0) {
				--endTimer;
			} else if (endTimer == 0) {
				// don't end until ALL enemies and items are gone - we don't want you dying but completing the level
				if ((FlxG.state as LevelState).getEnemyBulletGroup().countLiving() <= 0 &&
					(FlxG.state as LevelState).getEnemyGroup().countLiving() <= 0 &&
					(FlxG.state as LevelState).getItemGroup().countLiving() <= 0) {
					(FlxG.state as LevelState).levelFinished();
					endTimer = -10;
				}
			}
		}
		
		/**
		 * @return the next fleet, or null if we're done.
		 */
		private function getNextFleet():Fleet
		{
			if (last) {
				return null;
			}

			if (currentFleetCount == fleetCount) {
				currentFleetCount = 0;
				prevFleet = "";
				if (!half) {
					half = true;
				} else {
					last = true;
					if (boss != null) {
						return (Context.getRecycler().getNew(Fleet) as Fleet).resetMe(this, Context.getGameData().getFleetDefinition(boss), fleetCounter, true);
						++fleetCounter;
					} // else continue on
				}
			}

			++currentFleetCount;
			var arrayLength:int = half ? half2Fleets.length : half1Fleets.length;
			var array:Vector.<String> = half ? half2Fleets : half1Fleets;

			var index:int = Math.floor(Math.random() * arrayLength);
			if (array[index] == prevFleet) {
				var indexToSkip:int = index;
				index = Math.floor(Math.random() * (arrayLength - 1));
				if (index == indexToSkip) {
					index = arrayLength - 1;
				}
			}

			// back up the indices
			prevFleet = array[index];

			return (Context.getRecycler().getNew(Fleet) as Fleet).resetMe(this, Context.getGameData().getFleetDefinition(array[index]), fleetCounter);
			++fleetCounter;
		}
	}

}