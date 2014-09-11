package ua.olexandr.display.preloaders {  
	import flash.display.Sprite;
	import flash.events.Event;
	import ua.olexandr.tools.tweener.Tweener;
	
	/**
	 * @author Olexandr Fedorow,
	 * @copy Copyright (c) 2014
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.3
	 */
	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	public class BasePreloader extends Sprite {
		
		protected var _progress:Number;
		protected var _animating:Boolean;
		protected var _holder:Sprite;
		
		private var _fading:Boolean;
		private var _hasProgress:Boolean;
		
		/**
		 * Конструктор
		 */
		public function BasePreloader(hasProgress:Boolean) {
			_holder = new Sprite();
			addChild(_holder);
			
			_animating = false;
			fading = true;
			
			_hasProgress = hasProgress;
			if (_hasProgress)
				progress = 0;
			
			mouseChildren = false;
			mouseEnabled = false;
		}  
		
		/**
		 * Начать работу прелоадера
		 */
		final public function start():void {
			if (show())
				startIn();
		}
		
		/**
		 * Остановить работу прелоадера
		 */
		final public function stop():void {
			hide();
		}
		
		/**
		 * Поддерживается ли прогресс
		 */
		public function canProgress():Boolean {
			return _hasProgress;
		}
		
		/**
		 * Текущий прогресс
		 */
		final public function get progress():Number { 
			return _progress;
		}
		
		/**
		 * Текущий прогресс
		 */
		final public function set progress(value:Number):void {
			if (_progress != value) {
				_progress = value;
				update();
				
				dispatchEvent(new Event(Event.CHANGE));
				if (_progress == 1)
					dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Автоисчезание прелоадера в неактивном состоянии
		 */
		final public function get fading():Boolean {
			return _fading;
		}
		
		/**
		 * Автоисчезание прелоадера в неактивном состоянии
		 */
		final public function set fading(value:Boolean):void {
			_fading = value;
			_holder.alpha = (!_fading || _animating) ? 1 : 0;
		}
		
		
		override public function get width():Number { return 0; }
		override public function set width(value:Number):void { }
		
		override public function get height():Number { return 0; }
		override public function set height(value:Number):void { }
		
		
		private function show():Boolean {
			if (!_animating) {
				_animating = true;
				
				if (fading)
					Tweener.addTween(_holder, .3, { alpha:1 } );
				
				return true;
			}
			
			return false;
		}
		
		private function hide():void {
			if (_animating) {
				_animating = false;
				
				if (fading)		Tweener.addTween(_holder, .3, { alpha:0, onComplete:stopIn } );
				else			stopIn();
			}
		}
		
		
		/**
		 * Метод, вызываемый при старте работы
		 */
		protected function startIn():void {
			
		}
		
		/**
		 * Метод, вызываемый после остановки работы или исчезания
		 */
		protected function stopIn():void {
			
		}
		
		/**
		 * Метод, в котором обновляется значение прогресса
		 */
		protected function update():void {
			
		}
		
   }  
}  