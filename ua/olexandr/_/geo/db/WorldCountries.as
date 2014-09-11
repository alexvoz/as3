package ua.olexandr._.geo.db 
{
	import flash.utils.Dictionary;
	import net.vis4.data.tsv.TSVParser;
	import net.vis4.geo.Continent;
	import net.vis4.geo.Country;
	import net.vis4.geo.MapCoordinate;
	import net.vis4.utils.GeoUtil;
	
	/**
	 * ...
	 * @author gka
	 */
	public class WorldCountries 
	{
		protected var _countries:Array = [];
		protected var _continents:Array = [];
		
		/*
		 * @param res data resolution in km
		 */
		public function WorldCountries(mapdata:String, res:Number = 0) 
		{
			var data:Array = TSVParser.parse(mapdata);
			var _allC:uint = 0, _resC:uint = 0;
			
			
			var keep:Array = [];
			
			for each (var row:Array in data) {
				if (row.length < 6) continue;				
				var country:Country = new Country(row[0], getContinent(row[4]), row[1], row[2], row[3]);				
				var c:Array = (row[6] as String).split('|');
				
				for each (var s:String in c) {
					var shape:Array = [];
					var ms:Array = s.split(';');
					var lstPos:MapCoordinate = null;
					
					for each (var p:String in ms) {
						_allC++;
						var latlng:Array = p.split(',');
						var newPos:MapCoordinate = new MapCoordinate(latlng[1], latlng[0]);
						
						if (lstPos == null) {
							_resC++;
							shape.push(newPos);
							keep.push(newPos.toString());
							lstPos = newPos;
							
						} else {

							if (keep.indexOf(newPos.toString()) > -1) {
								shape.push(newPos);
								//_resC++;
								lstPos = newPos;
								
							} else if (GeoUtil.distance(lstPos, newPos) > res || newPos.lat < -75){
								
								shape.push(newPos);
								lstPos = newPos;	
								_resC++;
							} else {
								// skip point
							}
						}
						
						
					}
					country.shapes.push(shape);
				}
				_countries.push(country);
			}
			trace('WorldCountries initialized. ' + _countries.length + ' countries parsed. Reduced polygons from ' + _allC + ' to ' + _resC + ' points ('+Math.round(100*_resC/_allC)+'%)');
		}
	
		
		public function get countries():Array { return _countries; }
		
		public function set countries(value:Array):void 
		{
			_countries = value;
		}
		
		public function getCountry(code:String):Country
		{
			for each (var c:Country in _countries) {
				if (code == c.code2) return c;
			}
			return null;
		}
		
		public function getContinent(code:String):Continent
		{
			for each (var c:Continent in _continents) {
				if (c.code == code) return c;
			}
			c = new Continent(code);
			_continents.push(c);
			return c;
		}		
		
	}
	
}