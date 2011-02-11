package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import level.LevelState;
	import org.flixel.FlxG;
	
	public class BombBehavior extends Behavior 
	{

		private var bullet:String;
		private var target:Number;
		private var moveMode:int; // 0 = x, 1 = y
		private var rot:int;

		public function BombBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):BombBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			bullet = getProperty("bullet");
			// speed ranging from 0 to 1
			moveMode = Math.floor(Math.random() * 3.0) < 2 ? 0 : 1;
			if (moveMode == 0) {
				enemy.x = Math.random() < 0.5 ? FlxG.width : -enemy.width;
				enemy.y = FlxG.height * 0.25 + Math.random() * FlxG.height * 0.5 - enemy.height * 0.5;
				target = FlxG.width * 0.25 + Math.random() * FlxG.width * 0.5 - enemy.width * 0.5;
			} else {
				enemy.x = FlxG.width * 0.25 + Math.random() * FlxG.width * 0.5 - enemy.width * 0.5;
				enemy.y = -enemy.height;
				target = FlxG.height * 0.25 + Math.random() * FlxG.height * 0.5 - enemy.height * 0.5;
			}
			rot = -1;
		}

		override public function update(enemy:Enemy):void
		{
			if (rot < 0) {
				var done:Boolean = false;
				if (moveMode == 0) {
					enemy.x = MathExt.lerp(enemy.x, target, 0.04);
					if (Math.abs(enemy.x - target) < 1.0) {
						done = true;
					}
				} else {
					enemy.y = MathExt.lerp(enemy.y, target, 0.04);
					if (Math.abs(enemy.y - target) < 1.0) {
						done = true;
					}
				}
				if (done) {
					rot = 0;
				}
			} else {
				if (rot < 360) {
					if (rot % 15 == 0) {
						var dict1:Dictionary = new Dictionary();
						dict1["x"] = String(enemy.x + enemy.width / 2);
						dict1["y"] = String(enemy.y + enemy.height / 2);
						dict1["dir"] = String(rot);
						dict1["speed"] = "12";
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition(bullet),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict1), true);
					}
					rot += 5;
				} else {
					enemy.enemyFinished();
					for (var i:int = 0; i < 16; ++i) {
						var dict:Dictionary = new Dictionary();
						dict["x"] = String(enemy.x + enemy.width / 2);
						dict["y"] = String(enemy.y + enemy.height / 2);
						dict["dir"] = String(360.0 * i / 16.0);
						dict["speed"] = "12";
						(Context.getRecycler().getNew(Enemy) as Enemy).resetMe(
							null,
							Context.getGameData().getEnemyDefinition(bullet),
							(Context.getRecycler().getNew(BulletBehavior) as BulletBehavior).resetMe(dict), true);
					}
				}
			}
		}
	}

}