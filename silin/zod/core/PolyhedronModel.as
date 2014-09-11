/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import silin.zod.materials.*;
	import silin.zod.primitives.*;

	/**
	 * базовый класс для моделей, состоящих из рисуемых спрайтов-граней <br/>
	 * поддерживаемые материалы: DrawableMaterial, TextureMaterial, ColorMaterial
	 *
	 * @author silin
	 */

	public class PolyhedronModel extends Container3D
	{

		private var _material:Material;
		protected var _faces:Vector.<Face> = new Vector.<Face>();//массив граней
		private var _source:IBitmapDrawable;//источник картинки
		private var _animated:Boolean = false;//приват флага перерисовки по ENTER_FRAME

		/**
		 * constructor
		 * @param	material	материал отрисовки
		 */
		public function PolyhedronModel(material:Material)
		{
			super();
			//mouseChildren = false;
			_material = material||new DefaultMaterial();
			//проверки на валидность материала в наследниках, если негожий материал, то грани просто не создаем

		}
		/**
		 * отписка/удаление, сейчас не используется нигде 
		 */
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, render);
			while (numChildren) removeChildAt(0);
			_faces = null;
			_material = null;
		}

		public function createPolygonFace(vertices:Vector.<Number>, indices:Vector.<int>, uvData:Vector.<Number>, faceMatrix:Matrix3D ):void
		{

			var i:int;
			var face:Face = new Face(_material, vertices, indices, uvData);

			//коррекция типа видимости граней, завернутых не в ту сторону
			var dir:Number = (vertices[2] - vertices[0]) * (vertices[5] - vertices[3]) - (vertices[3] - vertices[1]) * (vertices[4] - vertices[2]);

			face.inside = dir > 0 ? !_inside : _inside;

			face.transform.matrix3D = faceMatrix;

			//добавляем в дисплейлист и список отрисовки
			addFace(face);

		}

		/**
		 * добавляет face в дисплей лист и в массив данных для отрисовки, <br/>
		 * структура модели должна быть одноуровневой: все грани - непосредственные дети
		 * @param	face
		 */
		public function addFace(face:Face):void
		{
			_faces.push(face);
			if(face is DisplayObject) addChild(face as DisplayObject);
		}

		/**
		 * перерисовывает контент
		 */
		public function update():void
		{
			render();
		}

		//перерисовка источника в щейпы сегментов (по событию - только видимые грани, без аргумента- все)
		private function render(event:Event=null):void
		{
			var i:int;
			//если вызов по евенту, а модель не при делах, то не считаем ничего
			if (event && !stage)
			{
				return;
			}

			_material.update();

			for (i = 0; i < _faces.length; i++)
			{

				//рисуем если грань видима или event==null('ручной' вызов)
				//if (_faces[i].visible || !event)

				if (_faces[i].visible || !_animated)
				{
					_faces[i].update();
				}
			}
		}

		

		/**
		 * флаг перерисовки по ENTER_FRAME (добавляет/удаляет листенер)
		 */
		public function get animated():Boolean { return _animated; }
		public function set animated(value:Boolean):void
		{
			if (_animated != value)
			{
				_animated = value;
				_animated ? addEventListener(Event.ENTER_FRAME, render) : removeEventListener(Event.ENTER_FRAME, render);
				render();
			}
		}

		/**
		 * флаг сглаживания при отрисовке
		 */
		public function get smoothing():Boolean
		{
			return _material.smoothing;

		}
		public function set smoothing(value:Boolean):void
		{
			_material.smoothing = value;
			_material.update();
			this.update();
		}

		/**
		 * материал отрисовки
		 */
		public function get material():Material { return _material; }

		public function set material(value:Material):void
		{
			_material = value || new DefaultMaterial();
			for (var i:int = 0; i < _faces.length; i++)
			{
				_faces[i].material = _material;
			}
			update();
		}

		/**
		 * число граней
		 */
		public function get facesNum():int
		{
			return _faces.length;
		}

		/**
		 * грань, находящаяся в данный момент под курсором
		 */
		public function get faceUnderCursor():Face
		{
			if (!stage) return null;
			for (var i:int = 0; i < facesNum; i++)
			{
				if (_faces[i].visible && _faces[i].hitTestPoint(stage.mouseX, stage.mouseY, true))
				{
					return _faces[i];
				}
			}
			return null;
		}

		/**
		 * координаты  мыши в системе координат материала, </br>
		 * неточно и ненадежно, но в простейших случаях (тектура не искажена) работает
		 */
		public function get materialMousePoint():Point
		{
			var f:Face = faceUnderCursor;
			if (f)
			{
				var p:Point = f.materialPoint;
				var tX:Number = f.mouseX + p.x;
				var tY:Number = f.mouseY + p.y;
				if (tX < 0) tX = 0;
				if (tY < 0) tY = 0;
				if (tX > material.sourceRect.width) tX = material.sourceRect.width;
				if (tY > material.sourceRect.height) tY = material.sourceRect.height;
				return new Point(tX, tY);
			}
			return null;

		}
	}

}

