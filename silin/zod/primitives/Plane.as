/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.primitives
{

	import flash.display.*;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;
	
	/**
	 * двухсторонняя плоскость<br/>
	 * @author silin
	 */
	public class Plane extends PolyhedronModel
	{

		private var _width:Number;
		private var _height:Number;

		/**
		 *
		 * @param	material	материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	width		ширина, по умолчанию  для ListMaterial - ширина объекта
		 * @param	height		высота, по умолчанию  для ListMaterial - высота объекта
		 */
		public function Plane(material:Material, width:int = 0, height:int = 0)
		{
			super(material);
			_width = width;
			_height = height;
			createFaces();
			update();

		}
		private function createFaces():void
		{

			var w:Number = _width / 2;
			var h:Number = _height / 2;

			var uvData:Vector.<Number>;
			var vertices:Vector.<Number> = Vector.<Number>([ -w, -h, -w, h, w, h, w, -h]);
			var indices:Vector.<int> = Vector.<int>([0, 1, 2, 0, 2, 3]);

			for (var i:int = 0; i < 2; i++)
			{

				var u0:Number = i / 2;
				var u1:Number = (i + 1) / 2;
				var v0:Number = 0;
				var v1:Number = 1;
				uvData = Vector.<Number>([u0, v0, u0, v1, u1, v1, u1, v0]);

				var mtrx:Matrix3D = new Matrix3D();
				if (i == 1) mtrx.appendRotation(180, Vector3D.Y_AXIS);
				createPolygonFace(vertices, indices, uvData, mtrx);

			}

		}

	}

}

