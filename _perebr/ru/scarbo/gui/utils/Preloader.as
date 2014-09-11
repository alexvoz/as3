package ru.scarbo.gui.utils 
{
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.text.engine.BreakOpportunity;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ru.scarbo.gui.core.BasicContainer;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Preloader extends BasicContainer 
	{
		public static const DEFAULT_COLOR:uint = 0x66AAFF;
		
		public var label:String = '';
		
		private var _background:PreloaderBackground;
		private var _spinner:Spinner;
		private var _text:TextField;
		private var _format:TextFormat;
		
		public function Preloader() 
		{
			super();
		}
		
		public function start():void {
			this._spinner.start();
			this.visible = true;
			this.changed = true;
		}
		public function stop():void {
			this._spinner.stop();
			this.visible = false;
			this.changed = true;
		}
		
		override protected function _createChildren():void {
			this._background = new PreloaderBackground(0xffffff, .6, 0xdddddd, 6);
			this.addChild(this._background);
			this._spinner = new Spinner();
			this._spinner.colorTick = DEFAULT_COLOR;
			this._spinner.visible = false;
			this._spinner.addEventListener(TimerEvent.TIMER, _timerChangeHandler);
			this.addChild(this._spinner);
			this._format = new TextFormat('_sans', 12, DEFAULT_COLOR, true);
			this._text = new TextField();
			this._text.mouseEnabled = false;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.defaultTextFormat = this._format;
			this.addChild(this._text);
			//
			this.setSize(120, 120);
		}
		
		override protected function _destroy():void {
			this._spinner.removeEventListener(TimerEvent.TIMER, _timerChangeHandler);
			//
			super._destroy();
		}
		
		override protected function _draw():void {
			this._background.setSize(this._width, this._height);
			this._spinner.x = (this._width - this._spinner.width) / 2;
			this._spinner.y = (this._height - this._spinner.height) / 2;
			this._text.x = (this._width - this._text.width) / 2;
			this._text.y = (this._height - this._text.height) / 2;
			//
			super._draw();
		}
		
		private function _timerChangeHandler(e:TimerEvent):void {
			this._text.text = this.label;
			this._text.x = (this._width - this._text.width) / 2;
			this._text.y = (this._height - this._text.height) / 2;
		}
	}

}

import ru.scarbo.gui.core.BasicMask;

class PreloaderBackground extends BasicMask
{
	private var _ellipse:uint;
	private var _border:uint;
	
	public function PreloaderBackground(color:uint, alpha:Number, border:uint, ellipse:uint)
	{
		this._ellipse = ellipse;
		this._border = border;
		super(color, alpha);
	}
	
	override protected function _draw(width:uint, height:uint):void {
		this._graphics.clear();
		this._graphics.lineStyle(.5, this._border);
		this._graphics.beginFill(this._color, this._alpha);
		this._graphics.drawRoundRect(0, 0, width, height, this._ellipse);
		this._graphics.endFill();
	}
}