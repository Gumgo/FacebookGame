package level.weapons 
{
	import level.Weapon;
	import level.Player;

	public class SpreadWeapon extends Weapon
	{

		private var timer:int;

		override public function shoot(player:Player):void
		{
			if (timer == 0) {
				timer = player.getFireRate(16);
				(Context.getRecycler().getNew(SpreadBullet) as SpreadBullet).resetMe(player.x + 8, player.y + 16, 100.0);
				(Context.getRecycler().getNew(SpreadBullet) as SpreadBullet).resetMe(player.x - 8 + player.width, player.y + 16, 80.0);
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