package ua.olexandr.media.spectrum {
	import flash.utils.ByteArray;
	import ua.olexandr.display.ResizableObject;
	
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class SoundSpectrum extends ResizableObject implements ISpectrum {
		
		private const LENGTH:int = 256;
		
		private var _color1:uint;
		private var _color2:uint;
		
		private var _plotH:int;
		
		/**
		 * 
		 * @param	color1
		 * @param	color2
		 */
		public function SoundSpectrum(color1:uint = 0x666666, color2:uint = 0x999999) {
			_color1 = color1;
			_color2 = color2;
		}
		
		/**
		 * 
		 * @param	bytes
		 */
		public function render(bytes:ByteArray):void {
			graphics.clear();
			graphics.beginFill(_color1);
			graphics.moveTo(0, _plotH);
			
			var n:Number = 0;
			
			for (var i:int = 0; i < LENGTH; i++) {
				n = (bytes.readFloat() * _plotH);
				graphics.lineTo(i * 2, _plotH - n);
			}
			
			graphics.lineTo(LENGTH * 2, _plotH);
			graphics.endFill();
			
			graphics.beginFill(_color2);
			graphics.moveTo(LENGTH * 2, _plotH);
			
			for (i = LENGTH; i > 0; i--) {
				n = (bytes.readFloat() * _plotH);
				graphics.lineTo(i * 2, _plotH - n);
			}
			
			graphics.lineTo(0, _plotH);
			graphics.endFill();
		}
		
		/**
		 * 
		 */
		override public function draw():void {
			_plotH = _height / 2;
		}
		
	}
}
