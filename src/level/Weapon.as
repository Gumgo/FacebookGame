package level 
{
	/**
	 * ...
	 * @author Ben
	 */
	public class Weapon 
	{

		public function shoot(player:Player):void
		{
			throw new Error("shoot was not overridden in a class derived from Weapon");
		}

		public function update():void
		{
		}

	}

}