package ru.cartoonizer.states 
{
	import by.blooddy.crypto.image.JPEGEncoder;
	import by.blooddy.crypto.image.PNG24Encoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import ru.cartoonizer.ContentLoader;
	import ru.cartoonizer.gui.controls.EmailTextInput;
	import ru.cartoonizer.ImageBox;
	import ru.scarbo.data.ClassLibrary;
	import ru.scarbo.gui.controls.Button;
	import ru.scarbo.gui.controls.IconButton;
	import ru.scarbo.gui.controls.TextInput;
	import ru.scarbo.gui.core.BasicButton;
	import ru.scarbo.gui.core.BasicSprite;
	import ru.scarbo.gui.events.ButtonEvent;
	import ru.scarbo.gui.managers.PopUpManager;
	import ru.scarbo.gui.utils.Preloader;
	import flash.external.ExternalInterface;
	import flash.net.sendToURL;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class State3 extends State 
	{
		private var _emailText:EmailTextInput;
		private var _isValidEmail:Boolean = false;
		private var _imageBox:ImageBox;
		private var _image:BitmapData;
		private var _file:FileReference;
		private var _preloader:Preloader;
		private var _saveBtn:BasicButton;
		private var _sizeText:TextInput;
		private var _loadingIcon:Sprite;
		
		public function State3() 
		{
			super();
		}
		
		public function set image(value:ImageBox):void {
			this._imageBox = value;
			this._imageBox.showWatermark();
		}
		
		override protected function _init():void {
			this._file = new FileReference();
			this._file.addEventListener(Event.SELECT, _startSaveHandler);
			this._file.addEventListener(ProgressEvent.PROGRESS, _progressSaveHandler);
			this._file.addEventListener(Event.COMPLETE, _completeSaveHandler);
			this._file.addEventListener(IOErrorEvent.IO_ERROR, _errorSaveHandler);
			this._file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _errorSaveHandler);
			this._preloader = ContentLoader.preloader;
					
			//
			super._init();
		}
		
		private function _startSaveHandler(e:Event):void {
			PopUpManager.addPopUp(this._preloader);
			PopUpManager.centerPopUp(this._preloader);
			this._preloader.start();
		}
		private function _progressSaveHandler(e:ProgressEvent):void {
			var precent:uint = e.bytesLoaded / e.bytesTotal * 100;
			this._preloader.label = precent.toString() + '%';
		}
		private function _completeSaveHandler(e:Event):void {
			this._preloader.stop();
			PopUpManager.removePopUp(this._preloader);
		}
		private function _errorSaveHandler(e:*):void {
			this._preloader.stop();
			PopUpManager.removePopUp(this._preloader);
		}
		
		override protected function _build():void {
			// E-mail input
			/*this._emailText = new EmailTextInput();
			this._emailText.x = 342;
			this._emailText.y = 262;
			this.addChild(this._emailText);*/
			
			var buttonCellWidth:int = 80;
			var buttonCellHeight:int = 80;
			
			var buttonsContainer:Sprite = new Sprite();
			this.addChild(buttonsContainer);
			buttonsContainer.x = 342;
			//buttonsContainer.y = 374;
			buttonsContainer.y = 302;
			
			var faceBookButton:IconButton = new IconButton();
			faceBookButton.icon = new Bitmap(ClassLibrary.getBitmapData('VKontakteBitmapData'));
			faceBookButton.name = 'vKontakteButton';
			faceBookButton.data = uint(200);
			faceBookButton.addEventListener(ButtonEvent.CLICK, this._saveClickHandler);
			buttonsContainer.addChild(faceBookButton);
			
			var vKontakteButton:IconButton = new IconButton();
			vKontakteButton.icon = new Bitmap(ClassLibrary.getBitmapData('FacebookBitmapData'));
			vKontakteButton.name = 'faceBookButton';
			vKontakteButton.x = buttonCellWidth;
			vKontakteButton.y = 0;
			vKontakteButton.data = uint(150);
			vKontakteButton.addEventListener(ButtonEvent.CLICK, this._saveClickHandler);
			buttonsContainer.addChild(vKontakteButton);
			
			var liveJournalButton:IconButton = new IconButton();
			liveJournalButton.icon = new Bitmap(ClassLibrary.getBitmapData('LiveJournalBitmapData'));
			liveJournalButton.name = 'liveJournalButton';
			liveJournalButton.x = buttonCellWidth * 2;
			liveJournalButton.y = 0;
			liveJournalButton.data = uint(100);
			liveJournalButton.addEventListener(ButtonEvent.CLICK, this._saveClickHandler);
			buttonsContainer.addChild(liveJournalButton);
			
			var odnoclassnikiButton:IconButton = new IconButton();
			odnoclassnikiButton.icon = new Bitmap(ClassLibrary.getBitmapData('OdnoclassnikiBitmapData'));
			odnoclassnikiButton.name = 'odnoclassnikiButton';
			odnoclassnikiButton.x = buttonCellWidth * 3;
			odnoclassnikiButton.y = 0;
			odnoclassnikiButton.data = uint(190);
			odnoclassnikiButton.addEventListener(ButtonEvent.CLICK, this._saveClickHandler);
			buttonsContainer.addChild(odnoclassnikiButton);
			
			var otherButton:IconButton = new IconButton();
			otherButton.icon = new Bitmap(ClassLibrary.getBitmapData('OtherBitmapData'));
			otherButton.name = 'otherButton';
			otherButton.x = buttonCellWidth * 4;
			otherButton.y = 0;
			otherButton.addEventListener(ButtonEvent.CLICK, this._otherClickHandler);
			buttonsContainer.addChild(otherButton);
			
			this._saveBtn = new BasicButton();
			this._saveBtn.setSize(227, 74);
			this._saveBtn.setSkin(new Bitmap(ClassLibrary.getBitmapData('SaveButtonUpSkin')), BasicButton.SKIN);
			this._saveBtn.setSkin(new Bitmap(ClassLibrary.getBitmapData('SaveButtonOverSkin')), BasicButton.SKIN_OVER);
			this._saveBtn.setSkin(null, BasicButton.SKIN_PRESS);
			this._saveBtn.x = 585;
			this._saveBtn.y = 541;
			this._saveBtn.data = uint(Main.DEFAULT_SIZE);
			this._saveBtn.addEventListener(ButtonEvent.CLICK, this._saveClickHandler);
			this.addChild(this._saveBtn);
			
			this._sizeText = new TextInput();
			this._sizeText.skin = ClassLibrary.getDisplayObject('TextInputUpSkin');
			this._sizeText.text = Main.DEFAULT_SIZE.toString();
			this._sizeText.setSize(40, 30);
			this._sizeText.restrict = '0-9';
			this._sizeText.x = 695;
			this._sizeText.y = 463;
			this._sizeText.addEventListener(Event.CHANGE, _sizeChangeHandler);
			this.addChild(this._sizeText);
			
			this._saveBtn.visible = false;
			this._sizeText.visible = false;
			this._libSprite.getChildByName('infoMc').visible = false;
			
			var bmp:BitmapData = new BitmapData(Main.DEFAULT_SIZE, Main.DEFAULT_SIZE);
			bmp.draw(this._imageBox);
			var avatar:Bitmap = new Bitmap(bmp, 'auto', true);
			avatar.x = Main.IMAGE_X;
			avatar.y = Main.IMAGE_Y;
			this.addChild(avatar);
			
			this._loadingIcon = ClassLibrary.getDisplayObject('LoadingSign') as Sprite;
			this.addChild(this._loadingIcon);
			this._loadingIcon.x = 560;
			this._loadingIcon.y = 492;
			this._loadingIcon.visible = false;
			
			super._build();
		}
		
		private function _saveClickHandler(e:ButtonEvent):void {
			if (!this._emailText || this._emailText.hasValidValue()) {
				this._saveBtn.visible = false;
				this._sizeText.visible = false;
				this._libSprite.getChildByName('infoMc').visible = false;
				
				/*
				this._loadingIcon.visible = true;
				
				var url:String = 'http://multava.net/store.php';
				var variables:URLVariables = new URLVariables();
				variables.email = this._emailText.value;
				variables.sex = this._userData.sex;
				
				var request:URLRequest = new URLRequest(url);
				request.data = variables;
				try {
					sendToURL(request);
					ExternalInterface.call('trackLead');
				} catch (e:Error) {
					// handle error here
				}
				
				this._loadingIcon.visible = false;
				*/
				
				var btn:BasicSprite = e.target as BasicSprite;
				this._imageBox.setSize(uint(btn.data), uint(btn.data));
				this._image = new BitmapData(uint(btn.data), uint(btn.data));
				this._image.draw(this._imageBox);
				var ba:ByteArray = JPEGEncoder.encode(this._image, 80);
				this._file.save(ba, 'avatar multava.net.jpg');
				this._file.addEventListener(Event.COMPLETE, this._saveCompleteHandler);
				
				ExternalInterface.call('goalCompleteHandler', 'SAVE_CLICK');
			} else {
				this._emailText.showErrorIcon();
			}
		}
		
		private function _otherClickHandler(e:ButtonEvent):void {
			this._saveBtn.visible = true;
			this._sizeText.visible = true;
			this._libSprite.getChildByName('infoMc').visible = true;
		}
		
		private function _saveCompleteHandler(e:Event):void {
			this._file.removeEventListener(Event.COMPLETE, this._saveCompleteHandler);
			ExternalInterface.call('goalCompleteHandler', 'SAVE_COMPLETE');
		}
		
		private function _sizeChangeHandler(e:Event):void {
			var input:uint = parseInt(this._sizeText.text);
			if (input < Main.MIN_SIZE) input = Main.MIN_SIZE;
			if (input > Main.MAX_SIZE) input = Main.MAX_SIZE;
			this._saveBtn.data = input;
		}
	}

}