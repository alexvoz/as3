package silin.audio.equalizers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import silin.audio.equalizers.Equalizer;
	import silin.utils.Draw;
	
	/**
	 * непропорциональное искажение по четырем диапазонам
	 * @author silin
	 */
	public class DistortEqualizer extends Equalizer
	{
		/**
		 * минимальный масштаб искажения
		 */
		public var minScale:Number = 0.5;
		/**
		 * максимальный масштаб искажения
		 */
		public var maxScale:Number = 1.5;
		/**
		 * сдвиг диапазонов относительно углов картинки
		 */
		public var shift:int = 0;
		
		private var bmd:BitmapData;
		private var kX:Number;
		private var kY:Number;
		
		/**
		 *
		 * @param	bitmapData	картинка
		 * @param	minScale	минимальный масштаб искажения
		 * @param	maxScale	максимальный масштаб искажения
		 * @param	shift		сдвиг диапазонов относительно углов картинки
		 */
		public function DistortEqualizer(bitmapData:BitmapData, minScale:Number = 0.5, maxScale:Number = 1.5, shift:int = 0)
		{
			super(4);
			this.minScale = minScale;
			this.maxScale = maxScale;
			this.shift = shift;
			bmd = bitmapData;
			
			kX = bmd.width / 2;
			kY = bmd.height / 2;
		
		}
		
		protected override function render():void
		{
			
			var ds:Number = maxScale - minScale;
			var x1:Number = -kX * (minScale + ds * spectrumValues[shift % 4]);
			var x2:Number = kX * (minScale + ds * spectrumValues[(shift + 1) % 4]);
			var x3:Number = kX * (minScale + ds * spectrumValues[(shift + 2) % 4]);
			var x4:Number = -kX * (minScale + ds * spectrumValues[(shift + 3) % 4]);
			
			var y1:Number = -kY * (minScale + ds * spectrumValues[shift % 4]);
			var y2:Number = -kY * (minScale + ds * spectrumValues[(shift + 1) % 4]);
			var y3:Number = kY * (minScale + ds * spectrumValues[(shift + 2) % 4]);
			var y4:Number = kY * (minScale + ds * spectrumValues[(shift + 3) % 4]);
			
			graphics.clear();
			Draw.freeTransform(graphics, bmd, x1, y1, x2, y2, x3, y3, x4, y4);
		}
	}

}