package ru.cartoonizer.vo 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import ru.scarbo.gui.core.BasicMask;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ResourceElementVO implements IResourceVO
	{
		public var color:int;
		public var copyColor:int;
		
		private var _id:uint;
		private var _child:DisplayObject;
		
		public function ResourceElementVO(id:uint, child:DisplayObject, color:String, copyColor:String = null) 
		{
			this.id = id;
			this.child = child;
			this.color = (color) ? parseInt('0x' + color) : -1;
			this.copyColor = (copyColor) ? parseInt('0x' + copyColor) : -1;
		}
		
		public function get icons():Object {
			return { 0:new BasicMask(this.color, 1) };
		}
		public function get weight():uint {
			return this.color;
		}
		
		public function get id():uint { return this._id; }
		public function set id(value:uint):void 
		{
			this._id = value;
		}
		
		public function get child():DisplayObject { return this._child; }
		public function set child(value:DisplayObject):void 
		{
			this._child = value;
		}
	}

}