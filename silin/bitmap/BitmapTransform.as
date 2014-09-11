/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.bitmap
{

	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import silin.filters.ColorAdjust;
	import silin.utils.Color;
	/**
	 * утилиты попиксельной трансформации битмапов
	 * @author silin
	 */
	public class BitmapTransform
	{

		private static const ORIGIN:Point = new Point();
		private static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.212671, 0.71516, 0.072169, 0, 0, 0.212671, 0.71516, 0.072169, 0, 0, 0.212671, 0.71516, 0.072169, 0, 0, 0, 0, 0, 1, 0]);
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function BitmapTransform()
		{
			throw(new Error ("BitmapTransform is a static class and should not be instantiated."));
		}
		
		/**
		 * считает массив доминирующих в картинке цветов <br/>
		 * результат может быть меньше заказанной длины <br/>
		 * и вообще может быть непредсказуемым, ибо шаманство
		 * @param	bitmapData	картинка
		 * @param	len			число цветов
		 * @param 	graySort	надо ли сортировать по насыщенности серого
		 * @return
		 */
		static public function getDominateColors(bitmapData:BitmapData, len:int = 8, graySort:Boolean=true):Array
		{
			
			
			//var bmd:BitmapData = bitmapData.clone();
			
			var size:Number = 64;
			var bmd:BitmapData = new BitmapData(size, size, false);
			var s:Number = Math.min(size / bitmapData.width, size / bitmapData.height);
			var mtrx:Matrix = new Matrix();
			mtrx.scale(s, s);
			bmd.draw(bitmapData, mtrx, null, null, null, true);
			
			var res:Array = [];
			var blurVal:int = 32;
			var roundVal:int = 48;
			// блурим, округляем
			bmd.applyFilter(bmd, bmd.rect, new Point(), new BlurFilter(blurVal, blurVal));
			BitmapTransform.decolor(bmd, roundVal);
			// считаем цвета
			var map:Object = { };
			var pixels:Vector.<uint> = bmd.getVector(bmd.rect);
			for each(var px:uint in pixels) map[px] = int(map[px]) + 1;
			
			// складывам в массив в виде объектов цвет-количество-серый эквивалент
			var sortArr:Array = [];
			for ( var key:String in map ) 
			{
				var clr:int = int(key);
				var gray:Number = (clr>>16&0xFF) * Color.R_LUM + (clr>>8&0xFF) * Color.G_LUM + (clr&0xFF) * Color.B_LUM;
				sortArr.push( { clr:clr, num:map[key], gray:gray} );
			}
			
			// сортируем по популярности
			sortArr.sortOn(["num"], Array.NUMERIC );
			//подрезаем до заказанной длины
			sortArr.splice(0, sortArr.length - len);
			//сортируем по серости
			if (graySort)
			{
				sortArr.sortOn(["gray"], Array.NUMERIC );
			}
			
			
			var resLen:int = Math.min(sortArr.length, len);
			for (var i:int = 0; i < resLen; i++) 
			{
				res.push(sortArr[i].clr);
			}
			
			
			
			return res;
		}
		
		static public function getHueColors(bitmapData:BitmapData, len:int = 8, graySort:Boolean=true):Array
		{
			
			var round:int = 5;
			//var bmd:BitmapData = bitmapData.clone();
			
			var size:Number = 64;
			var bmd:BitmapData = new BitmapData(size, size, false);
			var s:Number = Math.min(size / bitmapData.width, size / bitmapData.height);
			var mtrx:Matrix = new Matrix();
			mtrx.scale(s, s);
			bmd.draw(bitmapData, mtrx, null, null, null, true);
			var res:Array = [];
			var pixels:Vector.<uint> = bmd.getVector(bmd.rect);
			
			// считаем цвета
			var map:Object = { };
			
			for each(var px:uint in pixels) 
			{
				var h:int = int(round * Color.getHSL(px).h);
				map[h] = int(map[h]) + 1;
			}
			
			// складывам в массив в виде объектов цвет-количество-серый эквивалент
			var sortArr:Array = [];
			for ( var key:String in map ) 
			{
				sortArr.push( { h:key, num:map[key]} );
			}
			
			// сортируем по популярности
			sortArr.sortOn(["num"], Array.NUMERIC );
			//подрезаем до заказанной длины
			var resLen:int = Math.min(sortArr.length, len);
			for (var i:int = 0; i < resLen; i++) 
			{
				
				res.push(Color.fromHSL(sortArr[i].h/round, 1, 1));
			}
			
			
			return res;
			
			
			
		}
		
		/**
		 * усредненный цвет (24-битный)
		 * @param	bmd
		 * @return
		 */
		public static function getAverageColor(bmd:BitmapData):int
		{
			
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var pixels:Vector.<uint> = bmd.getVector(bmd.rect);
			for each(var px:uint in pixels)
			{
				r += px >> 16 * 0xFF;
				g += px >> 8 & 0xFF;
				b += px & 0xFF;
			}
			

			var count:int = pixels.length;
			r /= count;
			g /= count;
			b /= count;
			return  r << 16 | g << 8 | b;
			

		}

		/**
		 * обрезает скругления по углам
		 * @param	src
		 * @param	roundCorner
		 * @param	color
		 */
		public static function roundedCrop(src:BitmapData, radius:Number=32, color:uint = 0):void
		{

			var shape:Shape = new Shape();
			var mask:BitmapData = new BitmapData(src.width, src.height, true, 0);
			shape.graphics.beginFill(0);
			shape.graphics.drawRoundRect(0, 0, src.width, src.height, radius, radius);
			mask.draw(shape);

			var tmp:BitmapData = src.clone();
			src.fillRect(src.rect, color);
			src.copyPixels(tmp, src.rect, ORIGIN, mask, ORIGIN, true);
			tmp.dispose();
			mask.dispose();
		}
		/**
		 * рисует рамку с скругленными углами
		 * @param	src
		 * @param	radius		радиус
		 * @param	thickness	тольщина
		 * @param	color		цвет
		 * @param	alpha		прозрачность
		 */
		public static function roundedFrame(src:BitmapData, radius:Number = 32, thickness:Number = 0, color:int = 0, alpha:Number = 1):void
		{

			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.lineStyle(thickness, color, alpha);// , true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.MITER);
			thickness -= 1;
			shape.graphics.drawRoundRect(thickness/2, thickness/2, src.width - thickness, src.height - thickness, radius - thickness, radius - thickness);
			src.draw(shape);// , new Matrix(), null, null, null, true);
		}

		/**
		 * имитация капли
		 * @param	src 		битмап подложки
		 * @param	dropX		координаты центра капли
		 * @param	dropY
		 * @param	dropSize	размер
		 * @param	blurVal		величина блура
		 * @param	coeff		величина искажения
		 * @param  	appned		надо ли добавлять каплю к исходному битмапу
		 * @return  битпапДату капли
		 */
		public static function rainDrop(src:BitmapData, dropX:int, dropY:int, dropSize:int = 20, blurVal:int = 2, coeff:Number = 2, append:Boolean=false):BitmapData

		{
			if (dropSize <= 0) return null;

			if (coeff <= 0) coeff = 1;

			dropSize += dropSize % 2;

			var w1:int, h1:int;// , w2:int, h2:int;
			var halfSize:int = dropSize / 2;

			var radius:Number, oldRadius:Number, angle:Number, div:Number;

			var res:BitmapData = new BitmapData(dropSize + 2 * blurVal, dropSize + 2 * blurVal, true, 0x0);

			div =  halfSize  / Math.log( coeff * halfSize  + 1);
			for ( var h:int = -halfSize; h <= halfSize; ++h )
			{
				for ( var w:int = -halfSize; w <= halfSize; ++w )
				{

					radius = Math.sqrt( h * h + w * w );
					angle = Math.atan2( h, w );
					if ( radius <= halfSize )
					{
						oldRadius = radius;
						radius = (Math.exp(radius/div)-1)/coeff;
						w1 =  radius * Math.cos(angle);// + dropX;
						h1 =  radius * Math.sin(angle);

						// подсветка в зависимости от относительного радиуса и угла
						var bright:int = 0;
						var relRadius:int = Math.ceil(10 * oldRadius / halfSize);
						switch(relRadius) {
							case 3:
								if ( (angle >= 0.5) && (angle < 1.75) ) bright = 20;
							break;
							case 4:
								if ( (angle >= 0.0) && (angle < 2.25) )  bright = 30;
							break;
							case 5:
								if ( (angle >= 0.5) && (angle < 1.75) ) bright = 40;
							break;
							case 6:
								if ( (angle >= 0.25) && (angle < 0.50) ) bright = 30;
								if ( (angle >= 1.75 ) && (angle < 2.0) ) bright = 30;
							break;
							case 7:
								if ( (angle >= 0.50) && (angle < 1.75)) bright = -20;
								if ( (angle >= 0.0) && (angle < 0.25) ) bright = 20;
								if ( (angle >= 2.0) && (angle < 2.25) ) bright = 20;
							break;
							case 8:
								if ( (angle >= 0.10) && (angle < 2.0) )  bright = -20;
								if ( (angle >= -2.50) && (angle < -1.90) )  bright = 60;
							break;
							case 9:
								if ( (angle >= 0.75) && (angle < 1.50) ) bright = -40;
								if ( (angle >= -0.10) && (angle < 0.75) ) bright = -30;
								if ( (angle >= 1.50) && (angle < 2.35)) bright = -30;
							break;
							case 10:
								if ( (angle >= 0.0) && (angle < 2.25) ) bright = -80;
								if ( (angle >= 2.25) && (angle < 2.5) ) bright = -40;
								if ( (angle >= -0.25) && (angle < 0.0)) bright = -40;
							break;

						}

						var pixel:int = src.getPixel(dropX + w1, dropY + h1);
						var r:int = (pixel >> 16 & 0xFF) + bright;
						var g:int = (pixel >> 8 & 0xFF) + bright;
						var b:int = (pixel & 0xFF) + bright;
						//диапазон
						r = ( r < 0 ) ? 0 : ( r > 0xFF ? 0xFF : r );
						g = ( g < 0 ) ? 0 : ( g > 0xFF ? 0xFF : g );
						b = ( b < 0 ) ? 0 : ( b > 0xFF ? 0xFF : b );

						res.setPixel32(blurVal + halfSize + w, blurVal + halfSize + h, (0xFF << 24 | r << 16 | g << 8 | b));

					}
				}

			}

			res.applyFilter(res, res.rect, ORIGIN, new BlurFilter(blurVal, blurVal));

			if (append)
			{
				var mtrx:Matrix = new Matrix();
				mtrx.translate(dropX - res.width/2, dropY - res.height/2);
				src.draw(res, mtrx);
				res.dispose();
				return null;
			}else
			{
				return res;
			}
		}

		/////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////
		/**
		 * режет на фрагменты, ворочает их относительно исходного положения
		 * @param	bmd 			битмапДата, который искажаем
		 * @param	size 			размер ячейки
		 * @param	alpha			прозрачноcть эффекта
		 * @param	shiftCoeff		смещение (при rotateCell=false от него мало толку)
		 * @param	rotateCell		надо ли крутить ячеки
		 * @param	shiftAround		надо ли смещать ячеки еще и по кругу (актуально для shiftCoeff > 0)
		 */
		public static function crystalize(bmd:BitmapData, size:int = 10, alpha:Number=1, shiftCoeff:Number=0, rotateCell:Boolean=true, shiftAround:Boolean=false):void

		{
			var res:BitmapData = new BitmapData(bmd.width, bmd.height, true, 0x0);
			if (size < 1) return;

			size += size % 2;
			var nX:int = Math.ceil(bmd.width / size);
			var nY:int = Math.ceil(bmd.height / size);
			var originRect:Rectangle = new Rectangle(0, 0, size, size);

			//маска
			var mS:Shape = new Shape();
			//здесь возможны всякие выверты и с альфой и с формой
			mS.graphics.beginFill(0, alpha);
			mS.graphics.drawRect(0, 0, size, size);

			var mBmd:BitmapData = new BitmapData(size, size, true, 0);
			mBmd.draw(mS);

			//спрайт и битмап для копии
			var rSprite:Sprite = new Sprite();
			var rBitmap:Bitmap = new Bitmap();

			for (var i:int = 0; i < nX; i++)
			{
				for (var j:int = 0; j < nY; j++)
				{
					var dX:int = i * size;
					var dY:int = j * size;
					var sourceRec:Rectangle = new Rectangle(dX, dY, size, size);

					var kX:Number = j % 2 ? shiftCoeff : -shiftCoeff;
					var kY:Number = i % 2 ? shiftCoeff : -shiftCoeff;

					if (shiftAround && shiftCoeff)
					{
						var fi:Number = Math.atan2(nY/2 - j, nX/2 - i);
						kX *= Math.sin(fi);
						kY *= Math.cos(fi);
					}

					rBitmap.bitmapData = new BitmapData(size, size, true, 0);
					rBitmap.bitmapData.copyPixels(bmd, sourceRec, ORIGIN, mBmd, ORIGIN, true);

					rSprite.addChild(rBitmap);
					if (rotateCell)
					{
						var mtrx:Matrix = new Matrix();
						mtrx.translate( -size/2,-size/2);
						mtrx.rotate((i%2+j%2)*45);
						mtrx.translate( size/2,size/2);
						rBitmap.transform.matrix = mtrx;
					}

					//рисуем спрайт на холст
					var drawMtrx:Matrix = new Matrix();
					drawMtrx.translate(dX+kX * size/4, dY + kY * size/4);
					res.draw(rSprite, drawMtrx);

				}

			}

			bmd.draw(res);
			res.dispose();

		}

		//////////////////////////////////
		///////////////////////////////////
		/**
		 * букетная заливка(Magic wand tool), для битмапов без прозрачности
		 * @param	bmd
		 * @param	x			координаты точки анализа
		 * @param	y
		 * @param	color		цвет заливки
		 * @param	tol			точность
		 */
		public static function bucketFill(bmd:BitmapData, x:int, y:int, color:int, tol:int = 64):void
		{
			var wandColor:int = bmd.getPixel(x, y);

			//битмап цвета точки клика
			var tmp:BitmapData = new BitmapData(bmd.width, bmd.height, false, wandColor);

			//битмап разницы между оригиналом и цветом
			tmp.draw(bmd, null, null, BlendMode.DIFFERENCE);

			//ColorMatrixFilter, суммирующий все компоненты в синий канал
			var clrMtrx:ColorAdjust = new ColorAdjust();
			clrMtrx.setChannels(0,0,7);//всех в синий
			tmp.applyFilter(tmp, tmp.rect, ORIGIN, clrMtrx.filter);

			//кроем нулем что не попадает в tol
			tmp.threshold(tmp, tmp.rect, ORIGIN, "<=", tol, 0x0, 0xFF);

			//заливаем  то, что получилось  из точки клика
			tmp.floodFill(x, y, 0xFF000000);

			//красим оригинал заказанным цветом по свопадению с заливкой floodFill'ом
			bmd.threshold(tmp, tmp.rect, ORIGIN, "==",  0xFF000000, color | 0xFF000000);

		}

		///////////////////////////////////////////////////////
		/**
		 * округляет цвета с точночтью tol по каждому каналу
		 * @param	bmd
		 * @param	tol
		 */
		public static function decolor(bmd:BitmapData, tol:int):void
		{
			
			var pixels:Vector.<uint> = bmd.getVector(bmd.rect);
			var len:int = pixels.length;
			for (var i:int = 0; i < len; i++) 
			{
				pixels[i]=Color.round(pixels[i], tol);
			}
			bmd.setVector(bmd.rect, pixels);
		}

		
		/**
		 * пкерекрашивает битмап цветами из массива colors, исходя из градаций серого заданных каналов
		 * @param	bmd
		 * @param	colors		масссив цветов
		 * @param	channels	каналы, учитываемые в при раскраске, R|G|B, 1..7
		 *
		 */
		public static function colorizeBitmap(bmd:BitmapData, colors:Array/*uint*/, channels:int=7):void
		{

			var clr:ColorAdjust = new ColorAdjust();

			clr.setChannels(channels, 0, 0, 0);//всех складываем в красный
			bmd.applyFilter(bmd, bmd.rect, ORIGIN, clr.filter);
			//красим палитрой по красному каналу
			bmd.paletteMap(bmd, bmd.rect, ORIGIN,  colors);
		}

		/**
		 * скетчевый рисунок на базе adaptive threshold
		 * @param	bmd
		 * @param	value 	характерный размер, px
		 * @param	noise	рандомное удаление черных пикселей, 0..1
		 */
		public static function sketchBitmap(bmd:BitmapData, value:int=32, noise:Number=0):void
		{
			//заблуренная копия
			var blurBmd:BitmapData = bmd.clone();
			blurBmd.applyFilter(blurBmd, blurBmd.rect, ORIGIN, new BlurFilter(value, value));
			//дорисовываем заблуренный с blendMode

			bmd.draw(blurBmd, null, null, BlendMode.SUBTRACT);
			//чистим
			bmd.threshold(bmd, bmd.rect, ORIGIN, '>', 0, 0xffffffff, 0xff);
			//шум
			if (noise) bmd.pixelDissolve(bmd, bmd.rect, ORIGIN, 0, bmd.width * bmd.height * noise, 0xFFFFFF);

		}

		/**
		 * создает  отмасштабировную картинку из исходной
		 * @param	bmd
		 * @param	scale
		 * @return
		 */
		public static function getScaledBitmapData(bmd:BitmapData, scale:Number):BitmapData
		{
			var mtrx:Matrix = new Matrix();
			mtrx.scale(scale, scale);
			var res:BitmapData = new BitmapData(scale * bmd.width, scale * bmd.height);
			res.draw(bmd, mtrx, null, null, null, true);
			return res;
		}
	}

}

