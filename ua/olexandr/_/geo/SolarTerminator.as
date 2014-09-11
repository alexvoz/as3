package net.vis4.geo 
{
	import net.vis4.utils.DateUtil;
	import net.vis4.utils.NumberUtil;
	
	/**
	 * ...
	 * @author gka
	 */
	public class SolarTerminator 
	{
		/**
		 * 
		 * @param	date
		 * @return	Array of MapCoordinates
		 */
		public static function getSolarTerminator(date:Date):Array
		{
			var h:Number, b:Number, l:Number, cs:Array, cp:uint, llng:Number, ph:Number, B:Number, x:Number,
				y:Number, L:Number, ll:MapCoordinate;
			
			const RNG:uint = 90;
			
			b = NumberUtil.deg2rad(23.45) * Math.sin((2*Math.PI / 365) * (DateUtil.dayOfYear(date)+284));
			h = (date.hoursUTC - 12) + date.minutesUTC / 60;
			l = NumberUtil.deg2rad(-15 * h);
			
			cs = []; 
			var rv:Boolean;
			for (ph = 0; ph < Math.PI*2; ph += NumberUtil.deg2rad(1)) {
				B = Math.asin(Math.cos(b) * Math.sin(ph));
				x = -Math.cos(l) * Math.sin(b) * Math.sin(ph) - Math.sin(l) * Math.cos(ph);
				y = -Math.sin(l) * Math.sin(b) * Math.sin(ph) + Math.cos(l) * Math.cos(ph);
				L = Math.atan2(y, x);
				ll = new MapCoordinate(NumberUtil.rad2deg(B), NumberUtil.rad2deg(L));
				
				if (cs.length > 0 
					&& ((ll.lng < -RNG && cs[cs.length - 1].lng > RNG) 
					 || (ll.lng > RNG && cs[cs.length - 1].lng < -RNG))) {
					rv = (ll.lng > RNG && cs[cs.length - 1].lng < -RNG);
					cp = cs.length-1;
				}
				cs.push(ll);
				//trace(ll.lng);
			}
			
			var rs:Array = [];
			rs = rs.concat(cs.slice(cp+1), cs.slice(0, cp));
			//cs = new Array().concat(cs.slice(cp), cs.slice(0, cp - 1));
			
			return rs;
		}
	}
	

	
}