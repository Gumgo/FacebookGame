package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class PlayerBullet extends FlxSprite 
	{

		private var name:String;
		protected var damage:int;
		
		public function PlayerBullet(name:String, damage:int, X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) 
		{
			this.name = name;
			this.damage = damage;
			super(X, Y, SimpleGraphic);
			(FlxG.state as LevelState).getBulletGroup().add(this);
		}

		override public function update():void
		{
			if (!onScreen()) {
				(FlxG.state as LevelState).getBulletGroup().remove(this);
			}

			super.update();
		}

		public function getName():String
		{
			return name;
		}

		public function getDamage():int
		{
			return damage;
		}

		public function hit():void
		{
			(FlxG.state as LevelState).getBulletGroup().remove(this);
		}
		
	}

}