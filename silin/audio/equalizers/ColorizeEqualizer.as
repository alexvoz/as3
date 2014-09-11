/*
   The MIT License,
   Copyright (c) 2011. silin (http://silin.su#AS3)
 */
package silin.audio.equalizers
{
	import flash.display.*;
	import flash.geom.*;
	import silin.bitmap.*;
	import silin.utils.*;
	
	/**
	 * расцветка битмапа палитрой
	 *
	 * @author silin
	 */
	public class ColorizeEqualizer extends GradientEqualizer
	{
		/**
		 * подгоночный клеффицент изменения альфы расцвеченной картинки в зависимости от уровня <br/>
		 * если ноль, то не трогаем альфу
		 */
		public var alphaLevel:Number = 3;
		private var resBitmap:Bitmap;
		private var srcBitmap:Bitmap;
		
		/**
		 *
		 * @param	bitmapData	картинка
		 * @param	colorArr	массив цветов
		 * @param	dampAlpha	альфа заглушки
		 * @param	dampColor	цвет заглушки
		 */
		public function ColorizeEqualizer(bitmapData:BitmapData, colorArr:Array /*uint*/ = null, dampAlpha:Number = 0.618, dampColor:uint = 0x000000)
		{
			
			super(colorArr);
			
			srcBitmap = new Bitmap(bitmapData.clone());
			resBitmap = new Bitmap(new BitmapData(srcBitmap.width, srcBitmap.height, false));
			addChild(srcBitmap);
			
			// заглушка основной картинки
			if (dampAlpha > 0)
			{
				var dampShape:Shape = new Shape();
				dampShape.graphics.beginFill(dampColor, dampAlpha);
				dampShape.graphics.drawRect(0, 0, srcBitmap.width, srcBitmap.height);
				addChild(dampShape);
			}
			addChild(resBitmap);
		
		}
		
		protected override function render():void
		{
			resBitmap.bitmapData.copyPixels(srcBitmap.bitmapData, srcBitmap.bitmapData.rect, new Point());
			BitmapTransform.colorizeBitmap(resBitmap.bitmapData, Color.getGradientArray(colors, null, ratios));
			resBitmap.alpha = alphaLevel ? alphaLevel * level : 1;
		}
	}

}