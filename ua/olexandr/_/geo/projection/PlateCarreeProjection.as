package ua.olexandr._.geo.projection {
	import flash.geom.Point;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class PlateCarreeProjection extends MapProjection {
		
		public function PlateCarreeProjection(scale:Number = 10000) {
			super(scale);
		}
		
		public override function coord2point(c:MapCoordinate):Point {
			var lat:Number = c.lat * Math.PI / -180;
			var lng:Number = c.lng * Math.PI / 180;
			var lat_norm:Number = 46 * Math.PI / 180;
			
			return new Point(_scale * lng, _scale * (lat));
		}
	
	}

}