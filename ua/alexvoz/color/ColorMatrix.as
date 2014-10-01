package ua.alexvoz.color {
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mario Klingemann
	 * http://www.quasimondo.com/
	 * @editor ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	 
	public class ColorMatrix {
		public var matrix:Array;
		
		private static const IDENTITY:Array = [	
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0
		];
		public const COLOR_DEFICIENCY_TYPES:Array = [
			'Protanopia',
			'Protanomaly',
			'Deuteranopia',
			'Deuteranomaly',
			'Tritanopia',
			'Tritanomaly',
			'Achromatopsia',
			'Achromatomaly'
		];
		private static const LUMA_R:Number = 0.212671;
		private static const LUMA_G:Number = 0.71516;
		private static const LUMA_B:Number = 0.072169;
		private static const LUMA_R2:Number = 0.3086;
		private static const LUMA_G2:Number = 0.6094;
		private static const LUMA_B2:Number = 0.0820;
		private static const RAD:Number = Math.PI / 180;
		private static const ONETHIRD:Number = 1 / 3;
		
		/**
		 * Конструктор
		 * @param	defMatrix - массив из 20 элементов или объект ColorMatrix. По умолчанию "единичная" матрица.
		 */
		public function ColorMatrix(defMatrix:Object = null) {
			if (defMatrix is ColorMatrix) matrix = defMatrix.matrix.concat();
				else if (defMatrix is Array) matrix = defMatrix.concat();
					else reset();
		}
		
		/**
		 * Сброс матрицы
		 */
		public function reset():void {
			matrix = IDENTITY.concat();
		}
		
		/**
		 * Копирование объекта ColorMatrix
		 */
		public function clone():ColorMatrix {
			return new ColorMatrix(matrix);
		}
		
		/**
		 * Наложение матрицы
		 * @param	mat - матрица из 20 элементов
		 */
		public function concatMatrix(mat:Array):void {
			var tempArr:Array = [];
			var i:int = 0;
			for (var y:int = 0; y < 4; y++) {
					for (var x:int = 0; x < 5; x++) {
						tempArr[int(i + x)] = mat[i] * matrix[x] + 
						mat[int(i + 1)] * matrix[int(x +  5)] + 
						mat[int(i + 2)] * matrix[int(x + 10)] + 
						mat[int(i + 3)] * matrix[int(x + 15)] +
						(x == 4 ? mat[int(i + 4)] : 0);
					}
					i+=5;
				}
			matrix = tempArr;
		}
		
		/**
		 * вернуть ColorMatrixFilter
		 */
		public function get filter():ColorMatrixFilter {
			return new ColorMatrixFilter(matrix);
		}
		
		/**
		 * Применить матрицу к BitmapData
		 * @param	bitmapData - BitmapData
		 */
		public function applyFilter(bitmapData:BitmapData):void {
			bitmapData.applyFilter( bitmapData, bitmapData.rect, new Point(), filter);
		}
		
		/**
		 * Инвертирование матрицы
		 */
		public function invert():void {
            concatMatrix([ 
				-1, 0, 0, 0, 255,
				0, -1, 0, 0, 255,
				0, 0, -1, 0, 255,
				0, 0, 0,  1, 0
			]);
		}
		
		/**
		 * Цветовое насыщение
		 * @param s - интенсивность [0.0...2.0] (0.0 - 0% - обесцвечивание, 1.0 - 100% - как в оригинале, < 0.0 - инвертирование цвета)
		 */
		public function adjustSaturation(s:Number = 1):void{
			var sInv:Number;
			var irlum:Number;
			var iglum:Number;
			var iblum:Number;
			sInv = (1 - s);
			irlum = (sInv * LUMA_R);
			iglum = (sInv * LUMA_G);
			iblum = (sInv * LUMA_B);
			concatMatrix([
				(irlum + s), iglum, iblum, 0, 0, 
				irlum, (iglum + s), iblum, 0, 0, 
				irlum, iglum, (iblum + s), 0, 0, 
				0, 0, 0, 1, 0
			]);
        }
		
		/**
		 * Констраст изображения. [-1.0..1.0] (-1 - чисто-серый)
		 * @param	r - интенсивность красного канала [-1.0..1.0]
		 * @param	g - интенсивность зеленого канала [-1.0..1.0] (если NaN - то равняется r)
		 * @param	b - интенсивность синего канала [-1.0..1.0] (если NaN - то равняется r)
		 */
		public function adjustContrast(r:Number, g:Number = NaN, b:Number = NaN):void {
			if (isNaN(g)) g = r;
			if (isNaN(b)) b = r;
			r += 1;
			g += 1;
			b += 1;
			concatMatrix([
				r, 0, 0, 0, (128 * (1 - r)), 
				0, g, 0, 0, (128 * (1 - g)), 
				0, 0, b, 0, (128 * (1 - b)), 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Яркость изображения. [-255.0..255.0] (-255 - черный, 255 - белый)
		 * @param	r - интенсивность красного канала [-255.0..255.0]
		 * @param	g - интенсивность зеленого канала [-255.0..255.0] (если NaN - то равняется r)
		 * @param	b - интенсивность синего канала [-255.0..255.0] (если NaN - то равняется r)
		 */
		public function adjustBrightness(r:Number, g:Number = NaN, b:Number = NaN):void {
			if (isNaN(g)) g = r;
			if (isNaN(b)) b = r;
			concatMatrix([
				1, 0, 0, 0, r, 
				0, 1, 0, 0, g, 
				0, 0, 1, 0, b, 
				0, 0, 0, 1, 0
			]);
        }
		
		/**
		 * Обесцвечивание (по цветовым каналам) [0..Infinity] (0 - канал отключен)
		 * @param	r - интенсивность красного канала [0..Infinity] (0 - канал отключен)
		 * @param	g - интенсивность зеленого канала [0..Infinity] (0 - канал отключен)
		 * @param	b - интенсивность синего канала [0..Infinity] (0 - канал отключен)
		 */
		public function toGreyscale(r:Number, g:Number = NaN, b:Number = NaN):void {
			if (isNaN(g)) g = r;
			if (isNaN(b)) b = r;
			concatMatrix([
				r, g, b, 0, 0, 
				r, g, b, 0, 0, 
				r, g, b, 0, 0, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Тон (Оттенок)
		 * @param	degrees - угол смещения тона (оттенка) [-180.0..180.0]
		 */
		public function adjustHue(degrees:Number):void {
			degrees *= RAD;
			var cos:Number = Math.cos(degrees);
			var sin:Number = Math.sin(degrees);
			concatMatrix([
				((LUMA_R + (cos * (1 - LUMA_R))) + (sin * -(LUMA_R))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * -(LUMA_G))), ((LUMA_B + (cos * -(LUMA_B))) + (sin * (1 - LUMA_B))), 0, 0, 
				((LUMA_R + (cos * -(LUMA_R))) + (sin * 0.143)), ((LUMA_G + (cos * (1 - LUMA_G))) + (sin * 0.14)), ((LUMA_B + (cos * -(LUMA_B))) + (sin * -0.283)), 0, 0, 
				((LUMA_R + (cos * -(LUMA_R))) + (sin * -((1 - LUMA_R)))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * LUMA_G)), ((LUMA_B + (cos * (1 - LUMA_B))) + (sin * LUMA_B)), 0, 0, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Перевести яркость в прозрачность
		 */
		public function luminance2Alpha():void {
			concatMatrix([
				0, 0, 0, 0, 255, 
				0, 0, 0, 0, 255, 
				0, 0, 0, 0, 255, 
				LUMA_R, LUMA_G, LUMA_B, 0, 0
			]);
		}
		
		/**
		 * Интенсивность прозрачности
		 * @param	amount [0.0..Infinity], < 0 - инвертировать прозрачность
		 */
		public function adjustAlphaContrast(amount:Number):void {
			amount += 1;
			concatMatrix([
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, amount, (128 * (1 - amount))
			]);
		}
		
		/**
		 * Тонирование (Колоризация)
		 * @param	rgb - цвет [0x000000..0xFFFFFF]
		 * @param	amount - интенсивность [0.0..1.0]? < 0 - выцветание, > 1 - перетонирование
		 */
		public function colorize(rgb:uint, amount:Number = 1):void {
			var r:Number = (((rgb >> 16) & 0xFF) / 0xFF);;
			var g:Number = (((rgb >> 8) & 0xFF) / 0xFF);
			var b:Number = ((rgb & 0xFF) / 0xFF);
			var inv_amount:Number = (1 - amount);
			concatMatrix([
				(inv_amount + ((amount * r) * LUMA_R)), ((amount * r) * LUMA_G), ((amount * r) * LUMA_B), 0, 0, 
				((amount * g) * LUMA_R), (inv_amount + ((amount * g) * LUMA_G)), ((amount * g) * LUMA_B), 0, 0, 
				((amount * b) * LUMA_R), ((amount * b) * LUMA_G), (inv_amount + ((amount * b) * LUMA_B)), 0, 0, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Установить каналы цветов
		 * @param	r - цветность красного канала [0..1] (0 - черный, 1 - без изменений, < 0 - инверсия, > 1 - перенасыщение) 
		 * @param	g - цветность синего канала [0..1] (0 - черный, 1 - без изменений, < 0 - инверсия, > 1 - перенасыщение) 
		 * @param	b - цветность зеленого канала [0..1] (0 - черный, 1 - без изменений, < 0 - инверсия, > 1 - перенасыщение) 
		 * @param	a - уровень альфа канала [0..1] (0 - прозрачный, 1 - без изменений, < 0 - инверсия, > 1 - перенасыщение) 
		 */
		public function setChannels(r:int = 1, g:int = 1, b:int = 1, a:int = 1):void {
			g *= 2;
			b *= 4;
			a *= 8;
			var rf:Number = (((r & 1) == 1) ? 1 : 0 ) + (((r & 2) == 2) ? 1 : 0) + (((r & 4) == 4) ? 1 : 0) + (((r & 8) == 8) ? 1 : 0);
			if (rf > 0) rf = (1 / rf);
			var gf:Number = (((g & 1) == 1) ? 1 : 0 ) + (((g & 2) == 2) ? 1 : 0) + (((g & 4) == 4) ? 1 : 0) + (((g & 8) == 8) ? 1 : 0);
			if (gf > 0) gf = (1 / gf);
			var bf:Number = (((b & 1) == 1) ? 1 : 0 ) + (((b & 2) == 2) ? 1 : 0) + (((b & 4) == 4) ? 1 : 0) + (((b & 8) == 8) ? 1 : 0);
			if (bf > 0) bf = (1 / bf);
			var af:Number = (((a & 1) == 1) ? 1 : 0 ) + (((a & 2) == 2) ? 1 : 0) + (((a & 4) == 4) ? 1 : 0) + (((a & 8) == 8) ? 1 : 0);
			if (af > 0) af = (1 / af);
			concatMatrix([
				(((r & 1) == 1)) ? rf : 0, (((r & 2) == 2)) ? rf : 0, (((r & 4) == 4)) ? rf : 0, (((r & 8) == 8)) ? rf : 0, 0, 
				(((g & 1) == 1)) ? gf : 0, (((g & 2) == 2)) ? gf : 0, (((g & 4) == 4)) ? gf : 0, (((g & 8) == 8)) ? gf : 0, 0, 
				(((b & 1) == 1)) ? bf : 0, (((b & 2) == 2)) ? bf : 0, (((b & 4) == 4)) ? bf : 0, (((b & 8) == 8)) ? bf : 0, 0, 
				(((a & 1) == 1)) ? af : 0, (((a & 2) == 2)) ? af : 0, (((a & 4) == 4)) ? af : 0, (((a & 8) == 8)) ? af : 0, 0
			]);
		}
		
		/**
		 * Наложение матрицы на текущую
		 * @param	colorMatrix - матрица для смешивания
		 * @param	amount - интенсивность
		 */
		public function blend(colorMatrix:ColorMatrix, amount:Number):void {
			var inv_amount:Number = (1 - amount);
			for (var i:int = 0; i < 20; i++) {
				matrix[i] = ((inv_amount * matrix[i]) + (amount * colorMatrix.matrix[i]));
			};
		}
		
		/**
		 * Экстраполировать матрицу из текущей
		 * @param	colorMatrix - матрица для экстраполяции
		 * @param	factor - ??
		 */
		public function extrapolate(colorMatrix:ColorMatrix, factor:Number ):void {
			for (var i:int = 0; i < 20; i++) {
				matrix[i] += (colorMatrix.matrix[i] - matrix[i]) * factor;
			};
		}

		/**
		 * ???
		 * @param	r
		 * @param	g
		 * @param	b
		 */
		public function average(r:Number=ONETHIRD, g:Number=ONETHIRD, b:Number=ONETHIRD):void {
			concatMatrix([
				r, g, b, 0, 0, 
				r, g, b, 0, 0, 
				r, g, b, 0, 0, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Граничные значения яркости
		 * @param	threshold - от
		 * @param	factor - до
		 */
		public function threshold(threshold:Number, factor:Number = 256):void {
			concatMatrix([
				(LUMA_R * factor), (LUMA_G * factor), (LUMA_B * factor), 0, (-(factor-1) * threshold), 
				(LUMA_R * factor), (LUMA_G * factor), (LUMA_B * factor), 0, (-(factor-1) * threshold), 
				(LUMA_R * factor), (LUMA_G * factor), (LUMA_B * factor), 0, (-(factor-1) * threshold), 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Граничные значения цветов
		 * @param	threshold - от
		 * @param	factor - до
		 */
		public function thresholdRGB(threshold:Number, factor:Number=256):void {
			concatMatrix([
				factor, 0, 0, 0, (-(factor-1) * threshold), 
				0, factor, 0, 0, (-(factor-1) * threshold), 
				0, 0, factor, 0, (-(factor-1) * threshold), 
				0, 0, 0, 1, 0
			]);
        }
		
		/**
		 * Граничные значения прозрачности
		 * @param	threshold - от
		 * @param	factor - до
		 */
		public function thresholdAlpha(threshold:Number, factor:Number = 256):void {
			concatMatrix([
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, factor, (-factor * threshold)
			]);
		}
		
		/**
		 * Обесцвечивание
		 */
		public function desaturate():void {
			concatMatrix([
				LUMA_R, LUMA_G, LUMA_B, 0, 0, 
				LUMA_R, LUMA_G, LUMA_B, 0, 0, 
				LUMA_R, LUMA_G, LUMA_B, 0, 0, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * Случайный эффект
		 * @param	amount - интенсивность [0.0..1.0]
		 */
		public function randomize(amount:Number = 1):void {
			var inv_amount:Number = (1 - amount);
			var r1:Number = (inv_amount + (amount * (Math.random() - Math.random())));
			var g1:Number = (amount * (Math.random() - Math.random()));
			var b1:Number = (amount * (Math.random() - Math.random()));
			var o1:Number = ((amount * 0xFF) * (Math.random() - Math.random()));
			var r2:Number = (amount * (Math.random() - Math.random()));
			var g2:Number = (inv_amount + (amount * (Math.random() - Math.random())));
			var b2:Number = (amount * (Math.random() - Math.random()));
			var o2:Number = ((amount * 0xFF) * (Math.random() - Math.random()));
			var r3:Number = (amount * (Math.random() - Math.random()));
			var g3:Number = (amount * (Math.random() - Math.random()));
			var b3:Number = (inv_amount + (amount * (Math.random() - Math.random())));
			var o3:Number = ((amount * 0xFF) * (Math.random() - Math.random()));
			concatMatrix([
				r1, g1, b1, 0, o1, 
				r2, g2, b2, 0, o2, 
				r3, g3, b3, 0, o3, 
				0, 0, 0, 1, 0
			]);
		}
		
		/**
		 * 
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @param	alpha
		 */
		public function setMultiplicators(red:Number = 1, green:Number = 1, blue:Number = 1, alpha:Number = 1):void {
			concatMatrix([ 
				red,   0, 0, 0, 0,
				0, green, 0, 0, 0,
				0, 0, blue,  0, 0,
				0, 0, 0, alpha, 0 
			]);
		}
		
		/**
		 * Сбросить цветовые каналы
		 */
		public function clearChannels(red:Boolean = false, green:Boolean = false, blue:Boolean = false, alpha:Boolean = false):void{
			if (red) matrix[0] = matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0;
			if (green) matrix[5] = matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0;
			if (blue) matrix[10] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0;
			if (alpha) matrix[15] = matrix[16] = matrix[17] = matrix[18] = matrix[19] = 0;
		}
		
		/**
		 * Перевести RGB в прозрачность
		 * @param	r - интенсивность красного цвета
		 * @param	g - интенсивность зеленого цвета
		 * @param	b - интенсивность синего цвета
		 */
		public function rgb2Alpha(r:Number = ONETHIRD, g:Number = ONETHIRD, b:Number = ONETHIRD):void {
			concatMatrix([
				0, 0, 0, 0, 255, 
				0, 0, 0, 0, 255, 
				0, 0, 0, 0, 255, 
				r, g, b, 0, 0
			]);
		}
		
		/**
		 * Инверсия прозрачности
		 */
		public function invertAlpha():void {
			concatMatrix([
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, -1, 255
			]);
		}
		
		/**
		 * Нормализация массива
		 */
		public function normalize():void {
			for (var i:int = 0; i < 4; i++) {
				var sum:Number = 0;
				for (var j:int = 0; j < 4; j++) {
					sum += matrix[i * 5 + j] * matrix[i * 5 + j];
				}
				sum = 1 / Math.sqrt(sum);
				if (sum != 1) {
					for (j = 0; j < 4; j++) {
						matrix[i * 5 + j] *= sum;
					}
				}
			}
		}
		
		/**
		 * Применить эффект
		 */
		public function applyColorDeficiency(type:String):void {
			// the values of this method are copied from http://www.nofunc.com/Color_Matrix_Library/ 
			switch (type) {
				case 'Protanopia':
					concatMatrix([
						0.567, 0.433, 0, 0, 0, 
						0.558, 0.442, 0, 0, 0, 
						0, 0.242, 0.758, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Protanomaly':
					concatMatrix([
						0.817, 0.183, 0, 0, 0, 
						0.333, 0.667, 0, 0, 0, 
						0, 0.125, 0.875, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Deuteranopia':
					concatMatrix([
						0.625, 0.375, 0, 0, 0, 
						0.7, 0.3, 0, 0, 0, 
						0, 0.3, 0.7, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Deuteranomaly':
					concatMatrix([
						0.8, 0.2, 0, 0, 0, 
						0.258, 0.742, 0, 0, 0, 
						0, 0.142, 0.858, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Tritanopia':
					concatMatrix([
						0.95, 0.05, 0, 0, 0, 
						0, 0.433, 0.567, 0, 0, 
						0, 0.475, 0.525, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Tritanomaly':
					concatMatrix([
						0.967, 0.033, 0, 0, 0, 
						0, 0.733, 0.267, 0, 0, 
						0, 0.183, 0.817, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Achromatopsia':
					concatMatrix([
						0.299, 0.587, 0.114, 0, 0, 
						0.299, 0.587, 0.114, 0, 0, 
						0.299, 0.587, 0.114, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
				case 'Achromatomaly':
					concatMatrix([
						0.618, 0.320, 0.062, 0, 0, 
						0.163, 0.775, 0.062, 0, 0, 
						0.163, 0.320, 0.516, 0, 0, 
						0, 0, 0, 1, 0
					]);
					break;
			}
			
		}
		
		/**
		 * Авто обесцвечивание 
		 */
		public function autoDesaturate(bitmapData:BitmapData, stretchLevels:Boolean = false, outputToBlueOnly:Boolean = false, tolerance:Number = 0.01):void {
			var histogram:Vector.<Vector.<Number>> = bitmapData.histogram(bitmapData.rect);
			var sum_r:Number = 0;
			var sum_g:Number = 0;
			var sum_b:Number = 0;
			var min:Number;
			var max:Number;
			var minFound:Boolean = false;
			var histR:Vector.<Number> = histogram[0];
			var histG:Vector.<Number> = histogram[1];
			var histB:Vector.<Number> = histogram[2];
			for (var i:int = 0; i < 256; i++) {
				sum_r += histR[i] * i;
				sum_g += histG[i] * i;
				sum_b += histB[i] * i;
			}
			var total:Number = sum_r + sum_g + sum_b;
			if (total == 0) {
				total = 3;
				sum_r = sum_g = sum_b = 3;
			}
			sum_r /= total;
			sum_g /= total;
			sum_b /= total;
			var offset:Number = 0;
			if (stretchLevels) {
				var minPixels:Number = bitmapData.rect.width * bitmapData.rect.height * tolerance;
				var sr:Number = 0;
				var sg:Number = 0;
				var sb:Number = 0;
				for ( i = 0; i < 256; i++ ) {
					sr += histR[i];
					sg += histG[i];
					sb += histB[i];
					if ( sr > minPixels || sg > minPixels || sb > minPixels ) {
						min = i;
						break;
					}
				}
				sr = 0;
				sg = 0;
				sb = 0;
				for (i = 256; --i > -1;){
					sr += histR[i];
					sg += histG[i];
					sb += histB[i];
					if ( sr > minPixels || sg > minPixels || sb > minPixels ) {
						max = i;
						break;
					}
				}
				
				if ( max - min < 255) {
					var f:Number = 256 / ((max - min) + 1);
					sum_r *= f;
					sum_g *= f;
					sum_b *= f;
					offset = -min;
				}
			}
			f = 1 / Math.sqrt(sum_r * sum_r + sum_g * sum_g + sum_b * sum_b);
			sum_r *= f;
			sum_g *= f;
			sum_b *= f;
			if (!outputToBlueOnly)
				concatMatrix([
					sum_r, sum_g, sum_b, 0, offset,
					sum_r, sum_g, sum_b, 0, offset,
					sum_r, sum_g, sum_b, 0, offset,
					0, 0, 0, 1, 0
				]); 
			else concatMatrix([
					0, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					sum_r, sum_g, sum_b, 0, offset,
					0, 0, 0, 1, 0
				]);
		}
    
        /**
		 * Инвертировать матрицу 2
		 */
		public function invertMatrix():Boolean {
			var coeffs:Matrix3D = new Matrix3D(Vector.<Number>([
				matrix[0], matrix[1], matrix[2], matrix[3],
				matrix[5], matrix[6], matrix[7], matrix[8],
				matrix[10], matrix[11], matrix[12], matrix[13],
				matrix[15], matrix[16], matrix[17], matrix[18]
			]));
			var check:Boolean = coeffs.invert();
			if (!check) return false;
			matrix[0] = coeffs.rawData[0]; 
			matrix[1] = coeffs.rawData[1]; 
			matrix[2] = coeffs.rawData[2]; 
			matrix[3] = coeffs.rawData[3]; 
			var tmp1:Number = -(coeffs.rawData[0] * matrix[4] + coeffs.rawData[1] * matrix[9] + coeffs.rawData[2] * matrix[14] + coeffs.rawData[3] * matrix[15]);
			matrix[5] = coeffs.rawData[4]; 
			matrix[6] = coeffs.rawData[5]; 
			matrix[7] = coeffs.rawData[6]; 
			matrix[8] = coeffs.rawData[7]; 
			var tmp2:Number = -(coeffs.rawData[4] * matrix[4] + coeffs.rawData[5] * matrix[9] + coeffs.rawData[6] * matrix[14] + coeffs.rawData[7] * matrix[15]);
			matrix[10] = coeffs.rawData[8]; 
			matrix[11] = coeffs.rawData[9]; 
			matrix[12] = coeffs.rawData[10]; 
			matrix[13] = coeffs.rawData[11]; 
			var tmp3:Number = -(coeffs.rawData[8] * matrix[4] + coeffs.rawData[9] * matrix[9] + coeffs.rawData[10] * matrix[14] + coeffs.rawData[11] * matrix[15]);
			matrix[15] = coeffs.rawData[12]; 
			matrix[16] = coeffs.rawData[13]; 
			matrix[17] = coeffs.rawData[14]; 
			matrix[18] = coeffs.rawData[15]; 
			var tmp4:Number = -(coeffs.rawData[12] * matrix[4] + coeffs.rawData[13] * matrix[9] + coeffs.rawData[14] * matrix[14] + coeffs.rawData[15] * matrix[15]);
			matrix[4] = tmp1;
			matrix[9] = tmp2;
			matrix[14] = tmp3;
			matrix[19] = tmp4;
			return true;
		}
		
		/**
		 * Применить матрицу на цвет?
		 * @param	rgba - цвет в формате 0x00000000
		 * @return  цвет в формате 0x00000000
		 */
		public function applyMatrix(rgba:uint):uint {
			var a:Number = (rgba >>> 24) & 0xff;
			var r:Number = (rgba >>> 16) & 0xff;
			var g:Number = (rgba >>> 8) & 0xff;
			var b:Number =  rgba & 0xff;
			var r2:int = 0.5 + r * matrix[0] + g * matrix[1] + b * matrix[2] + a * matrix[3] + matrix[4];
			var g2:int = 0.5 + r * matrix[5] + g * matrix[6] + b * matrix[7] + a * matrix[8] + matrix[9];
			var b2:int = 0.5 + r * matrix[10] + g * matrix[11] + b * matrix[12] + a * matrix[13] + matrix[14];
			var a2:int = 0.5 + r * matrix[15] + g * matrix[16] + b * matrix[17] + a * matrix[18] + matrix[19];
			if (a2 < 0) a2 = 0;
			if (a2 > 255) a2 = 255;
			if (r2 < 0) r2 = 0;
			if (r2 > 255) r2 = 255;
			if (g2 < 0) g2 = 0;
			if (g2 > 255) g2 = 255;
			if (b2 < 0) b2 = 0;
			if (b2 > 255) b2 = 255;
			return a2<<24 | r2<<16 | g2<<8 | b2;
		}
		
		/**
		 * ???
		 */
		public function fitRange():void {
			for (var i:int = 0; i < 4; i++) {
				var minFactor:Number = 0;
				var maxFactor:Number = 0;
				for (var j:int = 0; j < 4; j++) {
					if (matrix[i * 5 + j] < 0) minFactor += matrix[i * 5 + j];
						else maxFactor += matrix[i * 5 + j];
				}
				var range:Number =  maxFactor * 255 - minFactor * 255;
				var rangeCorrection:Number = 255 / range;
				if (rangeCorrection != 1)	{
					for ( j = 0; j < 4; j++ ) {
						matrix[i*5+j] *= rangeCorrection;
					}
				}
				minFactor = 0;
				maxFactor = 0;
				for (j = 0; j < 4; j++){
					if (matrix[i * 5 + j] < 0) minFactor += matrix[i * 5 + j];
						else maxFactor += matrix[i * 5 + j];
				}
				var worstMin:Number = minFactor * 255;
				var worstMax:Number = maxFactor * 255;
				matrix[i * 5 + 4] = -(worstMin + (worstMax - worstMin) * 0.5 - 127.5);
			}
    }
		
		
		/**
		 * Изменить тон (оттенок)?
		 * @param	degrees - угол смещения тона (оттенка) [-180.0..180.0]
		 */
		public function rotateHue(degrees:Number):void {
			var _arr:Array = initHue();
			concatMatrix(_arr[0].matrix);
			rotateBlue(degrees);
			concatMatrix(_arr[1].matrix);
		}
		
		private function initHue():Array {
			//var _greenRotation:Number = 35.0;
			var _greenRotation:Number = 39.182655;
			var _preHue:ColorMatrix = new ColorMatrix();
			_preHue.rotateRed(45);
			_preHue.rotateGreen(-_greenRotation);
			var _lum:Array = [LUMA_R2, LUMA_G2, LUMA_B2, 1.0];
			_preHue.transformVector(_lum);
			var _red:Number = _lum[0] / _lum[2];
			var _green:Number = _lum[1] / _lum[2];
			_preHue.shearBlue(_red, _green);
			var _postHue:ColorMatrix = new ColorMatrix();
			_postHue.shearBlue(-_red, -_green);
			_postHue.rotateGreen(_greenRotation);
			_postHue.rotateRed(-45);
			return [_preHue, _postHue];
		}
		
		/**
		 * ???
		 */
		public function transformVector(values:Array):void {
			if (values.length != 4) return;
			var r:Number = values[0] * matrix[0] + values[1] * matrix[1] + values[2] * matrix[2] + values[3] * matrix[3] + matrix[4];
			var g:Number = values[0] * matrix[5] + values[1] * matrix[6] + values[2] * matrix[7] + values[3] * matrix[8] + matrix[9];
			var b:Number = values[0] * matrix[10] + values[1] * matrix[11] + values[2] * matrix[12] + values[3] * matrix[13] + matrix[14];
			var a:Number = values[0] * matrix[15] + values[1] * matrix[16] + values[2] * matrix[17] + values[3] * matrix[18] + matrix[19];
			values[0] = r;
			values[1] = g;
			values[2] = b;
			values[3] = a;
		}
		
		public function shearRed(green:Number, blue:Number):void {
			shearColor(0, 1, green, 2, blue);
		}
    
		public function shearGreen(red:Number, blue:Number):void {
			shearColor(1, 0, red, 2, blue);
		}
    
		public function shearBlue(red:Number, green:Number):void {
			shearColor(2, 0, red, 1, green);
		}
		
		private function shearColor(x:int, y1:int, d1:Number, y2:int, d2:Number):void {
			var _matrix:Array = IDENTITY.concat();
			_matrix[y1 + x * 5] = d1;
			_matrix[y2 + x * 5] = d2;
			concatMatrix(_matrix);
		}
		
		public function rotateRed(degrees:Number):void {
			rotateColor(degrees, 2, 1); 
		}
    
		public function rotateGreen(degrees:Number):void {
			rotateColor(degrees, 0, 2); 
		}
    
		public function rotateBlue(degrees:Number):void {
			rotateColor(degrees, 1, 0); 
		}
		
		private function rotateColor(degrees:Number, x:int, y:int):void {
			degrees *= RAD;
			var _matrix:Array = IDENTITY.concat();
			_matrix[x + x * 5] = _matrix[y + y * 5] = Math.cos(degrees);
			_matrix[y + x * 5] =  Math.sin(degrees);
			_matrix[x + y * 5] = -Math.sin(degrees);
			concatMatrix(_matrix);
		}
        
	}
    
}
