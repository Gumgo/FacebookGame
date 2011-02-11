package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class ZigZagBehavior extends Behavior 
	{

		private var bullet:String;
		private var speed:Number;
		private var offset:Number;
		private var time:int;
		private var shoots:Boolean;
		
		public function ZigZagBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):ZigZagBehavior
		{
			super.resetMeSuper(properties);		
			if ( getProperty("shoots") == null) {
				shoots = true;
			} else {
				shoots = getProperty("shoots") == "true" ? true : false;
			}
			if (shoots) {
				bullet = getProperty("bullet");
			}
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.y = -enemy.height;
			offset = Number(getProperty("offset")) - enemy.width * 0.5;
			time = 0;
			if (getProperty("speed") == null) {
				speed = 12;
			} else {
				speed = Number(getProperty("speed"));
			}
		}

		override public function update(enemy:Enemy):void
		{
			
			enemy.y += speed;
			enemy.x = offset + Math.cos( 2.0 * Math.PI * ((time % 40) / 40.0) ) * 32.0;

			++time;

			if (shoots && Math.random() < 0.02) {
				var dict:Dictionary = new Dictionary();
				dict["x"] = String(enemy.x + enemy.width / 2);
				dict["y"] = String(enemy.y + enemy.height);
				dict["speed"] = String(speed + 2);
				if (!shoots) {
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
					null,
					Context.getGameData().getEnemyDefinition(bullet),
					(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
				}
			}
			if (enemy.y > 0 && !enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
	}

}
