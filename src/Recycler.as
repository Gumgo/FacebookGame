package  
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;

	public class Recycler 
	{
		private var listDict:Dictionary;

		public function Recycler()
		{
			listDict = new Dictionary();
		}

		public function getNew(classType:Class):Object
		{
			var vec:Vector.<Object> = listDict[classType];
			if (vec == null) {
				vec = new Vector.<Object>();
				listDict[classType] = vec;
			}
			if (vec.length == 0) {
				return new classType();
			} else {
				return vec.pop();
			}
		}

		public function recycle(o:Object):void
		{
			var classType:Class = getDefinitionByName(getQualifiedClassName(o)) as Class;
			var vec:Vector.<Object> = listDict[classType];
			if (vec == null) {
				vec = new Vector.<Object>();
				listDict[classType] = vec;
			}

			/*
// TEMPORARY - FOR CATCHING BUGS ONLY!!!!! REMOVE IN FINAL BUILD!
for (var i:int = 0; i < vec.length; ++i) {
	if (vec[i] == o) {
		var a:int;
		a = 0;
	}
}*/

			vec.push(o);
		}

		public static function addToGroup(group:FlxGroup, object:FlxObject):void
		{
			for (var i:int = 0; i < group.members.length; ++i) {
				if (group.members[i] == object) {
					var a:int = 3;
					a = 3;
				}
			}
			var firstNull:int = group.getFirstNull();
			if (firstNull == -1) {
				group.add(object);
			} else {
				group.members[firstNull] = object;
			}
		}

	}

}