package ua.olexandr.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class DisplayUtils {
		
		/**
		 *
		 * @param	parent
		 * @param	child
		 * @param	props
		 * @return
		 */
		[Inline]
		public static function createDisplayObject(parent:DisplayObjectContainer, child:DisplayObject, props:Object = null):DisplayObject {
			parent.addChild(child);
			
			for (var i:String in props) {
				try {
					child[i] = props[i];
				} catch (e:Error) {
					trace(e.message);
				}
			}
			
			return child;
		}
		
		/**
		 * Возвращает массив детей для заданного родителя
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function getChildren(target:DisplayObjectContainer):Array {
			var _arr:Array = [];
			var _len:int = target.numChildren;
			
			for (var i:int = 0; i < _len; i++)
				_arr[i] = target.getChildAt(i);
			
			return _arr;
		}
		
		/**
		 * Возвращает первого ребенка для заданного родителя
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function getFirstChild(target:DisplayObjectContainer):DisplayObject {
			return target.numChildren ? target.getChildAt(0) : null;
		}
		
		/**
		 * Возвращает последенего ребенка для заданного родителя
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function getLastChild(target:DisplayObjectContainer):DisplayObject {
			return target.numChildren ? target.getChildAt(target.numChildren - 1) : null;
		}
		
		/**
		 * Возвращает ребенка, следующего за данным
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function getNextChild(target:DisplayObject):DisplayObject {
			if (target.parent) {
				var _parent:DisplayObjectContainer = target.parent;
				var _index:int = _parent.getChildIndex(target) + 1;
				return _index > _parent.numChildren - 1 ? null : _parent.getChildAt(_index);
			}
			return null;
		}
		
		/**
		 * Возвращает ребенка, предыдущего данному
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function getPreviousChild(target:DisplayObject):DisplayObject {
			if (target.parent) {
				var _parent:DisplayObjectContainer = target.parent;
				var _index:int = _parent.getChildIndex(target) - 1;
				return _index < 0 ? null : _parent.getChildAt(_index);
			}
			return null;
		}
		
		/**
		 * Очищает заданный $target от детей пока numChildren != $remainingNum
		 * @param	$target
		 * @param	$remainingNum
		 * @param	$removeTop
		 */
		[Inline]
		public static function clear(target:DisplayObjectContainer, remainingNum:int = 0, removeTop:Boolean = false):void {
			if (target.numChildren > remainingNum) {
				while (target.numChildren > remainingNum)
					target.removeChildAt(removeTop ? target.numChildren - 1 : 0);
			}
		}
		
		/**
		 *
		 * @param	target
		 * @param	children
		 */
		[Inline]
		public static function disable(target:InteractiveObject, children:Boolean = true):void {
			target.mouseEnabled = false;
			if (children && target is DisplayObjectContainer)
				(target as DisplayObjectContainer).mouseChildren = false;
		}
		
		/**
		 *
		 * @param	target
		 * @param	children
		 */
		[Inline]
		public static function enable(target:InteractiveObject, children:Boolean = true):void {
			target.mouseEnabled = true;
			if (children && target is DisplayObjectContainer)
				(target as DisplayObjectContainer).mouseChildren = true;
		}
		
		/**
		 * Возвращает самого верхнего родителя для приложения
		 * @param	$target
		 * @return
		 */
		[Inline]
		public static function topParent(target:DisplayObject):DisplayObject {
			if (target.parent as DisplayObject)
				return topParent(target.parent as DisplayObject)
			else
				return (target as DisplayObject);
		}
		
		/**
		 * Возвращает имя класса
		 * @param	$target
		 * @param	$full
		 * @return
		 */
		[Inline]
		public static function getClassName(target:DisplayObject, full:Boolean = false):String {
			var _arr:Array = getQualifiedClassName(target).split('::');
			return full ? _arr.join('.') : _arr[_arr.length - 1];
		}
		
		/**
		 * Округляет координаты детей заданного объекта на levelsOfDepth (0 - максимум) глубин
		 * @param	$target
		 */
		[Inline]
		public static function roundChildrenPositions(target:DisplayObjectContainer, levelsOfDepth:uint = 1):void {
			var _len:int = target.numChildren;
			for (var i:int = 0; i < _len; i++) {
				var _child:DisplayObject = target.getChildAt(i);
				
				roundPosition(_child);
				
				if (levelsOfDepth != 1 && _child is DisplayObjectContainer)
					roundChildrenPositions(_child as DisplayObjectContainer, Math.max(0, levelsOfDepth - 1));
			}
		}
		
		/**
		 * Округляет координаты заданного объекта
		 * @param	$target
		 */
		[Inline]
		public static function roundPosition(target:DisplayObject):void {
			if (!(target is Stage)) {
				target.x = Math.round(target.x);
				target.y = Math.round(target.y);
			}
		}
		
		/**
		 *
		 * @param	target
		 * @param	value
		 */
		[Inline]
		public static function skewX(target:DisplayObject, value:Number):void {
			var _m:Matrix = target.transform.matrix;
			_m.c = Math.tan(GeomUtils.degreesToRadians(value));
			target.transform.matrix = _m;
		}
		
		/**
		 *
		 * @param	target
		 * @param	value
		 */
		[Inline]
		public static function skewY(target:DisplayObject, value:Number):void {
			var _m:Matrix = target.transform.matrix;
			_m.b = Math.tan(GeomUtils.degreesToRadians(value));
			target.transform.matrix = _m;
		}
		
		/**
		 *
		 * @param	target
		 * @param	point
		 * @return
		 */
		[Inline]
		public static function localToGlobal(target:DisplayObject, point:Point = null):Point {
			var _point:Point = point ? point.clone() : new Point(target.x, target.y);
			var _parent:DisplayObject = target.parent;
			while (_parent) {
				_point.x += _parent.x;
				_point.y += _parent.y;
				_parent = _parent.parent;
			}
			return _point;
		}
		
		/**
		 *
		 * @param	target
		 * @param	point
		 * @return
		 */
		[Inline]
		public static function globalToLocal(target:DisplayObject, point:Point):Point {
			var _point:Point = point.clone();
			var _parent:DisplayObject = target.parent;
			while (_parent) {
				_point.x -= _parent.x;
				_point.y -= _parent.y;
				_parent = _parent.parent;
			}
			return _point;
		}
		
		/**
		 *
		 * @param	target
		 * @param	childs
		 */
		[Inline]
		public static function zSort(target:DisplayObjectContainer, childs:Array):void {
			childs = childs.sortOn(['y', 'name'], [Array.NUMERIC, Array.DESCENDING]);
			var _len:int = childs.length;
			while (_len--) {
				var _child:DisplayObject = childs[_len] as DisplayObject;
				if (target.getChildAt(_len) != _child)
					target.setChildIndex(_child, _len);
			}
		}
		
		/**
		 * 
		 * @param	target
		 * @param	center
		 * @param	degrees
		 */
		[Inline]
		public static function centerRotate(target:DisplayObject, center:Point, degrees:Number):void {
			var m:Matrix = target.transform.matrix;
			
			m.tx -= center.x;
			m.ty -= center.y;
			m.rotate(GeomUtils.degreesToRadians(degrees));
			m.tx += center.x;
			m.ty += center.y;
			
			target.transform.matrix = m;
		}
	
	}
}