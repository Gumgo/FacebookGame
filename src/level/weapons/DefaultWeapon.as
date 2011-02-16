package level.weapons 
{
	import level.Player;
	import level.Weapon;

	public class DefaultWeapon extends Weapon 
	{

		private var side:Boolean;
		private var timer:int;

		override public function shoot(player:Player):void
		{
			if (timer == 0) {
				if (side == false) {
					(Context.getRecycler().getNew(DefaultBullet) as DefaultBullet).resetMe(player.x + 12, player.y);
				} else {
					(Context.getRecycler().getNew(DefaultBullet) as DefaultBullet).resetMe(player.x + player.width - 12, player.y);
				}
				side = !side;
				timer = player.getFireRate(8);
			}
		}

		override public function update():void
		{
			if (timer > 0) {
				--timer;
			}
		}
		
	}

}