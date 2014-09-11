package ua.olexandr.tools.conversions {
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class ColorConversions {
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function RGBtoCMYK(r:Number, g:Number, b:Number):Object {
			var _max:Number = Math.max(r, g, b);
			var _min:Number = Math.min(r, g, b);
			var _ir:Number = 1 - r;
			var _ig:Number = 1 - g;
			var _ib:Number = 1 - b;

			var _k:Number = (_ir < _ig) ? _ir : _ig;
			_k = (_k < _ib) ? _k : _ib;

			return { c:(_ir - _k) / (1 - _k), m:(_ig - _k) / (1 - _k), y:(_ib - _k) / (1 - _k), k:_k };
		}
		
		/**
		 * 
		 * @param	c
		 * @param	m
		 * @param	y
		 * @param	k
		 * @return
		 */
		[Inline]
		public static function CMYKtoRGB(c:Number, m:Number, y:Number, k:Number):Object {
			var _r:Number = _c * (1 - k) + k;
			var _g:Number = _m * (1 - k) + k;
			var _b:Number = _y * (1 - k) + k;
			
			if (_r > 1.0)
				_r = 1.0;
			
			if (_g > 1.0)
				_g = 1.0;
			
			if (_b > 1.0)
				_b = 1.0;
			
			return { r:1 - _r, g:1 - _g, b:1 - _b };
		}
		
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function RGBtoHSV(r:Number, g:Number, b:Number):Object {
			var _max:Number = Math.max(r, g, b);
			var _min:Number = Math.min(r, g, b);
			var _d:Number = _max - _min;
			var _h:Number = 0;
			var _s:Number = (_max != 0) ? _d / _max : 0;
			var _b:Number = _max;
			
			if (_s != 0.0) {
				var _cr:Number = (_max - r) / _d;
				var _cg:Number = (_max - g) / _d;
				var _cb:Number = (_max - b) / _d;
				
				if (r == _max) {
					_h = _cb - _cg;
				} else if (g == _max) {
					_h = _cr - _cb + 2;
				} else {
					_h = _cg - _cr + 4;
				}
				
				_h /= 6;
				
				if (_h < 0)
					_h++;
			}

			return new { h:_h, s:_s, b:_b };
		}
		
		/**
		 * 
		 * @param	h
		 * @param	s
		 * @param	v
		 * @return
		 */
		[Inline]
		public static function HSVtoRGB(h:Number, s:Number, v:Number):Object {
			var _r:Number;
			var _g:Number;
			var _b:Number;
			
			if (s == 0) {
				_r = _g = _b = v;
			} else {
				var i:Number = (h % 1) * 6;
				var f:Number = i % 1;
				var m:Number = v * (1 - s);
				var n:Number = v * (1 - s * f);
				var k:Number = v * (1 - s * (1 - f));
				
				switch (int(i)) {
					case 0: {
						_r = v;
						_g = k;
						_b = m;
						break;
					}
					case 1: {
						_r = n;
						_g = v;
						_b = m;
						break;
					}
					case 2: {
						_r = m;
						_g = v;
						_b = k;
						break;
					}
					case 3: {
						_r = m;
						_g = n;
						_b = v;
						break;
					}
					case 4: {
						_r = k;
						_g = m;
						_b = v;
						break;
					}
					case 5: {
						_r = v;
						_g = m;
						_b = n;
						break;
					}
				}
			}
			
			return { r:_r, g:_g, b:_b };
		}
		
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function RGBtoHLS(r:Number, g:Number, b:Number):Object {
			var _max:Number = Math.max(r, g, b);
			var _min:Number = Math.min(r, g, b);
			var _n:Number = _max + _min;
			var _d:Number = _max - _min;
			var _h:Number = 0;
			var _l:Number = _n / 2;
			var _s:Number = 0;
			
			if (_max != _min) {
				_s = (_l <= .5) ? _d / _n : _d / (2 - _n);
				
				var _cr:Number = (_max - r) / _d;
				var _cg:Number = (_max - g) / _d;
				var _cb:Number = (_max - b) / _d;
				
				switch (_max) {
					case r: {
						_h = _cb - _cg;
						break;
					}
					case g: {
						_h = _cr - _cb + 2;
						break;
					}
					case b: {
						_h = _cg - _cr + 4;
						break;
					}
				}
				
				_h /= 6;
				
				if (_h < 0)
					_h++;
			}

			return { h:_h, l:_l, s:_s };
		}
		
		/**
		 * 
		 * @param	h
		 * @param	l
		 * @param	s
		 * @return
		 */
		[Inline]
		public static function HLStoRGB(h:Number, l:Number, s:Number):Object {
			var _max:Number = (l <= .5) ? l * (1 + s) : l * (1 - s) + s;
			var _min:Number = 2 * l - _max;
			var _r:Number;
			var _g:Number;
			var _b:Number;
			
			if (s == 0) {
				_r = _g = _b = l;
			} else {
				var n:Number = 1 / 3;
				_r = _calcHLSValue(_min, _max, h + n);
				_g = _calcHLSValue(_min, _max, h);
				_b = _calcHLSValue(_min, _max, h - n);
			}
			
			return { r:_r, g:_g, b:_b };
		}
		
		
		[Inline]
		private static function calcHLSValue(min:Number, max:Number, hue:Number):Number {
			if (hue > 1) 		hue--;
			else if (hue < 0) 	hue++;
			
			var n:Number = 1 / 6;
			var d:Number = max - min;
			
			if (hue < n) {
				return min + d * hue / n;
			} else if (hue < 3 * n) {
				return max;
			} else if (hue < 4 * n) {
				return min + d * (4 * n - hue) / n;
			} else {
				return min;
			}
		}
		
	}

}