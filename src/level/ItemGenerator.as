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
		private const WEAPON_SPACING:int = 35 * 60;
		private const POWERUP_SPACING:int = 40 * 60;
		private const ELEMENT_SPACING:int = 15 * 60

		// weight the elements - we want uncollected ones to appear more often
		private const UNENCOUNTERED_WEIGHT:Number = 3.0;
		private const COLLECTED_WEIGHT:Number = 1.0;
		private var totalWeight:Number;
		private var totalNewWeight:Number;

		public function ItemGenerator()
		{
			nextWeaponTick = NOWEAPON_SPACING * (1.0 + Math.random() * 0.5);
			nextPowerupTick = POWERUP_SPACING * (1.0 + Math.random() * 0.5);
			nextElementTick = ELEMENT_SPACING * (1.0 + Math.random() * 0.5);

			var elements:Vector.<int> = Context.getLevelElements();
			totalWeight = 0;
			totalNewWeight = 0;
			for (var i:int = 0; i < elements.length; ++i) {
				if (Context.getPersistentState().getElementState(elements[i]) == PersistentState.ELEM_COLLECTED) {
					totalWeight += COLLECTED_WEIGHT;
				} else {
					totalWeight += UNENCOUNTERED_WEIGHT;
					totalNewWeight += UNENCOUNTERED_WEIGHT;
				}
			}
		}

		public function randomSpawn(x:int, y:int, guaranteeElement:Boolean = false, applyEffect:Boolean = true):void
		{
			var tick:int = (FlxG.state as LevelState).getTick();
			if (tick > nextWeaponTick && !guaranteeElement) {
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
			} else if (tick > nextPowerupTick && !guaranteeElement) {
				(Context.getRecycler().getNew(HealthItem) as HealthItem).resetMe(x, y);
				nextPowerupTick = tick + POWERUP_SPACING * (1.0 + Math.random() * 0.5);
			} else if (tick > nextElementTick || guaranteeElement) {
				var elements:Vector.<int> = Context.getLevelElements();
				// spawn a random (weighted) element
				var randElem:Number = Math.random() * (guaranteeElement ? totalNewWeight : totalWeight);
				if (!guaranteeElement || totalNewWeight > 0) {
					var totalSoFar:Number = 0;
					for (var i:int = 0; i < elements.length; ++i) {
						if (Context.getPersistentState().getElementState(elements[i]) == PersistentState.ELEM_COLLECTED) {
							if (!guaranteeElement) {
								totalSoFar += COLLECTED_WEIGHT;
							}
						} else {
							totalSoFar += UNENCOUNTERED_WEIGHT;
						}
						if (randElem < totalSoFar) {
							(Context.getRecycler().getNew(ElementItem) as ElementItem).resetMe(x, y, elements[i], applyEffect);
							nextElementTick = tick + ELEMENT_SPACING * (1.0 + Math.random() * 0.5);
							return;
						}
					}
				} else {
					// no new ones left; just pick a random element
					index = Math.floor(Math.random() * elements.length);
					(Context.getRecycler().getNew(ElementItem) as ElementItem).resetMe(x, y, elements[index], applyEffect);
					nextElementTick = tick + ELEMENT_SPACING * (1.0 + Math.random() * 0.5);
				}
			}
		}

	}

}