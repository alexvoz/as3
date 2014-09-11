package ua.olexandr.display {
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import ua.olexandr.constants.AlignConst;
	import ua.olexandr.tools.display.Aligner;
	import ua.olexandr.tools.display.Scaler;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class Image extends FillObject {
		
		private var _source:Bitmap;
		private var _fitIn:Boolean;
		private var _align:String;
		
		/**
		 * 
		 * @param	source
		 * @param	smoothing
		 */
		public function Image(source:Bitmap, smoothing:Boolean = true) {
			super(0, 0);
			
			_source = source;
			addChild(_source);
			
			smoothing = smoothing;
			
			_fitIn = false;
			_align = AlignConst.CC;
			
			setSize(_source.width, _source.height);
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			_source.bitmapData.dispose();
			_source.bitmapData = null;
		}
		
		/**
		 * 
		 */
		public function get fitIn():Boolean { return _fitIn; }
		/**
		 * 
		 */
		public function set fitIn(value:Boolean):void {
			_fitIn = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get align():String { return _align; }
		/**
		 * 
		 */
		public function set align(value:String):void {
			_align = value;
			invalidate();
		}
		
		/**
		 * 
		 */
		public function get smoothing():Boolean { return _source.smoothing; }
		/**
		 * 
		 */
		public function set smoothing(value:Boolean):void { _source.smoothing = value; }
		
		/**
		 * 
		 */
		public function get source():Bitmap {
			return _source;
		}
		
		
		/**
		 * 
		 */
		override protected function draw():void {
			super.draw();
			
			scrollRect = new Rectangle(0, 0, _width, _height);
			
			if (_source) {
				if (_fitIn) Scaler.scaleInside(_source, _width, _height);
				else		Scaler.scaleOutside(_source, _width, _height);
				
				Aligner.align(_source, scrollRect, _align);
			}
		}
		
	}

}