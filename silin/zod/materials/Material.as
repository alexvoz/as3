/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.materials 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * базовый класс материалов
	 * @author silin
	 */
	public class Material
	{
		///флаг сглаживания при отрисовке шейпов граней
		protected var _smoothing:Boolean = false;
		///область копирования в источнике (DrawableMaterial)
		protected var _sourceRect:Rectangle = null;
		///BitmapData заливки шейпов (TextureMaterial,DrawableMaterial)
		protected var _bitmapData:BitmapData;
		
		public function Material() 
		{
			
		}
		
		/**
		 * перерисовка источника в bitmapData; <br/>
		 * здесь заглушка, используется только в DrawableMaterial
		 */
		public function update():void
		{
			
		}
		
		/**
		 * сглаживание при отрисовке; <br/>
		 */
		public function get smoothing():Boolean { return _smoothing; }
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
		}
		
		/**
		 * область копирования в источнике; <br/>
		 * заглушка, используется только в DrawableMaterial
		 */
		public function get sourceRect():Rectangle { return _sourceRect; }
	}

}