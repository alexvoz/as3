/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets.book
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;

	/**
	 * темплет странички
	 */
	internal class PageTemplet extends Sprite
	{

		private var _paperBitmap:Bitmap = new Bitmap();
		private var _content:Sprite=new Sprite();
		private var _shape:Shape = new Shape();
		private var _page:int;
		private var _dataProvider:Array/*PageContent*/;
		private var _paper:BitmapData;

		/**
		 * constructor
		 */
		public function PageTemplet()
		{

			visible = false;
			addChild(_paperBitmap);
			addChild(_content);
			addChild(_shape);
			_content.cacheAsBitmap = true;
			mouseEnabled = false;
			//mouseChildren = false;
			_content.mouseEnabled = false;
		}

		
		//установка размеров
		internal function setSize(width:Number, height:Number):void
		{

			_content.y = -height;
			_paperBitmap.y = -height;
			_shape.y = -height;

			var mtrx:Matrix = new Matrix();
			mtrx.createGradientBox(width, height, 0, 0, 0);
			var colors:Array = [0, 0xFFFFFF, 0];
			var ratios:Array = [0x00, 0x66, 0xff];
			var alphas:Array = [0.05, 0.05, 0.05];
			_shape.graphics.clear();
			_shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mtrx);
			_shape.graphics.drawRect(0, 0, width, height);
			_shape.graphics.endFill();

		}

		
		//установка содержимого, соответсвущему num
		internal function setContent(num:int):void
		{
			_page = num;
			while (_content.numChildren) _content.removeChildAt(0);

			var data:PageContent = _dataProvider[num];
			visible = (data != null);
			if (data)
			{
				_content.addChild(data);

			}

		}
		
		//преобразование точки в координаты родителя (книги)
		internal function pointToParent(p:Point):Point
		{
			var gp:Point = localToGlobal(p);
			return parent.globalToLocal(gp);
		}

		///////////////////////////////////////////////////

		internal function get page():int { return _page; }
		//датапровайдер книги
		internal function get dataProvider():Array/*PageContent*/ { return _dataProvider; }
		internal function set dataProvider(value:Array/*PageContent*/):void
		{
			_dataProvider = value;
		}
		
		//шейп для отрисовки отблеска
		internal function get shade():Shape
		{
			return _shape;
		}
		
		internal function get paper():BitmapData { return _paper; }
		internal function set paper(value:BitmapData):void
		{

			_paper = value;
			_paperBitmap.bitmapData = _paper;
		}
		//////////////

	}

}
