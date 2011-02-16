package help 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import inventory.InventoryState;
	import org.flixel.data.FlxFade;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxText;

	public class HelpState extends FlxState 
	{
		private var controlsGroup:FlxGroup;
		private var itemsGroup:FlxGroup;

		private var groups:Array;
		private var currentGroup:int;
		private var transition:Number;
		private var scrolling:int;
		private const NEXT:int = 1;
		private const PREV:int = 2;
		private var destination:int;
		private var fading:Boolean;

		private var background:MovieClip;
		private var shape:Shape;
		private var matrix:Matrix;

		private var controlsPrev:FlxSprite;
		private var controlsNext:FlxSprite;
		private var itemsPrev:FlxSprite;

		override public function create():void 
		{
			FlxG.mouse.show();

			var bgNum:int = Math.floor(Math.random() * Resources.BACKGROUND_COUNT) + 1;
			var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "Anim");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;

			destination = 0;
			fading = false;

			controlsGroup = new FlxGroup();
			itemsGroup = new FlxGroup();

			var text:FlxText = new FlxText(FlxG.width * 0.5 - 96, 80, 192, "Controls");
			text.size = 32;
			text.alignment = "center";
			controlsGroup.add(text);

			text = new FlxText(FlxG.width + FlxG.width * 0.5 - 96, 80, 192, "Items");
			text.size = 32;
			text.alignment = "center";
			itemsGroup.add(text);

			controlsPrev = new FlxSprite(64, text.y + text.height * 0.5, Context.getResources().getSprite("prev"));
			controlsPrev.y -= controlsPrev.height * 0.5;
			controlsGroup.add(controlsPrev);

			controlsNext = new FlxSprite(FlxG.width - 64, text.y + text.height * 0.5, Context.getResources().getSprite("next"));
			controlsNext.y -= controlsNext.height * 0.5;
			controlsNext.x -= controlsNext.width;
			controlsGroup.add(controlsNext);

			itemsPrev = new FlxSprite(FlxG.width + 64, text.y + text.height * 0.5, Context.getResources().getSprite("prev"));
			itemsPrev.y -= itemsPrev.height * 0.5;
			itemsGroup.add(itemsPrev);

			const BASE_CTRLS_X:int = 192 - 64 + 16;
			const BASE_CTRLS_Y:int = 192 - 16;
			var sprite:FlxSprite = new FlxSprite(BASE_CTRLS_X + 16, BASE_CTRLS_Y + 16, Context.getResources().getSprite("arrowUp"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 16, BASE_CTRLS_Y + 64 + 16, Context.getResources().getSprite("arrowDown"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 16 - 64, BASE_CTRLS_Y + 64 + 16, Context.getResources().getSprite("arrowLeft"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 16 + 64, BASE_CTRLS_Y + 64 + 16, Context.getResources().getSprite("arrowRight"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X - 128 + 64 - 16, BASE_CTRLS_Y + 128 + 32, Context.getResources().getSprite("space"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X - 64, BASE_CTRLS_Y, Context.getResources().getSprite("esc"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 32 + 64, BASE_CTRLS_Y, Context.getResources().getSprite("minus"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 32 + 128, BASE_CTRLS_Y, Context.getResources().getSprite("plus"));
			controlsGroup.add(sprite);
			sprite = new FlxSprite(BASE_CTRLS_X + 32 + 128, BASE_CTRLS_Y + 64, Context.getResources().getSprite("zero"));
			controlsGroup.add(sprite);

			text = new FlxText(FlxG.width - 128 - 256 * 0.5 + 16, BASE_CTRLS_Y - 32, 192 - 16,
			"Use the arrow keys to navigate your ship. Use the space bar to fire your weapons.\n\nPress escape to pause.\n\nAdjust volume with + and - and mute sound with 0.");
			text.size = 16;
			text.alignment = "left";
			controlsGroup.add(text);

			text = new FlxText(FlxG.width + 64 + 64, 128 + 16, FlxG.width - 128 - 64,
			"Collect elements to improve your ship. At the end of each level the elements you’ve collected will appear in your inventory.\n\n" +
			"Warning: elements may have positive or negative temporary effects.");
			text.size = 16;
			text.alignment = "left";
			itemsGroup.add(text);

			var elems:Array = new Array(3, 24, 43, 76, 25, 65, 32, 97);
			var elem:FlxSprite;
			for (var i:int = 0; i < 8; i += 2) {
				elem = new FlxSprite(text.x - 64, text.y + 12 + i * 12, Context.getResources().getSprite(Context.getGameData().getElementDefinition(elems[i]).getSprite()));
				elem.color = Context.getGameData().getElementDefinition(elems[i]).getColor();
				itemsGroup.add(elem);
				elem = new FlxSprite(text.x - 64 + 24, text.y + 12 + i * 12, Context.getResources().getSprite(Context.getGameData().getElementDefinition(elems[i + 1]).getSprite()));
				elem.color = Context.getGameData().getElementDefinition(elems[i + 1]).getColor();
				itemsGroup.add(elem);
			}

			text = new FlxText(FlxG.width + 64, 320, FlxG.width - 128 - 128, "Collect these items to obtain secondary weapons and regain energy for your ship.");
			text.size = 16;
			text.alignment = "right";
			itemsGroup.add(text);

			itemsGroup.add(new FlxSprite(text.x + text.width + 48 + 16, text.y, Context.getResources().getSprite("healthItem")));
			itemsGroup.add(new FlxSprite(text.x + text.width + 48, text.y + 32, Context.getResources().getSprite("spreadItem")));
			itemsGroup.add(new FlxSprite(text.x + text.width + 48 + 32, text.y + 32, Context.getResources().getSprite("laserItem")));
			itemsGroup.add(new FlxSprite(text.x + text.width + 48, text.y + 64, Context.getResources().getSprite("missileItem")));
			itemsGroup.add(new FlxSprite(text.x + text.width + 48 + 32, text.y + 64, Context.getResources().getSprite("bombItem")));
			text.y = text.y + (32 * 3 / 2) - text.height * 0.5;

			groups = new Array(controlsGroup, itemsGroup);
			currentGroup = 0;
			transition = 0;
			scrolling = 0;

			shape = new Shape();
			shape.graphics.lineStyle(2.0, 0xFFFFFF, 1);
			shape.graphics.moveTo(32, 32);
			shape.graphics.lineTo(FlxG.width - 32, 32);
			shape.graphics.moveTo(FlxG.width - 32, 32);
			shape.graphics.lineTo(FlxG.width - 32, FlxG.height - 32);
			shape.graphics.moveTo(FlxG.width - 32, FlxG.height - 32);
			shape.graphics.lineTo(32, FlxG.height - 32);
			shape.graphics.moveTo(32, FlxG.height - 32);
			shape.graphics.lineTo(32, 32);
			matrix = new Matrix;

			var fadeIn:FlxFadeIn = new FlxFadeIn();
			fadeIn.start(0xff000000, 0.5);
			defaultGroup.add(fadeIn);
		}

		override public function update():void
		{
			if (scrolling == 0) {
				if (destination == PREV) {
					--currentGroup;
					transition = 1.0;
					scrolling = -1;
				} else if (destination == NEXT) {
					scrolling = 1;
				}
				destination = 0;
			} else if (scrolling == 1) {
				transition += 0.025;
				if (transition >= 1) {
					++currentGroup;
					transition = 0;
					scrolling = 0;
				}
			} else if (scrolling == -1) {
				transition -= 0.025;
				if (transition <= 0) {
					transition = 0;
					scrolling = 0;
				}
			}

			var smoothTransition:Number = ( -Math.cos(transition * Math.PI) + 1.0) * 0.5;
			FlxG.scroll.x = -(currentGroup + smoothTransition) * FlxG.width;

			if (scrolling == 0) {
				(groups[currentGroup] as FlxGroup).update();
			}

			if (!fading) {
				if (currentGroup == 0) {
					if (controlsNext.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
						if (controlsNext.color != 0x00FF00) {
							controlsNext.color = 0x00FF00;
						}
						if (FlxG.mouse.justPressed()) {
							destination = NEXT;
							controlsNext.color = 0xFFFFFF;
						}
					} else if (controlsNext.color != 0xFFFFFF) {
						controlsNext.color = 0xFFFFFF;
					}
					if (controlsPrev.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
						if (controlsPrev.color != 0x00FF00) {
							controlsPrev.color = 0x00FF00;
						}
						if (FlxG.mouse.justPressed()) {
							var fadeOut:FlxFade = new FlxFade();
							fadeOut.start(0xff000000, 0.5, function():void
							{
								parent.removeChild(background);
								FlxG.state = new InventoryState();
							});
							defaultGroup.add(fadeOut);
							controlsPrev.color = 0xFFFFFF;
							fading = true;
						}
					} else if (controlsPrev.color != 0xFFFFFF) {
						controlsPrev.color = 0xFFFFFF;
					}
				} else if (currentGroup == 1) {
					if (itemsPrev.overlapsPoint(FlxG.mouse.x - FlxG.width * 2, FlxG.mouse.y)) {
						if (itemsPrev.color != 0x00FF00) {
							itemsPrev.color = 0x00FF00;
						}
						if (FlxG.mouse.justPressed()) {
							destination = PREV;
							itemsPrev.color = 0xFFFFFF;
						}
					} else if (itemsPrev.color != 0xFFFFFF) {
						itemsPrev.color = 0xFFFFFF;
					}
				}
			}

			super.update();
		}

		override public function render():void
		{
			matrix.identity();
			matrix.tx = FlxG.width * currentGroup + FlxG.scroll.x;
			FlxG.buffer.draw(shape, matrix);
			if (transition != 0) {
				matrix.tx += FlxG.width;
				FlxG.buffer.draw(shape, matrix);
			}
			(groups[currentGroup] as FlxGroup).render();
			if (transition != 0) {
				(groups[currentGroup + 1] as FlxGroup).render();
			}

			super.render();
		}
		
	}

}