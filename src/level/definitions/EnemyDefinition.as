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
		private var damage:int;
		private var deathOnPlayerCollision:Boolean;
		private var invincible:Boolean;

		private var items:Vector.<String>;
		private var dropRates:Vector.<Number>;
		private var strengths:Vector.<Number>;

		public function EnemyDefinition(name:String, sprite:String, deathSprite:String, deathSound:String, health:int, color:uint, damage:int, deathOnPlayerCollision:Boolean, invincible:Boolean, items:Vector.<String>, dropRates:Vector.<Number>, strengths:Vector.<Number>)
		{
			this.name = name;
			this.sprite = sprite;
			this.deathSprite = deathSprite;
			this.deathSound = deathSound;
			this.health = health;
			this.color = color;
			this.damage = damage;
			this.deathOnPlayerCollision = deathOnPlayerCollision;
			this.invincible = invincible;

			this.items = items;
			this.dropRates = dropRates;
			this.strengths = strengths;
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

		public function getItems():Vector.<String>
		{
			return items;
		}

		public function getDropRates():Vector.<Number>
		{
			return dropRates;
		}

		public function getStrengths():Vector.<Number>
		{
			return strengths;
		}

	}

}