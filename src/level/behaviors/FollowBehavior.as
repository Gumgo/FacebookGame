package level.behaviors 
{
	import flash.utils.Dictionary;
	import level.enemies.Behavior;
	import level.enemies.Enemy;
	import org.flixel.FlxG;

	public class FollowBehavior extends Behavior 
	{
		private static var pathDict:Dictionary = new Dictionary();

		private var path:Vector.<int>;
		private const SPEED:Number = 10;
		private var tick:int;
		private var lastVecPos:int;
		private var dir:Number;
		private var dirChange:int;

		public function FollowBehavior()
		{
			super();
		}

		public function resetMe(properties:Dictionary):FollowBehavior
		{
			super.resetMeSuper(properties);
			return this;
		}

		override public function init(enemy:Enemy):void
		{
			if (getProperty("end") != null) {
				if (getProperty("end") == "head") {
					// generate random turns
					path = new Vector.<int>();
					pathDict[enemy.getFleetId()] = path;
					// write initial info
					var spawnSide:int = Math.floor(Math.random() * 3);
					path.push(spawnSide);
					var initDir:int;
					if (spawnSide == 2) {
						var spawnPos:int = Math.floor(Math.random() * FlxG.width * 0.5) + FlxG.width * 0.25;
						path.push(spawnPos);
						if (spawnPos < FlxG.width * 0.5) {
							initDir = 0;
						} else {
							initDir = 1;
						}
					} else {
						spawnPos = Math.floor(Math.random() * FlxG.height * 0.5) + FlxG.height * 0.25;
						path.push(spawnPos);
						if (spawnPos < FlxG.height * 0.5) {
							initDir = 1 - spawnSide;
						} else {
							initDir = spawnSide;
						}
					}
					path.push(initDir);

					var curr:int = 0;
					for (var i:int = 0; i < 8; ++i) {
						curr += Math.floor(Math.random() * 35) + 5;
						path.push(curr);
					}
				} else if (getProperty("end") == "tail") {
					path = pathDict[enemy.getFleetId()];
					pathDict[enemy.getFleetId()] = null; // just to be safe...
					delete pathDict[enemy.getFleetId()];
				}
			} else {
				path = pathDict[enemy.getFleetId()];
			}

			tick = 0;
			lastVecPos = 3;
			var side:int = path[0];
			var pos:int = path[1];
			dirChange = path[2];
			if (side == 0) {
				dir = 0;
				enemy.x = -enemy.width;
				enemy.y = pos - enemy.height * 0.5;
			} else if (side == 1) {
				dir = 180;
				enemy.x = FlxG.width;
				enemy.y = pos - enemy.height * 0.5;
			} else {
				dir = 270;
				enemy.x = pos - enemy.width * 0.5;
				enemy.y = -enemy.height;
			}
		}

		override public function update(enemy:Enemy):void
		{
			enemy.angle = -dir - 90;
			var xInc:Number = Math.cos(dir * Math.PI / 180.0) * SPEED;
			var yInc:Number = -Math.sin(dir * Math.PI / 180.0) * SPEED;
			enemy.x += xInc;
			enemy.y += yInc;

			if (dirChange == 0) {
				dir += 3;
			} else if (dirChange == 1) {
				dir -= 3;
			}

			if (path.length <= lastVecPos) {
				dirChange = 2;
			} else {
				if (path[lastVecPos] == tick) {
					dirChange = dirChange == 0 ? 1 : 0;
					++lastVecPos;
				}
			}
			++tick;

			if (!enemy.onScreen()) {
				enemy.enemyFinished();
			}
		}
		
		

	}

}
