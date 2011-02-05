package  
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;

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
			vec.push(o);
		}

	}

}