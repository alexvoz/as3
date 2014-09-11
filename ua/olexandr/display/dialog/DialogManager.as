package ua.olexandr.display.dialog {
	import flash.display.Stage;
	import flash.events.Event;
	import ua.olexandr.display.Box;
	
	public class DialogManager {
		
		private static var _stage:Stage;
		private static var _dialogs:Array;
		private static var _back:Box;
		
		private static var _dialog:Dialog;
		
		/**
		 * 
		 * @param	stage
		 */
		public static function init(stage:Stage):void {
			_stage = stage;
			_dialogs = [];
			_back = new Box(0x000000, .3);
		}
		
		
		/**
		 * 
		 * @param	dialog
		 */
		public static function add(dialog:Dialog):void {
			if (_stage) {
				_dialogs.push(dialog);
				show();
			} else {
				throw new Error("DialogManager necessary to be inited before add dialogs");
			}
		}
		
		/**
		 * 
		 */
		public static function remove():void {
			if (_dialog) {
				_stage.removeChild(_dialog);
				_dialog.removeEventListener(Event.SELECT, buttonSelectHandler);
				_dialog = null;
				
				_stage.removeChild(_back);
				
				_stage.removeEventListener(Event.RESIZE, resizeHandler);
			}
			
			show();
		}
		
		/**
		 * 
		 */
		public static function removeAll():void {
			_dialogs = [];
			remove();
		}
		
		
		private static function show():void {
			if (!_dialog && _dialogs.length) {
				_stage.addChild(_back);
				
				_dialog = _dialogs.splice(0, 1)[0];
				_dialog.addEventListener(Event.SELECT, buttonSelectHandler);
				
				_stage.addChild(_dialog);
				
				_stage.addEventListener(Event.RESIZE, resizeHandler);
				resizeHandler(null);
			}
		}
		
		private static function buttonSelectHandler(e:Event):void {
			remove();
		}
		
		private static function resizeHandler(e:Event):void {
			_back.setSize(_stage.stageWidth, _stage.stageHeight);
			
			_dialog.x = _stage.stageWidth - _dialog.width >> 1;
			_dialog.y = _stage.stageHeight - _dialog.height >> 1;
		}
		
	}
}