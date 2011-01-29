package level
{
	import level.weapons.DefaultWeapon;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import level.enemies.Enemy;

	public class Player extends FlxSprite 
	{

		private var maxHealth:int;
		private var currentHealth:int;

		private var primaryWeapon:Weapon;
		private var secondaryWeapon:Weapon;

		private var endTimer:int;

		public function Player() 
		{
			maxHealth = 100;
			currentHealth = 100;

			super(FlxG.width / 2, FlxG.height / 2, Context.getResources().getSprite("player"));
			x -= width / 2;
			y -= height / 2;

			primaryWeapon = new DefaultWeapon();
		}

		override public function update():void
		{
			if (!dead) {
				primaryWeapon.update();
				if (secondaryWeapon != null) {
					secondaryWeapon.update();
				}

				if (FlxG.keys.LEFT) {
					x -= 8;
				}
				if (FlxG.keys.RIGHT) {
					x += 8;
				}
				if (FlxG.keys.UP) {
					y -= 8;
				}
				if (FlxG.keys.DOWN) {
					y += 8;
				}
				if (FlxG.keys.SPACE) {
					primaryWeapon.shoot(this);
					if (secondaryWeapon != null) {
						secondaryWeapon.shoot(this);
					}
				}

				if (x < 0) {
					x = 0;
				}

				if (x > FlxG.width - width) {
					x = FlxG.width - width;
				}

				if (y < 0) {
					y = 0;
				}

				if (y > FlxG.height - height) {
					y = FlxG.height - height;
				}
			} else {
				if (endTimer > 0) {
					--endTimer;
				} else if (endTimer == 0) {
					(FlxG.state as LevelState).levelFailed();
					endTimer = -1;
				}
			}

			super.update();
		}

		public function onHit(enemy:Enemy):void
		{
			enemy.damagePlayer(this);
		}

		public function adjustHealth(amount:int):void
		{
			if (dead) {
				return;
			}

			var prevHealth:int = currentHealth;
			currentHealth += amount;

			if (amount > 0) {
				// green screen flash
			} else if (amount < 0) {
				// red screen flash
				var ratio1:Number = Number(prevHealth) / Number(maxHealth);
				var ratio2:Number = Number(currentHealth) / Number(maxHealth);
				if (ratio1 > 0.15 && ratio2 <= 0.15) {
					(FlxG.state as LevelState).getLevelText().setText("Warning: health is low", 0xFF0000, 30);
				}
			}

			if (currentHealth > maxHealth) {
				currentHealth = maxHealth;
			}

			if (currentHealth < 0) {
				currentHealth = 0;
			}

			(FlxG.state as LevelState).getHealthBar().updateHealth(currentHealth / maxHealth);

			if (currentHealth == 0) {
				onDie();
			}
		}

		public function onDie():void
		{
			loadGraphic(Context.getResources().getSprite("explosion"), true);
			addAnimation("die", [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
			play("die");
			dead = true;

			endTimer = 120;
		}

		public function setSecondaryWeapon(weapon:Weapon):void
		{
			secondaryWeapon = weapon;
		}

	}

}