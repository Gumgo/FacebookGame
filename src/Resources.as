package  
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class Resources 
	{
		// SPRITES:
		private var sprites:Dictionary;
		[Embed(source = "../bin/resources/ship_placeholder.png")] private var player:Class;
		[Embed(source = "../bin/resources/enemy1.png")] private var enemy1:Class;
		[Embed(source = "../bin/resources/explosion.png")] private var explosion:Class;
		[Embed(source = "../bin/resources/default_bullet.png")] private var defaultBullet:Class;
		[Embed(source = "../bin/resources/enemy_bullet.png")] private var enemyBullet:Class;
		[Embed(source = "../bin/resources/blob.png")] private var blob:Class;
		[Embed(source = "../bin/resources/laser_bullet.png")] private var laserBullet:Class;
		[Embed(source = "../bin/resources/bomb.png")] private var bombBullet:Class;
		[Embed(source = "../bin/resources/missile.png")] private var missileBullet:Class;
		[Embed(source = "../bin/resources/test_item.png")] private var testItem:Class;
		[Embed(source = "../bin/resources/table_entry.png")] private var tableEntry:Class;
		[Embed(source = "../bin/resources/banner.png")] private var banner1x128:Class;
		[Embed(source = "../bin/resources/border.png")] private var border:Class;
		[Embed(source = "../bin/resources/logo.png")] private var logo:Class;

		[Embed(source = "../bin/resources/background1.swf")] private var background1Anim:Class;
		[Embed(source = "../bin/resources/background2.swf")] private var background2Anim:Class;
		[Embed(source = "../bin/resources/background2moving.swf")] private var background2AnimMove:Class;

		[Embed(source = "../bin/resources/health.png")] private var healthBar:Class;

		// SOUNDS:
		private var sounds:Dictionary;
		[Embed(source = "../bin/resources/beep.mp3")] private var beep:Class;

		public static var BACKGROUND_COUNT:int = 2;

		public function Resources()
		{
			sprites = new Dictionary();
			sprites["player"] = player;
			sprites["enemy1"] = enemy1;
			sprites["explosion"] = explosion;
			sprites["defaultBullet"] = defaultBullet;
			sprites["enemyBullet"] = enemyBullet;
			sprites["blob"] = blob;
			sprites["laserBullet"] = laserBullet;
			sprites["bombBullet"] = bombBullet;
			sprites["missileBullet"] = missileBullet;
			sprites["testItem"] = testItem;
			sprites["healthBar"] = healthBar;
			sprites["tableEntry"] = tableEntry;
			sprites["banner1x128"] = banner1x128;
			sprites["border"] = border;
			sprites["background1"] = background1Anim;
			sprites["background1Anim"] = background1Anim;
			sprites["background2Anim"] = background2Anim;
			sprites["background2AnimMove"] = background2AnimMove;
			sprites["logo"] = logo;

			sounds = new Dictionary();
			sounds["beep"] = beep;
		}

		public function getSprite(name:String):Class
		{
			var sprite:Class = sprites[name];
			if (sprite == null) {
				trace("Invalid sprite " + name);
			}
			return sprite;
		}

		public function getSound(name:String):Class
		{
			var sound:Class = sounds[name];
			if (sound == null) {
				trace("Invalid sound " + name);
			}
			return sound;
		}
	}

}