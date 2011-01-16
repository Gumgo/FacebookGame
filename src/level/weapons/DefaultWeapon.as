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
					new DefaultBullet(player.x + 12, player.y);
				} else {
					new DefaultBullet(player.x + player.width - 12, player.y);
				}
				side = !side;
				timer = 5;
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