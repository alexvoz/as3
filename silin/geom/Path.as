
/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.geom
{
	import flash.geom.Point;
	/**
	 * расчет параметров кривой, заданной в стиле curveTo [(cX,cY),(aX,aY),..,(cX,cY)]<br>
	 * идея и прототип © Ivan Dembicki,  Path class 
	 */
	public class Path {
		
		
		private var _pathLength:Number = 0;
		private var _segmentsArr:Array = [];
		private var _points:Array;
		
		
		/**
		 * constructor
		 * @param	points	массив точек (один или больше сегментов безье в виде [(aX,aY),(cX,cY),..,(aX,aY)])
		 */
		public function Path(points:Array) {
			
			_points = points;
			update();
			
		}
		
		

		/**
		 * расчет параметров точки  на кривой
		 * @param	pos 	позиция точки, px 
		 * @return
		 */
		public function getPathPoint(pos:Number):PathPoint {
			
			if (_segmentsArr.length < 1) 
			{
				return null;
			}
			
			if (pos > length) {
				pos = length;
			} else if (pos < 0) {
				pos = 0;
			}
			
			var len:Number = 0;
			var i:int = 0;
			
			while (len <= pos && i<_segmentsArr.length)
			{
				var segm:PathSegment = _segmentsArr[i++];
				len += segm.length;
			}
			
			return segm.getPoint(pos-(len-segm.length));
			
		}
		
		
		private function update():void
		{
			_segmentsArr = [];
			_pathLength = 0;
			for (var i:int=1; i<_points.length-1; i += 2) {
				var segm:PathSegment = new PathSegment(_points[i - 1], _points[i], _points[i + 1]);
				_pathLength += segm.length;
				_segmentsArr.push(segm);
				
			}
		}
		
		/**
		 * длина кривой, px
		 */
		public function get length():Number { return _pathLength; }
		/**
		 * массив curveTo-точек
		 */
		public function get points():Array { return _points; }
		public function set points(value:Array):void
		{
			_points = value;
			update();
		}
		
		
	}
}
