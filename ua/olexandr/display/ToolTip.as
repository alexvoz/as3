package ua.olexandr.display {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import ua.olexandr.constants.AlignConst;
	import ua.olexandr.structures.Indents;
	
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.3
	 */
	public class ToolTip extends ResizableObject {
		
		private var _holder:Sprite;
		private var _content:DisplayObject;
		
		private var _fillColor:uint;
		private var _fillAlpha:Number;
		
		private var _borderColor:uint;
		private var _borderAlpha:Number;
		private var _borderThickness:int;
		
		private var _align:String;
		private var _radius:int;
		
		private var _indents:Indents;
		
		private var _tailWidth:int;
		private var _tailHeight:int;
		private var _tailOffset:int;
		private var _tailCenter:int;
		
		private var _tipHeight:int;
		
		/**
		 * Contructor
		 * @param	content
		 * @param	winStyle
		 */
		public function ToolTip(content:DisplayObject, winStyle:Boolean = false) {
			_holder = new Sprite();
			addChild(_holder);
			
			_content = content;
			_holder.addChild(_content);
			
			mouseChildren = false;
			mouseEnabled = false;
			
			
			_fillColor = winStyle ? 0xFFFFE1 : 0xF4F4F4;
			_fillAlpha = 1;
			
			_borderColor = winStyle ? 0x646464 : 0x767676;
			_borderAlpha = 1;
			_borderThickness = 1;
			
			_align = AlignConst.BL;
			_radius = winStyle ? 0 : 4;
			
			_indents = new Indents(2, 2, 2, 2);
			
			setTail();
		}
		
		/**
		 * Установить отступы
		 * @param	left
		 * @param	top
		 * @param	right
		 * @param	bottom
		 */
		public function setIndents(left:int, top:int, right:int, bottom:int):void {
			_indents.left = left;
			_indents.top = top;
			_indents.right = right;
			_indents.bottom = bottom;
			
			invalidate();
		}
		
		/**
		 * Установить параметры хвостика
		 * @param	offset	смещение от левого края
		 * @param	width	ширина
		 * @param	height	высота
		 * @param	center	центр (от смещения)
		 */
		public function setTail(offset:int = 10, width:int = 8, height:int = 6, center:int = 4):void {
			_tailOffset = offset;
			_tailWidth = width;
			_tailHeight = height;
			_tailCenter = center;
			
			invalidate();
		}
		
		
		/**
		 * Контент
		 */
		public function get content():DisplayObject { return _content; }
		
		
		/**
		 * Цвет заливки
		 */
		public function get fillColor():uint { return _fillColor; }
		/**
		 * Цвет заливки
		 */
		public function set fillColor(value:uint):void {
			_fillColor = value;
			invalidate();
		}
		
		/**
		 * Прозрачность заливки
		 */
		public function get fillAlpha():Number { return _fillAlpha; }
		/**
		 * Прозрачность заливки
		 */
		public function set fillAlpha(value:Number):void {
			_fillAlpha = value;
			invalidate();
		}
		
		
		/**
		 * Цвет границ
		 */
		public function get borderColor():uint { return _borderColor; }
		/**
		 * Цвет границ
		 */
		public function set borderColor(value:uint):void {
			_borderColor = value;
			invalidate();
		}
		
		/**
		 * Прозрачность границ
		 */
		public function get borderAlpha():Number { return _borderAlpha; }
		/**
		 * Прозрачность границ
		 */
		public function set borderAlpha(value:Number):void {
			_borderAlpha = value;
			invalidate();
		}
		
		/**
		 * Толщина границ
		 */
		public function get borderThickness():int { return _borderThickness; }
		/**
		 * Толщина границ
		 */
		public function set borderThickness(value:int):void {
			_borderThickness = value;
			invalidate();
		}
		
		
		/**
		 * Положение хвостика (AlignConst)
		 */
		public function get align():String { return _align; }
		/**
		 * Положение хвостика (AlignConst)
		 */
		public function set align(value:String):void {
			_align = value;
			invalidate();
		}
		
		/**
		 * Радиус скругления
		 */
		public function get radius():int { return _radius; }
		/**
		 * Радиус скругления
		 */
		public function set radius(value:int):void {
			_radius = value;
			invalidate();
		}
		
		
		/**
		 * Отступ слева
		 */
		public function get indentLeft():int { return _indents.left; }
		/**
		 * Отступ слева
		 */
		public function set indentLeft(value:int):void {
			setIndents(value, _indents.top, _indents.right, _indents.bottom);
		}
		
		/**
		 * Отступ сверху
		 */
		public function get indentTop():int { return _indents.top; }
		/**
		 * Отступ сверху
		 */
		public function set indentTop(value:int):void {
			setIndents(_indents.left, value, _indents.right, _indents.bottom);
		}
		
		/**
		 * Отступ справа
		 */
		public function get indentRight():int { return _indents.right; }
		/**
		 * Отступ справа
		 */
		public function set indentRight(value:int):void {
			setIndents(_indents.left, _indents.top, value, _indents.bottom);
		}
		
		/**
		 * Отступ снизу
		 */
		public function get indentBottom():int { return _indents.bottom; }
		/**
		 * Отступ снизу
		 */
		public function set indentBottom(value:int):void {
			setIndents(_indents.left, _indents.top, _indents.right, value);
		}
		
		
		/**
		 * Смещение хвостика
		 */
		public function get tailOffset():int { return _tailOffset; }
		/**
		 * Смещение хвостика
		 */
		public function set tailOffset(value:int):void {
			setTail(value, _tailWidth, _tailHeight, _tailCenter);
		}
		
		/**
		 * Ширина хвостика
		 */
		public function get tailWidth():int { return _tailWidth; }
		/**
		 * Ширина хвостика
		 */
		public function set tailWidth(value:int):void { 
			setTail(_tailOffset, value, _tailHeight, _tailCenter);
		}
		
		/**
		 * Высота хвостика
		 */
		public function get tailHeight():int { return _tailHeight; }
		/**
		 * Высота хвостика
		 */
		public function set tailHeight(value:int):void {
			setTail(_tailOffset, _tailWidth, value, _tailCenter);
		}
		
		/**
		 * Центр хвостика (от смещения)
		 */
		public function get tailCenter():int { return _tailCenter; }
		/**
		 * Центр хвостика (от смещения)
		 */
		public function set tailCenter(value:int):void {
			setTail(_tailOffset, _tailWidth, _tailHeight, value);
		}
		
		
		override protected function measure():void {
			_width = _indents.left + Math.ceil(_content.width) + _indents.right;
			_height = _indents.top + Math.ceil(_content.height) + _indents.bottom + _tailHeight;
			_tipHeight = _height - _tailHeight;
		}
		
		override protected function draw():void {
			var _g:Graphics = _holder.graphics;
			_g.clear();
			_g.beginFill(_fillColor, _fillAlpha);
			if (_borderThickness)
				_g.lineStyle(_borderThickness, _borderColor, _borderAlpha, true);
			
			var _tOffset:int;
			switch (_align) {
				case AlignConst.TL: {
					_content.x = _indents.left;
					_content.y = _indents.top + _tailHeight;
					
					drawTL();
					
					_holder.x = -_tailOffset - _tailCenter;
					_holder.y = 0;
					break;
				}
				case AlignConst.TC: {
					_content.x = _indents.left;
					_content.y = _indents.top + _tailHeight;
					
					_tOffset = drawTC();
					
					_holder.x = -_tOffset - _tailCenter;
					_holder.y = 0;
					break;
				}
				case AlignConst.TR: {
					_content.x = _indents.left;
					_content.y = _indents.top + _tailHeight;
					
					drawTR();
					
					_holder.x = -_width + _tailOffset + _tailCenter;
					_holder.y = 0;
					break;
				}
				case AlignConst.BL: {
					_content.x = _indents.left;
					_content.y = _indents.top;
					
					drawBL();
					
					_holder.x = -_tailOffset - _tailCenter;
					_holder.y = -_tipHeight - _tailHeight;
					break;
				}
				case AlignConst.BC: {
					_content.x = _indents.left;
					_content.y = _indents.top;
					
					_tOffset = drawBC();
					
					_holder.x = -_tOffset - _tailCenter;
					_holder.y = -_tipHeight - _tailHeight;
					break;
				}
				case AlignConst.BR: {
					_content.x = _indents.left;
					_content.y = _indents.top;
					
					drawBR();
					
					_holder.x = -_width + _tailOffset + _tailCenter;
					_holder.y = -_tipHeight - _tailHeight;
					break;
				}
			}
			
			_g.endFill();
		}
		
		private function drawTL():void {
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tailOffset, _tailHeight);
					_g.lineTo(_tailOffset + _tailCenter, 0);
					_g.lineTo(_tailOffset + _tailWidth, _tailHeight);
				}
				
				_g.lineTo(_width - _radius, _tailHeight);
				_g.curveTo(_width, _tailHeight, _width, _tailHeight + _radius);
				_g.lineTo(_width, _height - _radius);
				_g.curveTo(_width, _height, _width - _radius, _height);
				_g.lineTo(_radius, _height);
				_g.curveTo(0, _height, 0, _height - _radius);
				_g.lineTo(0, _tailHeight + _radius);
				_g.curveTo(0, _tailHeight, _radius, _tailHeight);
			} else {
				_g.moveTo(0, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tailOffset, _tailHeight);
					_g.lineTo(_tailOffset + _tailCenter, 0);
					_g.lineTo(_tailOffset + _tailWidth, _tailHeight);
				}
				
				_g.lineTo(_width, _tailHeight);
				_g.lineTo(_width, _height);
				_g.lineTo(0, _height);
				_g.lineTo(0, _tailHeight);
			}
		}
		
		private function drawTC():int {
			var _tOffset:int = (_width - _tailWidth) * .5;
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tOffset, _tailHeight);
					_g.lineTo(_tOffset + _tailCenter, 0);
					_g.lineTo(_tOffset + _tailWidth, _tailHeight);
				}
				
				_g.lineTo(_width - _radius, _tailHeight);
				_g.curveTo(_width, _tailHeight, _width, _tailHeight + _radius);
				_g.lineTo(_width, _height - _radius);
				_g.curveTo(_width, _height, _width - _radius, _height);
				_g.lineTo(_radius, _height);
				_g.curveTo(0, _height, 0, _height - _radius);
				_g.lineTo(0, _tailHeight + _radius);
				_g.curveTo(0, _tailHeight, _radius, _tailHeight);
			} else {
				_g.moveTo(0, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tOffset, _tailHeight);
					_g.lineTo(_tOffset + _tailCenter, 0);
					_g.lineTo(_tOffset + _tailWidth, _tailHeight);
				}
				
				_g.lineTo(_width, _tailHeight);
				_g.lineTo(_width, _height);
				_g.lineTo(0, _height);
				_g.lineTo(0, _tailHeight);
			}
			
			return _tOffset;
		}
		
		private function drawTR():void {
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_width - _tailOffset - _tailWidth, _tailHeight);
					_g.lineTo(_width - _tailOffset - _tailCenter, 0);
					_g.lineTo(_width - _tailOffset, _tailHeight);
				}
				
				_g.lineTo(_width - _radius, _tailHeight);
				_g.curveTo(_width, _tailHeight, _width, _tailHeight + _radius);
				_g.lineTo(_width, _height - _radius);
				_g.curveTo(_width, _height, _width - _radius, _height);
				_g.lineTo(_radius, _height);
				_g.curveTo(0, _height, 0, _height - _radius);
				_g.lineTo(0, _tailHeight + _radius);
				_g.curveTo(0, _tailHeight, _radius, _tailHeight);
			} else {
				_g.moveTo(0, _tailHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_width - _tailOffset - _tailWidth, _tailHeight);
					_g.lineTo(_width - _tailOffset - _tailCenter, 0);
					_g.lineTo(_width - _tailOffset, _tailHeight);
				}
				
				_g.lineTo(_width, _tailHeight);
				_g.lineTo(_width, _height);
				_g.lineTo(0, _height);
				_g.lineTo(0, _tailHeight);
			}
		}
		
		private function drawBL():void {
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, 0);
				_g.lineTo(_width - _radius, 0);
				_g.curveTo(_width, 0, _width, _radius);
				_g.lineTo(_width, _tipHeight - _radius);
				_g.curveTo(_width, _tipHeight, _width - _radius, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tailOffset + _tailWidth, _tipHeight);
					_g.lineTo(_tailOffset + _tailCenter, _height);
					_g.lineTo(_tailOffset, _tipHeight);
				}
				
				_g.lineTo(_radius, _tipHeight);
				_g.curveTo(0, _tipHeight, 0, _tipHeight - _radius);
				_g.lineTo(0, _radius);
				_g.curveTo(0, 0, _radius, 0);
			} else {
				_g.moveTo(0, 0);
				_g.lineTo(_width, 0);
				_g.lineTo(_width, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tailOffset + _tailWidth, _tipHeight);
					_g.lineTo(_tailOffset + _tailCenter, _height);
					_g.lineTo(_tailOffset, _tipHeight);
				}
				
				_g.lineTo(0, _tipHeight);
				_g.lineTo(0, 0);
			}
		}
		
		private function drawBC():int {
			var _tOffset:int = (_width - _tailWidth) * .5;
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, 0);
				_g.lineTo(_width - _radius, 0);
				_g.curveTo(_width, 0, _width, _radius);
				_g.lineTo(_width, _tipHeight - _radius);
				_g.curveTo(_width, _tipHeight, _width - _radius, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tOffset + _tailWidth, _tipHeight);
					_g.lineTo(_tOffset + _tailCenter, _height);
					_g.lineTo(_tOffset, _tipHeight);
				}
				
				_g.lineTo(_radius, _tipHeight);
				_g.curveTo(0, _tipHeight, 0, _tipHeight - _radius);
				_g.lineTo(0, _radius);
				_g.curveTo(0, 0, _radius, 0);
			} else {
				_g.moveTo(0, 0);
				_g.lineTo(_width, 0);
				_g.lineTo(_width, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_tOffset + _tailWidth, _tipHeight);
					_g.lineTo(_tOffset + _tailCenter, _height);
					_g.lineTo(_tOffset, _tipHeight);
				}
				
				_g.lineTo(0, _tipHeight);
				_g.lineTo(0, 0);
			}
			
			return _tOffset;
		}
		
		private function drawBR():void {
			var _g:Graphics = _holder.graphics;
			
			if (_radius) {
				_g.moveTo(_radius, 0);
				_g.lineTo(_width - _radius, 0);
				_g.curveTo(_width, 0, _width, _radius);
				_g.lineTo(_width, _tipHeight - _radius);
				_g.curveTo(_width, _tipHeight, _width - _radius, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_width - _tailOffset, _tipHeight);
					_g.lineTo(_width - _tailOffset - _tailCenter, _height);
					_g.lineTo(_width - _tailOffset - _tailWidth, _tipHeight);
				}
				
				_g.lineTo(_radius, _tipHeight);
				_g.curveTo(0, _tipHeight, 0, _tipHeight - _radius);
				_g.lineTo(0, _radius);
				_g.curveTo(0, 0, _radius, 0);
			} else {
				_g.moveTo(0, 0);
				_g.lineTo(_width, 0);
				_g.lineTo(_width, _tipHeight);
				
				if (_tailWidth && _tailHeight) {
					_g.lineTo(_width - _tailOffset, _tipHeight);
					_g.lineTo(_width - _tailOffset - _tailCenter, _height);
					_g.lineTo(_width - _tailOffset - _tailWidth, _tipHeight);
				}
				
				_g.lineTo(0, _tipHeight);
				_g.lineTo(0, 0);
			}
		}
		
	}

}