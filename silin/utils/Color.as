/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.utils
{
	
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	/**
	 * утилиты для работы с цветом
	 * @author silin 
	 */
	public class Color
	{
		public static const R_LUM:Number = 0.212671;
		public static const G_LUM:Number = 0.715160;
		public static const B_LUM:Number = 0.072169;
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Color()
		{
			throw(new Error("Color is a static class and should not be instantiated."))
		}
		/**
		 * контрастный переданному цвет
		 * @param	clr
		 * @return
		 */
		public static function getContrastColor(clr:int):int
		{
			var r:int = clr >> 16;
			var g:int = clr >> 8 & 0xFF;
			var b:int = clr & 0xFF;
			//return  (0xFF - r) << 16 | (0xFF - g) << 8 | (0xFF - b);
			return (r + 0x80) % 0xFF << 16 | (g + 0x80) % 0xFF << 8 | (b + 0x80) % 0xFF;
		}
		/**
		 * сичтает массив из len цветов, исходя из парамтров заливки
		 * @param	colors	массив цветов 
		 * @param	ratios	массив пропорций, по умолчанию равномерное распределение
		 * @return
		 */
		public static function getGradientArray(colors:Array, alphas:Array=null, ratios:Array=null,len:int=256, transp:Boolean=true) : Array
        {
			var i:int;
			
			if (colors.length < 2)
			{
				throw(new Error("invalid colors array"));
				return;
			}
			if (!alphas)
			{
				alphas = [];
				for (i = 0; i < colors.length; i++) alphas.push(1);
			}
			
			
			
			if (!ratios)
			{
				ratios = [];
				for (i = 0; i < colors.length; i++) 
					ratios.push(0xFF * i / (colors.length - 1));
					
			}
			//TODO: проверка длин массивов
            var res:Array=[];
            var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
            var mtrx:Matrix = new Matrix();
            var bmd:BitmapData = new BitmapData(len, 1, true, 0);
            
            mtrx.createGradientBox(len, 1, 0, 0, 0);
            g.clear();
            g.beginGradientFill("linear", colors, alphas, ratios, mtrx);
            g.drawRect(0, 0, len, 1);
            g.endFill();
            bmd.draw(shape);
			
			
			for (i = 0; i < len; i++) 
			{
				transp ? res.push(bmd.getPixel32(i, 0)) : res.push(bmd.getPixel(i, 0));
            }
			bmd.dispose();
           
            return res;
        }
		
		/**
		 * 0xAARRGGBB из компонентов
		 * @param	r
		 * @param	g
		 * @param	b
		 * @param	a
		 * @return
		 */
		static public function fromRGB(r:int, g:int, b:int, a:int=0xFF):uint
		{
			return a << 24 | r << 16 | g << 8 | b;
		}
		
		/**
		 * {r:red, g:green, b:blue} из 0xRRGGBB
		 * @param	clr
		 * @return
		 */
		static public function getRGB(clr:uint):Object
		{
			var r:int = clr >> 16 & 0xFF;
			var g:int = clr >> 8 & 0xFF;
			var b:int = clr & 0xFF;
			
			return {r:r, g:g, b:b};
		}
		
		/**
		 * {a:alpha, r:red, g:green, b:blue} из 0xAARRGGBB
		 * @param	clr
		 * @return
		 */
		static public function getARGB(clr:uint):Object
		{
			
			var a:int = clr >> 24 & 0xFF;
			var r:int = clr >> 16 & 0xFF;
			var g:int = clr >> 8 & 0xFF;
			var b:int = clr & 0xFF;
			
			return {a:a, g:g, r:r, b:b};
		}
		/**
		 * смешение цветов clr1 и сдк2 в пропорции ratio [0..1]
		 * @param	clr1
		 * @param	clr2
		 * @param	ratio
		 * @return
		 */
		static public function mixColors(clr1:uint, clr2:uint, ratio:Number = 0.5):uint
		{
			//var a:int = ratio * (clr1 >> 24 & 0xFF) + (1 - ratio) * (clr2 >> 24 & 0xFF);
			var r:int = (1 - ratio) * (clr1 >> 16 & 0xFF) + ratio * (clr2 >> 16 & 0xFF);
			var g:int = (1 - ratio) * (clr1 >> 8 & 0xFF) + ratio * (clr2 >> 8 & 0xFF);
			var b:int = (1 - ratio) * (clr1  & 0xFF) + ratio * (clr2  & 0xFF);
			return fromRGB(r, g, b);
		}
		/**
		 * усредненный цвет BitmapData, перерисовка со масштабированием в 1 px (не особо точно это)
		 * @param	bmd
		 * @return
		 */
		static public function averageColor(bmd:BitmapData):uint
		{
			var bmp:Bitmap = new Bitmap(bmd);
			var px:BitmapData = new BitmapData(1, 1, false);
			var mtrx:Matrix = new Matrix(1 / bmd.width, 0, 0, 1 / bmd.height);
			px.draw(bmd, mtrx, null, null, null, true);
			return px.getPixel(0, 0);
		}
		
		/*
		static public function nearColor(clr:int, k:Number=0.15):int
		{
			
			
			var r:int = clr >> 16 & 0xFF;
			var g:int = clr >> 8 & 0xFF;
			var b:int = clr & 0xFF;
			
			
			r = Math.round(r * (1 + (r < 0x80 ? k : -k )));
			g = Math.round(g * (1 + (g < 0x80 ? k : -k )));
			b = Math.round(b * (1 + (b < 0x80 ? k : -k )));
			
			
			
			return r << 16 | g << 8 | b;
		}
		
		
		static public function depthColor(clr:int, val:Number):int
		{
			
			
			var r:int = clr >> 16 & 0xFF;
			var g:int = clr >> 8 & 0xFF;
			var b:int = clr & 0xFF;
			
			
			
			r = Math.round(val * r);
			g = Math.round(val * g);
			b = Math.round(val * b);
			
			
			if (r > 0xFF) r = 0xFF;
			if (g > 0xFF) g = 0xFF;
			if (b > 0xFF) b = 0xFF;
			
			return r << 16 | g << 8 | b;
		}
		*/
		/**
		 * покомпонентно округляет цвет с заданной точностью
		 * @param	clr	цвет(24-битный)
		 * @param	tol	точночть
		 * @return
		 */
		static public function round(clr:int, tol:int = 16):uint
		{
			
			var r:int = tol * int((clr >> 16 & 0xFF) / tol);
			var g:int = tol * int((clr >> 8 & 0xFF) / tol);
			var b:int = tol * int((clr & 0xFF) / tol);
			
			return r << 16 | g << 8 | b;
		}

		/**
		 * {h:hue, s:saturation, l:luminance} из 0xRRGGBB <br/>
		 * hue 			: -Pi..Pi <br/>
		 * saturation	: 0..1 <br/>
		 * luminance	: 0..1 <br/>
		 * @param	clr
		 * @return  { h:hue, s:saturation, l:luminance }
		 */
		static public function getHSL(clr:uint):Object
		{
			var r:Number = (clr >> 16 & 0xFF) / 0xFF;
			var g:Number = (clr >> 8 & 0xFF) / 0xFF;
			var b:Number = (clr & 0xFF) / 0xFF;
			var luminance:Number =  r * 0.29900 + g * 0.58700 + b * 0.14400;
			var u:Number = - r * 0.14714 - g * 0.28886 + b * 0.43600;
			var v:Number =   r * 0.61500 - g * 0.51499 - b * 0.10001;
			var hue:Number = Math.atan2(v, u);
			var saturation:Number = Math.sqrt( 2 * (u * u + v * v) );
			return {h:hue, s:saturation, l:luminance};
			
		}
		
		/**
		 * 0xRRGGBB из hue/saturation/luminance
		 * @param	h	-Pi..Pi 
		 * @param	s	0..1
		 * @param	l	0..1
		 * @return
		 */
		static public function fromHSL(h:Number, s:Number, l:Number):uint
		{
			s*= Math.SQRT1_2;
			var u:Number = Math.cos( h ) * s;
			var v:Number = Math.sin( h ) * s;
			var r:Number = 0.970874 * l  - 0.0591995 * u + 1.13983  * v;
			var g:Number = 0.970874 * l  - 0.453834  * u - 0.580599 * v;
			var b:Number = 0.970874 * l + 1.97292 * u + 0.00000781528 * v; 
			var clr:uint = fromRGB(0xFF * r, 0xFF * g, 0xFF * b);
			return clr;
		}
		
/*		
from http://www.quasimondo.com/archives/000696.php
So a formula that does not need any min/max and ifs to convert rgb to hsl looks like this:

// r,b and b are assumed to be in the range 0...1
luminance =  r * 0.29900 + g * 0.58700 + b * 0.14400;
u = - r * 0.14714 - g * 0.28886 + b * 0.43600;
v =   r * 0.61500 - g * 0.51499 - b * 0.10001;
hue = atan( v, u );
saturation = Math.sqrt( u*u + v*v );

In this case hue will be between -Pi and Pi and saturation will be between 0 and 1/sqrt(2), so you might want to multiply the saturation by sqrt(2) to get it in a range between 0 and 1.

Of course this also works the other way round - hsl to rgb looks like this:

// hue is an angle in radians (-Pi...Pi)
// for saturation the range 0...1/sqrt(2) equals 0% ... 100%
// luminance is in the range 0...1
u = cos( hue ) * saturation;
v = sin( hue ) * saturation;
r = 0.970874 * luminance  - 0.0591995 * u + 1.13983  * v;
g = 0.970874 * luminance  - 0.453834  * u - 0.580599 * v;
b = 0.970874 * luminance + 1.97292 * u + 0.00000781528 * v; 
  */

		
		
		

	}
	
}

