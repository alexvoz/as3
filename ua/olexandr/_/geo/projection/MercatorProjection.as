package ua.olexandr._.geo.projection {
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class MercatorProjection extends MapProjection {
		private var _cache:Dictionary;
		
		public function MercatorProjection(scale:Number = 10000) {
			_cache = new Dictionary(true);
			super(scale);
		}
		
		public override function coord2point(c:MapCoordinate):Point {
			if (_cache[c] is Point)
				return _cache[c];
			
			var lat:Number = c.lat * Math.PI / -180;
			var lng:Number = c.lng * Math.PI / 180;
			var lng_norm:Number = 0;
			
			var p:Point = new Point(_scale * (lng - lng_norm), _scale * Math.log(Math.tan(0.25 * Math.PI + 0.5 * lat)));
			
			_cache[c] = p;
			
			return p;
		
		}
	}

}