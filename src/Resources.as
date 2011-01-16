package  
{
	import flash.utils.Dictionary;

	public class Resources 
	{
		private var sprites:Dictionary;

		[Embed(source = "../bin/resources/ship_placeholder.png")] private var player:Class;
		[Embed(source = "../bin/resources/enemy1.png")] private var enemy1:Class;
		[Embed(source = "../bin/resources/explosion_placeholder.png")] private var explosion:Class;
		[Embed(source = "../bin/resources/default_bullet.png")] private var defaultBullet:Class;
		[Embed(source = "../bin/resources/test_item.png")] private var testItem:Class;

		public function Resources()
		{
			sprites = new Dictionary();
			sprites["player"] = player;
			sprites["enemy1"] = enemy1;
			sprites["explosion"] = explosion;
			sprites["defaultBullet"] = defaultBullet;
			sprites["testItem"] = testItem;
		}

		public function getSprite(name:String):Class
		{
			var sprite:Class = sprites[name];
			if (sprite == null) {
				trace("Invalid sprite " + name);
			}
			return sprite;
		}
	}

}