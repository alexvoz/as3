package ua.olexandr.display {
	import flash.events.Event;
	import ua.olexandr.display.ResizableObject;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class AddedObject extends ResizableObject {
		
		/**
		 * 
		 */
		public function AddedObject() {
			addEventListener(Event.ADDED_TO_STAGE, _addedToHandler, false, 0, true);
		}
		
		private function _addedToHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _addedToHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromHandler, false, 0, true);
			
			added();
		}
		
		private function _removedFromHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromHandler);
			addEventListener(Event.ADDED_TO_STAGE, _addedToHandler, false, 0, true);
			
			removed();
		}
		
		
		protected function added():void {
			//code here
		}
		
		protected function removed():void {
			//code here
		}
	}
	
}