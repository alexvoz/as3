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
	 * паралепипед из дисплейОбжектов
	 * @author silin
	 */
	public class ObjBox extends DisplayobjectModel
	{
		public var objects:Array = [];
		/**
		 * 
		 * @param	size 	габариты
		 * @param	front	стороны
		 * @param	right
		 * @param	back
		 * @param	left
		 * @param	top
		 * @param	bottom
		 */
		public function ObjBox(size:Vector3D, 
					front:DisplayObject = null, right:DisplayObject = null,	back:DisplayObject = null, 
					left:DisplayObject = null, bottom:DisplayObject = null, top:DisplayObject = null) 
		{
			var sX:Number = size.x / 2;
			var sY:Number = size.y / 2;
			var sZ:Number = size.z / 2;
			
			
			var matrices:Array = [];
			var mtrx:Matrix3D;
			if (front)
			{
				mtrx = new Matrix3D();
				mtrx.appendTranslation(0, 0, -sY);
				objects.push(front);
				matrices.push(mtrx);
			}
			if (right)
			{
				mtrx = new Matrix3D();
				mtrx.appendRotation( -90, Vector3D.Y_AXIS);
				mtrx.appendTranslation(sX, 0, 0);
				objects.push(right);
				matrices.push(mtrx);
			}
			if (back)
			{
				mtrx = new Matrix3D();
				mtrx.appendTranslation(0, 0, -sY);
				mtrx.appendRotation(180, Vector3D.Y_AXIS);
				objects.push(back);
				matrices.push(mtrx);
			}
			if (left)
			{
				mtrx = new Matrix3D();
				mtrx.appendRotation(90, Vector3D.Y_AXIS);
				mtrx.appendTranslation( -sX, 0, 0);
				objects.push(left);
				matrices.push(mtrx);
			}
			if (top)
			{
				mtrx = new Matrix3D();
				mtrx.appendRotation(-90, Vector3D.X_AXIS);
				mtrx.appendTranslation(0, -sZ, 0);
				objects.push(top);
				matrices.push(mtrx);
			}
			if (bottom)
			{
				mtrx = new Matrix3D();
				mtrx.appendRotation( 90, Vector3D.X_AXIS);
				mtrx.appendTranslation(0, sZ, 0);
				objects.push(bottom);
				matrices.push(mtrx);
			}
			
			super(objects, matrices);
		}
		
		
		
	}

}