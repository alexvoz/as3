package ua.olexandr.display.preloaders {
	import flash.display.Graphics;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.2
	 */
	
	public class RoundPreloader extends BasePreloader {
		
		private var _backColor:uint;
		private var _backAlpha:Number;
		private var _foreColor:uint;
		private var _foreAlpha:Number;
		private var _radiusMax:int;
		private var _radiusMin:int;
		
		/**
		 * 
		 * @param	colorBack
		 * @param	colorFore
		 * @param	radiusMin
		 * @param	radiusMax
		 */
		public function RoundPreloader(backColor:uint = 0xEEEEEE, backAlpha:Number = 1, foreColor:uint = 0x777777, foreAlpha:Number = 1, radiusMin:int = 14, radiusMax:int = 18) {
			_backColor = backColor;
			_backAlpha = backAlpha;
			_foreColor = foreColor;
			_foreAlpha = foreAlpha;
			_radiusMin = radiusMin;
			_radiusMax = radiusMax;
			
			super(true);
			
			_holder.rotation = -90;
		}
		
		
		override protected function update():void {
			var _r:Number = progress * 360;
			while (_r > 360)
				_r -= 360;
			
			var g:Graphics = _holder.graphics;
			g.clear();
			
			g.beginFill(_backColor, _backAlpha);
			g.drawCircle(0, 0, _radiusMin);
			g.drawCircle(0, 0, _radiusMax);
			g.endFill();
			
			if (_r != 0) {
				var _arc:Number = (_r / 180 * Math.PI); // % (Math.PI * 2);
				var _len:Number = Math.abs(Math.ceil(_arc * 10 / Math.PI));
				
				if (_arc < 0)
					_len += 1;
					
				var _angle:Number = _arc / _len;
				
				var _ctrlOut:Number = _radiusMax / Math.cos(-_angle / 2);
				var _ctrlIn:Number = _radiusMin / Math.cos(-_angle / 2);
				
				var _startX:Number = _radiusMax * Math.cos(0);
				var _startY:Number = _radiusMax * Math.sin(0);
				
				var _endX:Number = _radiusMin * Math.cos(_arc);
				var _endY:Number = _radiusMin * Math.sin(_arc);
				
				var i:int;
				var _aOut:Number, _cOut:Number, _aIn:Number, _cIn:Number;
				var _controlX:Number, _controlY:Number, _anchorX:Number, _anchorY:Number;
				
				g.beginFill(_foreColor, _foreAlpha);
				g.moveTo(_startX, _startY);
				for (i = 1; i < _len + 1; i++) {
					_aOut = _angle * i;
					_cOut = _aOut - _angle / 2;
					_anchorX = _radiusMax * Math.cos(_aOut);
					_anchorY = _radiusMax * Math.sin(_aOut);
					_controlX = _ctrlOut * Math.cos(_cOut);
					_controlY = _ctrlOut * Math.sin(_cOut);
					g.curveTo(_controlX, _controlY, _anchorX, _anchorY);
				}
				
				g.lineTo(_endX, _endY);
				for (i = 1; i < _len + 1; i++) {
					_aIn = _aOut - _angle * i;
					_cIn = _aIn + _angle / 2;
					_anchorX = _radiusMin * Math.cos(_aIn);
					_anchorY = _radiusMin * Math.sin(_aIn);
					_controlX = _ctrlIn * Math.cos(_cIn);
					_controlY = _ctrlIn * Math.sin(_cIn);
					g.curveTo(_controlX, _controlY, _anchorX, _anchorY);
				}
				
				g.lineTo(_startX, _startY);
				g.endFill();
			}
		}
		
	}

}