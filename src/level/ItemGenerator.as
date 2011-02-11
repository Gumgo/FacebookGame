package level 
{

	import level.items.*;

	public class ItemGenerator 
	{

		public function randomSpawn(x:int, y:int):void
		{
			const ITEM_CHANCE:Number = 7;		// percent chance of items appearing
			const ELEMENT_CHANCE:Number = 4;	// percent chance of elements appearing

			var rand:Number = Math.random() * 100.0;
			if (rand < ITEM_CHANCE) {
				// generate item
				var item:int = Math.floor(Math.random() * 5.0);
				if (item == 0) {
					(Context.getRecycler().getNew(HealthItem) as HealthItem).resetMe(x, y);
				} else if (item == 1) {
					(Context.getRecycler().getNew(SpreadItem) as SpreadItem).resetMe(x, y);
				} else if (item == 2) {
					(Context.getRecycler().getNew(LaserItem) as LaserItem).resetMe(x, y);
				} else if (item == 3) {
					(Context.getRecycler().getNew(MissileItem) as MissileItem).resetMe(x, y);
				} else if (item == 4) {
					(Context.getRecycler().getNew(BombItem) as BombItem).resetMe(x, y);
				}
			} else if (rand < ITEM_CHANCE + ELEMENT_CHANCE) {
				var elements:Vector.<int> = Context.getLevelElements();
				// spawn a random element
				var randElem:int = Math.floor(Math.random() * elements.length);
				(Context.getRecycler().getNew(ElementItem) as ElementItem).resetMe(x, y, elements[randElem]);
			}
		}

	}

}