package  
{
	import level.definitions.GameData;
	import level.LevelState;

	public class Context 
	{
		public static var bgFrameRateHack:Boolean = false;

		private static var gameData:GameData = new GameData();
		private static var resources:Resources = new Resources();
		private static var persistentState:PersistentState = new PersistentState();
		private static var recycler:Recycler = new Recycler();

		private static var levelElements:Vector.<int> = new Vector.<int>();

		public static function getGameData():GameData
		{
			return gameData;
		}

		public static function getResources():Resources
		{
			return resources;
		}

		public static function getPersistentState():PersistentState
		{
			return persistentState;
		}

		public static function getRecycler():Recycler
		{
			return recycler;
		}

		public static function getLevelElements():Vector.<int>
		{
			return levelElements;
		}
	}

}