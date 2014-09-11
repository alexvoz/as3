package ua.olexandr.media.spectrum {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class Spectrum {
		
		private static var _helper:Sprite = new Sprite();
		
		private static var _view:ISpectrum;
		private static var _bytes:ByteArray;
		
		/**
		 * 
		 */
		public static function get bytes():ByteArray { return _bytes; }
		
		/**
		 * 
		 */
		public static function get view():ISpectrum { return _view; }
		/**
		 * 
		 */
		public static function set view(value:ISpectrum):void {
			var _flag:Boolean = Boolean(_view);
			
			_view = value;
			
			if (_view) {
				if (!_flag) {
					_helper.addEventListener(Event.ENTER_FRAME, efHandler);
					efHandler(null);
				}
			} else {
				if (_flag) {
					_helper.removeEventListener(Event.ENTER_FRAME, efHandler);
					_bytes = null;
				}
			}
		}
		
		
		private static function efHandler(e:Event):void {
			_bytes = new ByteArray();
			
			try {
				SoundMixer.computeSpectrum(_bytes);
			} catch (e:Error) { }
			
			_view.render(_bytes);
		}
		
	}

}