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
		[Embed(source = "../bin/resources/explosion_placeholder.png")] private var explosion:Class;
		[Embed(source = "../bin/resources/default_bullet.png")] private var defaultBullet:Class;
		[Embed(source = "../bin/resources/test_item.png")] private var testItem:Class;
		[Embed(source = "../bin/resources/table_entry.png")] private var tableEntry:Class;
		[Embed(source = "../bin/resources/banner.png")] private var banner1x128:Class;

		[Embed(source = "../bin/resources/background1.swf")] private var background1Anim:Class;
		[Embed(source = "../bin/resources/background2.swf")] private var background2Anim:Class;

		[Embed(source = "../bin/resources/health.png")] private var healthBar:Class;

		// SOUNDS:
		private var sounds:Dictionary;
		[Embed(source = "../bin/resources/beep.mp3")] private var beep:Class;

		public function Resources()
		{
			sprites = new Dictionary();
			sprites["player"] = player;
			sprites["enemy1"] = enemy1;
			sprites["explosion"] = explosion;
			sprites["defaultBullet"] = defaultBullet;
			sprites["testItem"] = testItem;
			sprites["healthBar"] = healthBar;
			sprites["tableEntry"] = tableEntry;
			sprites["banner1x128"] = banner1x128;
			sprites["background1"] = background1Anim;
			sprites["background1Anim"] = background1Anim;
			sprites["background2Anim"] = background2Anim;

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