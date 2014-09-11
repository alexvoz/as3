package ua.olexandr.utils {
	import ua.olexandr.geo.MapCoordinate;
	
	public class GeoUtils {
		
		/*
		 * returns distance in km
		 */
		[Inline]
		public static function distance(a:MapCoordinate, b:MapCoordinate):Number {
			var R:Number = 6371; // km
			var d:Number = Math.acos(Math.sin(GeomUtils.degreesToRadians(a.lat)) * Math.sin(GeomUtils.degreesToRadians(b.lat)) + Math.cos(GeomUtils.degreesToRadians(a.lat)) * Math.cos(GeomUtils.degreesToRadians(b.lat)) * Math.cos(GeomUtils.degreesToRadians(b.lng) - GeomUtils.degreesToRadians(a.lng))) * R;
			return d;
		}
	}

}