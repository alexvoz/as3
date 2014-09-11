package ua.olexandr.display.effects {
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Fire extends Sprite {
		
		/**
		 * 
		 */
		public var phaseRateX:Number = 0;
		/**
		 * 
		 */
		public var phaseRateY:Number = 5;
		
		private const MARGIN:int = 10;
		
		private var _offsets:Array = [new Point(), new Point()];
		private var _seed:Number = Math.random();
		
		private var _fire:Sprite;
		private var _gradientBD:BitmapData;
		private var _displaceBD:BitmapData;
		
		private var _rdm:Number;
		
		/**
		 * 
		 * @param	w
		 * @param	h
		 */
		public function Fire(w:Number = 30, h:Number = 90) {
			var _colorIn:uint = 0xFFCC00;
			var _colorOut:uint = 0xE22D09;
			
			var _focalPointRatio:Number = .6
			
			var _matrix:Matrix;
			var _colors:Array;
			var _alphas:Array;
			var _ratios:Array;
			
			
			_matrix = new Matrix();
			_matrix.createGradientBox(w, h, Math.PI / 2, -w / 2, -h * (_focalPointRatio + 1) / 2);
			
			_colors = [_colorIn, _colorOut, _colorOut];
			_alphas = [1, 1, 0];
			_ratios = [30, 100, 220];
			
			_fire = new Sprite();
			_fire.graphics.beginGradientFill(GradientType.RADIAL, _colors, _alphas, _ratios, _matrix, SpreadMethod.PAD, InterpolationMethod.RGB, _focalPointRatio);
			_fire.graphics.drawEllipse(-w / 2, -h * (_focalPointRatio + 1) / 2, w, h);
			_fire.graphics.endFill();
			
			_fire.graphics.beginFill(0x000000, 0);
			_fire.graphics.drawRect(-w / 2, 0, w + MARGIN, 1);
			_fire.graphics.endFill();
			
			addChild(_fire);
			
			
			_displaceBD = new BitmapData(w + MARGIN, h, false, 0xFFFFFFFF);
			
			
			_matrix = new Matrix();
			_matrix.createGradientBox(w + MARGIN, h, Math.PI / 2, 0, 0);
			
			_colors = [0x666666, 0x666666];
			_alphas = [0, 1];
			_ratios = [120, 220];
			
			var _gradient:Sprite = new Sprite();
			_gradient.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix);
			_gradient.graphics.drawRect(0, 0, w + MARGIN, h);
			_gradient.graphics.endFill();
			
			
			_gradientBD = new BitmapData(w + MARGIN, h, true, 0x00FFFFFF);
			_gradientBD.draw(_gradient);
			
			_rdm = Math.floor(Math.random() * 10);
			
			
			addEventListener(Event.ENTER_FRAME, efHandler);
		}
		
		
		private function efHandler(e:Event):void {
			for (var i:int = 0; i < 2; i++) {
				_offsets[i].x += phaseRateX;
				_offsets[i].y += phaseRateY;
			}
			
			_displaceBD.perlinNoise(30 + _rdm, 60 + _rdm, 2, _seed, false, false, 7, true, _offsets);
			_displaceBD.copyPixels(_gradientBD, _gradientBD.rect, new Point(), null, null, true);
			
			_fire.filters = [new DisplacementMapFilter(_displaceBD, new Point(), 1, 1, 20, 10, DisplacementMapFilterMode.CLAMP)];
		}
	}
}