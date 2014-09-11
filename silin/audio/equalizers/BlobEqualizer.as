/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	import flash.geom.Point;
	
	/**
	 * клякса
	 * @author silin
	 */
	public class BlobEqualizer extends ShapeEqualizer
	{
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радиус
		 * @param	minRadius		минимальный радиус
		 * @param	color			цвет заливки
		 */
		public function BlobEqualizer(bands:uint = 8, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0x808080)
		{
			super(bands);
			this.maxSize = maxRadius;
			this.minSize = minRadius;
			super.color = color;
		}
		
		protected override function render():void
		{
			var i:int;
			var pX:Number;
			var pY:Number;
			var cX:Number;
			var cY:Number;
			var fi:Number;
			var cicle:Vector.<Point> = new Vector.<Point>(bands + 1, true);
			
			graphics.clear();
			graphics.beginFill(color);
			var k:Number = minSize / maxSize;
			for (i = 0; i < bands; i++)
			{
				fi = 2 * i * Math.PI / bands;
				pX = (Math.cos(fi) * (k + (1 - k) * spectrumValues[i])) * maxSize;
				pY = (Math.sin(fi) * (k + (1 - k) * spectrumValues[i])) * maxSize;
				
				cicle[i] = new Point(pX, pY);
			}
			cicle[i] = cicle[0];
			pX = 0.5 * (cicle[0].x + cicle[bands - 1].x);
			pY = 0.5 * (cicle[0].y + cicle[bands - 1].y);
			graphics.moveTo(pX, pY);
			for (i = 0; i < bands; i++)
			{
				cX = cicle[i].x;
				cY = cicle[i].y;
				pX = 0.5 * (cicle[i].x + cicle[i + 1].x);
				pY = 0.5 * (cicle[i].y + cicle[i + 1].y);
				graphics.curveTo(cX, cY, pX, pY);
			}
			graphics.endFill();
		}
	
	}

}