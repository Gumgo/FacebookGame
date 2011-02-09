package level.weapons 
{
	import level.Weapon;
	import level.Player;

	public class BombWeapon extends Weapon
	{

		private var timer:int;

		override public function shoot(player:Player):void
		{
			if (timer == 0) {
				timer = int(Math.ceil( 5.0 / player.getShotRateMultiplier()));
				(Context.getRecycler().getNew(BombBullet) as BombBullet).resetMe(player.x + player.width / 2, player.y + player.height / 2);
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