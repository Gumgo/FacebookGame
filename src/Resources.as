package  
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class Resources 
	{
		// NOTE: when specifying resources, you can optionally append a # plus a maximum random number (1 digit) to the end
		// for example, I might want to randomly choose exp1, exp2, or exp3
		// to do this, I request "exp#3"
		// note that it must be this exact syntax and is limited to one digit, ranging from [1,n] (inclusive)

		// SPRITES:
		private var sprites:Dictionary;
		[Embed(source = "../bin/resources/sprites/player.png")] private var player:Class;
		[Embed(source = "../bin/resources/sprites/player_outline.png")] private var playerOutline:Class;

		[Embed(source = "../bin/resources/sprites/enemy_1.png")] private var enemy1:Class;
		[Embed(source = "../bin/resources/sprites/enemy_2.png")] private var enemy2:Class;
		[Embed(source = "../bin/resources/sprites/enemy_3.png")] private var enemy3:Class;
		[Embed(source = "../bin/resources/sprites/enemy_4.png")] private var enemy4:Class;
		[Embed(source = "../bin/resources/sprites/enemy_5.png")] private var enemy5:Class;

		[Embed(source = "../bin/resources/sprites/Boss_1.png")] private var boss1:Class;
		[Embed(source = "../bin/resources/sprites/Boss_2.png")] private var boss2:Class;
		[Embed(source = "../bin/resources/sprites/Boss_3.png")] private var boss3:Class;
		[Embed(source = "../bin/resources/sprites/Boss_4.png")] private var boss4:Class;

		[Embed(source = "../bin/resources/sprites/explosion.png")] private var explosion:Class;

		[Embed(source = "../bin/resources/sprites/default_bullet.png")] private var defaultBullet:Class;
		[Embed(source = "../bin/resources/sprites/enemy_bullet1.png")] private var enemyBullet1:Class;
		[Embed(source = "../bin/resources/sprites/enemy_bullet2.png")] private var enemyBullet2:Class;
		[Embed(source = "../bin/resources/sprites/enemy_bullet3.png")] private var enemyBullet3:Class;
		[Embed(source = "../bin/resources/sprites/enemy_bullet4.png")] private var enemyBullet4:Class;
		[Embed(source = "../bin/resources/sprites/firebullet1.png")] private var fireBullet:Class;
		[Embed(source = "../bin/resources/sprites/spark.png")] private var spark:Class;
		[Embed(source = "../bin/resources/sprites/bolt.png")] private var bolt:Class;
		[Embed(source = "../bin/resources/sprites/shield.png")] private var shieldBullet:Class;
		[Embed(source = "../bin/resources/sprites/laser.png")] private var laser:Class;
		[Embed(source = "../bin/resources/sprites/mine.png")] private var mineBullet:Class;
		[Embed(source = "../bin/resources/sprites/blob.png")] private var blob:Class;
		[Embed(source = "../bin/resources/sprites/item1.png")] private var radioactive:Class;
		[Embed(source = "../bin/resources/sprites/item2.png")] private var nonmetal1:Class;
		[Embed(source = "../bin/resources/sprites/item3.png")] private var metal4 :Class;
		[Embed(source = "../bin/resources/sprites/item4.png")] private var nonmetal3:Class;
		[Embed(source = "../bin/resources/sprites/item5.png")] private var metal1:Class;	
		[Embed(source = "../bin/resources/sprites/item6.png")] private var nonmetal2:Class;
		[Embed(source = "../bin/resources/sprites/item7.png")] private var metal3:Class;
		[Embed(source = "../bin/resources/sprites/item8.png")] private var metal2:Class;
		[Embed(source = "../bin/resources/sprites/laser_bullet.png")] private var laserBullet:Class;
		[Embed(source = "../bin/resources/sprites/bomb.png")] private var bombBullet:Class;
		[Embed(source = "../bin/resources/sprites/missile.png")] private var missileBullet:Class;

		[Embed(source = "../bin/resources/sprites/energy_item.png")] private var healthItem:Class;
		[Embed(source = "../bin/resources/sprites/spread_item.png")] private var spreadItem:Class;
		[Embed(source = "../bin/resources/sprites/laser_item.png")] private var laserItem:Class;
		[Embed(source = "../bin/resources/sprites/missile_item.png")] private var missileItem:Class;
		[Embed(source = "../bin/resources/sprites/bomb_item.png")] private var bombItem:Class;

		[Embed(source = "../bin/resources/sprites/table_entry.png")] private var tableEntry:Class;
		[Embed(source = "../bin/resources/sprites/banner.png")] private var banner1x128:Class;
		[Embed(source = "../bin/resources/sprites/border.png")] private var border:Class;
		[Embed(source = "../bin/resources/sprites/logo.png")] private var logo:Class;

		[Embed(source = "../bin/resources/backgrounds/background1.swf")] private var background1Anim:Class;
		[Embed(source = "../bin/resources/backgrounds/background2.swf")] private var background2Anim:Class;
		[Embed(source = "../bin/resources/backgrounds/background3.swf")] private var background3Anim:Class;
		[Embed(source = "../bin/resources/backgrounds/background2moving.swf")] private var background2AnimMove:Class;
		[Embed(source = "../bin/resources/backgrounds/background3moving.swf")] private var background3AnimMove:Class;

		[Embed(source = "../bin/resources/sprites/healthbar.png")] private var healthBar:Class;
		[Embed(source = "../bin/resources/sprites/healthbar_left.png")] private var healthBarLeft:Class;
		[Embed(source = "../bin/resources/sprites/healthbar_right.png")] private var healthBarRight:Class;
		[Embed(source = "../bin/resources/sprites/healthbar_top.png")] private var healthBarTop:Class;
		[Embed(source = "../bin/resources/sprites/healthbar_bottom.png")] private var healthBarBottom:Class;

		// SOUNDS:
		private var sounds:Dictionary;
		[Embed(source = "../bin/resources/sounds/beep.mp3")] private var beep:Class;

		[Embed(source = "../bin/resources/sounds/exp1.mp3")] private var exp1:Class;
		[Embed(source = "../bin/resources/sounds/exp2.mp3")] private var exp2:Class;
		[Embed(source = "../bin/resources/sounds/exp3.mp3")] private var exp3:Class;
		[Embed(source = "../bin/resources/sounds/exp4.mp3")] private var exp4:Class;
		[Embed(source = "../bin/resources/sounds/exp5.mp3")] private var exp5:Class;
		[Embed(source = "../bin/resources/sounds/exp6.mp3")] private var exp6:Class;
		[Embed(source = "../bin/resources/sounds/exp7.mp3")] private var exp7:Class;
		[Embed(source = "../bin/resources/sounds/exp8.mp3")] private var exp8:Class;

		[Embed(source = "../bin/resources/sounds/gun1.mp3")] private var gun1:Class;

		[Embed(source = "../bin/resources/sounds/collect.mp3")] private var collect:Class;

		[Embed(source = "../bin/resources/music/menu.mp3")] private var menu:Class;

		public static var BACKGROUND_COUNT:int = 3;

		public function Resources()
		{
			sprites = new Dictionary();
			sprites["player"] = player;
			sprites["playerOutline"] = playerOutline;
			sprites["enemy1"] = enemy1;
			sprites["enemy2"] = enemy2;
			sprites["enemy3"] = enemy3;
			sprites["enemy4"] = enemy4;
			sprites["enemy5"] = enemy5;
			sprites["boss1"] = boss1;
			sprites["boss2"] = boss2;
			sprites["boss3"] = boss3;
			sprites["boss4"] = boss4;
			sprites["explosion"] = explosion;
			sprites["defaultBullet"] = defaultBullet;
			sprites["enemyBullet1"] = enemyBullet1;
			sprites["enemyBullet2"] = enemyBullet2;
			sprites["enemyBullet3"] = enemyBullet3;
			sprites["enemyBullet4"] = enemyBullet4;
			sprites["bolt"] = bolt;
			sprites["fireBullet"] = fireBullet;
			sprites["shieldBullet"] = shieldBullet;
			sprites["spark"] = spark;
			sprites["laser"] = laser;
			sprites["mineBullet"] = mineBullet;
			sprites["blob"] = blob;
			sprites["laserBullet"] = laserBullet;
			sprites["bombBullet"] = bombBullet;
			sprites["missileBullet"] = missileBullet;
			sprites["healthItem"] = healthItem;
			sprites["spreadItem"] = spreadItem;
			sprites["laserItem"] = laserItem;
			sprites["missileItem"] = missileItem;
			sprites["bombItem"] = bombItem;
			sprites["healthBar"] = healthBar;
			sprites["healthBarLeft"] = healthBarLeft;
			sprites["healthBarRight"] = healthBarRight;
			sprites["healthBarTop"] = healthBarTop;
			sprites["healthBarBottom"] = healthBarBottom;
			sprites["tableEntry"] = tableEntry;
			sprites["banner1x128"] = banner1x128;
			sprites["border"] = border;
			sprites["background1"] = background1Anim;
			sprites["background1Anim"] = background1Anim;
			sprites["background2Anim"] = background2Anim;
			sprites["background2AnimMove"] = background2AnimMove;
			sprites["background3Anim"] = background3Anim;
			sprites["background3AnimMove"] = background3AnimMove;
			sprites["logo"] = logo;
			sprites["metal1"] = metal1;
			sprites["metal2"] = metal2;
			sprites["metal3"] = metal3;
			sprites["metal4"] = metal4;
			sprites["nonmetal1"] = nonmetal1;
			sprites["nonmetal2"] = nonmetal2;
			sprites["nonmetal3"] = nonmetal3;
			sprites["radioactive"] = radioactive;

			sounds = new Dictionary();
			sounds["beep"] = beep;
			sounds["exp1"] = exp1;
			sounds["exp2"] = exp2;
			sounds["exp3"] = exp3;
			sounds["exp4"] = exp4;
			sounds["exp5"] = exp5;
			sounds["exp6"] = exp6;
			sounds["exp7"] = exp7;
			sounds["exp8"] = exp8;
			sounds["gun1"] = gun1;
			sounds["collect"] = collect;

			sounds["menu"] = menu;
		}

		public function getSprite(name:String):Class
		{
			var str:String = name;
			if (str.length >= 2 && str.charAt(str.length - 2) == "#") {
				var val:Number = Number(str.charAt(str.length - 1));
				if (isNaN(val)) {
					throw new Error("Invalid random resource formatting " + str);
				} else {
					str = str.slice(0, str.length - 2);
					str += (1 + Math.floor(Math.random() * val)).toString();
				}
			}
			var sprite:Class = sprites[str];
			if (sprite == null) {
				throw new Error("Invalid sprite " + str);
			}
			return sprite;
		}

		public function getSound(name:String):Class
		{
			var str:String = name;
			if (str.length >= 2 && str.charAt(str.length - 2) == "#") {
				var val:Number = Number(str.charAt(str.length - 1));
				if (isNaN(val)) {
					throw new Error("Invalid random resource formatting " + str);
				} else {
					str = str.slice(0, str.length - 2);
					str += (1 + Math.floor(Math.random() * val)).toString();
				}
			}
			var sound:Class = sounds[str];
			if (sound == null) {
				throw new Error("Invalid sound " + str);
			}
			return sound;
		}
	}

}