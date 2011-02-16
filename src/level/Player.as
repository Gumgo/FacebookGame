package level
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import level.weapons.BombWeapon;
	import level.weapons.DefaultWeapon;
	import level.weapons.LaserWeapon;
	import level.weapons.MissileWeapon;
	import level.weapons.SpreadWeapon; // TEMP FOR TESTING
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import level.enemies.Enemy;

	public class Player extends FlxSprite 
	{

		private var maxHealth:int;
		private var currentHealth:int;

		private var primaryWeapon:Weapon;
		private var secondaryWeapon:Weapon;
		private var damageMultiplier:Number;
		private var shields:Number;

		private var endTimer:int;

		private var xPrev:Number;
		private var yPrev:Number;

		private var outline:BitmapData;
		private var point:FlxPoint;
		private var matrix:Matrix;
		private var colorTf:ColorTransform;
		private var time:int;

		public function Player() 
		{
			outline = FlxG.addBitmap(Context.getResources().getSprite("playerOutline"));
			point = new FlxPoint();
			matrix = new Matrix();
			colorTf = new ColorTransform();

			maxHealth = Context.getPersistentState().getCurrentHealth();
			currentHealth = maxHealth;

			damageMultiplier = Context.getPersistentState().getCurrentDamage();
			shields = Context.getPersistentState().getCurrentShields();

			super(FlxG.width / 2, FlxG.height / 2, Context.getResources().getSprite("player"));
			x -= width / 2;
			y -= height / 2;
			xPrev = x;
			yPrev = y;

			time = 0;

			primaryWeapon = new DefaultWeapon();

			// FOR TESTING:
			//secondaryWeapon = new SpreadWeapon();
		}

		override public function render():void
		{
			if (!dead) {
				getScreenXY(point);
				point.x -= (outline.width - width) * 0.5;
				point.y -= (outline.height - height) * 0.5;
				matrix.identity();
				matrix.translate( -outline.width * 0.5, -outline.height * 0.5);
				matrix.rotate(angle * Math.PI / 180.0);
				matrix.translate( outline.width * 0.5, outline.height * 0.5);
				matrix.translate(point.x, point.y);
				colorTf.alphaMultiplier =
					(Context.getPersistentState().getCurrentShields() - PersistentState.SHIELDS_MIN) /
					(PersistentState.SHIELDS_MAX - PersistentState.SHIELDS_MIN);
				colorTf.redMultiplier = colorTf.greenMultiplier = 0;
				colorTf.blueMultiplier = 1;
				colorTf.alphaMultiplier *= 1 - 0.75 * ((Math.cos((time / 120.0) * 2.0 * Math.PI) + 1) * 0.5);
				FlxG.buffer.draw(outline, matrix, colorTf, BlendMode.NORMAL);
			}
			super.render();
		}

		override public function update():void
		{
			xPrev = x;
			yPrev = y;

			++time;
			if (time >= 120) {
				time = 0;
			}

			if (!dead) {
				primaryWeapon.update();
				if (secondaryWeapon != null) {
					secondaryWeapon.update();
				}

				var tilt:int = 0;

				if (FlxG.keys.LEFT) {
					x -= 8;
					--tilt;
				}
				
				if (FlxG.keys.RIGHT) {
					x += 8;
					++tilt;
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

				if (tilt == 0) {
					if (angle > 0) {
						angle = Math.max(0, angle - 2);
					} else if (angle < 0) {
						angle = Math.min(0, angle + 2);
					}
				} else if (tilt == 1) {
					angle = Math.min(6, angle + 2);
				} else if (tilt == -1) {
					angle = Math.max( -6, angle - 2);
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

			if (amount > 0) {
				currentHealth += amount;
				// green screen flash
			} else if (amount < 0) {
				// red screen flash
				currentHealth -= int(Math.ceil( -amount / shields));
				var ratio1:Number = Number(prevHealth) / Number(maxHealth);
				var ratio2:Number = Number(currentHealth) / Number(maxHealth);
				if (ratio1 > 0.15 && ratio2 <= 0.15) {
					(FlxG.state as LevelState).getLevelText().setText("Warning: energy is low", 0xFF0000, 180);
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
			angle = 0;
			loadGraphic(Context.getResources().getSprite("explosion"), true);
			addAnimation("die", [0, 1, 2, 3, 4, 5, 6, 7], 30, false);
			play("die");
			dead = true;
			FlxG.play(Context.getResources().getSound("exp#8"));

			endTimer = 120;
		}

		public function setSecondaryWeapon(weapon:Weapon):void
		{
			secondaryWeapon = weapon;
		}

		public function getSecondaryWeapon():Weapon
		{
			return secondaryWeapon;
		}

		public function getXPrev():Number
		{
			return xPrev;
		}

		public function getYPrev():Number
		{
			return yPrev;
		}

		public function getDamageMultiplier():Number
		{
			return damageMultiplier;
		}

		public function getShields():Number
		{
			return shields;
		}

	}

}