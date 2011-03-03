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

		private var toxicity:int;
		private static const TOXIC_TIME:int = 8 * 60;
		private static const TOXIC_RATE:int = 48;

		private var speedTimer:int;
		private var speedModify:int;
		private static const SPEEDUP_TIME:int = 10 * 60;
		private static const SPEEDDOWN_TIME:int = 6 * 60;

		private var shieldTimer:int;
		private var shieldModify:int;
		private static const SHIELDUP_TIME:int = 10 * 60;
		private static const SHIELDDOWN_TIME:int = 6 * 60;

		private var fireTimer:int;
		private static const FIRE_TIME:int = 10 * 60;
		private static const FIRE_INC:Number = 1.25;

		private var invulnerableTimer:int;
		private static const INVULNERABLE_TIME:int = 4 * 60 + 30;

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

			toxicity = 0;
			speedTimer = 0;
			speedModify = 0;
			shieldTimer = 0;
			shieldModify = 0;
			fireTimer = 0;
			invulnerableTimer = 0;
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

				var speed:int = 8;
				if (speedTimer > 0) {
					if (speedModify == -1) {
						speed = 6;
					} else if (speedModify == 1) {
						speed = 10;
					}
				}

				if (FlxG.keys.LEFT) {
					x -= speed;
					--tilt;
				}
				if (FlxG.keys.RIGHT) {
					x += speed;
					++tilt;
				}
				if (FlxG.keys.UP) {
					y -= speed;
				}
				if (FlxG.keys.DOWN) {
					y += speed;
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

				if (toxicity > 0) {
					if (toxicity % TOXIC_RATE == 0) {
						adjustHealth( -1);
					}
					--toxicity;
				}

				if (speedTimer > 0) {
					--speedTimer;
				}

				if (shieldTimer > 0) {
					--shieldTimer;
				}

				if (fireTimer > 0) {
					--fireTimer;
				}

				if (invulnerableTimer > 0) {
					--invulnerableTimer;
				}

			} else {
				if (endTimer > 0) {
					--endTimer;
				} else if (endTimer == 0) {
					(FlxG.state as LevelState).levelFailed();
					endTimer = -1;
				}
			}

			if (!dead && toxicity > 0)
				if (color != 0xC0FFC0) {
					color = 0xC0FFC0;
				}
			} else if (color != 0xFFFFFF) {
				color = 0xFFFFFF;
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
				var adjShield:Number = shields;
				if (shieldTimer > 0) {
					if (shieldModify == 1) {
						adjShield *= 1.5;
					} else if (shieldModify == -1) {
						adjShield /= 1.5;
					}
				}
				currentHealth -= int(Math.ceil( -amount / adjShield));
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
			loadGraphic(Context.getResources().getSprite("explosionBig"), true);
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

		public function toxify():void
		{
			toxicity = TOXIC_TIME;
		}

		public function speedUp():void
		{
			speedModify = 1;
			speedTimer = SPEEDUP_TIME;
		}

		public function speedDown():void
		{
			speedModify = -1;
			speedTimer = SPEEDDOWN_TIME;
		}

		public function shieldUp():void
		{
			shieldModify = 1;
			shieldTimer = SHIELDUP_TIME;
		}

		public function shieldDown():void
		{
			shieldModify = -1;
			shieldTimer = SHIELDDOWN_TIME;
		}

		public function fastFire():void
		{
			fireTimer = FIRE_TIME;
		}

		public function getFireRate(originalRate:int):int
		{
			if (fireTimer == 0) {
				return originalRate;
			} else {
				return originalRate / FIRE_INC;
			}
		}

		public function invulnerable():void
		{
			invulnerableTimer = INVULNERABLE_TIME;
		}

		public function isInvulnerable():Boolean
		{
			return invulnerableTimer > 0;
		}

	}

}