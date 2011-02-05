package level 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class PlayerBullet extends FlxSprite 
	{

		private var name:String;
		protected var damage:int;

		public function PlayerBullet()
		{
			super();
		}

		protected function resetMeSuper(name:String, damage:int, X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null):PlayerBullet
		{
			this.name = name;
			this.damage = damage;
			this.x = X;
			this.y = Y;
			loadGraphic(SimpleGraphic);
			(FlxG.state as LevelState).getBulletGroup().add(this);
			return this;
		}

		override public function update():void
		{
			if (!onScreen()) {
				(FlxG.state as LevelState).getBulletGroup().remove(this);
				Context.getRecycler().recycle(this);
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
			Context.getRecycler().recycle(this);
		}
		
	}

}