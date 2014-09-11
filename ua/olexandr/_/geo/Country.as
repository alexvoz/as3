package ua.olexandr._.geo 
{
	import flash.geom.Rectangle;
	import net.vis4.geom.Polygon;
	
	/**
	 * ...
	 * @author gka
	 */
	public class Country 
	{
		private var _name:String;
		private var _continent:Continent;
		private var _code2:String;
		private var _code3:String;
		private var _num:String;
		private var _shapes:Array;
		
		public function Country(name:String, continent:Continent, code2:String = '', code3:String = '', num:String = '', shapes:Array = null) 
		{
			_name = name;
			_continent = continent;
			continent.addCountry(this);
			_code2 = code2;
			_code3 = code3;
			_num = num;
			_shapes = shapes != null ? shapes : [];
		}
		

				
		public function get name():String { return _name; }
		
		public function get continent():Continent { return _continent; }
		
		public function get code2():String { return _code2; }
		
		public function get code3():String { return _code3; }
		
		public function get num():String { return _num; }
		
		public function get shapes():Array { return _shapes; }
		
		public function set shapes(value:Array):void 
		{
			_shapes = value;
		}
		
	}
	
}