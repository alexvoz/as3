package ua.olexandr.display.proxies {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import ua.olexandr.utils.GeomUtils;
	
	public class DisplayProxy extends BaseProxy {
		
		protected var _view:DisplayObject;
		
		public function get view():DisplayObject {
			return _view;
		}
		
		public function get container():DisplayObjectContainer {
			return _view as DisplayObjectContainer;
		}
		
		public function get interactive():InteractiveObject {
			return _view as InteractiveObject;
		}
		
		public function get sprite():Sprite {
			return _view as Sprite;
		}
		
		public function get movieClip():MovieClip {
			return _view as MovieClip;
		}
		
		public function get shape():Shape {
			return _view as Shape;
		}
		
		public function get bitmap():Bitmap {
			return _view as Bitmap;
		}
		
		public function get textField():TextField {
			return _view as TextField;
		}
		
		public function get graphics ():Graphics {
            if (sprite) 		return sprite.graphics;
            else if (shape) 	return shape.graphics;
			
            return null;
        }
		
		
		/**
		 * Constructor
		 * @param	view
		 */
		public function DisplayProxy(view:DisplayObject) {
			super(view);
			_view = view;
		}
		
		/**
		 * Переместить
		 * @param	x
		 * @param	y
		 * @param	truncate
		 * @return
		 */
		public function moveTo(x:Number, y:Number, truncate:Boolean = false):DisplayProxy {
			view.x = truncate ? Math.round(x) : x;
			view.y = truncate ? Math.round(y) : y;
			return this;
		}
		
		/**
		 * Сместить
		 * @param	dx
		 * @param	dy
		 * @param	truncate	округлить?
		 * @return
		 */
		public function offset(dx:Number, dy:Number, truncate:Boolean = false):DisplayProxy {
			return moveTo(view.x + dx, view.y + dy, truncate);
		}
		
		/**
		 * Растянуть
		 * @param	scaleX
		 * @param	scaleY
		 * @return
		 */
		public function scale(scaleX:Number, scaleY:Number = NaN):DisplayProxy {
			if (isNaN(scaleY))
				scaleY = scaleX;
			
			view.scaleX = scaleX;
			view.scaleY = scaleY;
			
			return this;
		}
		
		/**
		 * Исказить по X
		 * @param	value
		 * @return
		 */
		public function skewX(value:Number):DisplayProxy {
			var _m:Matrix = view.transform.matrix;
			_m.c = Math.tan(GeomUtils.degreesToRadians(value));
			view.transform.matrix = _m;
			
			return this;
		}
		
		/**
		 * Исказить по Y
		 * @param	value
		 * @return
		 */
		public function skewY(value:Number):DisplayProxy {
			var _m:Matrix = view.transform.matrix;
			_m.b = Math.tan(GeomUtils.degreesToRadians(value));
			view.transform.matrix = _m;
			
			return this;
		}
		
		
		/**
		 * 
		 * @param	target
		 * @param	color
		 */
		public function setColor(color:uint):DisplayProxy {
			var _colorTransform:ColorTransform = _view.transform.colorTransform;
			_colorTransform.color = color;
			_view.transform.colorTransform = _colorTransform;
			
			return this;
		}
		
		
		/**
		 * Показать
		 * @return
		 */
		public function show():DisplayProxy {
			view.visible = true;
			return this;
		}
		
		/**
		 * Спрятать
		 * @return
		 */
		public function hide():DisplayProxy {
			view.visible = false;
			return this;
		}
		
		/**
		 * Переключить видимость
		 * @return
		 */
		public function toggle():DisplayProxy {
			view.visible = !view.visible;
			return this;
		}
		
		
		/**
		 * Отключить мышь
		 * @return
		 */
		public function mouseDisable():DisplayProxy {
			if (interactive)
				interactive.mouseEnabled = false;
			
			if (container)
				container.mouseChildren = false;
			
			return this;
		}
		
		/**
		 * Включить мышь
		 * @return
		 */
		public function mouseEnable():DisplayProxy {
			if (interactive)
				interactive.mouseEnabled = true;
			
			if (container)
				container.mouseChildren = true;
			
			return this;
		}
		
		/**
		 * Переключить мышь
		 * @return
		 */
		public function mouseToggle():DisplayProxy {
			if (interactive)
				interactive.mouseEnabled = !interactive.mouseEnabled;
			
			if (container)
				container.mouseChildren = container.mouseEnabled;
			
			return this;
		}
		
		
		/**
		 * Добавить ребенка
		 * @param	child
		 * @param	index
		 * @return
		 */
		public function addChild(child:DisplayObject, index:int = int.MAX_VALUE):DisplayProxy {
			if (container) {
				if (index == int.MAX_VALUE) 	container.addChild(child);
				else 							container.addChildAt(child, index);
			}
			
			return this;
		}
		
		/**
		 * Удалить ребенка
		 * @param	child
		 * @return
		 */
		public function removeChild(child:DisplayObject):DisplayProxy {
			if (container && container.contains(child))
				container.removeChild(child);
			
			return this;
		}
		
		/**
		 * Удалить детей
		 * @param	remainNum		остаток
		 * @param	removeFromTop	направление удаления
		 * @return
		 */
		public function clear(remainNum:int = 0, removeFromTop:Boolean = false):DisplayProxy {
			if (container) {
				if (container.numChildren > remainNum) {
					while (container.numChildren > remainNum)
						container.removeChildAt(removeFromTop ? container.numChildren - 1 : 0);
				}
			}
			
			return this;
		}
		
		
		/**
		 * Получить массив детей
		 * @return
		 */
		public function getChildren():Array {
			var _children:Array = [];
			
			if (container) {
				var _len:int = container.numChildren;
				
				for (var i:int = 0; i < _len; i++)
					_children[i] = container.getChildAt(i);
			}
			
			return _children;
		}
		
		/**
		 * Получить первого ребенка
		 * @return
		 */
		public function getFirstChild():DisplayObject {
			return (container && container.numChildren) ? container.getChildAt(0) : null;
		}
		
		/**
		 * Получить последнего ребенка
		 * @return
		 */
		public function getLastChild():DisplayObject {
			return (container && container.numChildren) ? container.getChildAt(container.numChildren - 1) : null;
		}
		
		
		/*
		public function getBounds():Rect {
			if (!view.stage) {
				return null;
			}
			return Rect.coerce(view.getBounds(view));
		}
		
		public static function hitTest(globalX:int, globalY:int, checkBounds:Boolean = true):Boolean {
			_HIT_POINT.x = globalX;
			_HIT_POINT.y = globalY;
			if (checkBounds) {
				if ((!view is Bitmap) && !getBounds(view).containsPoint(view.globalToLocal(new Point(globalX, globalY)))) {
					return false;
				}
			}
			var localPoint:Point = DisplayObject(view).globalToLocal(_HIT_POINT);
			if (checkBounds && view is Bitmap) {
				if (localPoint.x < 0 || localPoint.y < 0 || localPoint.x >= view.width || localPoint.y >= view.height) {
					return false;
				}
			}
			if (view is Bitmap) {
				return hitTestBitmap(view as Bitmap, localPoint.x, localPoint.y);
			} else {
				return hitTestShape(view, localPoint.x, localPoint.y);
			}
		}
		
		private const _HIT_TEST_HELPER_BD:BitmapData = new BitmapData(1, 1, true, 0);
		private const _HIT_TEST_MATRIX:Matrix = new Matrix();
		private const _HIT_POINT:Point = new Point();
		
		private function hitTestShape(target:DisplayObject, localX:Number, localY:Number):Boolean {
			_HIT_TEST_MATRIX.tx = -localX;
			_HIT_TEST_MATRIX.ty = -localY;
			
			_HIT_TEST_HELPER_BD.setPixel32(0, 0, 0x1000000 - 100);
			_HIT_TEST_HELPER_BD.draw(target, _HIT_TEST_MATRIX);
			
			return _HIT_TEST_HELPER_BD.getPixel32(0, 0) > 0x1000000;
		}
		
		private function hitTestBitmap(bitmap:Bitmap, localX:int, localY:int):Boolean {
			if (bitmap) {
				var bitmapData:BitmapData = bitmap.bitmapData;
				if (localX < bitmap.width && localX >= 0 && localY < bitmap.height && localY >= 0) {
					if (bitmapData.getPixel32(localX, localY) > 0x1000000)
						return true;
				}
			}
			return false;
		}
		*/
		
	}
}
