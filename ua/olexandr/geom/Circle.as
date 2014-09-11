package ua.olexandr.geom {
	
	public class Circle {
		
		public var radius:Number
		public var x:Number
		public var y:Number
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	radius
		 */
		public function Circle(radius:Number, x:Number = 0, y:Number = 0) {
			this.radius = radius;
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Check whether two circles intersects each other
		 * @param	line
		 * @return
		 */
		public function intersectCircle(circle:Circle):Boolean {
			var _min:Number = radius + circle.radius;
			return Math.sqrt((x - circle.x) * (x - circle.x) + (y - circle.y) * (y - circle.y)) < _min;
		}
		
		public function get diameter():Number { return radius * 2; }
		public function set diameter(value:Number):void { radius = value * .5; }
		
		public function get area():Number { return Math.PI * Math.pow(radius, 2); }
		
		public function get perimeter():Number { return Math.PI * diameter; }
		
	}

}