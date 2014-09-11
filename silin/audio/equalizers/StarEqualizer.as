/*
  The MIT License, 
  Copyright (c) 2011. silin (http://silin.su#AS3)
*/
package silin.audio.equalizers
{
	/**
	 * звезда
	 * @author silin
	 */
	public class StarEqualizer extends ShapeEqualizer
	{
		
		public var rayThickness:Number = 4;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радус
		 * @param	minRadius		минмиальный радиус
		 * @param	color			цвет заливки
		 */
		public function StarEqualizer(bands:uint = 8, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0x808080)
		{
			
			super(bands);
			super.maxSize = maxRadius;
			super.minSize = minRadius;
			super.color = color;
		
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			var k:Number = Math.PI * 2 / bands;
			var base:Number = minSize * Math.sin(k / 2);
			if (base < rayThickness)
			{
				base = rayThickness;
			}
			
			var r:Number = minSize * Math.cos(k / 2);
			
			for (var i:int = 0; i < bands; i++)
			{
				//if (!spectrumValues[i]) continue;
				
				var fi:Number = i * k;
				var raySin:Number = Math.sin(fi);
				var rayCos:Number = Math.cos(fi);
				var baseSin:Number = Math.sin(fi + Math.PI * 0.5);
				var baseCos:Number = Math.cos(fi + Math.PI * 0.5);
				
				var iX:Number =  r * rayCos;
				var iY:Number =  r * raySin;
				//vertices
				var aX:Number = iX - base * baseCos;
				var aY:Number = iY - base * baseSin;
				var bX:Number = iX + base * baseCos;
				var bY:Number = iY + base * baseSin;
				var cX:Number =  (r + (maxSize - r) * spectrumValues[i]) * rayCos;
				var cY:Number =  (r + (maxSize - r) * spectrumValues[i]) * raySin;
				
				i ? graphics.lineTo(aX, aY) : graphics.moveTo(aX, aY);
				
				graphics.lineTo(cX, cY);
				graphics.lineTo(bX, bY);
			}
			graphics.endFill();
		}
	
	}
}

