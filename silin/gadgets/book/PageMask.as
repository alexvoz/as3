/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets.book   
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	/**
	 * шаблон для масок
	 * несет только метод отрисовки полигона по точкам из массива
	 */
	internal class PageMask extends Shape
	{
		
		public function PageMask() 
		{
			
		}
		/**
		 * рисует шейп по точкам в pointsArr
		 * @param	pointsArr
		 */
		internal function drawPoly(pointsArr:Array):void
		{
			
			graphics.clear();
			graphics.beginFill(0);
			graphics.moveTo(pointsArr[pointsArr.length - 1].x, pointsArr[pointsArr.length - 1].y);
			for (var i:int = 0; i < pointsArr.length; i++) {
				graphics.lineTo(pointsArr[i].x, pointsArr[i].y);
			}
			
			graphics.endFill();
		}
		
		internal function clear():void
		{
			graphics.clear();
		}
	}
	
}