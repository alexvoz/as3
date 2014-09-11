/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.zod.primitives
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import silin.zod.core.DisplayobjectModel;
	
	/**
	 * плоскость из дисплейОбжектов
	 * @author silin
	 */
	public class ObjPlane extends DisplayobjectModel
	{
		/**
		 * 
		 * @param	face		объект для лицевой стороны
		 * @param	back		объект для обратной строны
		 * @param	center		надо ли центрировать объекты
		 */
		public function ObjPlane(face:DisplayObject = null, back:DisplayObject = null) 
		{
			var objects:Array = [];
			var matrices:Array = [];
			var mtrx:Matrix3D;
			if (face)
			{
				mtrx = new Matrix3D();
				objects.push(face);
				matrices.push(mtrx);
			}
			if (back)
			{
				mtrx = new Matrix3D();
				mtrx.appendRotation(180, Vector3D.Y_AXIS);
				objects.push(back);
				matrices.push(mtrx);
			}
			
			
			super(objects, matrices);
		}
		
	}

}