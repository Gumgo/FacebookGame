package level.weapons 
{
	import level.Weapon;
	import level.Player;

	public class MissileWeapon extends Weapon
	{

		private var timer:int;

		override public function shoot(player:Player):void
		{
			if (timer == 0) {
				timer = 40;
				new MissileBullet(player.x + player.width / 2, player.y + 16);
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