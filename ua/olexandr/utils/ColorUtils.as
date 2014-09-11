package ua.olexandr.utils {
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class ColorUtils{
		
		/**
		 * 
		 * @param	str
		 * @param	def
		 * @return
		 */
		[Inline]
		public static function parse(str:String, def:uint = 0x000000):uint {
			return str ? uint('0x' + str.replace('#', '').replace('0x', '')) : def;
		}
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		[Inline]
		public static function combine(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function separate(color:uint):Object {
			return { r:getRed(color), g:getGreen(color), b:getBlue(color) };
		}
		
		/**
		 * 
		 * @param	color
		 * @param	prefix
		 * @return
		 */
		[Inline]
		public static function getString(color:uint, prefix:String = '#'):String {
			var _str:String = color.toString(16);
			
			while(_str.length < 6)
				_str = '0' + _str;
			
			return prefix + _str.toUpperCase();
		}
		
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function getWebColor(color:uint):uint {
			var _r:uint = Math.round(getRed(color) / 0x33) * 0x33;
			var _g:uint = Math.round(getGreen(color) / 0x33) * 0x33;
			var _b:uint = Math.round(getBlue(color) / 0x33) * 0x33;
			return combine(_r, _g, _b);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	color
		 */
		[Inline]
		public static function setColor(target:DisplayObject, color:uint):void {
			var _colorTransform:ColorTransform = target.transform.colorTransform;
			_colorTransform.color = color;
			target.transform.colorTransform = _colorTransform;
		}
		
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function getRed(color:uint):uint {
			return color >> 16;
		}
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function getGreen(color:uint):uint {
			return color >> 8 & 0xFF;
		}
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function getBlue(color:uint):uint {
			return color & 0xFF;
		}
		
		
		/**
		 * 
		 * @param	color
		 * @param	red
		 * @return
		 */
		[Inline]
		public static function setRed(color:uint, red:int):uint {
			return combine(red, getGreen(color), getBlue(color));
		}
		
		/**
		 * 
		 * @param	color
		 * @param	green
		 * @return
		 */
		[Inline]
		public static function setGreen(color:uint, green:int):uint {
			return combine(getRed(color), green, getBlue(color));
		}
		
		/**
		 * 
		 * @param	color
		 * @param	blue
		 * @return
		 */
		[Inline]
		public static function setBlue(color:uint, blue:int):uint {
			return combine(getRed(color), getGreen(color), blue);
		}
		
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function invertRed(color:uint):uint {
			return combine(0xFF - getRed(color), getGreen(color), getBlue(color));
		}
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function invertGreen(color:uint):uint {
			return combine(getRed(color), 0xFF - getGreen(color), getBlue(color));
		}
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function invertBlue(color:uint):uint {
			return combine(getRed(color), getGreen(color), 0xFF - getBlue(color));
		}
		
		
		/**
		 * 
		 * @param	color
		 * @return
		 */
		[Inline]
		public static function invertRGB(color:uint):uint {
			return combine(0xFF - getRed(color), 0xFF - getGreen(color), 0xFF - getBlue(color));
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @param	ratio
		 * @return
		 */
		[Inline]
		public static function ratioRGB(start:uint, end:uint, ratio:Number = .5):uint {
			var _r1:uint = getRed(start);
			var _g1:uint = getGreen(start);
			var _b1:uint = getBlue(start);
			
			var _r2:uint = getRed(end);
			var _g2:uint = getGreen(end);
			var _b2:uint = getBlue(end);
			
			var _rP:uint = _r1 + (_r2 - _r1) * ratio;
			var _gP:uint = _g1 + (_g2 - _g1) * ratio;
			var _bP:uint = _b1 + (_b2 - _b1) * ratio;
			
			return combine(_rP, _gP, _bP);
		}
		
		
	}

}
