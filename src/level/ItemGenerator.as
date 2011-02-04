package level 
{
	import level.items.TestItem;

	public class ItemGenerator 
	{

		public function randomSpawn(x:int, y:int):void
		{
			const ITEM_CHANCE:int = 10;		// percent chance of items appearing
			const ELEMENT_CHANCE:int = 2;	// percent chance of elements appearing

			var rand:Number = Math.random() * 100.0;
			if (rand < ITEM_CHANCE) {
				// generate item
				// TODO!!! Add more items
				(Context.getRecycler().getNew(TestItem) as TestItem).resetMe(x, y);
			} else if (rand < ITEM_CHANCE + ELEMENT_CHANCE) {
				var elements:Vector.<int> = Context.getLevelElements();
				// spawn a random element
				var randElem:int = Math.floor(Math.random() * elements.length);
				(Context.getRecycler().getNew(ElementItem) as ElementItem).resetMe(x, y, elements[randElem]);
			}
		}

	}

}