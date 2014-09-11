package ua.olexandr.display.preloaders {
	import flash.display.Graphics;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	
	public class RectPreloader extends BasePreloader {
		
		private var _backColor:uint;
		private var _backAlpha:Number;
		private var _foreColor:uint;
		private var _foreAlpha:Number;
		private var _width:int;
		private var _height:int;
		
		/**
		 * 
		 * @param	colorBack
		 * @param	colorFore
		 * @param	radiusMin
		 * @param	radiusMax
		 */
		public function RectPreloader(backColor:uint = 0xEEEEEE, backAlpha:Number = 1, foreColor:uint = 0x777777, foreAlpha:Number = 1, width:int = 200, height:int = 10) {
			_backColor = backColor;
			_backAlpha = backAlpha;
			_foreColor = foreColor;
			_foreAlpha = foreAlpha;
			_width = width;
			_height = height;
			
			super(true);
			
			_holder.x = -_width >> 1;
			_holder.y = -_height >> 1;
		}
		
		
		override protected function update():void {
			var g:Graphics = _holder.graphics;
			g.clear();
			
			g.beginFill(_backColor, _backAlpha);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
			
			if (progress != 0) {
				g.beginFill(_foreColor, _foreAlpha);
				g.drawRect(0, 0, _width * progress, _height);
				g.endFill();
			}
		}
		
	}

}
