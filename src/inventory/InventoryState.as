package inventory 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import level.LevelState;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.data.FlxFade;
	import level.definitions.ElementDefinition;
	
	public class InventoryState extends FlxState 
	{
		private static const ELEM_X:Array = new Array(
		null,
		0, 17,
		0, 1, 12, 13, 14, 15, 16, 17,
		0, 1, 12, 13, 14, 15, 16, 17,
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
		0, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
		0, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17);

		private static const ELEM_Y:Array = new Array(
		null,
		0, 0,
		1, 1, 1, 1, 1, 1, 1, 1,
		2, 2, 2, 2, 2, 2, 2, 2,
		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
		4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
		5, 5, 5, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
		6, 6, 6, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6);

		private var colors:Dictionary;
		private var descriptionBanner:FlxSprite;
		private var descriptionText:FlxText;
		private var descriptionTextRight:FlxText;

		private var currentDescription:int;
		private var currentHover:int;

		private var fade:FlxFadeIn;
		private var flash:FlxFadeIn;

		private var background:MovieClip;

		private var effectsSprite:FlxSprite;

		private var borderPixels:BitmapData;
		private var matrix:Matrix;
		private var borderLines:Dictionary;

		private var groupMode:Boolean;
		private var group:String;
		private var descRect:Rectangle;
		private var descriptions:Dictionary;
		private var groupText:FlxText;
		private var descText:FlxText;
		private var play:FlxText;
		private var back:FlxText;

		override public function create():void 
		{
			var bgNum:int = Math.floor(Math.random() * Resources.BACKGROUND_COUNT) + 1;
			var BackgroundDef:Class = Context.getResources().getSprite("background" + bgNum + "Anim");
			background = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;

			FlxG.mouse.show();
			colors = new Dictionary();
			colors["Non-Metal"]				= 0x80ff80;
			colors["Other Metal"]			= 0x8080ff;
			colors["Alkali Metal"]			= 0xff8080;
			colors["Alkali Earth Metal"]	= 0xffff80;
			colors["Transition Metal"]		= 0xff80ff;
			colors["Noble Gas"]				= 0x80ff00;
			colors["Halogen"]				= 0x80ffff;
			colors["Lanthanide"]			= 0x0080ff;
			colors["Actinide"]				= 0xff8000;
			colors["Unknown"]				= 0xffffff;

			var encounteredCount:int = 0;
			var collectedCount:int = 0;
			for (var i:int = 1; i < ELEM_X.length; ++i) {
				new InventoryElement(32 + ELEM_X[i] * 32, 32 + ELEM_Y[i] * 40, i);
				var status:int = Context.getPersistentState().getElementState(i);
				if (status == PersistentState.ELEM_ENCOUNTERED) {
					++encounteredCount;
				} else if (status == PersistentState.ELEM_COLLECTED) {
					++encounteredCount;
					++collectedCount;
				}
			}

			currentDescription = -1;
			currentHover = -1;

			var encPercent:Number = Math.round(100.0 * encounteredCount / 118.0);
			var colPercent:Number = Math.round(100.0 * collectedCount / 118.0);

			var title:FlxText = new FlxText(32 * 4, 32, 32 * 8, "Elements");
			title.size = 40;
			title.alignment = "center";

			var stats:FlxText = new FlxText(32 * 4, 88, 32 * 8);
			stats.size = 16;
			stats.alignment = "center";
			stats.text =
			"Encountered: " + encounteredCount + " (" + encPercent +
			"%)\nCollected: " + collectedCount + " (" + colPercent + "%)";
			defaultGroup.add(title);
			defaultGroup.add(stats);

			descriptionBanner = new FlxSprite(0, 0, Context.getResources().getSprite("banner1x128"));
			descriptionBanner.scale.x = FlxG.width * 2;
			descriptionBanner.alpha = 0.9;
			descriptionBanner.visible = false;
			descriptionText = new FlxText(32, 0, FlxG.width - 64);
			descriptionText.size = 16;
			descriptionText.color = 0;
			descriptionText.visible = false;
			descriptionTextRight = new FlxText(32, 0, FlxG.width - 64);
			descriptionTextRight.size = 16;
			descriptionTextRight.alignment = "right";
			descriptionTextRight.color = 0;
			descriptionTextRight.visible = false;

			matrix = new Matrix();
			borderPixels = FlxG.addBitmap(Context.getResources().getSprite("border"));
			effectsSprite = new FlxSprite(0, 0, null);
			effectsSprite.pixels = new BitmapData(FlxG.width, FlxG.height, true, 0);
			defaultGroup.add(effectsSprite);

			defaultGroup.add(descriptionBanner);
			defaultGroup.add(descriptionText);
			defaultGroup.add(descriptionTextRight);

			fade = new FlxFadeIn();
			defaultGroup.add(fade);
			fade.start();

			borderLines = new Dictionary();
			borderLines["Non-Metal"]			= new Array(
			0, 0, 0, 1,     0, 0, 1, 1,     0, 1, 0, 1,     1, 0, 1, 1,
			12, 1, 0, 4,    12, 1, 1, 1,    12, 2, 0, 1,    13, 2, 1, 1,
			13, 3, 0, 1,    14, 3, 1, 1,    14, 4, 0, 1,    15, 4, 1, 1,
			15, 5, 0, 1,    16, 1, 1, 4);
			borderLines["Other Metal"]			= new Array(
			12, 2, 0, 1,    13, 2, 1, 1,    13, 3, 0, 1,    14, 3, 1, 1,
			14, 4, 0, 1,    15, 4, 1, 1,    15, 5, 0, 1,    16, 5, 1, 1,
			12, 2, 1, 4,    12, 6, 0, 4);
			borderLines["Alkali Metal"]			= new Array(
			0, 1, 0, 1,     0, 1, 1, 6,     1, 1, 1, 6,     0, 7, 0, 1);
			borderLines["Alkali Earth Metal"]	= new Array(
			1, 1, 0, 1,     1, 1, 1, 6,     2, 1, 1, 6,     1, 7, 0, 1);
			borderLines["Transition Metal"]		= new Array(
			2, 3, 0, 10,    2, 3, 1, 2,     2, 5, 0, 1,     3, 5, 1, 2,
			3, 7, 0, 9,     12, 3, 1, 4);
			borderLines["Noble Gas"]			= new Array(
			17, 0, 0, 1,    17, 0, 1, 6,    17, 6, 0, 1,    18, 0, 1, 6);
			borderLines["Halogen"]				= new Array(
			16, 1, 0, 1,    16, 1, 1, 5,    16, 6, 0, 1,    17, 1, 1, 5);
			borderLines["Lanthanide"]			= new Array(
			2, 5, 0, 1,     2, 5, 1, 1,     2, 6, 0, 1,     3, 5, 1, 1,
			2, 8, 0, 14,    2, 8, 1, 1,     2, 9, 0, 14,    16, 8, 1, 1);
			borderLines["Actinide"]				= new Array(
			2, 6, 0, 1,     2, 6, 1, 1,     2, 7, 0, 1,     3, 6, 1, 1,
			2, 9, 0, 14,    2, 9, 1, 1,     2, 10, 0, 14,   16, 9, 1, 1);
			borderLines["Unknown"]				= new Array(
			12, 6, 0, 6,    12, 6, 1, 1,    12, 7, 0, 6,    18, 6, 1, 1);

			flash = new FlxFadeIn();
			defaultGroup.add(flash);
			groupMode = false;
			descRect = new Rectangle(0, 0, FlxG.width, FlxG.height);

			descriptions = new Dictionary();
			descriptions["Non-Metal"]			= "Filler description filler description filler description filler description filler description.";
			descriptions["Other Metal"]			= "Filler description filler description filler description filler description filler description.";
			descriptions["Alkali Metal"]		= "Filler description filler description filler description filler description filler description.";
			descriptions["Alkali Earth Metal"]	= "Filler description filler description filler description filler description filler description.";
			descriptions["Transition Metal"]	= "Filler description filler description filler description filler description filler description.";
			descriptions["Noble Gas"]			= "Filler description filler description filler description filler description filler description.";
			descriptions["Halogen"]				= "Filler description filler description filler description filler description filler description.";
			descriptions["Lanthanide"]			= "Filler description filler description filler description filler description filler description.";
			descriptions["Actinide"]			= "Filler description filler description filler description filler description filler description.";
			descriptions["Unknown"]				= "Filler description filler description filler description filler description filler description.";
			groupText = new FlxText(0, FlxG.height / 4, FlxG.width);
			groupText.visible = false;
			groupText.size = 32;
			groupText.alignment = "center";
			defaultGroup.add(groupText);
			descText = new FlxText( 32, FlxG.height / 2, FlxG.width);
			descText.size = 16;
			defaultGroup.add(descText);
			play = new FlxText(FlxG.width - 64 - 80, FlxG.height - 96, 80, "Play");
			play.size = 24;
			play.alignment = "right";
			back = new FlxText(64, FlxG.height - 96, 80, "Back");
			back.size = 24;
			play.visible = false;
			back.visible = false;
			defaultGroup.add(play);
			defaultGroup.add(back);
		}

		public function groupColor(group:String):uint
		{
			return colors[group];
		}

		public function describe(number:int, bottomScreen:Boolean, collected:Boolean):void
		{
			if (number <= 0) {
				descriptionBanner.visible = false;
				descriptionText.visible = false;
				descriptionTextRight.visible = false;
				return;
			}

			if (collected) {

				descriptionBanner.y = FlxG.height / 4;
				if (bottomScreen) {
					descriptionBanner.y = FlxG.height - descriptionBanner.y;
				}
				descriptionBanner.y -= descriptionBanner.height / 2;
				descriptionBanner.visible = true;

				var elem:ElementDefinition = Context.getGameData().getElementDefinition(number);
				descriptionText.text =
				elem.getNumber() + ": " + elem.getName() + " (" + elem.getSymbol() + ")\n" + elem.getDescription();
				descriptionText.y = descriptionBanner.y + descriptionBanner.height / 2;
				descriptionText.y -= descriptionText.height / 2;
				descriptionText.visible = true;

				descriptionTextRight.text = elem.getGroup();
				descriptionTextRight.y = descriptionText.y;
				descriptionTextRight.color = groupColor(elem.getGroup());
				// make the text color lighter
				var currentColor:uint = descriptionTextRight.color;
				var finalColor:uint = 0;
				for (var i:int = 0; i < 3; ++i) {
					finalColor <<= 8;
					var c:uint = currentColor & 0xff0000;
					currentColor <<= 8;
					c = c >>> (8 * 2);
					c /= 2;
					finalColor |= c;
				}
				descriptionTextRight.color = finalColor;
				descriptionTextRight.visible = true;

				currentDescription = number;
			}
			currentHover = number;
		}

		override public function update():void
		{
			var px:BitmapData = effectsSprite.pixels;
			px.colorTransform(effectsSprite.pixels.rect, new ColorTransform(0, 0, 0, 0));
			effectsSprite.pixels = px;

			var lastDescription:int = currentDescription;
			currentDescription = -1;
			currentHover = -1;
			describe( -1, false, false); // clear the description

			super.update();

			if (groupMode) {
				describe( -1, false, false);
			}

			var clicked:Boolean = false;

			// draw the groups
			if (currentHover > 0 || groupMode) {
				var lineArray:Array;
				if (groupMode) {
					lineArray = borderLines[group];
				} else {
					lineArray = borderLines[Context.getGameData().getElementDefinition(currentHover).getGroup()];
				}
				for (var i:int = 0; i < lineArray.length / 4; ++i) {
					matrix.identity();
					matrix.translate(0, -3); // center vertically
					var x:Number = lineArray[i * 4] * 32 + 32;
					var y:Number = lineArray[i * 4 + 1] * 40 + 32;
					var vert:Number = lineArray[i * 4 + 2];
					var sc:Number = lineArray[i * 4 + 3];
					sc *= (vert == 1) ? 40 : 32;
					matrix.scale(sc, 1);
					if (vert == 1) {
						matrix.rotate( Math.PI * 0.5 );
					}
					matrix.translate(x, y);
					effectsSprite.pixels.draw(borderPixels, matrix, new ColorTransform(1, .875, 0), BlendMode.ADD);
				}

				if (!groupMode) {
					if (FlxG.mouse.justPressed()) {
						flash.start(0x80FFFFFF, 0.25, null, true);
						groupMode = true;
						group = Context.getGameData().getElementDefinition(currentHover).getGroup();
						descText.text = descriptions[group];
						groupText.text = group;
						descText.visible = true;
						groupText.visible = true;
						play.visible = true;
						back.visible = true;
						clicked = true;
					}
				} else {
					var shape:Shape = new Shape();
					shape.graphics.beginFill(0, 0.8);
					shape.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
					effectsSprite.pixels.draw(shape);
				}
			}

			effectsSprite.pixels = effectsSprite.pixels;


			if (!groupMode && currentDescription != lastDescription && currentDescription != -1) {
				FlxG.play(Context.getResources().getSound("beep"), 0.1);
			}

			if (groupMode) {
				if (play.visible && play.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					play.color = 0x00FF00;
					if (FlxG.mouse.justPressed() && !clicked) {
						play.visible = false;
						back.visible = false;
						var fadeOut:FlxFade = new FlxFade()
						fadeOut.start(0xFF000000, 1, startLevel);
						defaultGroup.add(fadeOut);
						function startLevel():void
						{
							parent.removeChild(background);

							var elemVec:Vector.<int> = Context.getLevelElements();
							elemVec.length = 0;
							for (var i:int = 1; i <= 118; ++i) {
								if (Context.getGameData().getElementDefinition(i).getGroup() == group) {
									elemVec.push(i);
								}
							}

							FlxG.state = new LevelState();
						}
					}
				} else {
					play.color = 0xFFFFFF;
				}
				if (back.visible && back.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					back.color = 0x00FF00;
					if (FlxG.mouse.justPressed() && !clicked) {
						descText.visible = false;
						groupText.visible = false;
						play.visible = false;
						back.visible = false;
						groupMode = false;
					}
				} else {
					back.color = 0xFFFFFF;
				}
			}
		}

		override public function render():void
		{
			effectsSprite.pixels = effectsSprite.pixels;
			super.render();
		}
		
	}

}