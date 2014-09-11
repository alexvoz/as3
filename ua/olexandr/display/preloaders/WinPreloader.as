package ua.olexandr.display.preloaders {  
	import flash.display.Shape;
	import flash.display.Sprite;
	import ua.olexandr.tools.tweener.Easing;
	import ua.olexandr.tools.tweener.Tweener;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	public class WinPreloader extends BasePreloader {  
		
		private var _count:int;
		private var _shift:int;
		private var _time:Number;
		private var _delay:Number;
		
		private var _dots:Array;
		
		private var _animateCount:int;
		
		/**
		 * 
		 * @param	color	цвет точек
		 * @param	radius	радиус точек
		 * @param	count	количество точек
		 * @param	space	расстояние между точками
		 * @param	shift	смещение от центра 
		 * @param	time	время анимации одного цикла одной точки
		 * @param	delay	задержка перед повтором анимации
		 */
		public function WinPreloader(color:uint = 0x000000, radius:int = 2, count:int = 5, space:int = 20, shift:int = 200, time:Number = .5, delay:Number = .5) {
			_count = count;  
			_shift = shift;
			_time = time;
			_delay = delay;
			
			super(false);
			
			_animating = false;
			_animateCount = 0;
			_dots = [];
			
			for (var i:int = 0; i < _count; i++) {
				var _item:Sprite = new Sprite();
				_item.x = space * i;
				_holder.addChild(_item);
				
				var _dot:Shape = drawCircle(radius, color);
				_item.addChild(_dot);
				
				_dots[i] = _dot;
			}
			
			_holder.x -= (_item.x + radius) * .5;
		}  
		
		
		override protected function startIn():void {
			nextIteration();
		}
		
		
		private function nextIteration(delay:Number = 0):void {
			for (var i:int = 0; i < _count; i++) {
				_animateCount++;
				
				var _dot:Shape = _dots[i] as Shape;
				_dot.alpha = 0;
				_dot.x = -_shift;
				
				var _d:Number = delay + .1 * (_count - 1 - i);
				Tweener.addTween(_dot, _time, { alpha:1, x:0, delay:_d, ease:Easing.expoOut } );
				
				_d += _time;
				Tweener.addTween(_dot, _time, { alpha:0, x:_shift, delay:_d, ease:Easing.expoIn, 
					onComplete:function():void {
						_animateCount--;
						if (_animateCount == 0 && _animating)
							nextIteration(_delay);
					}
				} );
			}
		}
		
		private function drawCircle(size:Number, color:uint = 0x000000):Shape {
			var _shape:Shape = new Shape();
			_shape.graphics.beginFill(color, 1);
			_shape.graphics.drawCircle(0, 0, size);
			_shape.graphics.endFill();
			return _shape;
		}
		
   }  
}  