package ru.scarbo.gui.core 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicMask extends Sprite implements IBasic
	{
		protected var _color:uint;
		protected var _alpha:Number;
		protected var _graphics:Graphics;
		
		public function BasicMask(color:uint = 0, alpha:Number = 0) 
		{
			this._color = color;
			this._alpha = alpha;
			this._graphics = this.graphics;
			//
			super();
		}
		
		public function setSize(width:int, height:int):void {
			this._draw(width, height);
		}

		protected function _draw(width:uint, height:uint):void {
			this._graphics.clear();
			this._graphics.beginFill(this._color, this._alpha);
			this._graphics.drawRect(0, 0, width, height);
			this._graphics.endFill();
		}
	}

}