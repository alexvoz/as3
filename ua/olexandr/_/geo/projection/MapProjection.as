package ua.olexandr._.geo.projection 
{
	import flash.geom.Point;
	import ua.olexandr._.geo.MapCoordinate;
	
	/**
	 * ...
	 * @author gka
	 */
	public class MapProjection 
	{
		protected var _scale:Number = 1;
		
		public function MapProjection(scale:Number = 1000) {
			_scale = scale;
		}
		
		public function coord2point(c:MapCoordinate):Point {
			return new Point(c.lng, c.lat);
		}
		
		public function sinc(x:Number):Number {
			return Math.sin(x) / x;
		}
		
		public function point2coord(p:Point):MapCoordinate
		{
			return new MapCoordinate(p.y, p.x);
		}
	}
	
}