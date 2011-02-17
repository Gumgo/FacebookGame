package level.definitions 
{
	public class ElementDefinition 
	{
		private var number:int;
		private var symbol:String;
		private var name:String;
		private var group:String;
		private var sprite:String;
		private var color:uint;
		private var flags:String;
		private var description:String;
		
		public function ElementDefinition(number:int, symbol:String, name:String, group:String, sprite:String, color:uint, flags:String, description:String)
		{
			this.number = number;
			this.symbol = symbol;
			this.name = name;
			this.group = group;
			this.sprite = sprite;
			this.color = color;
			this.flags = flags;
			this.description = description;
		}

		public function getNumber():int
		{
			return number;
		}

		public function getSymbol():String
		{
			return symbol;
		}

		public function getName():String
		{
			return name;
		}

		public function getGroup():String
		{
			return group;
		}

		public function getSprite():String
		{
			return sprite;
		}

		public function getColor():uint
		{
			return color;
		}

		public function containsFlag(flag:String):Boolean
		{
			for (var i:int = 0; i < flags.length; ++i) {
				if (flags.charCodeAt(i) == flag.charCodeAt(0)) {
					return true;
				}
			}
			return false;
		}

		public function getDescription():String
		{
			return description;
		}
		
	}

}