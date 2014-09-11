package ua.olexandr.managers {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import ua.olexandr.tools.display.Scaler;
	import ua.olexandr.utils.BitmapUtils;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	[Event(name="error",type="flash.events.ErrorEvent")]
	public class PrintManager extends EventDispatcher {
		
		private var _stage:Stage;
		private var _pages:Array;
		
		/**
		 * 
		 */
		public function PrintManager() {
			_pages = [];
		}
		
		/**
		 * 
		 * @param	stage
		 */
		public function init(stage:Stage):void {
			_stage = stage;
			
		}
		
		/**
		 * 
		 * @param	content
		 * @param	area
		 * @param	rotation
		 * @param	asBitmap
		 */
		public function add(content:Sprite, area:Rectangle = null, rotation:Boolean = true, asBitmap:Boolean = false):void {
			_pages.push(new PageItem(content, area, rotation, asBitmap));
		}
		
		/**
		 * 
		 */
		public function print():void {
			if (_pages.length) {
				try {
					var _job:PrintJob = new PrintJob();
				} catch (e:Error) {
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));
				}
				
				if (_job) {
					if (_job.start()) {
						//page w595 h842
						//content w643 h3221
						
						var _bitmaps:Array = [];
						var _added:Array = [];
						
						var _pagesCount:int;
						var _len:int = _pages.length;
						
						for (var i:int = 0; i < _len; i++){
							try {
								var _item:PageItem = _pages[i] as PageItem;
								var _holder:Sprite = _item.holder;
								var _page:Sprite = _item.page;
								
								var _pw:Number = _job.pageWidth;
								var _ph:Number = _job.pageHeight;
								
								if (_item.rotation) {
									if ((_page.width > _page.height && _ph > _pw) ||
										(_page.height > _page.width && _pw > _ph)) {
										_page.rotation = 90;
										//_page.rotation = -90;
										//_page.x = _page.height;
									}
								}
								
								if (_holder.width > _pw || _holder.height > _ph)
									Scaler.scaleInside(_holder, _pw, _ph);
								
								/*if (_item.asBitmap) {
									var _bitmap:Bitmap = BitmapUtils.fromSprite(_holder);
									_holder = BitmapUtils.toSprite(_bitmap);
									
									_bitmaps.push(_bitmap.bitmapData);
								}*/
								
								if (_stage) {
									_stage.addChild(_holder);
									_holder.x = _stage.stageWidth;
									_holder.y = _stage.stageHeight;
									
									_added.push(_holder);
								}
								
								_job.addPage(_holder, _item.area, new PrintJobOptions(_item.asBitmap));
								_pagesCount++;
							} catch (e:Error) {
								dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));
							}
						}
						
						if (_pagesCount)
							_job.send();
						
						if (_stage) {
							while (_added.length)
								_stage.removeChild(_added.shift() as Sprite);
						}
						
						while (_bitmaps.length)
							BitmapUtils.dispose(_bitmaps.shift() as Bitmap);
						
					} else {
						dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Print cancelled by user"));
					}
				}
			} else {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "The number of pages can not equals 0"));
			}
		}
		
		/**
		 * 
		 */
		public function clear():void {
			_pages = [];
		}
	
	}

}

import flash.display.Sprite;
import flash.geom.Rectangle;

class PageItem {
	
	public var holder:Sprite;
	public var page:Sprite;
	public var area:Rectangle;
	public var rotation:Boolean;
	public var asBitmap:Boolean;
	
	public function PageItem($page:Sprite, $area:Rectangle, $rotation:Boolean, $asBitmap:Boolean):void {
		page = $page;
		
		holder = new Sprite();
		holder.addChild(page);
		
		area = $area;
		rotation = $rotation;
		asBitmap = $asBitmap;
	}
	
}
