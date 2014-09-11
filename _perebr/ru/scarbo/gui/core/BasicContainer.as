package ru.scarbo.gui.core 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicContainer extends BasicSprite 
	{
		protected var _container:Sprite;
		protected var _mask:BasicMask;
		protected var _clipContent:Boolean;
		
		public function BasicContainer() 
		{
			this._container = new Sprite();
			this._mask = new BasicMask();
			this.addRawChild(this._container);
			this.addRawChild(this._mask);
			//
			super();
		}
		
		protected function addRawChild(child:DisplayObject):DisplayObject {
			return super.addChild(child);
		}
		protected function removeRawChild(child:DisplayObject):DisplayObject {
			return super.removeChild(child);
		}
		
		override final public function addChild(child:DisplayObject):DisplayObject {
			var child:DisplayObject = this._container.addChild(child);
			var index:int = this._container.numChildren - 1;
			this._addedChild(child, index);
			return child;
		}
		override final public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			var child:DisplayObject = this._container.addChildAt(child, index);
			this._addedChild(child, index);
			return child;
		}
		override final public function getChildAt(index:int):DisplayObject {
			return this._container.getChildAt(index);
		}
		override final public function getChildByName(name:String):DisplayObject {
			return this._container.getChildByName(name);
		}
		override final public function getChildIndex(child:DisplayObject):int {
			return this._container.getChildIndex(child);
		}
		override final public function removeChild(child:DisplayObject):DisplayObject {
			var index:int = this.getChildIndex(child);
			var child:DisplayObject = this._container.removeChild(child);
			this._removeChild(child, index);
			return child;
		}
		override final public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = this._container.removeChildAt(index);
			this._removeChild(child, index);
			return child;
		}
		override final public function setChildIndex(child:DisplayObject, index:int):void {
			this._container.setChildIndex(child, index);
		}
		override final public function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			this._container.swapChildren(child1, child2);
		}
		override final public function swapChildrenAt(index1:int, index2:int):void {
			this._container.swapChildrenAt(index1, index2);
		}
		override final public function get numChildren():int {
			return this._container.numChildren;
		}
		
		public function removeAllChildren():void {
			while (this._container.numChildren > 0) this._container.removeChildAt(0);
		}
		
		public function set clipContent(value:Boolean):void 
		{
			this._clipContent = value;
			this._container.mask = this._clipContent ? this._mask : null;
			this.changed = true;
		}
		
		override protected function _init():void {
			this._createChildren();
			super._init();
		}
		
		override protected function _draw():void {
			if (this._clipContent) {
				this._mask.setSize(this._width, this._height);
			}
			super._draw();
		}
		
		protected function _addedChild(child:DisplayObject, index:int):void {
			this.changed = true;
		}
		protected function _removeChild(child:DisplayObject, index:int):void {
			this.changed = true;
		}
		protected function _createChildren():void { }
	}

}