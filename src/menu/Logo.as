package menu 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Logo extends FlxSprite
	{

		private var vertices:Vector.<Number>;
		private var vertices2:Vector.<Number>;
		private var indices:Vector.<int>;
		private var uv:Vector.<Number>;

		private var flcr:int;
		private var flcr2:int;
		private var rect:Rectangle;
		private var point:Point;
		private var matrix:Matrix;
		private var timer:int;
		private var gray:BitmapData;
		private var initY:Number;
		private var seq:int;

		public function Logo() 
		{
			initY = 48;
			super(FlxG.width / 2, initY, Context.getResources().getSprite("logo"));
			x -= width / 2;
			vertices = new Vector.<Number>();
			vertices2 = new Vector.<Number>();
			indices = new Vector.<int>();
			uv = new Vector.<Number>();

			flcr = height - 32;
			flcr2 = flcr + 8;
			rect = new Rectangle();
			point = new Point();

			const ZIG:Number = 0.3;
			vertices.push(
			ZIG, 0,
			1 + ZIG, 0,
			-ZIG, 3 / 8,
			1 - ZIG, 3 / 8,
			ZIG, 5 / 8,
			1 + ZIG, 5 / 8,
			-ZIG, 1,
			1 - ZIG, 1);

			vertices2.push(
			-ZIG / 2, 0,
			1 - ZIG / 2, 0,
			ZIG / 2, 3 / 8,
			1 + ZIG / 2, 3 / 8,
			-ZIG / 2, 5 / 8,
			1 - ZIG / 2, 5 / 8,
			ZIG / 2, 1,
			1 + ZIG / 2, 1);

			indices.push(0, 1, 3, 0, 2, 3, 2, 3, 5, 2, 4, 5, 4, 5, 7, 4, 6, 7);

			uv.push(
			0, 0, 1, 0,
			0, 3 / 8, 1, 3 / 8,
			0, 5 / 8, 1, 5 / 8,
			0, 1, 1, 1);

			matrix = new Matrix();
			timer = -200;
			var grayFilter:ColorMatrixFilter = new ColorMatrixFilter(new Array(
			1 / 3, 1 / 3, 1 / 3, 0, 0,
			1 / 3, 1 / 3, 1 / 3, 0, 0,
			1 / 3, 1 / 3, 1 / 3, 0, 0,
			0, 0, 0, 1, 0));
			gray = new BitmapData(_framePixels.width, _framePixels.height);
			gray.applyFilter(_framePixels, _framePixels.rect, new Point(), grayFilter);
		}

		override public function update():void
		{
			--flcr;
			while (flcr < 0) {
				flcr += height;
			}
			--flcr2;
			while (flcr2 < 0) {
				flcr2 += height;
			}
			if (flcr2 < flcr) {
				var temp:int = flcr2;
				flcr2 = flcr;
				flcr = temp;
			}
			if (timer >= 0) {
				--timer;
			} else if (timer == -1) {
				timer = Math.floor(Math.random() * 120) + 120;
				seq = Math.floor(Math.random() * 3);
			} else if (timer == -200) {
				timer = -100;
			} else if (timer < -97) {
				++timer;
			} else if (timer == -97) {
				timer = -50;
			} else if (timer < -47) {
				++timer;
			} else if (timer == -47) {
				timer = Math.floor(Math.random() * 120) + 120;
				seq = Math.floor(Math.random() * 3);
			} else {
				timer = -100;
			}
			super.update();
		}

		override public function render():void
		{
			if (timer >= 3) {

				getScreenXY(_point);

				// draw top
				rect.x = 0;
				rect.y = 0;
				rect.width = width;
				rect.height = flcr;
				point.x = _point.x;
				point.y = _point.y;
				FlxG.buffer.copyPixels(_framePixels, rect, point);

				// draw flicker
				rect.y = flcr;
				rect.height = 1;
				point.x = _point.x - 8 + ((flcr % 4 < 2) ? 4 : 0);
				point.y = _point.y + flcr;
				FlxG.buffer.copyPixels(_framePixels, rect, point);

				// draw middle
				rect.y = flcr + 1;
				rect.height = flcr2 - flcr - 1;
				point.x = _point.x;
				point.y = _point.y + flcr + 1;
				FlxG.buffer.copyPixels(_framePixels, rect, point);

				// draw flicker
				rect.y = flcr2;
				rect.height = 1;
				point.x = _point.x - 8 + ((flcr2 % 4 < 2) ? 0 : 4);
				point.y = _point.y + flcr2;
				FlxG.buffer.copyPixels(_framePixels, rect, point);

				// draw bottom
				rect.y = flcr2 + 1;
				rect.height = height - flcr2 - 1;
				point.x = _point.x;
				point.y = _point.y + flcr2 + 1;
				FlxG.buffer.copyPixels(_framePixels, rect, point);

			} else if (timer >= 0) {

				const SQUASH:Number = 0.5;
				var shape:Shape = new Shape();
				if (seq == 0) {
					matrix.identity();
					matrix.scale(width, height * SQUASH);
					matrix.translate(x, y + height * (1.0 - SQUASH) * 0.5);
					shape.graphics.beginBitmapFill(gray);
					shape.graphics.drawTriangles(vertices, indices, uv);
					FlxG.buffer.draw(shape, matrix);
				} else if (seq == 1) {
					matrix.identity();
					matrix.scale(width, height * SQUASH);
					matrix.translate(x, y + height * (1.0 - SQUASH) * 0.5);
					shape.graphics.beginBitmapFill(gray);
					shape.graphics.drawTriangles(vertices2, indices, uv );
					FlxG.buffer.draw(shape, matrix);
				} else if (seq == 2) {
					const WSCALE:Number = 0.75;
					scale.y = 1.0 / WSCALE;
					scale.x = WSCALE;
					x = FlxG.width / 2 - width * 0.5;
					y = initY + height / 2 - height * 0.5;
					var btemp:BitmapData = pixels;
					pixels = gray;
					super.render();
					pixels = btemp;
					scale.x = 1.0;
					scale.y = 1.0;
					x = FlxG.width / 2 - width / 2;
					y = initY;
				}
			} else if (timer < -75) {
				const SCALE:Number = 3.0;
				scale.y = 1.0 / SCALE;
				scale.x = SCALE;
				x = FlxG.width / 2 - width * 0.5;
				y = initY + height / 2 - height * 0.5;
				var temp:BitmapData = pixels;
				pixels = gray;
				super.render();
				pixels = temp;
				scale.x = 1.0;
				scale.y = 1.0;
				x = FlxG.width / 2 - width / 2;
				y = initY;
			} else if (timer < -25) {
				const SCALE2:Number = 0.75;
				scale.y = 1.0 / SCALE2;
				scale.x = SCALE2;
				x = FlxG.width / 2 - width * 0.5;
				y = initY + height / 2 - height * 0.5;
				var temp1:BitmapData = pixels;
				pixels = gray;
				super.render();
				pixels = temp1;
				scale.x = 1.0;
				scale.y = 1.0;
				x = FlxG.width / 2 - width / 2;
				y = initY;
			}
		}
		
	}

}