package ua.olexandr._.geo.db 
{
	import flash.display.Sprite;
	import net.vis4.geo.db.MapData;
	/**
	 * ...
	 * @author gka
	 */
	public class EmbeddedMapData extends Sprite
	{
		public var mapData:String;
		
		public function EmbeddedMapData() 
		{
			// jjkk
			mapData = new MapData().toString();
		}
		
	}

}