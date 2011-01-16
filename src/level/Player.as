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
		private var damageTimer:int;

		private var primaryWeapon:Weapon;
		private var secondaryWeapon:Weapon;

		public function Player() 
		{
			maxHealth = 100;
			currentHealth = 100;
			damageTimer = 0;

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

				if (damageTimer > 0) {
					--damageTimer;
				}
			}

			super.update();
		}

		public function onHit(enemy:Enemy):void
		{
			if (damageTimer == 0) {
				enemy.damagePlayer(this);
				damageTimer = 20;
			}
		}

		public function adjustHealth(amount:int):void
		{
			currentHealth += amount;

			if (amount > 0) {
				// green screen flash
			} else if (amount < 0) {
				// red screen flash
			}

			if (currentHealth > maxHealth) {
				currentHealth = maxHealth;
			}

			if (currentHealth <= 0) {
				currentHealth = 0;
				onDie();
			}
		}

		public function onDie():void
		{
			loadGraphic(Context.getResources().getSprite("explosion"), true);
			addAnimation("die", [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
			play("die");
			dead = true;
		}

		public function setSecondaryWeapon(weapon:Weapon)
		{
			secondaryWeapon = weapon;
		}

	}

}