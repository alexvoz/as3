package ru.cartoonizer 
{
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import ru.cartoonizer.vo.IResourceVO;
	import ru.cartoonizer.vo.ResourceDeleteVO;
	import ru.cartoonizer.vo.ResourceElementVO;
	import ru.cartoonizer.vo.ResourcePreviewVO;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ResourceParser 
	{
		private var _cache:Object;
		
		public function ResourceParser() 
		{
			this._cache = { };
		}
		
		public function addResource(value:Sprite, id:String):void {
			var numChildren:uint = value.numChildren;
			var elements:Array = [];
			for (var i:uint = 0; i < numChildren; i++) {
				var child:DisplayObject = value.getChildAt(i) as DisplayObject;
				var split:Array = child.name.split('_');
				var key:uint = parseInt(split[1]);
				var identifer:String = (split.length >= 3) ? split[2] : null;
				//
				if (identifer == 'preview') {
					elements.push(new ResourcePreviewVO(key, child));
				}
				else if (identifer == 'copy') {
					elements.push(new ResourceElementVO(key, child, null, split[3]));
				}
				else {
					elements.push(new ResourceElementVO(key, child, identifer));
				}
			}
			elements.sortOn(['id', 'weight'], [Array.NUMERIC, Array.NUMERIC]);
			//
			var array:Array = [];
			var preview:ResourcePreviewVO;
			var index:uint = 0;
			var itter:uint = 0;
			for each(var resource:IResourceVO in elements) {
				if (index != resource.id) {
					preview = resource as ResourcePreviewVO;
					array.push(resource);
					index = resource.id;
					itter++;
				}
				if (Object(resource).hasOwnProperty('color')) {
					if (resource['copyColor'] > -1) {
						preview.elements_copy.push(resource);
					}else {
						preview.elements.push(resource);
					}
				}
			}
			array.push(new ResourceDeleteVO());
			this._cache[id] = array;
		}
		
		public function getResources(id:String):Array/*ResourcePreviewVO*/ {
			return this._cache[id];
		}
	}

}