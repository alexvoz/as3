package ua.olexandr.utils {
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class FilterUtils {
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getGrayscaleFilter():ColorMatrixFilter {
			return new ColorMatrixFilter([ 	0.3086, 0.6094, 0.082, 0, 0,
											0.3086, 0.6094, 0.082, 0, 0,
											0.3086, 0.6094, 0.082, 0, 0,
											0, 0, 0, 1, 0]);
		}
		
		/**
		 * 
		 * @return
		 */
		[Inline]
		public static function getNegativeFilter():ColorMatrixFilter {
			return new ColorMatrixFilter([ 	-1, 0, 0, 0, 255,
											0, -1, 0, 0, 255,
											0, 0, -1, 0, 255,
											0, 0, 0, 1, 0]);
		}
		
		/**
		 * sets brightness value available are -100 ~ 100 @default is 0
		 * @param 		value:int	brightness value
		 * @return		ColorMatrixFilter
		 */
		[Inline]
		public static function getBrightnessFilter(value:Number):ColorMatrixFilter {
			value = value * (255 / 250);
			
			var _arr:Array = [];
    		_arr = _arr.concat([1, 0, 0, 0, value]);	// red
   		 	_arr = _arr.concat([0, 1, 0, 0, value]);	// green
   		 	_arr = _arr.concat([0, 0, 1, 0, value]);	// blue
    		_arr = _arr.concat([0, 0, 0, 1, 0]);		// alpha
			
    		return new ColorMatrixFilter(_arr);
		}
		
		/**
		 * sets contrast value available are -100 ~ 100 @default is 0
		 * @param 		value:int	contrast value
		 * @return		ColorMatrixFilter
		 */
		[Inline]
		public static function getContrastFilter(value:Number):ColorMatrixFilter {
			value /= 100;
			var _s:Number = value + 1;
    		var _o:Number = 128 * (1 - _s);
			
			var _arr:Array = [];
			_arr = _arr.concat([_s, 0, 0, 0, _o]);	// red
			_arr = _arr.concat([0, _s, 0, 0, _o]);	// green
			_arr = _arr.concat([0, 0, _s, 0, _o]);	// blue
			_arr = _arr.concat([0, 0, 0, 1, 0]);	// alpha
			
			return new ColorMatrixFilter(_arr);
		}
		
		/**
		 * sets saturation value available are -100 ~ 100 @default is 0
		 * @param 		value:int	saturation value
		 * @return		ColorMatrixFilter
		 */
		[Inline]
		public static function getSaturationFilter(value:Number):ColorMatrixFilter {
			const lumaR:Number = 0.212671;
    		const lumaG:Number = 0.71516;
    		const lumaB:Number = 0.072169;
			
			var _v:Number = (value / 100) + 1;
			var _i:Number = (1 - _v);
   		 	var _r:Number = (_i * lumaR);
    		var _g:Number = (_i * lumaG);
    		var _b:Number = (_i * lumaB);
			
			var _arr:Array = new Array();
			_arr = _arr.concat([(_r + _v), _g, _b, 0, 0]);	// red
			_arr = _arr.concat([_r, (_g + _v), _b, 0, 0]);	// green
			_arr = _arr.concat([_r, _g, (_b + _v), 0, 0]);	// blue
			_arr = _arr.concat([0, 0, 0, 1, 0]);			// alpha
			
 			return new ColorMatrixFilter(_arr);
		}
		
		/**
		 * 
		 * @param	value
		 * @return
		 */
		[Inline]
		public static function getSepiaFilter(value:Number):ColorMatrixFilter {
			return new ColorMatrixFilter([	0.3930000066757202, 0.7689999938011169, 0.1889999955892563, 0, 0,
											0.3490000069141388, 0.6859999895095825, 0.1679999977350235, 0, 0,
											0.2720000147819519, 0.5339999794960022, 0.1309999972581863, 0, 0,
											0, 0, 0, 1, 0,
											0, 0, 0, 0, 1]);

		}
	
		/*
		public static function getTintFilter(color:uint):ColorMatrixFilter {
			var r:int = (( color >> 16 ) & 0xFF );
			var g:int = (( color >> 8 )  & 0xFF );
			var b:int = (( color )       & 0xFF );
			
			//var colorTransform:ColorTransform = new ColorTransform( 1.0, 1.0, 1.0, 1.0, r, g, b );
			
			return new ColorMatrixFilter([]);
		}
		*/
		
	}

}
