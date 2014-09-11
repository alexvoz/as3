package ru.scarbo.gui.managers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import ru.scarbo.gui.core.BasicSprite;
	import ru.scarbo.gui.events.BasicEvent;
	import ru.scarbo.gui.utils.ColorFilter;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class PopUpManager extends Sprite 
	{
		private static var _inited:Boolean = false;
		private static var _layoutCenterChilren:Array = [];
		private static var _target:BasicSprite;
		private static var _modal:Sprite;
		private static var _modalBitmap:Bitmap;
		private static var _point:Point = new Point(0, 0);
		private static var _gray:ColorFilter = new ColorFilter(ColorFilter.GRAYSCALE);
		private static var _blur:BlurFilter = new BlurFilter();
		
		public static function init(value:BasicSprite):void {
			if (!PopUpManager._inited) {
				PopUpManager._inited = true;
				PopUpManager._target = value;
				PopUpManager._target.addEventListener(BasicEvent.DRAW, _drawHandler);
				//
				PopUpManager._modalBitmap = new Bitmap();
				PopUpManager._modal = new Sprite();
				PopUpManager._target.addChild(PopUpManager._modal);
			}
		}
		
		public static function addPopUp(value:DisplayObject, modal:Boolean = false):void {
			if (PopUpManager._inited) {
				PopUpManager._target.addChild(value);
				if (modal) _createModal();
			}
		}
		
		public static function createPopUp(value:Class, modal:Boolean = false):DisplayObject {
			if (PopUpManager._inited) {
				var child:DisplayObject = new value() as DisplayObject;
				PopUpManager._target.addChild(child);
				if (modal) _createModal();
				return child;
			}else {
				return null;
			}
		}
		
		public static function removePopUp(value:DisplayObject):void {
			if (PopUpManager._inited) {
				PopUpManager._target.removeChild(value);
				_destroyModal();
			}
		}
		
		public static function centerPopUp(value:DisplayObject):void {
			if (PopUpManager._inited) {
				if (PopUpManager._layoutCenterChilren.indexOf(value) == -1) {
					PopUpManager._layoutCenterChilren.push(value);
					PopUpManager._target.changed = true;
				}
			}
		}
		
		private static function _drawHandler(e:BasicEvent):void {
			var length:uint = PopUpManager._layoutCenterChilren.length;
			for (var i:uint = 0; i < length; i++) {
				var child:DisplayObject = PopUpManager._layoutCenterChilren[i] as DisplayObject;
				child.x = (PopUpManager._target.width - child.width) / 2;
				child.y = (PopUpManager._target.height - child.height) / 2;
			}
			_createScreen();
		}
		
		private static function _createScreen():void {
			var bmp:BitmapData = new BitmapData(PopUpManager._target.width, PopUpManager._target.height);
			bmp.draw(PopUpManager._target.stage);
			bmp.applyFilter(bmp, bmp.rect, _point, _gray.filter);
			bmp.applyFilter(bmp, bmp.rect, _point, _blur);
			PopUpManager._modalBitmap.bitmapData = bmp;
		}
		private static function _createModal():void {
			if (PopUpManager._modal.numChildren <= 0) {
				PopUpManager._modal.addChild(PopUpManager._modalBitmap);
			}
			PopUpManager._target.changed = true;
			
		}
		private static function _destroyModal():void {
			if (PopUpManager._modal.numChildren > 0) PopUpManager._modal.removeChild(PopUpManager._modalBitmap);
			PopUpManager._modalBitmap.bitmapData.dispose();
		}
		
	}

}