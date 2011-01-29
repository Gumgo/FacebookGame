package inventory 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
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

		override public function create():void 
		{
			var BackgroundDef:Class = Context.getResources().getSprite("background1Anim");
			var background:MovieClip = new BackgroundDef() as MovieClip;
			background.scaleX = 2.0;
			background.scaleY = 2.0;
			parent.addChildAt(background, 0);
			bgColor = 0;

			FlxG.mouse.show();
			colors = new Dictionary();
			colors["Non-Metal"]				= 0x80ff80;
			colors["Other Non-Metal"]		= 0x8080ff;
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
			descriptionText = new FlxText(32, 0, FlxG.width - 64);
			descriptionText.size = 16;
			descriptionText.color = 0;
			descriptionTextRight = new FlxText(32, 0, FlxG.width - 64);
			descriptionTextRight.size = 16;
			descriptionTextRight.alignment = "right";
			descriptionText.color = 0;

			defaultGroup.add(descriptionBanner);
			defaultGroup.add(descriptionText);
			defaultGroup.add(descriptionTextRight);
		}

		public function groupColor(group:String):uint
		{
			return colors[group];
		}

		public function describe(number:int, bottomScreen:Boolean):void
		{
			if (number <= 0) {
				descriptionBanner.visible = false;
				descriptionText.visible = false;
				descriptionTextRight.visible = false;
				return;
			}

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

		override public function update():void
		{
			var lastDescription:int = currentDescription;
			describe( -1, false); // clear the description
			super.update();

			if (currentDescription != lastDescription && currentDescription != -1) {
				FlxG.play(Context.getResources().getSound("beep"));
			}
		}
		
	}

}