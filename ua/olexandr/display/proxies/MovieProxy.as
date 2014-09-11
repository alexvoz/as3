package ua.olexandr.display.proxies {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ua.olexandr.events.FrameEvent;
	/**
	 * ...
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	[Event(name="complete", type="ua.olexandr.events.FrameEvent")]
	[Event(name="change", type="ua.olexandr.events.FrameEvent")]
	public class MovieProxy extends DisplayProxy {
		
		private var _playing:Boolean;
		private var _repeat:Boolean;
		private var _reverse:Boolean;
		
		/**
		 * Contructor
		 * @param	target
		 * @param	frame
		 */
		public function MovieProxy(target:MovieClip, frame:int = 1) {
			super(target);
			
			_playing = false;
			_repeat = false;
			_reverse = false;
			
			gotoFrame(frame);
		}
		
		/**
		 * Начать проигрывание
		 */
		public function play():MovieProxy {
			if (!_playing) {
				_playing = true;
				movieClip.addEventListener(Event.ENTER_FRAME, efHandler);
			}
			
			return this;
		}
		
		/**
		 * Остановить проигрывание
		 */
		public function stop():MovieProxy {
			if (_playing) {
				_playing = false;
				movieClip.removeEventListener(Event.ENTER_FRAME, efHandler);
			}
			
			return this;
		}
		
		/**
		 * Оставить проигрывание и перейти на первый кадр
		 */
		public function reset():MovieProxy {
			stop();
			return gotoFrame(1);
		}
		
		/**
		 * Перейти к метке
		 * @param	label
		 */
		public function gotoLabel(label:String):MovieProxy {
			stop();
			
			movieClip.gotoAndStop(label);
			dispatchEvents();
			
			return this;
		}
		
		/**
		 * Перейти к кадру
		 * @param	frame
		 */
		public function gotoFrame(frame:int):MovieProxy {
			stop();
			
			movieClip.gotoAndStop(frame);
			dispatchEvents();
			
			return this;
		}
		
		/**
		 * Перейти к предыдущему кадру
		 */
		public function gotoPrevFrame():MovieProxy { 
			return gotoFrame(currentFrame - 1);
		}
		/**
		 * Перейти к следующему кадру
		 */
		public function gotoNextFrame():MovieProxy { 
			return gotoFrame(currentFrame + 1);
		}
		
		/**
		 * Перейти к первому кадру
		 */
		public function gotoFirstFrame():MovieProxy { 
			return gotoFrame(1);
		}
		/**
		 * Перейти к последнему кадру
		 */
		public function gotoLastFrame():MovieProxy { 
			return gotoFrame(totalFrames);
		}
		
		/**
		 * Проигрывается ли в текущий момент
		 * @return
		 */
		public function isPlaying():Boolean { return _playing; }
		
		
		/**
		 * Текущий кадр
		 */
		public function get currentFrame():int { return movieClip.currentFrame; }
		/**
		 * Количество кадров
		 */
		public function get totalFrames():int { return movieClip.totalFrames; }
		
		/**
		 * Отношение текущего кадра к общему количеству
		 */
		public function get ratio():Number {
			return (currentFrame - 1) / (totalFrames - 1);
		}
		/**
		 * Отношение текущего кадра к общему количеству
		 */
		public function set ratio(value:Number):void {
			movieClip.gotoAndStop(value * (totalFrames - 1) + 1);
			dispatchEvents();
		}
		
		/**
		 * Повторение проигрывания
		 */
		public function get repeat():Boolean { return _repeat; }
		/**
		 * Повторение проигрывания
		 */
		public function set repeat(value:Boolean):void { _repeat = value; }
		
		/**
		 * Проигрывание в обратную сторону
		 */
		public function get reverse():Boolean { return _reverse; }
		/**
		 * Проигрывание в обратную сторону
		 */
		public function set reverse(value:Boolean):void { _reverse = value; }
		
		
		private function efHandler(e:Event):void {
			var _last:int = _reverse ? 1 : totalFrames;
			var _first:int = _reverse ? totalFrames : 1;
			var _next:int = currentFrame + (_reverse ? -1 : 1);
			
			if (currentFrame == _last) 	movieClip.gotoAndStop(_first);
			else						movieClip.gotoAndStop(_next);
			
			dispatchEvents();
			
			if (currentFrame == _last) {
				if (!_repeat)
					stop();
			}
		}
		
		private function dispatchEvents():void {
			if (movieClip.currentFrameLabel)
				dispatchEvent(new Event(movieClip.currentFrameLabel));
			
			dispatchEvent(new FrameEvent(FrameEvent.CHANGE, currentFrame));
			
			if (currentFrame == totalFrames)
				dispatchEvent(new FrameEvent(FrameEvent.COMPLETE));
		}
		
	}

}