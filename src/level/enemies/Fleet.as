package level.enemies 
{
	import org.flixel.FlxG;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import level.definitions.FleetDefinition;

	public class Fleet 
	{
		private var parent:Wave;
		private var enemies:Vector.<String>
		private var behaviors:Vector.<String>
		private var behaviorProperties:Vector.<Dictionary>
		private var times:Vector.<int>;

		private var remaining:int;
		private var tick:int;

		public function Fleet()
		{
		}

		public function resetMe(parent:Wave, definition:FleetDefinition):Fleet
		{
			this.parent = parent;
			this.enemies = definition.getEnemies();
			this.behaviors = definition.getBehaviors();
			this.behaviorProperties = definition.getBehaviorProperties();
			this.times = definition.getTimes();
			remaining = enemies.length;
			tick = 0;
			return this;
		}

		public function update():void
		{
			for (var i:int = 0; i < times.length; ++i) {
				if (times[i] == tick) {
					var Definition:Class = getDefinitionByName("level.behaviors." + behaviors[i]) as Class;
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						this,
						Context.getGameData().getEnemyDefinition(enemies[i]),
						(Context.getRecycler().getNew(Definition) as Definition).resetMe(behaviorProperties[i]));
				}
			}

			++tick;
		}

		/**
		 * Automatically called from Enemy when it goes off the screen or is killed.
		 */
		public function enemyFinished():void
		{
			--remaining;
			if (remaining == 0) {
				Context.getRecycler().recycle(this);
				parent.fleetFinished(this);
			}
		}
	}
}