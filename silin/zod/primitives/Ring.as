/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.primitives
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;

	/**
	 * кольцо<br/>
	 * DrawableMaterial трактуется как плоскость, сворачиваемая в обечайку
	 * @author silin
	 */
	public class Ring extends PolyhedronModel
	{
		private var _segmentHight:Number=0;//высота сегмента
		private var _segmentWight:Number = 0;//ширина сегмента
		private var _arc:Number;//угол дуги сегмента
		private var _radius:Number=0;//радиус
		private var _segmentsNum:int;//количество сегментов

		/**
		 * constructor
		 * @param	material			материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	radius				радиус
		 * @param	height				высота
		 * @param	segments			число сегментов
		 */
		public function Ring(material:Material, radius:Number, height:Number,  segments:int = 32)
		{
			super(material);

			_radius = radius;
			_segmentsNum = segments;

			_arc = 2 * Math.PI / _segmentsNum;
			_segmentWight = _radius * 2 * Math.tan(_arc / 2);
			_segmentHight = height;

			createFaces();
			update();
		}

		private function createFaces():void
		{

			var w:Number = Math.ceil(_segmentWight / 2);
			var h:Number = Math.ceil(_segmentHight / 2);

			var vertices:Vector.<Number> = Vector.<Number>([ -w, -h, -w, h,  w, h, w, -h]);//верешины в шейпе
			var indices:Vector.<int> = Vector.<int>([0, 1, 2, 0, 2, 3]);

			//Faces
			for (var i:int = 0; i < _segmentsNum; i++)
			{

				var u0:Number = i / _segmentsNum;
				var u1:Number = (i + 1) / _segmentsNum;
				var v0:Number = 0;
				var v1:Number = 1;

				var uvData:Vector.<Number> = Vector.<Number>([u0, v0, u0, v1, u1, v1, u1, v0]);

				var mtrx:Matrix3D = new Matrix3D();
				mtrx.position = new Vector3D(_radius * Math.cos(i * _arc), 0, _radius * Math.sin(i * _arc));
				mtrx.prependRotation( -i * 360 / _segmentsNum - 90, Vector3D.Y_AXIS);

				createPolygonFace(vertices, indices, uvData, mtrx);

			}

		}

		/**
		 * радиус
		 */
		public function get radius():Number { return _radius; }

	}

}

