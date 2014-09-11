/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import silin.geom.*;
	
	
	/**
	 * утилиты рисования 
	 * 
	 * @author silin
	 * 
	 */
	public class Draw
	{
		
		/**
		 * размер штриха
		 */
		public static var DASH_LENGTH:Number = 8;
		/**
		 * размер разрыва
		 */
		public static var GAP_LENGTH:Number = 4;
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Draw()
		{
			throw(new Error("Draw is a static class and should not be instantiated."))
		}
		
		/**
		 * рисует дугу в graphics
		 * @param	graphics		где рисовать
		 * @param	centerX			X-координата центра
		 * @param	centerY			Y-координата центра
		 * @param	radius			радиус
		 * @param	startAngle		начальный угол
		 * @param	arcAngle		угол дуги
		 * @param	steps			число отрезков
		 */
		public static function arc(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:int=16):void
		{
			
			var angleStep:Number = arcAngle / steps;
			graphics.moveTo(centerX + Math.cos(startAngle) * radius, centerY + Math.sin(startAngle) * radius);
			while(steps-->0)
			{
				startAngle+= angleStep
				graphics.lineTo(centerX + Math.cos(startAngle) * radius, centerY + Math.sin(startAngle) * radius);
			}
		}
		
		/**
		 * рисует пунктирную дугу в graphics
		 * @param	graphics		где рисовать
		 * @param	centerX			X-координата центра
		 * @param	centerY			Y-координата центра
		 * @param	radius			радиус
		 * @param	startAngle		начальный угол
		 * @param	arcAngle		угол дуги
		 * @param	shift			начальная позиция штриха: 0..1 
		 */
		public static function dashedArc(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, shift:Number=0):void
		{
			var arcLen:Number = radius * Math.abs( arcAngle);
			var steps:int = Math.round(arcLen / (DASH_LENGTH + GAP_LENGTH));
			var angleStep:Number = arcAngle / steps;
			var dashStep:Number = DASH_LENGTH / (DASH_LENGTH + GAP_LENGTH) * angleStep;
			var gapStep:Number = angleStep - dashStep;
			
			startAngle += angleStep * shift;
			graphics.moveTo(centerX + Math.cos(startAngle) * radius, centerY + Math.sin(startAngle) * radius);
			
			while(steps-->0)
			{
				startAngle += dashStep;
				graphics.lineTo(centerX + Math.cos(startAngle) * radius, centerY + Math.sin(startAngle) * radius);
				startAngle += gapStep;
				graphics.moveTo(centerX + Math.cos(startAngle) * radius, centerY + Math.sin(startAngle) * radius);
			}
		}
		
		/**
		 * рисует пунктирную окружность в graphics
		 * @param	graphics		где рисовать
		 * @param	centerX			X-координата центра
		 * @param	centerY			Y-координата центра
		 * @param	radius			радиус
		 * @param	startAngle		начальный угол
		 * @param	arcAngle		угол дуги
		 * @param	shift			начальная позиция штриха, 0..1 
		 */
		public static function dashedCircle(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, shift:Number=0):void
		{
			dashedArc(graphics, centerX, centerY, radius, 0, 2 * Math.PI, shift);
		}
		
		/**
		 * отсвет на шарике
		 * @param	graphics		где рисовать
		 * @param	radius			радиус
		 * @param	dir				ориентация источника света (в стиле StageAlign)
		 * @param	whiteAlpha		прозрачность светлой части (центр)
		 * @param	blackAlpha		прозрачность темной части (периферия)
		 * @param	focalRatio		сдвиг от цента -1..1
		 */
		public static function ballShade(graphics:Graphics, radius:Number, dir:String="TL", whiteAlpha:Number=0.5, blackAlpha:Number=0.25, focalRatio:Number=0.5):void
		{
			var angle:Number=0;
			switch(dir)
			{
				case "B":
					angle = Math.PI / 2;
				break;
				case "BL":
					angle = 3 * Math.PI / 4;
				break;
				case "BR":
					angle = Math.PI / 4;
				break;
				case "L":
					angle = Math.PI;
				break;
				case "T":
					angle = -Math.PI / 2;
				break;
				case "TL":
					angle = -3 * Math.PI / 4;
				break;
				case "TR":
					angle = -Math.PI / 4;
				break;
				default:
					
				break;
			}
			var fillType:String = "radial";
			var colors:Array = [0xFFFFFF, 0x0];
			var alphas:Array = [whiteAlpha, blackAlpha];
			var ratios:Array = [0, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(radius * 2, radius * 2, angle, -radius, -radius);
			graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, "pad", "rgb", focalRatio);
			graphics.drawCircle(0, 0, radius);
		}
		
		/**
		 * 
		 * @param	graphics		где рисовать
		 * @param	x				
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	shift			начальная позиция штриха, 0..1 
		 */
		public static function dashedRecangle(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, shift:Number=0):void
		{
			var tl:Point = new Point(x, y);
			var tr:Point = new Point(x + width, y);
			var br:Point = new Point(x + width, y + height);
			var bl:Point = new Point(x, y + height);
			
			dashedLine(graphics, tl, tr, shift);
			dashedLine(graphics, tr, br, shift);
			dashedLine(graphics, br, bl, shift);
			dashedLine(graphics, bl, tl, shift);
		}
		
		/**
		 * рисует пунктирную линию в graphics
		 * @param	graphics		где рисовать
		 * @param	startPoint		начальная точка
		 * @param	endPoint		конечеая точка
		 * @param	shift			начальная позиция штриха, 0..1 
		 */
		public static function dashedLine(graphics:Graphics, startPoint:Point, endPoint:Point, shift:Number=0):void
		{
			shift %= 1;
			if (shift < 0) shift += 1;
			var dashMode:Boolean = false;
			//текущая длина в зависмости от того с чего начинаем: с черточки или пробела
			var currLen:Number = shift * (GAP_LENGTH + DASH_LENGTH);
			//общая длина
			var totLen:Number = Point.distance(startPoint, endPoint);
			
			var dir:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			var cos:Number = Math.cos(dir);
			var sin:Number = Math.sin(dir);
			var cX:Number;
			var cY:Number;
			//если стратуем дальше промежутка, то надо дорисовать хвостик черточки в начале
			if (currLen > GAP_LENGTH)
			{
				
				graphics.moveTo(startPoint.x, startPoint.y);
				cX = startPoint.x + (currLen - GAP_LENGTH) * cos;
				cY = startPoint.y + (currLen - GAP_LENGTH) * sin;
				graphics.lineTo(cX, cY);
				
			}
			
			while (currLen < totLen)
			{
				//текущая точка
				cX = startPoint.x + currLen * cos;
				cY = startPoint.y + currLen * sin;
				//рисуем или двигаем указатель 
				if (dashMode)
				{
					graphics.lineTo(cX, cY);
					currLen += GAP_LENGTH;
				}else
				{
					graphics.moveTo(cX, cY);
					currLen += DASH_LENGTH;
				}
				dashMode = !dashMode;
			}
			//если закончилось на стадии линии, то дорисовываем остаток черточки
			if (dashMode) graphics.lineTo(endPoint.x, endPoint.y);
			
		}
		
		/**
		 * рисует пунктирную кривую в graphics
		 * @param	graphics		где рисовать
		 * @param	startPoint		начальная точка
		 * @param	controlPoint	управляющая точка
		 * @param	endPoint		конечная точка
		 * @param	shift			начальная позиция штриха, 0..1 
		 */
		public static function dashedCurve(graphics:Graphics, startPoint:Point, controlPoint:Point, endPoint:Point, shift:Number=0):void
		{
			dashedPath(graphics, [startPoint, controlPoint, endPoint], shift);
		}
		
		/**
		 * рисует серию curveTo
		 * @param	graphics	где рисовать
		 * @param	points		[(cX,cY),(aX,aY),..,(cX,cY)]
		 */
		public static function path(graphics:Graphics, points:Array/*Point*/):void
		{
			
			
			graphics.moveTo(points[0].x,points[0].y);
			for (var i:int = 1; i < points.length-1; i+=2) 
			{
				var cPoint:Point = points[i];
				var aPoint:Point = points[i + 1];
				graphics.curveTo(cPoint.x, cPoint.y, aPoint.x, aPoint.y);
			}
			
		}
		
		
		/**
		 * рисуеет пунктирную кривую, заданную массивом точек [(cX,cY),(aX,aY),..,(cX,cY)]
		 * @param	graphics		где рисовать
		 * @param	points			массив точек
		 * @param	shift			начальная позиция штриха, 0..1 
		 */
		public static function dashedPath(graphics:Graphics, points:Array/*Point*/, shift:Number=0):void
		{
			
			shift %= 1;
			if (shift < 0) shift += 1;
			
			var dashMode:Boolean = false;
			var path:Path = new Path(points);
			var currLen:Number =  shift * (GAP_LENGTH+DASH_LENGTH);
			var totLen:Number = path.length;
			var startPoint:Point = points[0];
			var endPoint:Point = points[points.length - 1];
			var currPoint:PathPoint;
			//если стратуем дальше промежутка, то надо дорисовать хвостик черточки в начале
			if (currLen > GAP_LENGTH)
			{
				graphics.moveTo(startPoint.x, startPoint.y);
				currPoint = path.getPathPoint(currLen - GAP_LENGTH);
				graphics.lineTo(currPoint.x, currPoint.y);
			}
			
			while (currLen < totLen)
			{
				//текущая точка
				currPoint = path.getPathPoint(currLen);
				//рисуем или двигаем ло указателя, двигаем указатель 
				if (dashMode)
				{
					graphics.lineTo(currPoint.x, currPoint.y);
					currLen += GAP_LENGTH;
				}else
				{
					graphics.moveTo(currPoint.x, currPoint.y);
					currLen += DASH_LENGTH;
				}
				dashMode = !dashMode;
			}
			//если закончилось на стадии линии, то дорисовываем остаток черточки
			if (dashMode) graphics.lineTo(endPoint.x, endPoint.y);
			
		}
		
		/**
		 * рисует по точкам points сглаженную пунктирную линию
		 * @param	graphics	где рисовать
		 * @param	points		массив точек по которым сглаживать
		 * @param	shift		начальная позиция штриха, 0..1
		 * @param	coeff		коефф. сглаживания
		 * @param	fitMode		степень кривой подгонки (quadratic|cubic)
		 */
		public static function dashedFitLine(graphics:Graphics, points:Array/*Point*/, shift:Number=0,coeff:Number=0.38, fitMode:String="quadratic"):void
		{
			var fitPath:FitLine = new FitLine(points, coeff, fitMode);
			dashedPath(graphics, fitPath.fitPoints, shift);
		}
		
		/**
		 * рисует по точкам points сглаженную линию
		 * @param	graphics	где рисовать
		 * @param	points		массив точек по которым сглаживать
		 * @param	shift		начальная позиция штриха, 0..1
		 * @param	coeff		коефф. сглаживания
		 * @param	fitMode		степень кривой подгонки (quadratic|cubic)
		 */
		public static function fitLine(graphics:Graphics, points:Array/*Point*/, shift:Number = 0, coeff:Number = 0.38, fitMode:String = "quadratic"):void
		{
			var fpath:FitLine = new FitLine(points, coeff, fitMode);
			fpath.drawFitLine(graphics);
		}
		/**
		 * рисует многоугольник по точкам
		 * @param	graphics
		 * @param	points
		 */
		public static function poly(graphics:Graphics, points:Array/*Point*/):void
		{
			
			graphics.moveTo(points[points.length - 1].x, points[points.length - 1].y);
			for (var i:int = 0; i < points.length; i++) {
				graphics.lineTo(points[i].x, points[i].y);
			}
		}
		
		public static function points(graphics:Graphics, points:Array/*Point*/):void
		{
			
			graphics.moveTo(points[0].x, points[0].y);
			for (var i:int = 1; i < points.length; i++) {
				graphics.lineTo(points[i].x, points[i].y);
			}
		}
		
		/**
		 * FP10 <br/>
		 * рисует битмаповую заливку в произвольные координаты <br/>
		 * идея  Vadim BELLinSKY aka Zebestov (http://flasher.ru/forum/blog.php?b=346)
		 * @param	graphics 	где рисовать
		 * @param	image		что рисовать
		 * @param	x1			TL
		 * @param	y1
		 * @param	x2			TR
		 * @param	y2
		 * @param	x3			BR
		 * @param	y3
		 * @param	x4			BL
		 * @param	y4
		 * 
		 * @example	http://silin.su/AS3/bitmap/distort10/bin/uvt/
		 */
		public static function freeTransform(
				graphics:Graphics, image:BitmapData, 
				x1:Number, y1:Number, 
				x2:Number, y2:Number, 
				x3:Number, y3:Number, 
				x4:Number, y4:Number, 
				smoothing:Boolean=true):void
		{
			//диагонали
			var x31:Number = x3 - x1;
			var x42:Number = x4 - x2;
			var y13:Number = y1 - y3;
			var y24:Number = y2 - y4;
			
			// точка пересечения диагоналей
			var c1:Number = x1 * y3 - x3 * y1;
			var c2:Number = x2 * y4 - x4 * y2;
			var iX:Number = -(c1 * x42 - c2 * x31) / (y13 * x42 - y24 * x31);
			var iY:Number = -(y13 * c2 - y24 * c1) / (y13 * x42 - y24 * x31);
 
			// T коэффициенты исходя из положения точки пересечения диагоналей
			// UV координаты координаты всегда 0/1, меняются только Т 
			var x1i:Number = x1 - iX;
			var y1i:Number = y1 - iY;
			var x2i:Number = x2 - iX;
			var y2i:Number = y2 - iY;
			var x3i:Number = x3 - iX;
			var y3i:Number = y3 - iY;
			var x4i:Number = x4 - iX;
			var y4i:Number = y4 - iY;
			var ratio2:Number = (x31 * x31 + y13 * y13) / (x42 * x42 + y24 * y24);
			_uvtdata[2] = Math.sqrt(ratio2 / (x3i * x3i + y3i * y3i));
			_uvtdata[5] = Math.sqrt(1 / (x4i * x4i + y4i * y4i));
			_uvtdata[8] =  Math.sqrt(ratio2 / (x1i * x1i + y1i * y1i));
			_uvtdata[11] = Math.sqrt(1 / (x2i * x2i + y2i * y2i));
			
			//рисуем
			//graphics.clear(); //это не наша забота, а того кто использует метод
			graphics.beginBitmapFill(image, null, false, smoothing);
			graphics.drawTriangles(Vector.<Number>([x1, y1, x2, y2, x3, y3, x4, y4]), _indices, _uvtdata);
			graphics.endFill();
		}
		
		static private var _indices:Vector.<int> = Vector.<int>([0, 1, 2, 2, 3, 0]);
		static private var _uvtdata:Vector.<Number> = Vector.<Number>([0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1]);
		
		/**
		 * FP10 <br/>
		 * отрисовка выпуклого многоугольника через drawTriangles
		 * @param	graphics
		 * @param	vertices
		 * @param	uvData
		 */
		public static function convexPoly(graphics:Graphics, vertices:Vector.<Number>, uvData:Vector.<Number>=null):void
		{
			var indices:Vector.<int> = new Vector.<int>();
			var len:int = vertices.length / 2;
			
			for (var i:int = 0; i < len-2; i++) 
			{
				var last:int = (i + 2) % len;
				indices.push(0, i + 1, last);
				
			}
			graphics.drawTriangles(vertices, indices, uvData);
			
		}
		
		
	}
	
}