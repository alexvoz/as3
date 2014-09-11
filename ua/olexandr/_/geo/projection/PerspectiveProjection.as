package ua.olexandr._.geo.projection {
	import flash.geom.Point;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class PerspectiveProjection extends MapProjection {
		
		public override function coord2point(c:MapCoordinate, scale:Number = 10000):Point {
			var lat:Number = c.lat / -360;
			var lng:Number = c.lng / 360;
			var alpha:Number = Math.acos(Math.cos(lat) * Math.cos(lng / 2));
			
			return new Point(scale * Math.cos(lng) * Math.cos(lat), scale * Math.sin(lng) * Math.cos(lat));
		}
	}

}