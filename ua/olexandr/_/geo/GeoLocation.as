package ua.olexandr._.geo 
{
	
	/**
	 * GeoLocation = MapCoordinate + Country
	 * 
	 * @author gka
	 */
	public class GeoLocation extends MapCoordinate
	{
		protected var _country:Country;
		
		public function GeoLocation(lat:Number, lng:Number, country:Country) 
		{
			super(lat, lng);
			_country = country;
		}
		
		public function get country():Country { return _country; }
		
		public function set country(value:Country):void 
		{
			_country = value;
		}
		
	}
	
}