/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	
	import flash.geom.Point;
	
	/**
	 * непонятное, кристалл что ли..
	 * @author silin
	 */
	public class CrystalEqualizer extends ShapeEqualizer
	{
		
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радус
		 * @param	color			цвет заливки
		 */
		public function CrystalEqualizer(bands:uint = 8,  maxRadius:Number = 50, color:uint = 0x808080)
		{
			
			super(bands);
			super.maxSize = maxRadius;
			super.color = color;
		
		}
		
		protected override function render():void
		{
			
			var i:int;
			
			var k:Number = Math.PI * 2 / bands;
			var tmp:Vector.<Point> = new Vector.<Point>(bands, true);
			for (i = 0; i < bands; i++)
			{
				var fi:Number = i * k;
				var pX:Number = maxSize * (Math.sin(fi) * spectrumValues[i]);
				var pY:Number = maxSize * (Math.cos(fi) * spectrumValues[i]);
				tmp[i] = new Point(pX, pY);
			}
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.moveTo(tmp[0].x, tmp[0].y);
			
			var d:int = 3;
			for (i = 0; i < bands; i++)
			{
				var p1:Point = tmp[i];
				var p2:Point = tmp[(i + d) % bands];
				graphics.lineTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
			}
			
			graphics.endFill();
		}
	
	}
}

