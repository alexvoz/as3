package ru.cartoonizer.vo 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import ru.scarbo.data.ClassLibrary;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class ResourcePreviewVO implements IResourceVO
	{
		public var elements:Array/*ResourceElementVO*/;
		public var elements_copy:Array/*ResourceElementVO*/;
		
		private var _id:uint;
		private var _icon:DisplayObject;
		
		public function ResourcePreviewVO(id:uint, icon:DisplayObject) 
		{
			this.id = id;
			this.icon = icon;
			this.elements = [];
			this.elements_copy = [];
		}
		
		public function get icons():Object {
			return { 0:new Bitmap(ClassLibrary.getBitmapData('TileSkin')) };
		}
		public function get weight():uint {
			return 0;
		}
		
		public function get id():uint { return this._id; }
		public function set id(value:uint):void 
		{
			this._id = value;
		}
		
		public function get icon():DisplayObject { return this._icon; }
		public function set icon(value:DisplayObject):void 
		{
			if (value) {
				var matrix:Matrix = new Matrix();
				matrix.scale(Main.THUMB_WIDTH / value.width, Main.THUMB_HEIGHT / value.height);
				var bmp:BitmapData = new BitmapData(Main.THUMB_WIDTH, Main.THUMB_HEIGHT, true, 0x00000000);
				bmp.draw(value);
				this._icon = new Bitmap(bmp, 'auto', true);
			}
		}
		
	}

}