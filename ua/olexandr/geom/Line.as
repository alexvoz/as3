package ua.olexandr.geom {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author Zeh Fernando - z at zeh.com.br
	 * @author Olexandr Fedorow
	 */
	public class Line {
		
		private var _p1:Point;
		private var _p2:Point;
		
		/**
		 * Constructor
		 * @param	p1
		 * @param	p2
		 * @param	clone
		 */
		public function Line(p1:Point, p2:Point, clone:Boolean = false) {
			_p1 = clone ? p1.clone() : p1;
			_p2 = clone ? p2.clone() : p2;
		}
		
		/**
		 * Check if a rectangle intersects OR contains this line
		 * @param	rect
		 * @return
		 */
		public function intersectsRect(rect:Rectangle):Boolean {
			if (rect.containsPoint(_p1) || rect.containsPoint(_p2))
				return true;
			
			if (intersectsLine(new Line(new Point(rect.left, rect.top), new Point(rect.right, rect.top))))
				return true;
			if (intersectsLine(new Line(new Point(rect.left, rect.top), new Point(rect.left, rect.bottom))))
				return true;
			if (intersectsLine(new Line(new Point(rect.left, rect.bottom), new Point(rect.right, rect.bottom))))
				return true;
			if (intersectsLine(new Line(new Point(rect.right, rect.top), new Point(rect.right, rect.bottom))))
				return true;
			
			return false;
		}
		
		/**
		 * Check whether two lines intersects each other
		 * @param	line
		 * @return
		 */
		public function intersectsLine(line:Line):Boolean {
			return Boolean(intersection(line));
		}
		
		/**
		 * Returns a point containing the intersection between two lines
		 * http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
		 * @param	line
		 * @return
		 */
		public function intersection(line:Line):Point {
			var a1:Number = _p2.y - _p1.y;
			var b1:Number = _p1.x - _p2.x;
			var a2:Number = line.p2.y - line.p1.y;
			var b2:Number = line.p1.x - line.p2.x;
			
			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0)
				return null;
			
			var c1:Number = _p2.x * _p1.y - _p1.x * _p2.y;
			var c2:Number = line.p2.x * line.p1.y - line.p1.x * line.p2.y;
			
			var p:Point = new Point((b1 * c2 - b2 * c1) / denom, (a2 * c1 - a1 * c2) / denom);
			
			if (Point.distance(p, _p2) > Point.distance(_p1, _p2))
				return null;
			if (Point.distance(p, _p1) > Point.distance(_p1, _p2))
				return null;
			if (Point.distance(p, line.p2) > Point.distance(line.p1, line.p2))
				return null;
			if (Point.distance(p, line.p1) > Point.distance(line.p1, line.p2))
				return null;
			
			return p;
		}
		
		/**
		 * Sets the new length of the line; 
		 * alignment = 0 aligns to the starting point, alignment == 1 to the end point
		 * @param	length
		 * @param	alignment
		 */
		public function setLength(length:Number, alignment:Number):void {
			if (isNaN(length))
				return;
			
			var l:Number = length;
			if (l == 0)
				return;
			
			var rest:Number = l - length;
			var f0:Number = alignment * rest;
			var f1:Number = (1 - alignment) * rest;
			var pp1:Point, pp2:Point;
			if (f0 == 0) {
				// Fast - start
				pp2 = Point.interpolate(_p2, _p1, (l - f1) / l);
				_p2.setTo(pp2.x, pp2.y);
			} else if (f1 == 0) {
				// Fast - end
				pp1 = Point.interpolate(_p2, _p1, f0 / l);
				_p1.setTo(pp1.x, pp1.y);
			} else {
				// Normal, middle
				pp1 = Point.interpolate(_p2, _p1, f0 / l);
				pp2 = Point.interpolate(_p2, _p1, (l - f1) / l);
				_p1.setTo(pp1.x, pp1.y);
				_p2.setTo(pp2.x, pp2.y);
			}
		}
		
		/**
		 * Sets the angle, from the starting point
		 * TODO: allow alignment of the new angle?
		 * @param	angle
		 */
		public function setAngle(angle:Number):void {
			_p2 = _p1.add(Point.polar(length, angle));
		}
		
		/**
		 * Duplicates an instance of Line. 
		 * @return
		 */
		public function clone():Line {
			return new Line(_p1.clone(), _p2.clone());
		}
		
		public function get length():Number {
			return Point.distance(_p1, _p2);
		}
		
		public function get angle():Number {
			return Math.atan2(_p2.y - _p1.y, _p2.x - _p1.x);
		}
		
		public function get p1():Point {
			return _p1;
		}
		
		public function get p2():Point {
			return _p2;
		}
	}
}
