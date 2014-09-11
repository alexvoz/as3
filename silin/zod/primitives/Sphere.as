/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.primitives
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import silin.zod.core.*;
	import silin.zod.materials.*;


	/**
	 * сфера<br/>
	 * DrawableMaterial трактуется как меркаторская (цилиндрическая) проекция сферы<br/>
	 * число разбиений определяется числом паралелей (без учета полюсов), число меридан в два раза больше<br/>
	 *
	 * @author silin
	 */
	public class Sphere extends PolyhedronModel
	{

		private var _latitudes:int;//паралели
		private var _longitudes:int;//меридианы
		private var _radius:Number;

		/**
		 *
		 * @param	material		материал (DrawableMaterial, ColorMaterial, TextureMaterial)
		 * @param	radius			радиус
		 * @param	latitudes		число горизонтальных разбиений (не считая полюсов)
		 */
		public function Sphere(material:Material, radius:Number, latitudes:int = 16, longitudes:int = 32 )
		{
			super(material);

			_latitudes = latitudes;
			_longitudes = longitudes;
			_radius = radius;

			createFaces();
			
			
			update();
		}

		private function createFaces():void
		{

			var face:Face;
			var uvData:Vector.<Number>;
			var vertices:Vector.<Number>;
			var indices:Vector.<int>=null;

			var dV:Number = Math.PI / (_longitudes);//половина дуги сегмента  паралели (XZ)
			var dU:Number = Math.PI / (_latitudes + 1) / 2;//половина дуги меридианального сегмента

			var kU:Number = 1 / (_latitudes + 1);//норимализованная высота сегмента(_latitudes+две пловинки на полюсах)
			var kV:Number = 1 / _longitudes;//нормализованная ширина

			for (var i:int = 0; i < _latitudes + 2; i++) //плюс два полюса
			{
				//наклон к XZ
				var u:Number = -Math.PI / 2 + Math.PI * i / (_latitudes + 1);

				for (var j:int = 0; j < _longitudes; j++)
				{
					//угол в XZ
					var v:Number = 2 * Math.PI * j / (_longitudes);

					//пиксельные размеры трапеции
					var tW:Number = Math.ceil(_radius * Math.cos(u - dU) * Math.tan(dV));//половин вехнего основания трапеции
					var bW:Number = Math.ceil(_radius * Math.cos(u + dU) * Math.tan(dV));//половин нижнего основания трапеции
					var h:Number =  Math.ceil(_radius * Math.sin(dU));//половина высоты трапеции

					//нормализованные координаты фрагмента в источнике
					var u0:Number = j * kV;
					var u1:Number = (j + 1) * kV;
					var v0:Number = (i - 0.5) * kU;
					var v1:Number = (i + 0.5) * kU;

					//координатная система перевернута
					if (i ==0)//северный полюс (на полюсах bW=tW)
					{
						//треуголник вершиной вверх
						uvData = Vector.<Number>([0.5, 0, u0, v1, u1, v1]);
						vertices = Vector.<Number>([ 0, 0, bW, -h, -bW, -h]);

					}else if (i < _latitudes+1)//трапеция
					{
						uvData = Vector.<Number>([u0, v0, u0, v1, u1, v1, u1, v0]);
						vertices = Vector.<Number>([tW, h, bW, -h, -bW, -h, -tW, h ]);
						indices = Vector.<int>([0, 1, 2, 0, 2, 3]);

					}else//южный полюс
					{
						//треугольник вершиной вниз
						uvData = Vector.<Number>([0.5, 1, u1, 1 - 0.5 * kU, u0, 1 - 0.5 * kU]);
						vertices = Vector.<Number>([ 0, 0, -tW, h, tW, h]);

					}

					var mtrx:Matrix3D = new Matrix3D();

					mtrx.appendRotation(180 - 180 / Math.PI * u, Vector3D.X_AXIS);
					mtrx.appendRotation(90 - 180 / Math.PI * v, Vector3D.Y_AXIS);

					var r:Number = _radius * Math.cos(dU);//расстояние до хорды
					mtrx.position = new Vector3D(r * Math.cos(u) * Math.cos(v), r * Math.sin(u), r * Math.cos(u) * Math.sin(v));

					createPolygonFace(vertices, indices, uvData, mtrx);

				}
			}

		}

		public function get radius():Number { return _radius; }

	}

}

