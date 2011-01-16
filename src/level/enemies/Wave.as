package level.enemies 
{
	import level.definitions.WaveDefinition;

	public class Wave 
	{
		private var parent:LevelGenerator;
		private var fleets:Vector.<String>;
		private var times:Vector.<int>;

		private var remaining:int;	// the number of remaining fleets
		private var tick:int;		// the current tick

		private var activeFleets:Vector.<Fleet>;	// the active fleets

		/**
		 * @param	parent the parent wave.
		 * @param	fleets a list of fleets.
		 * @param	times a list of times for these fleets.
		 */
		public function Wave(parent:LevelGenerator, definition:WaveDefinition)
		{
			this.parent = parent;
			this.fleets = definition.getFleets();
			this.times = definition.getTimes();

			activeFleets = new Vector.<Fleet>();
		}

		/**
		 * Starts the Wave.
		 */
		public function start():void
		{
			remaining = fleets.length;
			tick = 0;
		}

		/**
		 * Called each tick by the parent LevelGenerator.
		 */
		public function update():void
		{
			for (var i:int = 0; i < times.length; ++i) {
				if (times[i] == tick) {
					var newFleet:Fleet = new Fleet(this, Context.getGameData().getFleetDefinition(fleets[i]));
					activeFleets.push(newFleet);
				}
			}

			for (var t:int = 0; t < activeFleets.length; ++t) {
				activeFleets[t].update();
			}
			++tick;
		}

		/**
		 * Called by a Fleet when it is finished.
		 */
		public function fleetFinished(fleet:Fleet):void
		{
			// remove the fleet first
			for (var i:int = 0; i < activeFleets.length; ++i) {
				if (activeFleets[i] == fleet) {
					activeFleets[i] = activeFleets[activeFleets.length - 1];
					activeFleets.pop();
					break;
				}
			}

			--remaining;
			if (remaining == 0) {
				parent.waveFinished();
			}
		}

	}

}