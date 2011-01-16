package  
{
	import level.definitions.GameData;
	import level.LevelState;

	public class Context 
	{

		private static var gameData:GameData = new GameData();
		private static var resources:Resources = new Resources();

		public static function getGameData():GameData
		{
			return gameData;
		}

		public static function getResources():Resources
		{
			return resources;
		}
	}

}