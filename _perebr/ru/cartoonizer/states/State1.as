package ru.cartoonizer.states 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.gui.controls.IconButton;
	import ru.scarbo.gui.events.ButtonEvent;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class State1 extends State 
	{
		
		public function State1() 
		{
			super();
		}
		
		override protected function _build():void {
			var manButton:IconButton = new IconButton();
			manButton.icon = new Bitmap(ClassLibrary.getBitmapData('ManBitmapData'));
			manButton.x = 213;
			manButton.y = 308;
			manButton.addEventListener(ButtonEvent.CLICK, this._manClickHandler);
			this.addChild(manButton);
			//
			var womanButton:IconButton = new IconButton();
			womanButton.icon = new Bitmap(ClassLibrary.getBitmapData('WomanBitmapData'));
			womanButton.x = 462;
			womanButton.y = 308;
			womanButton.addEventListener(ButtonEvent.CLICK, this._womanClickHandler);
			this.addChild(womanButton);
			//
			super._build();
		}
		
		private function _manClickHandler(e:ButtonEvent):void {
			this._userData.sex = 'm';
			this.dispatchEvent(new Event('CHANGE_MAN'));
		}
		
		private function _womanClickHandler(e:ButtonEvent):void {
			this._userData.sex = 'f';
			this.dispatchEvent(new Event('CHANGE_WOMAN'));
		}
	}

}