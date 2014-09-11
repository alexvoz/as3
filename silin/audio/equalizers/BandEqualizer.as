/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	
	import flash.display.Shape;
	
	/**
	 * полоски
	 * @author silin
	 */
	public class BandEqualizer extends ShapeEqualizer
	{
		
		
		/**
		 * ширина диапазона
		 */
		public var bandWidth:Number;
		/**
		 * промежуток
		 */
		public var gap:Number;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxHeight		максимальная высота
		 * @param	minHeight		минимальная высота
		 * @param	bandWidth		ширина полосок
		 * @param	gap				промежуток
		 * @param	сolor			цвет полосок
		 *
		 */
		public function BandEqualizer(bands:uint = 8, maxHeight:Number = 50, minHeight:Number = 1, bandWidth:Number = 10, gap:Number = 1, color:uint = 0x808080)
		{
			
			super(bands);
			super.color = color;
			super.maxSize = maxHeight;
			super.minSize = minHeight;
			
			this.bandWidth = bandWidth;
			this.gap = gap;
			
		
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			
			for (var i:int = 0; i < bands; i++)
			{
				var h:Number = minSize + (maxSize - minSize) * spectrumValues[i];
				graphics.drawRect(i * bandWidth, maxSize, bandWidth - gap, -h);
				
			}
			graphics.endFill();
			graphics.beginFill(color);
			if (minSize)
			{
				graphics.drawRect(0, maxSize, bands * bandWidth - gap, -minSize);
			}
		
		}
	
	}
}

