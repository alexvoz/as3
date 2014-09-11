/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.materials 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	
	/**
	 * материал для одноцветной заливки
	 * @author silin
	 */
	public class ColorMaterial extends Material
	{
		/**
		 * константа для заливки случайным цветом
		 */
		public static const RANDOM:uint = 0xF000000;
		private var _color:uint = 0;
		public function ColorMaterial(color:uint) 
		{
			
			_color = color;
		}
		
		
		/**
		 * цвет заливик
		 */
		public function get color():uint 
		{ 
			return _color==RANDOM ? 0xFFFFFF * Math.random() : _color; 
		}
		public function set color(value:uint):void 
		{
			_color = value;
		}
		
	}

}