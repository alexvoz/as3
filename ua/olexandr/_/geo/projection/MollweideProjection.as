package ua.olexandr._.geo.projection {
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class MollweideProjection extends MapProjection {
		private var _cache:Dictionary;
		
		public function MollweideProjection(scale:Number = 10000) {
			_cache = new Dictionary(true);
			super(scale);
		}
		
		private var _phiDB:Dictionary = new Dictionary();
		
		public override function coord2point(c:MapCoordinate):Point {
			if (_cache[c] is Point)
				return _cache[c];
			
			var lat:Number = c.lat * Math.PI / -180;
			var lng:Number = c.lng * Math.PI / 180;
			var lng_norm:Number = Math.PI;
			
			if (!(_phiDB[lat] is Number)) {
				var phi:Number = iteratePhi(lat, lat);
				_phiDB[lat] = phi;
			} else {
				phi = _phiDB[lat];
			}
			
			var p:Point = new Point((Math.sqrt(8) / Math.PI) * _scale * (lng) * Math.cos(phi), Math.SQRT2 * _scale * Math.sin(lat));
			
			_cache[c] = p;
			
			return p;
		}
		
		private function iteratePhi(phi_start:Number, lat:Number):Number {
			var phi:Number = phi_start;
			//trace('phi_start:', phi/Math.PI * 180);
			var phi_dist:Number = phiDist(phi, lat);
			var phi_dist_max:Number = 0.0001;
			var c:uint = 0;
			while (Math.abs(phi_dist) > phi_dist_max && c++ < 100) {
				//trace('phi_dist:', phi_dist/Math.PI * 180);
				phi += phi_dist;
				phi_dist = phiDist(phi, lat);
			}
			return phi / 2;
		}
		
		private function phiDist(phi:Number, lat:Number):Number {
			return -(phi + Math.sin(phi) - Math.PI * Math.sin(lat)) / (1 + Math.cos(phi));
		}
	
	}

}