package ua.olexandr.tools {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	/**
	 * @author Olexandr Fedorow
	 */
	public class ImageBrowser extends EventDispatcher {
		
		private var _types:Array;
		private var _file:FileReference;
		private var _loader:Loader;
		private var _bitmap:Bitmap;
		
		/**
		 * 
		 */
		public function ImageBrowser(title:String = 'Images', extensions:String = '*.jpg;*.gif;*.png') {
			_types = [new FileFilter(title, extensions)];
			
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, fileSelectHandler);
			_file.addEventListener(Event.CANCEL, fileCancelHandler);
			_file.addEventListener(Event.COMPLETE, fileCompleteHandler);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
		
		/**
		 * 
		 */
		public function browse():void {
			_file.browse(_types);
		}
		
		/**
		 * 
		 */
		public function destroy():void {
			_file.removeEventListener(Event.SELECT, fileSelectHandler);
			_file.removeEventListener(Event.CANCEL, fileCancelHandler);
			_file.removeEventListener(Event.COMPLETE, fileCompleteHandler);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			
			_file = null;
			_loader = null;
			_types = null;
		}
		
		/**
		 * 
		 */
		public function get bitmap():Bitmap { return _bitmap; }
		
		
		private function fileCancelHandler(event:Event):void {
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		private function fileSelectHandler(event:Event):void {
			_file.load();
		}
		
		private function fileCompleteHandler(event:Event):void {
			_loader.loadBytes(_file.data);
		}
		
		private function loaderCompleteHandler(event:Event):void {
			_bitmap = _loader.content as Bitmap;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
