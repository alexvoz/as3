package ua.olexandr._.geo.projection {
	
	import flash.geom.Point;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class NoProjection extends MapProjection {
		
		public function NoProjection(scale:Number = 10000) {
			super(scale);
		}
		
		public override function coord2point(c:MapCoordinate):Point {
			return new Point(c.lng * _scale, -c.lat * _scale);
		}
	
	}

}