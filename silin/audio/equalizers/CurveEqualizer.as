/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	
	/**
	 * заливка по огибающей
	 * @author silin
	 */
	public class CurveEqualizer extends ShapeEqualizer
	{
		
		/**
		 * ширина диапазона
		 */
		public var shapeWidth:Number;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxHeight		максимальная высота
		 * @param	minHeight		минимальная высота 
		 * @param	shapeWidth		общая ширина 
		 * @param	color			цвет заливки
		 */
		public function CurveEqualizer(bands:uint = 8, shapeWidth:Number = 100,  maxHeight:Number = 50, 
		minHeight:Number=1, color:uint = 0x808080)
		{
			super(bands);
			super.minSize = minHeight;
			super.maxSize = maxHeight;
			super.color = color;
			this.shapeWidth = shapeWidth;
			
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			
			graphics.moveTo(0, maxSize - minSize);
			var bandWidth:Number = shapeWidth / bands;
			for (var i:int = 0; i < bands; i++)
			{
				var cX:Number = (i + 0.5) * bandWidth;
				var cY:Number = maxSize - spectrumValues[i] * (maxSize-minSize) - minSize;
				var pX:Number = (i + 1) * bandWidth;
				var pY:Number = maxSize - minSize;
				if (i < bands - 1)
				{
					pY -= (spectrumValues[i] + spectrumValues[i + 1]) * 0.5 * (maxSize - minSize);
				}
				graphics.curveTo(cX, cY, pX, pY);
			}
			graphics.lineTo(pX, maxSize);
			graphics.lineTo(0, maxSize);
		}
	
	}

}