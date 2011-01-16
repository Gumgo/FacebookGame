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

		public function Fleet(parent:Wave, definition:FleetDefinition)
		{
			this.parent = parent;
			this.enemies = definition.getEnemies();
			this.behaviors = definition.getBehaviors();
			this.behaviorProperties = definition.getBehaviorProperties();
			this.times = definition.getTimes();
			remaining = enemies.length;
			tick = 0;
		}

		public function update():void
		{
			for (var i:int = 0; i < times.length; ++i) {
				if (times[i] == tick) {
					var Definition:Class = getDefinitionByName("level.behaviors." + behaviors[i]) as Class;
					new Enemy(
						this,
						Context.getGameData().getEnemyDefinition(enemies[i]),
						new Definition(behaviorProperties[i]) as Behavior);
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
				parent.fleetFinished(this);
			}
		}
	}
}