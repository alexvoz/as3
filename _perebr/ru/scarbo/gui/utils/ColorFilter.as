package ru.scarbo.gui.utils 
{
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author scarbo
	 */
	public class ColorFilter
	{
		public static const CLEAR:uint = 0;
		public static const NEGATIVE:uint = 1;
		public static const GRAYSCALE:uint = 2;
		public static const SATURATION:uint = 3;
		public static const JARCOST:uint = 4;
		public static const CONTRAST:uint = 5;
		
		private static const RED:Number = .3086;
		private static const GREEN:Number = .6094;
		private static const BLUE:Number = .0820;
		
		private var _filter:ColorMatrixFilter;
		
		public function ColorFilter(type:uint = 0, params:Object = null) {
			switch(type) {
				case CLEAR:
				_filter = getClear();
				break;
				
				case NEGATIVE:
				_filter = getClear();
				break;
				
				case GRAYSCALE:
				_filter = getGrayScale();
				break;
				
				case SATURATION:
				_filter = getClear();
				break;
				
				case JARCOST:
				_filter = getClear();
				break;
				
				case CONTRAST:
				_filter = getClear();
				break;
			}
		}
		
		public function get filter():ColorMatrixFilter { return _filter; }
		
		private function getClear():ColorMatrixFilter {
			var arr:Array = [ 1, 0, 0, 0, 0,
			                  0, 1, 0, 0, 0,
							  0, 0, 1, 0, 0,
							  0, 0, 0, 1, 0];
			return new ColorMatrixFilter(arr);
		}
		private function getGrayScale():ColorMatrixFilter {
			var arr:Array = [ RED, GREEN, BLUE, 0, 0,
			                  RED, GREEN, BLUE, 0, 0,
							  RED, GREEN, BLUE, 0, 0,
							  RED, GREEN, BLUE, 1, 0];
			return new ColorMatrixFilter(arr);
		}
	}

}