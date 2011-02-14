package level 
{

	import level.weapons.BombWeapon;
	import level.weapons.LaserWeapon;
	import level.weapons.MissileWeapon;
	import level.weapons.SpreadWeapon;
	import org.flixel.FlxG;
	import level.items.*;

	public class ItemGenerator 
	{

		private var nextWeaponTick:int;
		private var nextPowerupTick:int;
		private var nextElementTick:int;

		private const NOWEAPON_SPACING:int = 5 * 60;
		private const WEAPON_SPACING:int = 60 * 60;
		private const POWERUP_SPACING:int = 40 * 60;
		private const ELEMENT_SPACING:int = 15 * 60

		public function ItemGenerator()
		{
			nextWeaponTick = NOWEAPON_SPACING * (1.0 + Math.random() * 0.5);
			nextPowerupTick = POWERUP_SPACING * (1.0 + Math.random() * 0.5);
			nextElementTick = ELEMENT_SPACING * (1.0 + Math.random() * 0.5);
		}

		public function randomSpawn(x:int, y:int):void
		{
			var tick:int = (FlxG.state as LevelState).getTick();
			if (tick > nextWeaponTick) {
				var weapon:Weapon = (FlxG.state as LevelState).getPlayer().getSecondaryWeapon();
				var index:int;
				if (weapon == null) {
					index = Math.floor(Math.random() * 4);
				} else {
					var currentIndex:int;
					if (weapon is LaserWeapon) {
						currentIndex = 0;
					} else if (weapon is SpreadWeapon) {
						currentIndex = 1;
					} else if (weapon is BombWeapon) {
						currentIndex = 2;
					} else if (weapon is MissileWeapon) {
						currentIndex = 3;
					}
					index = Math.floor(Math.random() * 3);
					if (index == currentIndex) {
						index = 3;
					}
				}
				if (index == 0) {
					(Context.getRecycler().getNew(LaserItem) as LaserItem).resetMe(x, y);
				} else if (index == 1) {
					(Context.getRecycler().getNew(SpreadItem) as SpreadItem).resetMe(x, y);
				} else if (index == 2) {
					(Context.getRecycler().getNew(BombItem) as BombItem).resetMe(x, y);
				} else if (index == 3) {
					(Context.getRecycler().getNew(MissileItem) as MissileItem).resetMe(x, y);
				}
				nextWeaponTick = tick + WEAPON_SPACING * (1.0 + Math.random() * 0.5);
			} else if (tick > nextPowerupTick) {
				(Context.getRecycler().getNew(HealthItem) as HealthItem).resetMe(x, y);
				nextPowerupTick = tick + POWERUP_SPACING * (1.0 + Math.random() * 0.5);
			} else if (tick > nextElementTick) {
				var elements:Vector.<int> = Context.getLevelElements();
				// spawn a random element
				var randElem:int = Math.floor(Math.random() * elements.length);
				(Context.getRecycler().getNew(ElementItem) as ElementItem).resetMe(x, y, elements[randElem]);
				nextElementTick = tick + ELEMENT_SPACING * (1.0 + Math.random() * 0.5);
			}
		}

	}

}