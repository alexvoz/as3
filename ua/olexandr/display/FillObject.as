package ua.olexandr.display {
	import flash.display.Graphics;
	import flash.display.Shape;
	import ua.olexandr.display.ResizableObject;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class FillObject extends ResizableObject {
		
		private var _fColor:uint;
		private var _fAlpha:Number;
		
		private var _bThick:Number;
		private var _bColor:uint;
		private var _bAlpha:Number;
		
		private var _rad:uint;
		
		private var _fill:Shape;
		private var _border:Shape;
		
		/**
		 * 
		 * @param	fillColor
		 * @param	fillAlpha
		 */
		public function FillObject(fillColor:uint = 0xFFFFFF, fillAlpha:Number = 1) {
			_border = new Shape();
			addChildAt(_border, 0);
			
			_fill = new Shape();
			addChildAt(_fill, 0);
			
			mouseChildren = false;
			
			_fColor = fillColor;
			_fAlpha = fillAlpha;
			
			_rad = 0;
			
			removeBorder();
		}
		
		/**
		 * 
		 * @param	color
		 * @param	alpha
		 * @param	thickness
		 */
		public function addBorder(color:uint = 0x000000, alpha:Number = 1, thickness:Number = 1):void {
			_bThick = thickness;
			_bColor = color;
			_bAlpha = alpha;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function removeBorder():void {
			_bThick = 0;
			_bColor = 0x000000;
			_bAlpha = 1;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get fillColor():uint { return _fColor; }
		/**
		 * 
		 */
		public function set fillColor(value:uint):void {
			_fColor = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get fillAlpha():Number { return _fAlpha; }
		/**
		 * 
		 */
		public function set fillAlpha(value:Number):void {
			_fAlpha = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get borderThickness():Number { return _bThick; }
		/**
		 * 
		 */
		public function set borderThickness(value:Number):void {
			_bThick = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get borderColor():uint { return _bColor; }
		/**
		 * 
		 */
		public function set borderColor(value:uint):void {
			_bColor = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get borderAlpha():Number { return _bAlpha; }
		/**
		 * 
		 */
		public function set borderAlpha(value:Number):void {
			_bAlpha = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get radius():uint { return _rad; }
		/**
		 * 
		 */
		public function set radius(value:uint):void {
			_rad = value;
			invalidate();
		}
		
		
		/**
		 * 
		 */
		override protected function draw():void {
			var _fg:Graphics = _fill.graphics;
			var _bg:Graphics = _border.graphics;
			
			_fg.clear();
			_bg.clear();
			
			if (_width && _height) {
				if (_bThick) {
					var _wMin:int = _width - _bThick * 2;
					var _hMin:int = _height - _bThick * 2;
					
					if (_rad) {
						var _radMin:uint = Math.max(0, _rad - _bThick);
						
						_fg.beginFill(_fColor, _fAlpha);
						_fg.drawRoundRect(_bThick, _bThick, _wMin, _hMin, _radMin);
						
						_bg.beginFill(_bColor, _bAlpha);
						_bg.drawRoundRect(0, 0, _width, _height, _rad);
						_bg.drawRoundRect(_bThick, _bThick, _wMin, _hMin, _radMin);
					} else {
						_fg.beginFill(_fColor, _fAlpha);
						_fg.drawRect(_bThick, _bThick, _wMin, _hMin);
						
						_bg.beginFill(_bColor, _bAlpha);
						_bg.drawRect(0, 0, _width, _height);
						_bg.drawRect(_bThick, _bThick, _wMin, _hMin);
					}
				} else {
					_fg.beginFill(_fColor, _fAlpha);
					if (_rad) 	_fg.drawRoundRect(0, 0, _width, _height, _rad);
					else 		_fg.drawRect(0, 0, _width, _height);
				}
			}
		}
		
	}

}