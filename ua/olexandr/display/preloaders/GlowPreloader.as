package ua.olexandr.display.preloaders {
	import flash.filters.GlowFilter;
	import ua.olexandr.display.FillObject;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	
	public class GlowPreloader extends BasePreloader {
		
		private var _backColor:uint;
		private var _backAlpha:Number;
		private var _foreColor:uint;
		private var _foreAlpha:Number;
		private var _width:int;
		private var _height:int;
		
		private var _back:FillObject;
		private var _fore:FillObject;
		
		/**
		 * 
		 * @param	colorBack
		 * @param	colorFore
		 * @param	radiusMin
		 * @param	radiusMax
		 */
		public function GlowPreloader(backColor:uint = 0xCCCCCC, backAlpha:Number = 1, foreColor:uint = 0x4080B0, foreAlpha:Number = 1, width:int = 200, height:int = 4) {
			_backColor = backColor;
			_backAlpha = backAlpha;
			_foreColor = foreColor;
			_foreAlpha = foreAlpha;
			_width = width;
			_height = height > 3 ? height : 3;
			
			_back = new FillObject(_backColor, _backAlpha);
			_back.setSize(_width, _height);
			
			_fore = new FillObject(_foreColor, _foreAlpha);
			_fore.y = 1;
			_fore.setSize(0, _height - _fore.y * 2);
			_fore.filters = [new GlowFilter(foreColor, 1, 4, 4, 2, 3)];
			
			super(true);
			
			_holder.addChild(_back);
			_holder.addChild(_fore);
			_holder.x = -_width >> 1;
			_holder.y = -_height >> 1;
		}
		
		
		override protected function update():void {
			_fore.width = _width * progress;
		}
		
	}

}