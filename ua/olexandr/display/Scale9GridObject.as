package ua.olexandr.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import ua.olexandr.display.ResizableObject;
	import ua.olexandr.structures.Indents;
	import ua.olexandr.tools.display.Arranger;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Scale9GridObject extends ResizableObject {
		
		private var _source:DisplayObject;
		private var _indents:Indents;
		private var _scaleCenter:Boolean;
		private var _smoothing:Boolean;
		
		private var _widthOriginal:Number;
		private var _heightOriginal:Number;
		
		private var _bitmapTL:Bitmap;
		private var _bitmapTC:Bitmap;
		private var _bitmapTR:Bitmap;
		private var _bitmapCL:Bitmap;
		private var _bitmapCC:Bitmap;
		private var _bitmapCR:Bitmap;
		private var _bitmapBL:Bitmap;
		private var _bitmapBC:Bitmap;
		private var _bitmapBR:Bitmap;
		
		/**
		 * Constructor
		 * @param	source			Source
		 * @param	indents			Indents left, top, right and bottom
		 * @param	scaleCenter		Scaling of center or sides
		 * @param	smoothing		Smoothing
		 */
		public function Scale9GridObject(source:DisplayObject, indents:Indents, scaleCenter:Boolean = true, smoothing:Boolean = true):void {
			_source = source;
			_indents = indents;
			_scaleCenter = scaleCenter;
			_smoothing = smoothing;
			
			_widthOriginal = _source.width;
			_heightOriginal = _source.height;
			
			if (indents.left < 0 || indents.top < 0 || indents.right < 0 || indents.bottom < 0)
				throw new Error("All indents should be greater than zero");
			
			if (indents.left + indents.right > _widthOriginal)
				throw new Error("Sum of left and right indents should be less than width of source");
			
			if (indents.left + indents.right > _widthOriginal)
				throw new Error("Sum of top and bottom indents should be less than width of source");
			
			initClips();
			
			setSize(_source.width, _source.height);
		}
		
		/**
		 * Scaling of center or sides
		 */
		public function get scaleCenter():Boolean { return _scaleCenter; }
		public function set scaleCenter(value:Boolean):void {
			_scaleCenter = value;
			invalidate();
		}
		
		/**
		 * Smoothing
		 */
		public function get smoothing():Boolean { return _smoothing; }
		public function set smoothing(value:Boolean):void {
			if (_smoothing == value)
				return;
			
			_smoothing = value;
			
			_bitmapTL.smoothing = _smoothing;
			_bitmapTC.smoothing = _smoothing;
			_bitmapTR.smoothing = _smoothing;
			_bitmapCL.smoothing = _smoothing;
			_bitmapCC.smoothing = _smoothing;
			_bitmapCR.smoothing = _smoothing;
			_bitmapBL.smoothing = _smoothing;
			_bitmapBC.smoothing = _smoothing;
			_bitmapBR.smoothing = _smoothing;
		}
		
		
		private function initClips():void {
			var _bmpData:BitmapData;
			var _clip:Rectangle;
			var _matrix:Matrix;
			
			var _wl:Number = _indents.left;
			var _wc:Number = _widthOriginal - _indents.right - _indents.left;
			var _wr:Number = _indents.right;
			
			var _ht:Number = _indents.top;
			var _hc:Number = _heightOriginal - _indents.top - _indents.bottom;
			var _hb:Number = _indents.bottom;
			
			var _xL:Number = 0;
			var _xC:Number = _wl;
			var _xR:Number = _widthOriginal - _wr;
			
			var _yT:Number = 0;
			var _yC:Number = _ht;
			var _yB:Number = _heightOriginal - _hb;
			
			_bitmapTL = sliceClip(_xL, _yT, _wl, _ht);
			addChild(_bitmapTL);
			
			_bitmapTC = sliceClip(_xC, _yT, _wc, _ht);
			addChild(_bitmapTC);
			
			_bitmapTR = sliceClip(_xR, _yT, _wr, _ht);
			addChild(_bitmapTR);
			
			_bitmapCL = sliceClip(_xL, _yC, _wl, _hc);
			addChild(_bitmapCL);
			
			_bitmapCC = sliceClip(_xC, _yC, _wc, _hc);
			addChild(_bitmapCC);
			
			_bitmapCR = sliceClip(_xR, _yC, _wr, _hc);
			addChild(_bitmapCR);
			
			_bitmapBL = sliceClip(_xL, _yB, _wl, _hb);
			addChild(_bitmapBL);
			
			_bitmapBC = sliceClip(_xC, _yB, _wc, _hb);
			addChild(_bitmapBC);
			
			_bitmapBR = sliceClip(_xR, _yB, _wr, _hb);
			addChild(_bitmapBR);
		}
		
		private function sliceClip(x:Number, y:Number, w:Number, h:Number):Bitmap {
			var _clip:Rectangle = new Rectangle(0, 0, w, h);
			var _matrix:Matrix = new Matrix(1, 0, 0, 1, -x, -y);
			
			var _bmpData:BitmapData = new BitmapData(_clip.width, _clip.height, true, 0xFFFFFF);
			_bmpData.draw(_source, _matrix, null, null, _clip, _smoothing);
			
			return new Bitmap(_bmpData);
		}
		
		
		override protected function measure():void {
			if (_width < _indents.left + _indents.right) {
				trace("Sum of left and right indents should be less than width of source");
				_width = _indents.left + _indents.right;
			}
			
			if (_height < _indents.top + _indents.bottom) {
				trace("Sum of top and bottom indents should be less than width of source");
				_height = _indents.top + _indents.bottom;
			}
		}
		
		override protected function draw():void {
			var _widthI:Number = _indents.left + _indents.right;
			var _heightI:Number = _indents.top + _indents.bottom;
			
			var _widthC:Number;
			var _heightC:Number;
			
			if (_scaleCenter) {
				_widthC = Math.round(_width - _widthI);
				_heightC = Math.round(_height - _heightI);
				
				_bitmapTC.width = _widthC;
				_bitmapCC.width = _widthC;
				_bitmapBC.width = _widthC;
				
				_bitmapCL.height = _heightC;
				_bitmapCC.height = _heightC;
				_bitmapCR.height = _heightC;
			} else {
				_widthC = _widthOriginal - _widthI;
				_heightC = _heightOriginal - _heightI;
				
				var _widthL:int = Math.round((_width - _widthC) * _indents.left / _widthI);
				var _widthR:int = Math.round((_width - _widthC) * _indents.right / _widthI);
				
				var _heightT:int = Math.round((_height - _heightC) * _indents.top / _heightI);
				var _heightB:int = Math.round((_height - _heightC) * _indents.bottom / _heightI);
				
				_bitmapTL.width = _widthL;
				_bitmapCL.width = _widthL;
				_bitmapBL.width = _widthL;
				
				_bitmapTR.width = _widthR;
				_bitmapCR.width = _widthR;
				_bitmapBR.width = _widthR;
				
				_bitmapTL.height = _heightT;
				_bitmapTC.height = _heightT;
				_bitmapTR.height = _heightT;
				
				_bitmapBL.height = _heightB;
				_bitmapBC.height = _heightB;
				_bitmapBR.height = _heightB;
			}
			
			Arranger.arrangeByH([_bitmapTL, _bitmapTC, _bitmapTR]);
			Arranger.arrangeByH([_bitmapCL, _bitmapCC, _bitmapCR]);
			Arranger.arrangeByH([_bitmapBL, _bitmapBC, _bitmapBR]);
			
			Arranger.arrangeByV([_bitmapTL, _bitmapCL, _bitmapBL]);
			Arranger.arrangeByV([_bitmapTC, _bitmapCC, _bitmapBC]);
			Arranger.arrangeByV([_bitmapTR, _bitmapCR, _bitmapBR]);
		}
		
	}

}