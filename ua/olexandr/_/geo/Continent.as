package ua.olexandr._.geo 
{
	
	/**
	 * ...
	 * @author gka
	 */
	public class Continent 
	{
		public static const AFRICA:String = 'AF';
		public static const ASIA:String = 'AS';
		public static const EUROPE:String = 'EU';
		public static const ANTARCTICA:String = 'AN';
		public static const NORTH_AMERICA:String = 'NA';
		public static const SOUTH_AMERICA:String = 'SA';		
		public static const AUSTRALIA:String = 'OC';		
		
		private var _code:String;
		private var _countries:Array;
		
		public function Continent(ccode:String)
		{
			_countries = [];
			switch (ccode) {
				case AFRICA:
				case AUSTRALIA:
				case ASIA:
				case EUROPE:
				case ANTARCTICA:
				case NORTH_AMERICA:
				case SOUTH_AMERICA:
					_code = ccode;
					break;
				default:
					throw new Error('Unknown contintent code: ' + ccode);
			}
		}
		
		public function get code():String { return _code; }
		
		public function set code(value:String):void 
		{
			_code = value;
		}
		
		public function get countries():Array { return _countries; }
		
		public function addCountry(c:Country):void
		{
			_countries.push(c);
		}
	}
	
}