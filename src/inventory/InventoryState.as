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
	import help.HelpState;
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

		private var stats:FlxText;

		private var colors:Dictionary;
		private var descriptionBanner:FlxSprite;
		private var descriptionText:FlxText;
		private var descriptionTextRight:FlxText;

		private var helpText:FlxText;
		private var canClick:Boolean;
		private var resetText:FlxText;
		private var resetDisplay:Boolean;

		private var resetWarning:FlxText;
		private var resetYes:FlxText;
		private var resetNo:FlxText;

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
		private var descriptions:Dictionary;
		private var groupText:FlxText;
		private var descText:FlxText;
		private var play:FlxText;
		private var back:FlxText;

		private var elementVec:Vector.<InventoryElement>;

		private function resetElements():void
		{
			colors = new Dictionary();
			colors["Non-Metals"]			= 0x80ff80;
			colors["Other Metals"]			= 0x8080ff;
			colors["Metalloids"]			= 0xff0080;
			colors["Alkali Metals"]			= 0xff8080;
			colors["Alkaline Earth Metals"]	= 0xffff80;
			colors["Transition Metals"]		= 0xff80ff;
			colors["Noble Gases"]			= 0x80ff00;
			colors["Halogens"]				= 0x80ffff;
			colors["Lanthanides"]			= 0x0080ff;
			colors["Actinides"]				= 0xff8000;
			colors["Unknowns"]				= 0xffffff;

			var collectedCount:int;
			if (elementVec == null) {
				elementVec = new Vector.<InventoryElement>();
				collectedCount = 0;
				for (var i:int = 1; i < ELEM_X.length; ++i) {
					elementVec.push(new InventoryElement(32 + ELEM_X[i] * 32, 32 + ELEM_Y[i] * 40, i));
					var status:int = Context.getPersistentState().getElementState(i);
					if (status == PersistentState.ELEM_COLLECTED) {
						++collectedCount;
					}
				}
			} else {
				collectedCount = 0;
				for (i = 1; i < ELEM_X.length; ++i) {
					elementVec[i - 1].refresh();
					status = Context.getPersistentState().getElementState(i);
					if (status == PersistentState.ELEM_COLLECTED) {
						++collectedCount;
					}
				}
			}

			var colPercent:Number = Math.round(100.0 * collectedCount / 118.0);
			var currentLevel:int = Math.floor(Context.getGameData().getLevelCount() * collectedCount / (118.0 + 1.0));
			var elementsToAdvance:int = 0;
			if (currentLevel < Context.getGameData().getLevelCount() - 1) {
				while (Math.floor(Context.getGameData().getLevelCount() * (collectedCount + elementsToAdvance) / (118.0 + 1.0)) == currentLevel) {
					++elementsToAdvance;
				}
			}

			stats.text =
			"Collected: " + collectedCount + " (" + colPercent + "%)\n" +
			"Level " + (currentLevel + 1);
			if (elementsToAdvance != 0) {
				stats.text += " (need " + elementsToAdvance + " to advance)";
			}
		}

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

			currentDescription = -1;
			currentHover = -1;

			var title:FlxText = new FlxText(32 * 4, 32, 32 * 8, "Elements");
			title.size = 40;
			title.alignment = "center";

			stats = new FlxText(32 * 4 - 16, 88, 32 * 9);
			stats.size = 16;
			stats.alignment = "center";

			resetElements();

			defaultGroup.add(title);
			defaultGroup.add(stats);

			helpText = new FlxText(FlxG.width - 32 - 32, 0, 32, "?");
			helpText.size = 32;
			helpText.alignment = "center";
			helpText.y = FlxG.height - 40 * 2 - helpText.height * 0.5;
			defaultGroup.add(helpText);
			canClick = true;

			resetText = new FlxText(32, 0, 32, "X");
			resetText.size = 32;
			resetText.alignment = "center";
			resetText.y = FlxG.height - 40 * 2 - resetText.height * 0.5;
			defaultGroup.add(resetText);

			descriptionBanner = new FlxSprite(FlxG.width * 0.5, 0, Context.getResources().getSprite("banner1x128"));
			descriptionBanner.scale.x = FlxG.width;
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
			borderLines["Non-Metals"]				= new Array(
			0, 0, 0, 1,     0, 0, 1, 1,     0, 1, 0, 1,     1, 0, 1, 1,
			13, 1, 0, 3,    13, 1, 1, 1,    13, 2, 0, 1,    14, 2, 1, 1,
			14, 3, 0, 1,    15, 3, 1, 1,    15, 4, 0, 1,    16, 1, 1, 3);
			borderLines["Other Metals"]				= new Array(
			12, 2, 0, 1,    13, 2, 1, 2,    13, 4, 0, 1,    14, 4, 1, 1,
			14, 5, 0, 1,    15, 5, 1, 1,    12, 2, 1, 4,    12, 6, 0, 3);
			borderLines["Metalloids"]				= new Array(
			12, 1, 0, 1,    13, 1, 1, 1,    13, 2, 0, 1,    14, 2, 1, 1,
			14, 3, 0, 1,    15, 3, 1, 1,    15, 4, 0, 1,    16, 4, 1, 2,
			12, 2, 0, 1,    13, 2, 1, 2,    13, 4, 0, 1,    14, 4, 1, 1,
			14, 5, 0, 1,    15, 5, 1, 1,    12, 1, 1, 1,    15, 6, 0, 1);
			borderLines["Alkali Metals"]			= new Array(
			0, 1, 0, 1,     0, 1, 1, 6,     1, 1, 1, 6,     0, 7, 0, 1);
			borderLines["Alkaline Earth Metals"]	= new Array(
			1, 1, 0, 1,     1, 1, 1, 6,     2, 1, 1, 6,     1, 7, 0, 1);
			borderLines["Transition Metals"]		= new Array(
			2, 3, 0, 10,    2, 3, 1, 2,     2, 5, 0, 1,     3, 5, 1, 2,
			3, 7, 0, 9,     12, 3, 1, 4);
			borderLines["Noble Gases"]				= new Array(
			17, 0, 0, 1,    17, 0, 1, 6,    17, 6, 0, 1,    18, 0, 1, 6);
			borderLines["Halogens"]					= new Array(
			16, 1, 0, 1,    16, 1, 1, 5,    16, 6, 0, 1,    17, 1, 1, 5);
			borderLines["Lanthanides"]				= new Array(
			2, 5, 0, 1,     2, 5, 1, 1,     2, 6, 0, 1,     3, 5, 1, 1,
			2, 8, 0, 14,    2, 8, 1, 1,     2, 9, 0, 14,    16, 8, 1, 1);
			borderLines["Actinides"]				= new Array(
			2, 6, 0, 1,     2, 6, 1, 1,     2, 7, 0, 1,     3, 6, 1, 1,
			2, 9, 0, 14,    2, 9, 1, 1,     2, 10, 0, 14,   16, 9, 1, 1);
			borderLines["Unknowns"]					= new Array(
			12, 6, 0, 6,    12, 6, 1, 1,    12, 7, 0, 6,    18, 6, 1, 1);

			groupMode = false;

			descriptions = new Dictionary();
			descriptions["Non-Metals"]				= "Non-metals, unlike metals, are brittle, unmalleable, and poor electrical and heat conductors. At room temperature, these elements are either gases or solids. They share or gain their valence electrons easily in contrast to metals who easily lose their electrons.";
			descriptions["Other Metals"]			= "Unlike transition metals, these seven elements only have valence electrons in their outermost shell. These elements are opaque, solid, and are relatively dense. Like all metals, transition metals are malleable, ductile, and good electrical and heat conductors.";
			descriptions["Metalloids"]				= "Metalloids are elements with both metal and non-metal characteristics. These elements border the stair-step line which divides metals from non-metals. Some metalloids are semiconductors, which makes these particular elements useful in building computers.";
			descriptions["Alkali Metals"]			= "Alkali metals are highly reactive elements and do not naturally occur in their pure form. These metals are very reactive because they only have one valence electron. If exposed to water, these elements will explode.";
			descriptions["Alkaline Earth Metals"]	= "Alkaline earth metals are highly reactive elements and do not naturally occur in their pure form. These metals are very reactive because they only have two valence electrons. Their name comes from their oxides, which are alkaline (basic) when combined with water.";
			descriptions["Transition Metals"]		= "Transitional metals differ from the other elemental groups because their valence electrons exist in more than one shell. Generally, these elements have high boiling and melting points. Like all metals, these elements are malleable, ductile, and good electrical and heat conductors.";
			descriptions["Noble Gases"]				= "Noble gases are elements with very low reactivity. This low level of reactivity is due to these elements having the maximum number of electrons in their outer shell. All of these elements are gases at room temperature.";
			descriptions["Halogens"]				= "Halogens are highly reactive nonmetallic elements and do not naturally occur in their pure form. These elements all have seven valence electrons in their outer shell. At room temperature, halogens occur in all three forms of matter: gas, liquid, and solid.";
			descriptions["Lanthanides"]				= "Lanthanides are also categorized as rare earth metals. These elements are called Lanthanides because they are all very similar to the first element in the group, Lanthanum. These metals are used in the production of sunglasses because they deflect infrared and ultraviolet rays.";
			descriptions["Actinides"]				= "Actinides are also categorized as rare earth metals. All of these elements are radioactive, but only five of these elements have been found in nature. The others are synthetic elements created in particle accelerators or nuclear reactors.";
			descriptions["Unknowns"]				= "These six elements have been given temporary Latin names until they are fully reported and authenticated. All of these elements have been synthetically observed, but in very small numbers and unstable forms.";
			groupText = new FlxText(0, FlxG.height / 4, FlxG.width);
			groupText.visible = false;
			groupText.size = 32;
			groupText.alignment = "center";
			defaultGroup.add(groupText);
			descText = new FlxText(32, FlxG.height / 2, FlxG.width - 64);
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

			resetDisplay = false;
			resetWarning = new FlxText(0, FlxG.height / 4, FlxG.width, "Would you like to erase your saved game?\nWarning: this is irreversible.");
			resetWarning.visible = false;
			resetWarning.size = 20;
			resetWarning.alignment = "center";
			defaultGroup.add(resetWarning);
			resetYes = new FlxText(FlxG.width - 64 - 80, FlxG.height - 96, 80, "Yes");
			resetYes.size = 24;
			resetYes.alignment = "right";
			resetNo = new FlxText(64, FlxG.height - 96, 80, "No");
			resetNo.size = 24;
			resetYes.visible = false;
			resetNo.visible = false;
			defaultGroup.add(resetYes);
			defaultGroup.add(resetNo);

			flash = new FlxFadeIn();
			defaultGroup.add(flash);
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
			if (!resetDisplay && (currentHover > 0 || groupMode)) {
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
					if (FlxG.mouse.justPressed() && canClick) {
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

			if (!resetDisplay && !groupMode && helpText.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
				if (helpText.color != 0x00FF00) {
					helpText.color = 0x00FF00;
				}
				if (FlxG.mouse.justPressed() && canClick) {
					var fadeOut:FlxFade = new FlxFade()
					fadeOut.start(0xFF000000, 0.5, function():void
					{
						parent.removeChild(background);
						FlxG.state = new HelpState();
					});
					defaultGroup.add(fadeOut);
					canClick = false;
				}
			} else if (helpText.color != 0xFFFFFF) {
				helpText.color = 0xFFFFFF;
			}

			if (!resetDisplay && !groupMode && resetText.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
				if (resetText.color != 0xFF0000) {
					resetText.color = 0xFF0000;
				}
				if (FlxG.mouse.justPressed() && canClick) {
					resetDisplay = true;
					resetWarning.visible = true;
					resetYes.visible = true;
					resetNo.visible = true;
				}
			} else if (resetText.color != 0xFFFFFF) {
				resetText.color = 0xFFFFFF;
			}

			effectsSprite.pixels = effectsSprite.pixels;


			if (!groupMode && currentDescription != lastDescription && currentDescription != -1) {
				FlxG.play(Context.getResources().getSound("beep"), 0.1);
			}

			if (resetDisplay) {
				shape = new Shape();
				shape.graphics.beginFill(0, 0.8);
				shape.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
				effectsSprite.pixels.draw(shape);

				if (resetNo.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					if (resetNo.color != 0xFF0000) {
						resetNo.color = 0xFF0000;
					}
					if (FlxG.mouse.justPressed()) {
						resetDisplay = false;
						resetWarning.visible = false;
						resetYes.visible = false;
						resetNo.visible = false;
					}
				} else {
					if (resetNo.color != 0xFFFFFF) {
						resetNo.color = 0xFFFFFF;
					}
				}
				if (resetYes.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					if (resetYes.color != 0x00FF00) {
						resetYes.color = 0x00FF00;
					}
					if (FlxG.mouse.justPressed()) {
						Context.getPersistentState().reset();
						Context.getPersistentState().save();
						resetElements();
						resetDisplay = false;
						resetWarning.visible = false;
						resetYes.visible = false;
						resetNo.visible = false;
					}
				} else {
					if (resetYes.color != 0xFFFFFF) {
						resetYes.color = 0xFFFFFF;
					}
				}
			}

			if (groupMode) {
				if (play.visible && play.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					if (play.color != 0x00FF00) {
						play.color = 0x00FF00;
					}
					if (FlxG.mouse.justPressed() && !clicked) {
						play.visible = false;
						back.visible = false;
						fadeOut = new FlxFade()
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
					if (play.color != 0xFFFFFF) {
						play.color = 0xFFFFFF;
					}
				}
				if (back.visible && back.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
					if (back.color != 0x00FF00) {
						back.color = 0x00FF00;
					}
					if (FlxG.mouse.justPressed() && !clicked) {
						descText.visible = false;
						groupText.visible = false;
						play.visible = false;
						back.visible = false;
						groupMode = false;
					}
				} else {
					if (back.color != 0xFFFFFF) {
						back.color = 0xFFFFFF;
					}
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