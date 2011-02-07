package level.definitions 
{

	public class EnemyDefinition 
	{
		private var name:String;
		private var sprite:String;
		private var deathSprite:String;
		private var deathSound:String;
		private var health:int;
		private var color:uint;
		private var deathColor:uint;
		private var damage:int;
		private var deathOnPlayerCollision:Boolean;
		private var invincible:Boolean;

		public function EnemyDefinition(name:String, sprite:String, deathSprite:String, deathSound:String, health:int, color:uint, deathColor:uint, damage:int, deathOnPlayerCollision:Boolean, invincible:Boolean)
		{
			this.name = name;
			this.sprite = sprite;
			this.deathSprite = deathSprite;
			this.deathSound = deathSound;
			this.health = health;
			this.color = color;
			this.deathColor = deathColor;
			this.damage = damage;
			this.deathOnPlayerCollision = deathOnPlayerCollision;
			this.invincible = invincible;
		}

		public function getName():String
		{
			return name;
		}

		public function getSprite():String
		{
			return sprite;
		}

		public function getDeathSprite():String
		{
			return deathSprite;
		}

		public function getDeathSound():String
		{
			return deathSound;
		}

		public function getHealth():int
		{
			return health;
		}

		public function getColor():uint
		{
			return color;
		}

		public function getDeathColor():uint
		{
			return deathColor;
		}

		public function getDamage():int
		{
			return damage;
		}

		public function getDeathOnPlayerCollision():Boolean
		{
			return deathOnPlayerCollision;
		}

		public function getInvincible():Boolean
		{
			return invincible;
		}

	}

}