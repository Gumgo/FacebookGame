package level.behaviors 
{
	import level.enemies.Behavior;
	import flash.utils.Dictionary;
	import level.enemies.Enemy;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class MineBehavior extends Behavior 
	{

		private var xInc:Number;
		private var yInc:Number;
		private var speed:Number;
		private var disabled:Boolean;

		public function MineBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):MineBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			enemy.x = Number(getProperty("x"));
			enemy.y = Number(getProperty("y"));
			enemy.x -= enemy.width * 0.5;
			enemy.y -= enemy.height * 0.5;
			disabled = false;
		}

		override public function update(enemy:Enemy):void
		{
			if (!enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}

		public function disable():void
		{
			disabled = true;
		}

		override public function die(enemy:Enemy):void
		{
			if (!disabled) {
				for (var i:int = 0; i < 8; ++i) {
					var dict:Dictionary = new Dictionary();
					dict["x"] = String(enemy.x + enemy.width * 0.5);
					dict["y"] = String(enemy.y + enemy.height * 0.5);
					dict["dir"] = String(360.0 * i / 8.0);
					dict["speed"] = "12";
					(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
						null,
						Context.getGameData().getEnemyDefinition("bullet_d20"),
						(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
				}
			}
		}

	}

}