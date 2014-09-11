package ua.olexandr.tools {
	import flash.geom.Point;
	/**
	 * Copyright (c) 2012, Vladimir Agafonkin
	 * 
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class SimplifyDouglasPeucker {
		
		/**
		 * 
		 * @param	points
		 * @param	tolerance
		 * @param	quality
		 * @return
		 */
		public static function simplify(points:Array, tolerance:Number = 1, quality:Boolean = true):Array {
			tolerance = isNaN(tolerance) ? 1 : tolerance * tolerance;
			
			if (quality)
				points = simplifyDouglasPeucker(points, tolerance);
			points = simplifyRadialDistance(points, tolerance);
			
			return points;
		};
		
		
		private static function simplifyDouglasPeucker(points:Array, tolerance:Number):Array {
			var i:uint;
			var _len:uint = points.length;
			var _first:uint = 0;
			var _last:uint = _len - 1;
			
			var _distanceMax:Number;
			var _distance:Number;
			var _index:uint;
			
			var _stackFirst:Array = [];
			var _stackLast:Array = [];
			var _points:Array = [];
			
			var _markers:Array = new Array(_len);
			_markers[_first] = true
			_markers[_last] = true;
			
			while (_last) {
				_distanceMax = 0;
				
				for (i = _first + 1; i < _last; i++) {
					_distance = getSquareSegmentDistance(points[i], points[_first], points[_last]);
					
					if (_distance > _distanceMax) {
						_index = i;
						_distanceMax = _distance;
					}
				}
				
				if (_distanceMax > tolerance) {
					_markers[_index] = true;
					_stackFirst.push(_first, _index);
					_stackLast.push(_index, _last);
				}
				
				_first = _stackFirst.pop();
				_last = _stackLast.pop();
			}
			
			for (i = 0; i < _len; i++) {
				if (_markers[i])
					_points.push(points[i]);
			}
			
			return _points;
		}
		
		private static function simplifyRadialDistance(points:Array, tolerance:Number):Array {
			var _len:Number = points.length;
			var _pointCurr:Point;
			var _pointPrev:Point = points[0];
			var _points:Array = [_pointPrev];
			
			for (var i:uint = 1; i < _len; i++) {
				_pointCurr = points[i] as Point;
				
				if (getSquareDistance(_pointCurr, _pointPrev) > tolerance) {
					_points.push(_pointCurr);
					_pointPrev = _pointCurr;
				}
			}
			
			if (_pointPrev !== _pointCurr)
				_points.push(_pointCurr);
			
			return _points;
		}
		
		private static function getSquareDistance(p1:Point, p2:Point):Number {
			return Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2);
		}
		
		private static function getSquareSegmentDistance(p:Point, p1:Point, p2:Point):Number {
			var _x:Number = p1.x;
			var _y:Number = p1.y;
			var _dx:Number = p2.x - _x;
			var _dy:Number = p2.y - _y;
			var _t:Number;
			
			if (_dx || _dy) {
				_t = ((p.x - _x) * _dx + (p.y - _y) * _dy) / (Math.pow(_dx, 2) + Math.pow(_dy, 2));
				if (_t > 1) {
					_x = p2.x;
					_y = p2.y;
				} else if (_t > 0) {
					_x += _dx * _t;
					_y += _dy * _t;
				}
			}
			
			_dx = p.x - _x;
			_dy = p.y - _y;
			
			return Math.pow(_dx, 2) + Math.pow(_dy, 2);
		}
		
	}

}