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
		private var hitSound:Class;
		private var deathColor:uint;
		private var enemyHealth:int;
		private var damage:int;
		private var deathOnPlayerCollision:Boolean;
		private var invincible:Boolean;

		private var damageTimer:int;

		private var done:Boolean;
		private var bullet:Boolean;
		private var drops:Boolean;
		private var boss:Boolean;

		public function Enemy()
		{
			super();
		}

		public function resetMe(parent:Fleet, definition:EnemyDefinition, behavior:Behavior, bullet:Boolean = false, drops:Boolean = true, boss:Boolean = false):Enemy
		{
			exists = true;
			this.parent = parent;
			this.behavior = behavior;
			offset.x = offset.y = 0;
			x = y = 0;
			alpha = 1;
			color = 0xFFFFFF;
			_animations.length = 0;
			angle = 0;
			visible = true;
 			if  (definition.getRotate()) {
				loadRotatedGraphic(Context.getResources().getSprite(definition.getSprite()), 16, -1, false, true);
				offset.x = offset.y = (width - (width / 1.5)) * 0.5;
				width = height = width / 1.5;
			} else {
				loadGraphic(Context.getResources().getSprite(definition.getSprite()));
			}

			this.bullet = bullet;
			this.drops = drops;
			this.boss = boss;

			deathSprite = Context.getResources().getSprite(definition.getDeathSprite());
			deathSound = Context.getResources().getSound(definition.getDeathSound());
			hitSound = Context.getResources().getSound("exp#8");
			deathColor = definition.getDeathColor();
			enemyHealth = definition.getHealth();
			color = definition.getColor();
			damage = definition.getDamage();
			deathOnPlayerCollision = definition.getDeathOnPlayerCollision();
			invincible = definition.getInvincible();

			behavior.init(this);

			damageTimer = 0;

			done = false;

			if (bullet) {
				Recycler.addToGroup((FlxG.state as LevelState).getEnemyBulletGroup(), this);
			} else {
				Recycler.addToGroup((FlxG.state as LevelState).getEnemyGroup(), this);
			}

			return this;
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
					Context.getRecycler().recycle(this);
					Context.getRecycler().recycle(behavior);
					exists = false;
				} else {
					(FlxG.state as LevelState).getEnemyGroup().remove(this);
					Context.getRecycler().recycle(this);
					Context.getRecycler().recycle(behavior);
					exists = false;
				}
			}
			super.update();
		}

		public function damagePlayer(player:Player):void
		{
			if (damageTimer == 0 && damage > 0) {
				if (enemyHealth > 0) {
					player.adjustHealth( -damage);
				}
				damageTimer = 10;

				if (!bullet) {
					// create an explosion
					var avgX:Number = (x + width * 0.5 + player.x + player.width * 0.5) * 0.5;
					var avgY:Number = (y + height * 0.5 + player.y + player.height * 0.5) * 0.5;
					(Context.getRecycler().getNew(Explosion) as Explosion).resetMe(avgX, avgY);
				}
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
					bullet.hit();
					FlxG.play(hitSound, 0.8);
					enemyHealth -= bullet.getDamage();
					if (enemyHealth <= 0) {
						onDie();
					}
				}
			}
		}

		public function onDie():void
		{
			visible = true;
			enemyHealth = 0;

			x += width * 0.5;
			y += height * 0.5;

			offset.x = offset.y = 0;

			loadGraphic(deathSprite, true);
			var frames:Array = new Array();
			for (var f:uint = 0; f < _pixels.width / _pixels.height; ++f) {
				frames[f] = f;
			}
			addAnimation("die", frames, 30, false);
			play("die", true);
			color = deathColor;

			x -= width * 0.5;
			y -= height * 0.5;

			if (!bullet && drops) {
				(FlxG.state as LevelState).getItemGenerator().randomSpawn(x + width * 0.5, y + height * 0.5, boss, !boss);
			}

			FlxG.play(deathSound);

			behavior.die(this);

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
					Context.getRecycler().recycle(this);
					Context.getRecycler().recycle(behavior);
					exists = false;
				} else {
					(FlxG.state as LevelState).getEnemyGroup().remove(this);
					Context.getRecycler().recycle(this);
					Context.getRecycler().recycle(behavior);
					exists = false;
				}
			}
		}

		public function isFinished():Boolean
		{
			return done;
		}

		public function getBehavior():Behavior
		{
			return behavior;
		}

		public function getDamage():int
		{
			return damage;
		}

		public function setDamage(dmg:int):void
		{
			damage = dmg;
		}

		public function setInvincible(inv:Boolean):void
		{
			invincible = inv;
		}

		public function getFleetId():int
		{
			if (parent == null) {
				return -1;
			} else {
				return parent.getId();
			}
		}

	}

}