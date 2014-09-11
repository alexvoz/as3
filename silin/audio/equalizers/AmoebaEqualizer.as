/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	
	/**
	 * амебоподобное что-то 
	 * @author silin
	 */
	public class AmoebaEqualizer extends ShapeEqualizer
	{
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радиус
		 * @param	minRadius		минмимальный радиус
		 * @param	color			цвет заливки
		 */
		public function AmoebaEqualizer(bands:uint = 8, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0x808080)
		{
			super(bands);
			super.maxSize = maxRadius;
			super.minSize = minRadius;
			super.color = color;
		}
		
		protected override function render():void
		{
			var i:int;
			var del:Number = 1 / bands;
			var fi:Number = -2 * Math.PI / bands + del;
			
			var d:Number = maxSize - minSize;
			var pX:Number = Math.cos(fi) * (minSize + spectrumValues[bands - 1] * d);
			var pY:Number = Math.sin(fi) * (minSize + spectrumValues[bands - 1] * d);
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.moveTo(pX, pY);
			
			for (i = 0; i < bands; i++)
			{
				fi = 2 * i * Math.PI / bands + del;
				pX = Math.cos(fi) * (minSize + spectrumValues[i] * d);
				pY = Math.sin(fi) * (minSize + spectrumValues[i] * d);
				graphics.curveTo(0, 0, pX, pY);
			}
			
			graphics.endFill();
		}
	
	}

}