package ru.scarbo.gui.containers 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import ru.cartoonizer.data.UserData;
	import ru.cartoonizer.ImageBox;
	import ru.cartoonizer.StateManager;
	import ru.cartoonizer.states.State;
	import ru.cartoonizer.states.State1;
	import ru.cartoonizer.states.State2;
	import ru.cartoonizer.states.State3;
	import ru.scarbo.gui.core.BasicContainer;
	import ru.scarbo.gui.core.BasicSprite;
	import ru.scarbo.gui.managers.PopUpManager;
	
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Application extends BasicContainer
	{
		public var confXML:XML;
		private static var _application:Application;
		private var _stateManager:StateManager;
		private var _topSprite:BasicSprite;
		private var _userData:UserData;
		
		public static function get application():Application {
			if (!Application._application) Application._application = new Application(new ASingleton());
			return Application._application;
		}
		
		public function Application(singleton:ASingleton = null) 
		{
			if (!singleton) throw new IllegalOperationError('');
		}
		
		public function init():void {
			this._state1Init();
		}
		
		override protected function _init():void {
			this._stateManager = new StateManager(['State1', 'State2', 'State3' ]);
			this._topSprite = new BasicSprite();
			this.addRawChild(this._topSprite);
			PopUpManager.init(this._topSprite);
			
			this._userData = new UserData();
			
			//
			super._init();
		}
		
		override protected function _draw():void {
			this._topSprite.setSize(this._width, this._height);
		}
		
		/****STATE 1****/
		private function _state1Init():void {
			var state:State1 = new State1();
			state.libSprite = this._stateManager.nextState();
			state.userData = this._userData;
			state.addEventListener('CHANGE_MAN', this._changeManHandler);
			state.addEventListener('CHANGE_WOMAN', this._changeWomanHandler);
			this._stateChange(state);
			
			ExternalInterface.call('goalCompleteHandler', 'STATE_1');
		}
		private function _changeManHandler(e:Event):void {
			var state:State = e.target as State;
			state.removeEventListener('CHANGE_MAN', this._changeManHandler);
			state.removeEventListener('CHANGE_WOMAN', this._changeWomanHandler);
			//
			this._state2Init(Main.MAN_PATH);
		}
		private function _changeWomanHandler(e:Event):void {
			var state:State = e.target as State;
			state.removeEventListener('CHANGE_MAN', this._changeManHandler);
			state.removeEventListener('CHANGE_WOMAN', this._changeWomanHandler);
			//
			this._state2Init(Main.WOMAN_PATH);
		}
		
		/****STATE 2****/
		private function _state2Init(typeUrl:String):void {
			var state:State2 = new State2();
			State2(state).typeUrl = typeUrl;
			state.libSprite = this._stateManager.nextState();
			state.userData = this._userData;
			state.addEventListener('COMPLETE', this._completeHandler);
			this._stateChange(state);
			
			ExternalInterface.call('goalCompleteHandler', 'STATE_2');
		}
		private function _completeHandler(e:Event):void {
			var state:State = e.target as State;
			state.removeEventListener('COMPLETE', this._completeHandler);
			//
			this._state3Init(State2(state).image);
		}
		
		/****STATE 3****/
		private function _state3Init(image:ImageBox):void {
			var state:State3 = new State3();
			State3(state).image = image;
			state.libSprite = this._stateManager.nextState();
			state.userData = this._userData;
			this._stateChange(state);
			
			ExternalInterface.call('goalCompleteHandler', 'STATE_3');
		}
		
		private function _stateChange(state:State):void {
			this.removeAllChildren();
			this.addChild(state);
		}
	}

}

class ASingleton { }