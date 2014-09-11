/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.materials 
{
	import flash.display.*;
	import flash.geom.*;
	
	
	/**
	 * материал для отображения IBitmapDrawable источника
	 * @author silin
	 */
	public class DrawableMaterial  extends Material
	{
		private var _source:IBitmapDrawable;
		
		
		/**
		 * 
		 * @param	source			источник
		 * @param	sourceRect		область копирования
		 * @param	smoothing		сглаживание
		 */
		public function DrawableMaterial(source:IBitmapDrawable, sourceRect:Rectangle=null, smoothing:Boolean=false) 
		{
			_source = source;
			_smoothing = smoothing;
			//если есть валидный sourceRect, то берем его
			//если нет, то ориентируемся по источнику
			if (sourceRect && sourceRect.width && sourceRect.height)
			{
				_sourceRect = sourceRect;
				
			}else if (_source && _source["width"] && _source["height"])
			{
				if (_source is DisplayObject)
				{
					_sourceRect = DisplayObject(_source).getBounds(DisplayObject(_source));
				}else if (_source is BitmapData)
				{
					_sourceRect = BitmapData(_source).rect;
				}
				
			}else
			{
				throw(new Error("DrawableMaterial >> invalid source or/and sourceRect"));
			}
			update();
		}
		
		/**
		 * перерисовка источника в bitmapData;
		 */
		override public function update():void
		{
			if (_bitmapData)
			{
				_bitmapData.dispose();
			}
			
			_bitmapData = new BitmapData(_sourceRect.width, _sourceRect.height, true, 0x0);
			
			
			if (_source)
			{
				var mtrx:Matrix = new Matrix();
				mtrx.translate( -_sourceRect.x, -_sourceRect.y);
				_bitmapData.lock();
				_bitmapData.draw(_source, mtrx, null, null, null, _smoothing);
				_bitmapData.unlock();
			}
		}
		
		/**
		 * актуальный битмап
		 */
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		
		
		
		
		/**
		 * источник изображения
		 */
		/*public function get source():IBitmapDrawable { return _source; }
		
		public function set source(value:IBitmapDrawable):void 
		{
			_source = value;
		}*/
		
		
		
		
		
	}

}