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
		private var invincible:Boolean;

		private var items:Vector.<String>;
		private var dropRates:Vector.<Number>;
		private var strengths:Vector.<Number>;

		private var damageTimer:int;

		private var done:Boolean;
		private var bullet:Boolean;

		public function Enemy(parent:Fleet, definition:EnemyDefinition, behavior:Behavior, bullet:Boolean = false)
		{
			this.parent = parent;
			this.behavior = behavior;
			super(0, 0, Context.getResources().getSprite(definition.getSprite()));

			this.bullet = bullet;

			deathSprite = Context.getResources().getSprite(definition.getDeathSprite());
			deathSound = null;//Context.getResources().getSound(definition.getDeathSound());
			enemyHealth = definition.getHealth();
			color = definition.getColor();
			damage = definition.getDamage();
			deathOnPlayerCollision = definition.getDeathOnPlayerCollision();
			invincible = definition.getInvincible();

			items = definition.getItems();
			dropRates = definition.getDropRates();
			strengths = definition.getStrengths();

			behavior.init(this);

			damageTimer = 0;

			done = false;

			if (bullet) {
				(FlxG.state as LevelState).getEnemyBulletGroup().add(this);
			} else {
				(FlxG.state as LevelState).getEnemyGroup().add(this);
			}
		}

		override public function update():void
		{
			if (damageTimer > 0) {
				--damageTimer;
			}
			if (enemyHealth > 0) {
				behavior.update(this);
			} else if (finished) {
				if (bullet) {
					(FlxG.state as LevelState).getEnemyBulletGroup().remove(this);
				} else {
					(FlxG.state as LevelState).getEnemyGroup().remove(this);
				}
			}
			super.update();
		}

		public function damagePlayer(player:Player):void
		{
			if (damageTimer == 0) {
				if (enemyHealth > 0) {
					player.adjustHealth( -damage);
				}
				damageTimer = 10;
			}
		}

		public function onHitPlayer():void
		{
			if (deathOnPlayerCollision && enemyHealth > 0) {
				enemyHealth = 0;
				onDie();
			}
		}

		public function onHit(bullet:PlayerBullet):void
		{
			if (!invincible) {
				if (enemyHealth > 0) {
					enemyHealth -= bullet.getDamage();
					if (enemyHealth <= 0) {
						onDie();
					}
					bullet.hit();
				}
			}
		}

		public function onDie():void
		{
			x += width / 2;
			y += height / 2;

			loadGraphic(deathSprite, true);
			var frames:Array = new Array();
			for (var f:uint = 0; f < _pixels.width / _pixels.height; ++f) {
				frames[f] = f;
			}
			addAnimation("die", frames, 30, false);
			play("die");

			x -= width / 2;
			y -= height / 2;

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
			if (parent != null) {
				parent.enemyFinished();
			}

			done = true;

			if (enemyHealth > 0) {
				if (bullet) {
					(FlxG.state as LevelState).getEnemyBulletGroup().remove(this);
				} else {
					(FlxG.state as LevelState).getEnemyGroup().remove(this);
				}
			}
		}

		public function isFinished():Boolean
		{
			return done;
		}

	}

}