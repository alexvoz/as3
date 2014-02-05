package ua.alexvoz.display {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/**
	 * ...
	 * @author ALeXVoz 
	 * http://alexvoz.net/
	 * E-mail: alexvoz@mail.ru
	 * ICQ: 232-8-393-12
	 * Skype: alexvozn
	 */
	
	public class Scroll extends Sprite {
		private var _skin:InteractiveObject;
		private var _content:InteractiveObject;
		private var _height:Number = 150;
		private var _deltaYDrag:Number = 0;
		private var _dragStartPos:Number = 0;
		private var _contY:Number;
		private var _step:Number = .1;
		private var _deltaY:Number;
		private var _viewHeight:Number;
		private var _indentY:Number;
		private var _timer:uint;
		
		public function Scroll(content:InteractiveObject, skin:InteractiveObject) {
			_skin = skin;
			addChild(_skin);
			_content = content;
			initScroll();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height(value:Number):void {
			_height = value;
			if (isNaN(_viewHeight)) _viewHeight = value;
			setSizePos();
		}
		
		public function get content():InteractiveObject {
			return _content;
		}

		public function set content(value:InteractiveObject):void {
			_content = value;
		}
		
		public function get viewHeight():Number {
			return _viewHeight;
		}
		
		public function set viewHeight(value:Number):void {
			_viewHeight = value;
			setSizePos();
		}
		
		public function get indentY():Number {
			return _indentY;
		}
		
		public function set indentY(value:Number):void {
			_indentY = value;
			setSizePos();
		}
		
		override public function get y():Number {
			return super.y;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			if (isNaN(_indentY)) _indentY = value;
			setSizePos();
		}
		
		public function get step():Number {
			return _step;
		}
		
		public function set step(value:Number):void {
			_step = value;
		}
		
		private function initScroll(e:Event = null):void {
			setSizePos();
			setParam();
		}
		
		private function setSizePos():void {
			_skin.bg.height = _height;
			_skin.up.x = _skin.up.width / 2;
			_skin.up.y = _skin.up.height / 2;
			_skin.down.x = _skin.down.width/2;
			_skin.down.y = _skin.bg.height - _skin.down.height / 2;
			_deltaYDrag = _skin.bg.height - _skin.up.height - _skin.down.height;
			_dragStartPos = _skin.up.height;
			_deltaY = _content.height - _viewHeight;
			_contY = Math.abs(_indentY - _content.y);
			_skin.dragger.height = _viewHeight / _content.height * _deltaYDrag;
			updatePosDragger();
		}
		
		private function setParam():void {
			_skin.up.mouseChildren = false;
			_skin.up.buttonMode = true;
			_skin.up.addEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
			_skin.up.addEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
			_skin.up.addEventListener(MouseEvent.MOUSE_DOWN, upDownHandler);
			
			_skin.down.mouseChildren = false;
			_skin.down.buttonMode = true;
			_skin.down.addEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
			_skin.down.addEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
			_skin.down.addEventListener(MouseEvent.MOUSE_DOWN, downDownHandler);
			
			_skin.dragger.mouseChildren = false;
			_skin.dragger.buttonMode = true;
			_skin.dragger.addEventListener(MouseEvent.MOUSE_OVER, navOverHandler);
			_skin.dragger.addEventListener(MouseEvent.MOUSE_OUT, navOutHandler);
			_skin.dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDownHandler);
			
			_skin.bg.mouseChildren = false;
			_skin.bg.addEventListener(MouseEvent.CLICK, bgClickHandler);
			
			_skin.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			if (_content is InteractiveObject) (_content as InteractiveObject).addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		private function navOverHandler(e:MouseEvent = null):void {
			var _mc:MovieClip = e.target as MovieClip;
			_mc.gotoAndPlay('over');
		}
		
		private function navOutHandler(e:MouseEvent = null):void {
			var _mc:MovieClip = e.target as MovieClip;
			_mc.gotoAndPlay('out');
		}
		
		private function upDownHandler(e:MouseEvent = null):void {
			upClick(false);
			_timer = setTimeout(upClick, 500);
			stage.addEventListener(MouseEvent.MOUSE_UP, upUpHandler);
		}
		
		private function upUpHandler(e:MouseEvent = null):void {
			clearTimeout(_timer);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upUpHandler);
		}
		
		private function upClick(fl:Boolean = true):void {
			_contY = Math.max(0, _contY - _deltaY * _step)
			updatePosContent();
			updatePosDragger();
			if (fl) _timer = setTimeout(upClick, 80);
		}
		
		private function downDownHandler(e:MouseEvent = null):void {
			downClick(false);
			_timer = setTimeout(downClick, 500);
			stage.addEventListener(MouseEvent.MOUSE_UP, downUpHandler);
		}
		
		private function downUpHandler(e:MouseEvent = null):void {
			clearTimeout(_timer);
			stage.removeEventListener(MouseEvent.MOUSE_UP, downUpHandler);
		}
		
		private function downClick(fl:Boolean = true):void {
			_contY = Math.min(_deltaY, _contY + _deltaY * _step);
			updatePosContent();
			updatePosDragger();
			if (fl) _timer = setTimeout(downClick, 80);
		}
		
		private function draggerDownHandler(e:MouseEvent = null):void {
			var _rect:Rectangle = new Rectangle(0, _dragStartPos, 0, _deltaYDrag - _skin.dragger.height); // !!! не понятно откуда этот баг
			_skin.dragger.startDrag(false, _rect);
			stage.addEventListener(MouseEvent.MOUSE_UP, draggerUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggerMoveHandler);
		}
		
		private function draggerUpHandler(e:MouseEvent = null):void {
			_skin.dragger.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, draggerUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggerMoveHandler);
		}
		
		private function bgClickHandler(e:MouseEvent = null):void {
			if (_skin.dragger.y + _skin.dragger.height / 2 > _skin.bg.mouseY * _skin.bg.scaleY) upClick(false)
				else downClick(false);
		}
		
		private function draggerMoveHandler(e:MouseEvent = null):void {
			_contY = (_skin.dragger.y - _dragStartPos) / _deltaYDrag * _content.height;
			updatePosContent();
		}
		
		private function wheelHandler(e:MouseEvent):void {
			if (e.delta > 0) upClick(false)
				else downClick(false);
		   
		}
		
		private function updatePosContent():void {
			_content.y = _indentY - _contY;
		}
		
		private function updatePosDragger():void {
			_skin.dragger.y = _dragStartPos + _deltaYDrag * (_contY / _content.height);
		}
		
	}

}