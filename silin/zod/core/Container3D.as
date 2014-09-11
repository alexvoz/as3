/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.zod.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	

	/**
	 * контейнер для объектов Sprite3D, <br/>
	 * объекты других типов добавить можно, но они не будут учтены при сортировке и валидации<br/>
	 * @author silin
	 */
	public class Container3D extends Sprite3D
	{

		//приват флага сортировки в invalidate()
		private var _autoSorting:Boolean = false;

		/**
		 * constructor
		 */
		public function Container3D()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onStage);

		}

		//добавление в дисплейлист
		private function onStage(event:Event):void
		{
			invalidate();
		}

		/**
		 * валидация, заключается в валидации детей и сортировке для autoSorting=true
		 */
		override public function invalidate(): void
		{
			var i:int;
			var j:int;
			var len:int = 0;
			var sortArr:Vector.<Sprite3D> = new Vector.<Sprite3D>();
			var child:Sprite3D;
			

			if (!stage) return;
			//DEBUG
			//var t:int = getTimer();
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i) as Sprite3D;
				if (child)
				{
					child.invalidate();
					//сортируем только видимых
					if (_autoSorting && child.visible) 
					{
						child.sortVal = child.viewDistance;//viewDistance не годится для сортировки, ибо геттер со счетом внутри
						sortArr[len++] = child;
					}
				}
			}
			
			
			//var t:int = getTimer();
			if ( _autoSorting)
			{
				//				
				/*var indxArr:Array = valArr.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
				i = indxArr.length - 1;
				while(i--) addChild(Sprite3D(objArr[indxArr[i]]));*/
				
				
				/**
				 * вариант с самописной сортировкой вектора почти ничего не дает
				 * (основная нагрузка на addChild все равно)
				 * но при близкой пересортировке большого количества есть преимущество
				 */
				
				//сортировка
				var inc:int = int(len / 2 + 0.5);
				while (inc) 
				{
					for (i = inc; i < len; i++) 
					{
						var tmp:Sprite3D = sortArr[i];
						j = i;
						while (j >= inc && sortArr[j - inc].sortVal > tmp.sortVal) 
						{
							sortArr[j] = sortArr[j - inc];
							j = j - inc;
						}
						sortArr[j] = tmp;
					}
					inc = int(inc / 2.2 + 0.5);
				}
				//перерисовка
				while(len--) addChild(sortArr[len]);
				
			}
			//DEBUG
			//trace( "t : " + (getTimer() - t) );
		}
		
		/**
		 * флаг автосортировки (используется в invalidate), детям не раздаем
		 */
		public function get autoSorting():Boolean { return _autoSorting; }
		public function set autoSorting(value:Boolean):void
		{
			if (_autoSorting != value)
			{
				_autoSorting = value;
				invalidate();
			}
		}

		/**
		 *  степень затемнения, только раздача детям
		 */
		override public function get tintDepth():Number { return _tintDepth; }
		override public function set tintDepth(value:Number):void
		{
			if (_tintDepth != value)
			{
				_tintDepth = value;
				for (var i:int = 0; i < numChildren; i++) 
				{
					var obj:Sprite3D = getChildAt(i) as Sprite3D;
					if (obj) obj.tintDepth = value;
				}
			}
		}
		/**
		 * флаг изнанки, только раздача детям
		 */
		override public function get inside():Boolean { return _inside; }
		override public function set inside(value:Boolean):void
		{
			if (value != _inside)
			{
				for (var i:int = 0; i < numChildren; i++)
				{
					var obj:Sprite3D = getChildAt(i) as Sprite3D;
					if (obj) obj.inside = !obj.inside;

				}
				_inside = value;
			}
		}

	}

}

