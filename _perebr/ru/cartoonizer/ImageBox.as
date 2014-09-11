package ru.cartoonizer 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.gui.core.IBasic;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ImageBox extends Sprite implements IBasic
	{
		private var _watermark:Sprite;
		
		public function ImageBox() 
		{
			super();
		}
		
		public function set numContainers(value:uint):void 
		{
			for (var i:uint = 0; i < value; i++) {
				var child:Sprite = new Sprite();
				super.addChild(child);
			}
			this._watermark = ClassLibrary.getDisplayObject('Watermark') as Sprite;
			this.hideWatermark();
			super.addChild(this._watermark);
		}
		
		public function hideWatermark():void {
			this._watermark.visible = false;
		}
		public function showWatermark():void {
			this._watermark.visible = true;
		}
		
		public function setSize(width:int, height:int):void {
			var numChildren:uint = super.numChildren;
			for (var i:uint = 0; i < numChildren; i++) {
				var child:Sprite = super.getChildAt(i) as Sprite;
				child.width = width;
				child.height = height;
			}
		}
		
		override final public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var container:Sprite = super.getChildAt(index) as Sprite;
			if (container) {
				while (container.numChildren > 0) container.removeChildAt(0);
				return (child) ? container.addChild(child) : null;
			}else {
				return null;
			}
		}
		
		override final public function addChild(child:DisplayObject):DisplayObject {
			return null;
		}
		override final public function getChildAt(index:int):DisplayObject {
			return null;
		}
		override final public function getChildByName(name:String):DisplayObject {
			return null;
		}
		override final public function getChildIndex(child:DisplayObject):int {
			return -1;
		}
		override final public function removeChild(child:DisplayObject):DisplayObject {
			return null;
		}
		override final public function removeChildAt(index:int):DisplayObject {
			return null;
		}
		override final public function setChildIndex(child:DisplayObject, index:int):void {
			//
		}
		override final public function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			//
		}
		override final public function swapChildrenAt(index1:int, index2:int):void {
			//
		}
		
	}

}