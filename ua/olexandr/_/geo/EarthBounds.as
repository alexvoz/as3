package ua.olexandr._.geo 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.vis4.geo.MapCoordinate;
	import net.vis4.geo.projection.MapProjection;
	import net.vis4.geo.projection.PlateCarreeProjection;
	
	/**
	 * ...
	 * @author gka
	 */
	public class EarthBounds extends Rectangle
	{
		
		public function EarthBounds(scale:Number = 10000) 
		{
			var mp:MapProjection = new PlateCarreeProjection(scale);
			var tl:Point = mp.coord2point(new MapCoordinate( 90, -180));
		
			var br:Point = mp.coord2point(new MapCoordinate( -90, 180));
			
			super(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
			trace(this);
		}
		
	}
	
}