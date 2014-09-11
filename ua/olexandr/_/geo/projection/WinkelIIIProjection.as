package ua.olexandr._.geo.projection 
{
	import ua.olexandr._.geo.MapCoordinate;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author gka
	 */
	public class WinkelIIIProjection extends MapProjection
	{
		
		public function WinkelIIIProjection(scale:Number =10000) {
			super(scale);
		}
	
		public override function coord2point(c:MapCoordinate):Point 
		{
			var lat:Number = c.lat * Math.PI / -180;
			var lng:Number = c.lng * Math.PI / 180;
			
			var alpha:Number = Math.acos(Math.cos(lat) * Math.cos(lng / 2));
			
			if (lat == 0 && lng == 0) return new Point(0, 0);
			
			return new Point(
				0.5 * (lng * Math.cos(15* Math.PI / -180) + ((2 * Math.cos(lat) * Math.sin(lng / 2)) / sinc(alpha))) * _scale,
				0.5 * (lat + Math.sin(lat) / sinc(alpha)) * _scale
			);
		}
		
	}
	
}