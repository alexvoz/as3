/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.materials
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;


	/**
	 * материал для тайловой заливки битмапом
	 * @author silin
	 */
	public class TextureMaterial  extends Material
	{
		
		
		/**
		 * 
		 * @param	source			битмапДата сэмпла
		 * @param	smoothing		сглаживание
		 * @param	scale			масштабирование (если параметр опущен, то source используем по ссылке, иначе копируем)
		 */
		public function TextureMaterial(source:BitmapData,  smoothing:Boolean = false, scale:Number = 0 )
		{
			
			_smoothing = smoothing;
			var mtrx:Matrix = new Matrix();
			var w:Number = source.width;
			var h:Number = source.height;
			
			//мутный момент
			//неоднозначеость в передаче источника: копированием или по ссылке
			if (scale)
			{
				mtrx.scale(scale, scale);
				w *= scale;
				h *= scale;
				_bitmapData = new BitmapData(w, h, true, 0x0);
				_bitmapData.draw(source, mtrx, null, null, null, _smoothing);
			}else
			{
				_bitmapData = source;
			}
		}
		
		
		/**
		 * зактуальный битмап
		 */
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		/**
		 * матрица для подгонки сэмпла в заданные размеры
		 * @param	w
		 * @param	h
		 * @return
		 */
		public  function getFitMatrix(w: Number, h:Number):Matrix
		{
			
			var sX:Number = w / _bitmapData.width;
			var sY:Number = h / _bitmapData.height;
			while (sX < 0.75) sX *= 2;
			while (sY < 0.75) sY *= 2;
			
			while (sX > 1.25) sX /= 2;
			while (sY > 1.25) sY /= 2;
			
			var mtrx:Matrix = new Matrix();
			mtrx.scale(sX, sY);
			
			return mtrx;
			
		}
		
		

	}

}

