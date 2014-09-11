/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package  silin.audio.equalizers
{
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	
	/**
	 * базовый класс эквалазейров, использующих градиент цветов<br/>
	 * @author silin
	 */
	public class GradientEqualizer extends Equalizer 
	{
		/**
		 * каждый охотник желает знать..
		 */
		public static const RAINBOW:Array/*uint*/= [0x400080, 0x0000FF, 0x0080FF, 0x00FF00, 0xFFFF00, 0xFF8000, 0xFF0000];
		
		public var shapeWidth:Number = 100;
		public var shapeHeight:Number = 10;
		
		protected var colors:Array/*uint*/;
		protected var ratios:Array/*Number*/=[0];
		protected var alphas:Array/*Number*/=[1];
		
		/**
		 * 
		 * @param	colorArr	массив цветов, число диапазонов исходя из количества цветов
		 */
		public function GradientEqualizer(colorArr:Array/*uint*/= null) 
		{
			
			colors = (colorArr || RAINBOW).concat();
			if (colors.length > 1)
			{
				super(colors.length - 1);
			}else
			{
				throw(new Error("Invalid color Array"));
			}
			super.defaultLevel = 0.025;
			super.stretchFactor = 4;
			
			for (var i:int = 0; i < bands; i++) alphas[i + 1] = 1;
			
		}
		
		public override function set bands(value:uint):void
		{
			throw(new Error("GradientEqualizer#bands is defined by colors amount in constructor only"));
		}
		
		protected override function onEnterFrame(event:Event=null):void
		{

			// заполняем ratios и alphas со второго до числа цветов
			super.onEnterFrame();
			for (var i: int = 0; i < bands; i++)
			{
				ratios[i + 1] = (ratios[i] + 0xFF * bandWeights[i]);
				
			}
			render();
		}
		
		protected override function render():void
		{
            var mtrx:Matrix = new Matrix();
            mtrx.createGradientBox(shapeWidth, shapeHeight, 0, 0, 0);
            graphics.clear();
            graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mtrx);
            graphics.drawRect(0, 0, shapeWidth, shapeHeight);
            graphics.endFill();
		}
	}

}