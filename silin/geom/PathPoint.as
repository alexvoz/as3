/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.geom
{
	
	/**
	 * точка кривой Безье(координаты+rotation)
	 * @author silin
	 */
	public class PathPoint
	{
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		/**
		 * constructor
		 * @param	x
		 * @param	y
		 * @param	rotation
		 */
		public function PathPoint(x:Number, y:Number, rotation:Number=0) 
		{
			this.rotation = rotation;
			this.x = x;
			this.y = y;
		}
		
	}
	
}