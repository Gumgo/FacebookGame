package level.enemies
{
	import level.Item;
	import org.flixel.FlxG;
	import flash.utils.getDefinitionByName;
	import level.definitions.EnemyDefinition;
	import level.enemies.Behavior;
	import level.enemies.Fleet;
	import level.Player;
	import level.PlayerBullet;
	import level.LevelState;
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite 
	{
		private var parent:Fleet;
		private var behavior:Behavior;

		private var deathSprite:Class;
		private var deathSound:Class;
		private var enemyHealth:int;
		private var damage:int;
		private var deathOnPlayerCollision:Boolean;

		private var items:Vector.<String>;
		private var dropRates:Vector.<Number>;
		private var strengths:Vector.<Number>;

		public function Enemy(parent:Fleet, definition:EnemyDefinition, behavior:Behavior)
		{
			this.parent = parent;
			this.behavior = behavior;
			super(0, 0, Context.getResources().getSprite(definition.getSprite()));

			deathSprite = Context.getResources().getSprite(definition.getDeathSprite());
			deathSound = null;//Context.getResources().getSound(definition.getDeathSound());
			enemyHealth = definition.getHealth();
			color = definition.getColor();
			damage = definition.getDamage();
			deathOnPlayerCollision = definition.getDeathOnPlayerCollision();

			items = definition.getItems();
			dropRates = definition.getDropRates();
			strengths = definition.getStrengths();

			behavior.init(this);

			(FlxG.state as LevelState).getEnemyGroup().add(this);
			FlxG.state.defaultGroup.add(this);
		}

		override public function update():void
		{
			behavior.update(this);
		}

		public function damagePlayer(player:Player):void
		{
			player.adjustHealth(-damage);
		}

		public function onHit(bullet:PlayerBullet):void
		{
			enemyHealth -= bullet.getDamage();
			if (enemyHealth <= 0) {
				onDie();
			}
			bullet.hit();
		}

		public function onDie():void
		{
			// TODO: should switch to deathsprite here (or spawn a temporary object with deathsprite)

			var drop:Number = Math.random();
			var sum:Number = 0.0;
			for (var i:int = 0; i < items.length; ++i) {
				// go through all the possible drops
				sum += dropRates[i];
				if (drop < sum) {
					var Definition:Class = getDefinitionByName("level.items." + items[i]) as Class;
					new Definition(x + width / 2, y + width / 2, strengths[i]);
					break;
				}
			}

			enemyFinished();
		}

		/**
		 * This should be called at the end of onDie(); it is also called when the enemies goes off screen.
		 */
		public function enemyFinished():void
		{
			parent.enemyFinished();
			(FlxG.state as LevelState).getEnemyGroup().remove(this);
			FlxG.state.defaultGroup.remove(this);
		}

	}

}