/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.materials 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	/**
	 * заглушка из квадратиков (TextureMaterial)
	 * @author silin
	 */
	public class DefaultMaterial extends TextureMaterial
	{
		public static var SIZE:int = 28;
		
		public function DefaultMaterial() 
		{
			
			var size:Number = SIZE / 2;
			var alpha:Number = 1;
			var shape:Shape = new Shape();
			var clr1:uint = 0x808080;
			var clr2:uint = 0xC0C0C0;
			
			shape.graphics.beginFill(clr1,alpha);
			shape.graphics.drawRect(0, 0, size, size);
			shape.graphics.drawRect(size, size, size, size);
			shape.graphics.beginFill(clr2,alpha);
			shape.graphics.drawRect(size, 0, size, size);
			shape.graphics.drawRect(0, size, size, size);
			
			var bmd:BitmapData = new BitmapData(2 * size, 2 * size, true, 0x0);
			bmd.draw(shape);
			super(bmd);
			
			
		}
		
		
		
		
	}

}