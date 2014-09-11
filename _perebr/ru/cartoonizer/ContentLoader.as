package ru.cartoonizer 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.utils.setTimeout;
	import ru.scarbo.gui.containers.Application;
	import ru.scarbo.gui.managers.PopUpManager;
	import ru.scarbo.gui.utils.Preloader;
	/**
	 * ...
	 * @author ...
	 */
	public class ContentLoader 
	{
		private static var _inited:Boolean = false;
		private static var _loader:BulkLoader;
		private static var _preloader:Preloader;
		
		static public function get loader():BulkLoader 
		{
			return ContentLoader._loader;
		}
		static public function get preloader():Preloader 
		{
			return _preloader;
		}
		static public function get inited():Boolean 
		{
			return ContentLoader._inited;
		}
		
		static public function init():void {
			if (!ContentLoader._inited) {
				var loader:BulkLoader = new BulkLoader('app');
				loader.addEventListener(BulkProgressEvent.PROGRESS, _progressHandler);
				loader.addEventListener(BulkProgressEvent.COMPLETE, _completeHandler);
				var preloader:Preloader = PopUpManager.createPopUp(Preloader) as Preloader;
				PopUpManager.centerPopUp(preloader);
				//
				ContentLoader._loader = loader;
				ContentLoader._preloader = preloader;
				ContentLoader._inited = true;
			}
		}
		static public function add(url:String, props:* = null, autoStart:Boolean = true):LoadingItem {
			var loadingItem:LoadingItem = ContentLoader._loader.add(url, props);
			if (autoStart && !ContentLoader._loader.isRunning) {
				ContentLoader.start();
			}
			return loadingItem;
		}
		static public function start():void {
			ContentLoader._loader.start();
			ContentLoader._preloader.start();
		}
		
		static private function _completeHandler(e:BulkProgressEvent):void 
		{
			ContentLoader._preloader.stop();
		}
		static private function _progressHandler(e:BulkProgressEvent):void 
		{
			var precent:uint = e.bytesLoaded / e.bytesTotal * 100;
			ContentLoader._preloader.label = precent.toString() + '%';
		}
		
	}

}