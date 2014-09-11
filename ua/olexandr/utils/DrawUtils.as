package ua.olexandr.utils {
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author Fedorow Olexandr
	 */
	
	public class DrawUtils {
		
		/**
		 * Рисует сектор круга
		 * @param	canvas
		 * @param	center центр круга
		 * @param	radius радиус круга
		 * @param	angle угол поворота (в градусах)
		 * @param	clockwise по часовой стрелке
		 */
		[Inline]
		public static function drawSector(canvas:Graphics, center:Point, radius:Number, angle:int, clockwise:Boolean = true):void {
			canvas.moveTo(center.x, center.y);
			canvas.lineTo(center.x, center.y - radius);
			for (var i:Number = 0; i <= angle; i++) {
				var _x:Number = center.x - radius * Math.sin(i * Math.PI / 180) * (clockwise ? -1 : 1);
				var _y:Number = center.y - radius * Math.cos(i * Math.PI / 180);
				canvas.lineTo(_x, _y);
			}
			canvas.lineTo(center.x, center.y);
		}
		
		/**
		 * Рисует пунктирную линию
		 * @param	canvas
		 * @param	start начальная точка
		 * @param	end конечная точка
		 * @param	dash длина штриха
		 * @param	space интервал между штрихами
		 */
		[Inline]
		public static function drawDottedLine(canvas:Graphics, start:Point, end:Point, dash:Number = 1, space:Number = 1):void {
			var _distance:Number = Point.distance(start, end);
			
			canvas.moveTo(start.x, start.y);
			
			var _len:Number = _distance / (dash + space);
			
			var _stepFX:Number = (end.x - start.x) / _len;
			var _stepFY:Number = (end.y - start.y) / _len;
			
			var _stepDX:Number = _stepFX / (dash + space) * dash;
			var _stepDY:Number = _stepFY / (dash + space) * dash;
			
			var _x:Number = start.x;
			var _y:Number = start.y;
			
			_len = Math.floor(_len);
			
			for (var i:int = 0; i < _len; i++) {
				canvas.moveTo(_x, _y);
				canvas.lineTo(_x + _stepDX, _y + _stepDY);
				_x += _stepFX;
				_y += _stepFY;
			}
			canvas.moveTo(_x, _y);
			canvas.lineTo(end.x, end.y);
		}
		
		/**
		 * Рисует линию
		 * @param	canvas
		 * @param	start начальная точка
		 * @param	end конечная точка
		 */
		[Inline]
		public static function drawLine(canvas:Graphics, start:Point, end:Point):void {
			canvas.moveTo(start.x, start.y);
			canvas.lineTo(end.x, end.y);
		}
		
		/**
		 * Рисует сетку
		 * @param	canvas
		 * @param	w ширина области рисования
		 * @param	h высота области рисования
		 * @param	cols количество столбцов
		 * @param	rows количество строке
		 * @param	thick толщина границ
		 */
		[Inline]
		public static function drawGrid(canvas:Graphics, w:int, h:int, cols:int, rows:int, thick:int):void {
			var _cellW:Number = (w - (cols + 1) * thick) / cols;
			var _cellH:Number = (h - (rows + 1) * thick) / rows;
			
			canvas.drawRect(0, 0, w, h);
			
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < cols; j++)
					canvas.drawRect((j + 1) * thick + j * _cellW, (i + 1) * thick + i * _cellH, _cellW, _cellH);
			}
			canvas.endFill();
		}
		
		/**
		 * Рисует сплайн (плавную линию)
		 * @param	canvas
		 * @param	arr массив точек <Point>
		 * @param	details количество точек в одном отрезке
		 * @example	Следующий код рисует сплайн
		 * var _arr:Array = [new Point(10, 10), new Point(20, 30), new Point(30, 20), new Point(40, 40)];
		 * graphics.lineStyle(1, 0xFF);
		 * DrawUtils.drawSpline(graphics, _arr, 10);
		 */
		[Inline]
		public static function drawSpline(canvas:Graphics, arr:Array, details:int = 10):void {
			canvas.moveTo(arr[0].x, arr[0].y);
			
			var _len:int = arr.length - 1;
			for (var i:int = 0; i < _len; i++) {
				var _p0:Point = arr[i ? i - 1 : 0];
				var _p1:Point = arr[i];
				var _p2:Point = arr[i + 1];
				var _p3:Point = arr[i + 2 < _len ? i + 2 : _len];
				
				for (var j:int = 1; j < details; j++) {
					var _k:Number = j / details;
					var _x:Number = ((2 * _p1.x) + ((-_p0.x + _p2.x) + ((2 * _p0.x - 5 * _p1.x + 4 * _p2.x - _p3.x) + ( -_p0.x + 3 * _p1.x - 3 * _p2.x + _p3.x) * _k) * _k) * _k) / 2;
					var _y:Number = ((2 * _p1.y) + ((-_p0.y + _p2.y) + ((2 * _p0.y - 5 * _p1.y + 4 * _p2.y - _p3.y) + ( -_p0.y + 3 * _p1.y - 3 * _p2.y + _p3.y) * _k) * _k) * _k) / 2;
					
					canvas.lineTo(_x, _y);
				}
				
				canvas.lineTo(_p2.x, _p2.y);
			}
			
			// k - номер точки на отрезке, n1, n2 - крайние точки отрезка, n0, n3 - соседние точки отрезка
			// ((2 * n1) + (( -n0 + n2) + ((2 * n0 - 5 * n1 + 4 * n2 - n3) + ( -n0 + 3 * n1 - 3 * n2 + n3) * k) * k) * k) / 2;
		}
		
		/**
		 * Рисует кривую Безье
		 * @param	canvas
		 * @param	start точка начала
		 * @param	end точка конца
		 * @param	anchors массив точек-якорей
		 * @param	details количество точек в расчетной кривой
		 * @example	Следующий код рисует кривую Безье
		 * var _arr:Array = [new Point(20, 30), new Point(30, 20)];
		 * graphics.lineStyle(1, 0xFF);
		 * DrawUtils.drawBezier(graphics, new Point(10, 10), new Point(40, 40), _arr, 100);
		 */
		[Inline]
		public static function drawBezier(canvas:Graphics, start:Point, end:Point, anchors:Array, details:int = 100):void {
			anchors = anchors.concat();
			anchors.unshift(start);
			anchors.push(end);
			
			var _step:Number = 1 / details;
			var _arr:Array = [];
			
			var _point0:Point, _point1:Point;
			
			for (var i:Number = 0; i < 1 + _step; i += _step) {
				if (i > 1)
					i = 1;
				
				var _index:int = _arr.length;
				_arr[_index] = new Point(0, 0);
				
				var _len:int = anchors.length;
				for (var j:int = 0; j < _len; j++) {
					var _p0:int = _len - 1;
					var _p1:int = MathUtils.factorial(_p0);
					var _p2:int = MathUtils.factorial(j);
					var _p3:int = MathUtils.factorial(_p0 - j);
					var _p4:Number = (_p1 / (_p2 * _p3)) * Math.pow(i, j) * Math.pow(1 - i, _p0 - j);
					
					_point0 = _arr[_index] as Point;
					_point1 = anchors[j] as Point;
					
					_point0.x += _point1.x * _p4;
					_point0.y += _point1.y * _p4;
				}
			}
			
			
			canvas.moveTo(_arr[0].x, _arr[0].y);
			
			_len = _arr.length;
			for (i = 1; i < _len; i++)
				canvas.lineTo(_arr[i].x, _arr[i].y);
		}
	
		/**
		 * Рисует линейный градиент
		 * @param	canvas
		 * @param	colors массив цветов
		 * @param	alphas массив значений альфа (такое же количество, как и colors)
		 * @param	ratios массив положений цвета (такое же количество, как и colors) <[0, 255]>
		 * @param	rect прямоугольник для рисования
		 * @param	angle угол направления градиента (в градусах)
		 * @param	spreadMethod
		 * @param	interpolationMethod
		 */
		[Inline]
		public static function drawLinearGradient(canvas:Graphics, colors:Array, alphas:Array, ratios:Array, rect:Rectangle, angle:Number = 90, spreadMethod:String = 'pad', interpolationMethod:String = 'rgb'):void {
			var _m:Matrix = new Matrix();
			_m.createGradientBox(rect.width, rect.height, GeomUtils.degreesToRadians(angle), rect.left, rect.top);
			canvas.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, _m, spreadMethod, interpolationMethod);
			canvas.drawRect(rect.x, rect.y, rect.width, rect.height);
			canvas.endFill();
		}
		
		/**
		 * Рисует палитру цветов
		 * @param	canvas
		 * @param	w высота 
		 * @param	h ширина
		 */
		[Inline]
		public static function drawPalette(canvas:Graphics, w:uint = 100, h:uint = 100):void {
			var _percent:Number;
			var _radians:Number;
			
			var _r:uint;
			var _g:uint;
			var _b:uint;
			
			var _color:uint;
			var _matrixW:Matrix;
			var _matrixB:Matrix;
			
			var _halfH:Number = h * .5;
			
			for (var i:int = 0; i < w; i++) {
				_percent = i / w;
				_radians = (-360 * _percent) * (Math.PI / 180);
				
				_r = Math.cos(_radians) * 127 + 128 << 16;
				_g = Math.cos(_radians + 2 * Math.PI / 3) * 127 + 128 << 8;
				_b = Math.cos(_radians + 4 * Math.PI / 3) * 127 + 128;
				
				_color = _r | _g | _b;
				
				_matrixW = new Matrix();
				_matrixW.createGradientBox(1, _halfH, Math.PI * .5, 0, 0);
				_matrixB = new Matrix();
				_matrixB.createGradientBox(1, _halfH, Math.PI * .5, 0, _halfH);
				
				canvas.lineStyle(1, 0, 1, false, LineScaleMode.NONE, CapsStyle.NONE);
				
				canvas.lineGradientStyle(GradientType.LINEAR, [0xFFFFFF, _color], [100, 100], [0, 255], _matrixW);
				canvas.moveTo(i, 0);
				canvas.lineTo(i, _halfH);
				
				canvas.lineGradientStyle(GradientType.LINEAR, [_color, 0], [100, 100], [0, 255], _matrixB);
				canvas.moveTo(i, _halfH);
				canvas.lineTo(i, h);
			}
		}
		
		/**
		 * Рисует многоугольник
		 * @param	canvas
		 * @param	x
		 * @param	y
		 * @param	radius
		 * @param	count
		 * @param	degrees
		 */
		[Inline]
		public static function drawPolygon(canvas:Graphics, x:Number, y:Number, radius:Number, count:uint, degrees:Number = 0):void {
			var _start:Number = GeomUtils.degreesToRadians(degrees);
			var _step:Number = GeomUtils.degreesToRadians(360 / count);
			
			for (var i:int = 0; i <= count; i++) {
				var _rads:Number = _step * i + _start;
				var _x:Number = Math.cos(_rads) * radius + x;
				var _y:Number = Math.sin(_rads) * radius + y;
				
				if (i == 0)	canvas.moveTo(_x, _y);
				else		canvas.lineTo(_x, _y);
			}
		}
		
		/**
		 * Рисует звезду
		 * @param	canvas
		 * @param	x
		 * @param	y
		 * @param	radiusIn
		 * @param	radiusOut
		 * @param	count
		 */
		[Inline]
		public static function drawStar(canvas:Graphics, x:Number, y:Number, radiusIn:Number, radiusOut:Number, count:uint):void {
			if (radiusIn > radiusOut) {
				radiusIn = radiusIn + radiusOut;
				radiusOut = radiusIn - radiusOut;
				radiusIn = radiusIn - radiusOut;
			}
			
			canvas.moveTo(x, y - radiusOut)
			
			var _start:Number = GeomUtils.degreesToRadians(360 / (count * 2));
			
			var _x:Number;
			var _y:Number;
			
			for (var i:int = 1, l:int = count * 2; i <= l; i++) {
				var _rads:Number = _start * i - Math.PI / 2;
				var _radius:Number = (i % 2) ? radiusIn : radiusOut;
				
				if (i != count * 2) {
					_x = Math.cos(_rads) * _radius + x;
					_y = Math.sin(_rads) * _radius + y;
				} else {
					_x = x;
					_y = y - radiusOut;
				}
				
				canvas.lineTo(_x, _y);
			}
		}
		
		/**
		 * Рисует звезду c плавными внутренними углами
		 * @param	canvas
		 * @param	x
		 * @param	y
		 * @param	radiusCtrl
		 * @param	radiusAnchor
		 * @param	_count
		 */
		[Inline]
		public static function drawBurst(canvas:Graphics, x:Number, y:Number, radiusIn:Number, radiusOut:Number, count:uint):void {
			if (radiusIn > radiusOut) {
				radiusIn = radiusIn + radiusOut;
				radiusOut = radiusIn - radiusOut;
				radiusIn = radiusIn - radiusOut;
			}
			
			canvas.moveTo(x, y - radiusOut)
			
			var _step:Number = GeomUtils.degreesToRadians(360 / (count * 2));
			
			var _xCtrl:Number;
			var _yCtrl:Number;
			var _xAnchor:Number;
			var _yAnchor:Number;
			
			var _len:int = count * 2;
			for (var i:int = 1; i <= _len; i++) {
				var _rads:Number = _step * i - Math.PI / 2;
				var _radius:Number = (i % 2) ? radiusIn : radiusOut;
				
				if (i % 2 == 1) {
					_xCtrl = Math.cos(_rads) * _radius + x;
					_yCtrl = Math.sin(_rads) * _radius + y;
				} else {
					if (i != count * 2) {
						_xAnchor = Math.cos(_rads) * _radius + x;
						_yAnchor = Math.sin(_rads) * _radius + y;
					} else {
						_xAnchor = x;
						_yAnchor = y - radiusOut;
					}
					
					canvas.curveTo(_xCtrl, _yCtrl, _xAnchor, _yAnchor);
				}
			}
		}
		
		/**
		 * Рисует звезду c плавными углами
		 * @param	canvas
		 * @param	x
		 * @param	y
		 * @param	radiusIn
		 * @param	radiusOut
		 * @param	count
		 */
		[Inline]
		public static function drawBiscuit(canvas:Graphics, x:Number, y:Number, radiusIn:Number, radiusOut:Number, count:uint):void {
			if (radiusIn > radiusOut) {
				radiusIn = radiusIn + radiusOut;
				radiusOut = radiusIn - radiusOut;
				radiusIn = radiusIn - radiusOut;
			}
			
			var _step:Number = GeomUtils.degreesToRadians(360 / (count * 2));
			
			var _xCtrl:Number;
			var _yCtrl:Number;
			var _xAnchor:Number;
			var _yAnchor:Number;
			
			var _len:int = count * 2 + 1;
			for (var i:int = 1; i <= _len; i++) {
				var _rads:Number = _step * i - Math.PI / 2;
				var _radius:Number = (i % 2) ? radiusIn : radiusOut;
				
				if (i % 2 != 1) {
					_xCtrl = Math.cos(_rads) * _radius + x;
					_yCtrl = Math.sin(_rads) * _radius + y;
				} else {
					if (i != count * 2) {
						_xAnchor = Math.cos(_rads) * _radius + x;
						_yAnchor = Math.sin(_rads) * _radius + y;
					} else {
						_xAnchor = x;
						_yAnchor = y - radiusOut;
					}
				
					if (i == 1) 	canvas.moveTo(_xAnchor, _yAnchor);
					else			canvas.curveTo(_xCtrl, _yCtrl, _xAnchor, _yAnchor);
				}
			}
		}
		
	}

}
