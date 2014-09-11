package ua.olexandr.managers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import ua.olexandr.utils.FilterUtils;
	
	public class PopupManager extends Sprite {
		
		private static var _inited:Boolean = false;
		private static var _popups:Array = [];
		private static var _target:DisplayObjectContainer;
		
		private static var _modal:Sprite;
		private static var _modalBitmap:Bitmap;
		
		/**
		 * 
		 * @param	value
		 */
		public static function init(value:DisplayObjectContainer):void {
			if (!_inited) {
				_inited = true;
				_target = value;
				_target.addEventListener(Event.RENDER, drawHandler);
				
				_modalBitmap = new Bitmap();
				_modal = new Sprite();
				_target.addChild(_modal);
			}
		}
		
		/**
		 * 
		 * @param	value
		 * @param	modal
		 */
		public static function addPopup(value:DisplayObject, modal:Boolean = false):void {
			if (_inited) {
				_target.addChild(value);
				if (modal)
					createModal();
			}
		}
		
		/**
		 * 
		 * @param	value
		 */
		public static function removePopup(value:DisplayObject):void {
			if (_inited) {
				_target.removeChild(value);
				destroyModal();
			}
		}
		
		/**
		 * 
		 * @param	value
		 */
		public static function centerPopup(value:DisplayObject):void {
			if (_inited) {
				if (_popups.indexOf(value) == -1) {
					_popups.push(value);
					_target.changed = true;
				}
			}
		}
		
		
		private static function drawHandler(e:Event):void {
			var _len:uint = _popups.length;
			for (var i:uint = 0; i < _len; i++) {
				var child:DisplayObject = _popups[i] as DisplayObject;
				child.x = (_target.width - child.width) / 2;
				child.y = (_target.height - child.height) / 2;
			}
			
			createScreen();
		}
		
		private static function createScreen():void {
			var _point:Point = new Point(0, 0);
			
			var bmp:BitmapData = new BitmapData(_target.width, _target.height);
			bmp.draw(_target.stage);
			bmp.applyFilter(bmp, bmp.rect, _point, FilterUtils.getGrayscaleFilter());
			bmp.applyFilter(bmp, bmp.rect, _point, new BlurFilter());
			_modalBitmap.bitmapData = bmp;
		}
		
		private static function createModal():void {
			if (_modal.numChildren <= 0)
				_modal.addChild(_modalBitmap);
			
			_target.changed = true;
		
		}
		
		private static function destroyModal():void {
			if (_modal.numChildren > 0)
				_modal.removeChild(_modalBitmap);
			_modalBitmap.bitmapData.dispose();
		}
	
	}

}