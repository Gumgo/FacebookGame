package  
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	public class PersistentState 
	{
		public static const ELEM_UNENCOUNTERED:int = 0;
		public static const ELEM_COLLECTED:int = 1;

		public static const HEALTH_MIN:int = 100;
		public static const HEALTH_MAX:int = 400;
		public static const SHIELDS_MIN:Number = 1.0;
		public static const SHIELDS_MAX:Number = 3.0;
		public static const DAMAGE_MIN:Number = 0.5;
		public static const DAMAGE_MAX:Number = 3.0;

		private static var currentHealth:int;
		private static var currentShields:Number;
		private static var currentDamage:Number;

		private static var score:int;

		private var elements:Array;
		private var collectedCount:int;

		private var userId:String;

		private var newUser:Boolean;

		public function PersistentState() 
		{
			elements = new Array();
			reset();
		}

		public function reset():void
		{
			collectedCount = 0;
			for (var i:int = 0; i < 118; ++i) {
				//if (Math.random() >= 7.5 / 8.0)
				elements[i] = ELEM_UNENCOUNTERED;
				//else { elements[i] = ELEM_COLLECTED;++collectedCount;}
			}

			score = 0;
		}

		public function setElementState(element:int, state:int):void
		{
			if (state == ELEM_COLLECTED && elements[element - 1] != ELEM_COLLECTED) {
				++collectedCount;
			} else if (state != ELEM_COLLECTED && elements[element - 1] == ELEM_COLLECTED) {
				--collectedCount;
			}
			elements[element - 1] = state;
		}

		public function getElementState(element:int):int
		{
			return elements[element - 1];
		}

		public function getCollectedElementCount():int
		{
			return collectedCount;
		}

		public function computeStats():void
		{
			var currentHealthElements:int = 0;
			var maxHealthElements:int = 0;
			var currentShieldsElements:int = 0;
			var maxShieldsElements:int = 0;
			var currentDamageElements:int = 0;
			var maxDamageElements:int = 0;
			for (var i:int = 0; i < 118; ++i) {
				var inc:int = elements[i] == ELEM_COLLECTED ? 1 : 0;
				var group:String = Context.getGameData().getElementDefinition(i + 1).getGroup();
				if (		group == "Non-Metals" ||
							group == "Noble Gases" ||
							group == "Lanthanides" ||
							group == "Metalloids") {
					++maxHealthElements;
					currentHealthElements += inc;
				} else if (	group == "Alkali Metals" ||
							group == "Alkaline Earth Metals" ||
							group == "Halogens" ||
							group == "Actinides") {
					++maxDamageElements;
					currentDamageElements += inc;
				} else if (	group == "Other Metals" ||
							group == "Transition Metals") {
					++maxShieldsElements;
					currentShieldsElements += inc;
				} else if (	group == "Unknowns") {
					// secret bonus
				} else {
					throw new Error("Unknown element group");
				}
			}

			currentHealth = int(MathExt.lerp(HEALTH_MIN, HEALTH_MAX, Number(currentHealthElements) / Number(maxHealthElements)));
			currentShields = MathExt.lerp(SHIELDS_MIN, SHIELDS_MAX, Number(currentShieldsElements) / Number(maxShieldsElements));
			currentDamage = MathExt.lerp(DAMAGE_MIN, DAMAGE_MAX, Number(currentDamageElements) / Number(maxDamageElements));
		}

		public function getCurrentHealth():int
		{
			return currentHealth;
		}

		public function getCurrentShields():Number
		{
			return currentShields;
		}

		public function getCurrentDamage():Number
		{
			return currentDamage;
		}

		public function incScore(amount:int):void
		{
			score += amount;
		}

		public function getScore():int
		{
			return score;
		}

		private static const encode:String =
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		public function getEncodedElements():String
		{
			var out:String = "";
			var written:int = 0;
			while (written < 118) {
				var val:int = 0;
				for (var i:int = 0; i < 6; ++i) {
					if (written + 1 <= 118 && getElementState(written + 1) == ELEM_COLLECTED) {
						val |= (1 << i);
					}
					++written;
				}
				out += encode.charAt(val);
			}

			return out;
		}

		public function setEncodedElements(encoded:String):void
		{
			if (encoded == null) {
				return;
			}

			var written:int = 0;
			for (var i:int = 0; i < encoded.length; ++i) {
				var val:int = encode.indexOf(encoded.charAt(i));
				for (var t:int = 0; t < 6; ++t) {
					if (written < 118) {
						if ((val & (1 << t)) != 0) {
							setElementState(written + 1, ELEM_COLLECTED);
						} else {
							setElementState(written + 1, ELEM_UNENCOUNTERED);
						}
					}
					++written;
				}
			}
		}

		public function setUserId(uid:String):void
		{
			userId = uid;
		}

		public function getUserId():String
		{
			return userId;
		}

		public function setNewUser(nu:Boolean):void
		{
			newUser = nu;
		}

		public function isNewUser():Boolean
		{
			return newUser;
		}

		public function getVerification():String
		{
			const SALT:String = "vk8n4aop25ef8hx3c60h";
			return MD5.encrypt(getUserId() + getEncodedElements() + getScore() + SALT);
		}

		public function save():void
		{
			if (userId == null) {
				return;
			}

			const URL:String = "http://students.washington.edu/jclement/nucleos/writesave.php"
			var request:URLRequest = new URLRequest(URL);
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			variables.uid = getUserId();
			variables.ss = getEncodedElements();
			variables.score = String(getScore());
			variables.verify = getVerification();
			request.data = variables;
			request.contentType = "application/x-www-form-urlencoded";

			var loader:URLLoader = new URLLoader(request);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}

	}

}