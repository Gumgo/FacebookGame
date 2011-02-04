package level.weapons 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import level.PlayerBullet;
	import level.LevelState;
	import org.flixel.FlxG;

	/**
	 * ...
	 * @author Ben
	 */
	public class SpreadBullet extends PlayerBullet
	{
		private var direction:Number;
		private var turnDir:Boolean;

		private var points:Vector.<Number>;

		public function SpreadBullet()
		{
			super();
		}

		public function resetMe(x:int, y:int, dir:Number):SpreadBullet
		{
			super.resetMeSuper("spread", 50, x, y, Context.getResources().getSprite("blob"));
			this.x -= width / 2;
			this.y -= height / 2;
			turnDir = Math.random() >= 0.5;
			direction = dir;
			blend = BlendMode.ADD;

			points = new Vector.<Number>();
			return this;
		}

		override public function update():void
		{
			const SPEED:Number = 10.0;
			var xInc:Number = Math.cos(direction * Math.PI / 180.0);
			var yInc:Number = -Math.sin(direction * Math.PI / 180.0);

			x += xInc * SPEED;
			y += yInc * SPEED;

			// store points
			var xSide:Number = Math.cos((direction + 90) * Math.PI / 180.0) * 3.0;
			var ySide:Number = -Math.sin((direction + 90) * Math.PI / 180.0) * 3.0;
			points.push(x + width / 2 + xSide);
			points.push(y + height / 2 + ySide);
			points.push(x + width / 2 - xSide);
			points.push(y + height / 2 - ySide);

			if (points.length > 8 * 4 ) {
				points.shift();
				points.shift();
				points.shift();
				points.shift();
			}

			var effects:BitmapData = (FlxG.state as LevelState).getEffects();
			var shape:Shape = new Shape();
			for (var i:int = 0; i < (points.length / 4) - 1; ++i) {
				var indices:Vector.<int> = new Vector.<int>();
				indices.push(i * 2, i * 2 + 1, i * 2 + 2, i * 2 + 1, i * 2 + 2, i * 2 + 3);
				shape.graphics.beginFill(0xFFFF00, 4 * i / points.length);
				shape.graphics.drawTriangles(points, indices);
			}
			effects.draw(shape, null, null);

			if (turnDir) {
				direction += 3.0;
			} else {
				direction -= 3.0;
			}
			if (Math.random() < 0.04) {
				turnDir = !turnDir;
			}

			const PADDING:Number = 32;
			// note: not calling super.update()
			if (x + width / 2 < -PADDING || x + width / 2 > FlxG.width + PADDING || y + height / 2 < -PADDING || y + height / 2 > FlxG.height + PADDING) {
				(FlxG.state as LevelState).getBulletGroup().remove(this);
			}
		}
	}

}