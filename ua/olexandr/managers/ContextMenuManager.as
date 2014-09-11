package ua.olexandr.managers {
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class ContextMenuManager extends EventDispatcher {
		
		private var _menu:ContextMenu;
		private var _target:InteractiveObject;
		private var _hash:Dictionary;
		
		/**
		 * 
		 * @param	target
		 * @param	hideBuiltInItems
		 */
		public function ContextMenuManager(target:InteractiveObject, hideBuiltInItems:Boolean = true) {
			_target = target;
			_menu = new ContextMenu();

			if (hideBuiltInItems)
				_menu.hideBuiltInItems();
			
			_target.contextMenu = _menu;
			
			_hash = new Dictionary();
			
			//_menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
		}
		
		/**
		 * 
		 * @param	caption
		 * @param	handler
		 * @param	separatorBefore
		 * @param	enabled
		 * @param	visible
		 * @return
		 */
		public function add(caption:String, handler:Function, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):ContextMenuItem {
			var _result:ContextMenuItem = createItem(caption, handler, separatorBefore, enabled, visible);
			_menu.customItems.push(_result);
			return _result;
		}
		
		/**
		 * 
		 * @param	id
		 * @param	caption
		 * @param	handler
		 * @param	separatorBefore
		 * @param	enabled
		 * @param	visible
		 * @return
		 */
		public function insert(id:*, caption:String, handler:Function, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):ContextMenuItem {
			var _result:ContextMenuItem = createItem(caption, handler, separatorBefore, enabled, visible);
			var _index:int = id is String ? getIndexByCaption(id) : id as int;
			
			(_menu.customItems as Array).splice(_index, 0, _result);
			
			return _result;
		}
		
		/**
		 * 
		 * @param	id
		 */
		public function remove(id:*):void {
			if (id is String)
				id = getIndexByCaption(id);
			customItems.splice(id as Number, 1);
		}
		
		/**
		 * 
		 */
		public function hideBuiltInItems():void {
			_menu.hideBuiltInItems();
		}
		
		/**
		 * 
		 * @param	id
		 * @return
		 */
		public function getItem(id:*):ContextMenuItem {
			if (id is String)
				id = getIndexByCaption(id);
			return _menu.customItems[id];
		}
		
		/**
		 * 
		 */
		public function get customItems():Array {
			return _menu.customItems;
		}
		
		/**
		 * 
		 */
		public function get builtInItems():ContextMenuBuiltInItems {
			return _menu.builtInItems;
		}
		
		/**
		 * 
		 */
		public function get contextMenu():ContextMenu {
			return _menu;
		}
		
		
		private function createItem(caption:String, handler:Function, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):ContextMenuItem {
			var _result:ContextMenuItem = new ContextMenuItem(caption, separatorBefore, enabled, visible);
			
			_hash[_result] = handler;
			_result.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuSelectHandler);
			
			return _result;
		}
		
		private function getIndexByCaption(caption:String):int {
			for (var i:int = 0 ; i < _menu.customItems.length; i++)
				if(_menu.customItems[i].caption == caption)
					return i;
			
			return -1;
		}
		
		private function menuSelectHandler(e:ContextMenuEvent):void {
			if (_hash[e.target])
				(_hash[e.target] as Function)();
			//dispatchEvent(new ContextMenuEvent(e.type, e.bubbles, e.cancelable, e.mouseTarget, e.contextMenuOwner));
		}
	}

}