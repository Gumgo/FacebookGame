package level.definitions 
{
	public class ElementDefinition 
	{
		private var number:int;
		private var symbol:String;
		private var name:String;
		private var group:String;
		private var description:String;
		
		public function ElementDefinition(number:int, symbol:String, name:String, group:String, description:String)
		{
			this.number = number;
			this.symbol = symbol;
			this.name = name;
			this.group = group;
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

		public function getDescription():String
		{
			return description;
		}
		
	}

}