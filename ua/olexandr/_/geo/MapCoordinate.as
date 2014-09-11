package ua.olexandr._.geo {
	import ua.olexandr.utils.MathUtils;
	
	/**
	 * ...
	 * @author gka
	 */
	public class MapCoordinate {
		
		private var _lat:Number;
		private var _lng:Number;
		
		/**
		 * 
		 * @param	lat	latitude = y
		 * @param	lng	longitude = x
		 */
		public function MapCoordinate(lat:Number, lng:Number) {
			latitude = lat;
			longitude = lng;
		}
		
		public function get longitude():Number { return _lng; }
		public function set longitude(value:Number):void { lng = value; }
		
		public function get latitude():Number { return _lat; }
		public function set latitude(value:Number):void { lat = value; }
		
		public function equals(m:MapCoordinate):Boolean {
			return 	MathUtils.round(m.latitude, 2) == MathUtils.round(latitude, 2) && 
					MathUtils.round(m.longitude, 2) == MathUtils.round(longitude, 2);
		}
		
		public function toString():String {
			return "[MapCoordinate longitude=" + longitude + " latitude=" + latitude + "]";
		}
		
	}

}