/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.text
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * текстфилд с подсветкой AS3
	 */
	public class CodeTextField extends TextField
	{
		
		private static const PRIMARY_KEYWORD:String = "class super dynamic extends implements import interface new case do while else if for in switch throw intrinsic private public static get set function var try catch finally while with default break continue delete return final each internal native override protected const namespace package include use AS3";
		private static const SECONADARY_KEYWORD:String = "void Null ArgumentError arguments Array Boolean Class Date DefinitionError Error EvalError Function int Math Namespace Number Object QName RangeError ReferenceError RegExp SecurityError String SyntaxError TypeError uint URIError VerifyError XML XMLList Accessibility AccessibilityProperties ActionScriptVersion AVM1Movie Bitmap BitmapData BitmapDataChannel BlendMode CapsStyle DisplayObject DisplayObjectContainer FrameLabel GradientType Graphics IBitmapDrawable InteractiveObject InterpolationMethod JointStyle LineScaleMode Loader LoaderInfo MorphShape MovieClip PixelSnapping Scene Shape SimpleButton SpreadMethod Sprite Stage StageAlign StageDisplayState StageQuality StageScaleMode SWFVersion EOFError IllegalOperationError InvalidSWFError IOError MemoryError ScriptTimeoutError StackOverflowError ActivityEvent AsyncErrorEvent ContextMenuEvent DataEvent ErrorEvent Event EventDispatcher EventPhase FocusEvent FullScreenEvent HTTPStatusEvent IEventDispatcher IMEEvent IOErrorEvent KeyboardEvent MouseEvent NetStatusEvent ProgressEvent SecurityErrorEvent StatusEvent SyncEvent TextEvent TimerEvent ExternalInterface BevelFilter BitmapFilter BitmapFilterQuality BitmapFilterType BlurFilter ColorMatrixFilter ConvolutionFilter DisplacementMapFilter DisplacementMapFilterMode DropShadowFilter GlowFilter GradientBevelFilter GradientGlowFilter ColorTransform Matrix Point Rectangle Transform Camera ID3Info Microphone Sound SoundChannel SoundLoaderContext SoundMixer SoundTransform Video FileFilter FileReference FileReferenceList IDynamicPropertyOutput IDynamicPropertyWriter LocalConnection NetConnection NetStream ObjectEncoding Responder SharedObject SharedObjectFlushStatus Socket URLLoader URLLoaderDataFormat URLRequest URLRequestHeader URLRequestMethod URLStream URLVariables XMLSocket PrintJob PrintJobOptions PrintJobOrientation ApplicationDomain Capabilities IME IMEConversionMode LoaderContext Security SecurityDomain SecurityPanel System AntiAliasType CSMSettings Font FontStyle FontType GridFitType StaticText StyleSheet TextColorType TextDisplayMode TextField TextFieldAutoSize TextFieldType TextFormat TextFormatAlign TextLineMetrics TextRenderer TextSnapshot ContextMenu ContextMenuBuiltInItems ContextMenuItem Keyboard KeyLocation Mouse ByteArray Dictionary Endian IDataInput IDataOutput IExternalizable Proxy Timer XMLDocument XMLNode XMLNodeType";
		private static const REGEXP:RegExp = /\/.+?(?<!\\)\/[gimsx]*/g;
		private static const STRING:RegExp = /\'.*?\'|\".*?\"/g;
		private static const NUMBER:RegExp= /\W(0x[0-9A-Fa-f]+|[\d\.]+)\W/g;
		private static const COMMENT:RegExp = /\/\*.*?\*\/|\/{2}.*?\r/sg;
		
		public static var BASE_FORMAT:TextFormat = new TextFormat("_typewriter", 12, 0x000000);
		public static var STRING_COLOR:uint = 0x800000;
		public static var NUMBER_COLOR:uint = 0x004080;
		public static var COMMENT_COLOR:uint = 0x008000;
		public static var REGEXP_COLOR:uint = 0xFF00FF;
		public static var PRIMARY_COLOR:uint = 0x0000FF;
		public static var SECONDARY_COLOR:uint = 0x008080;
		
		public function CodeTextField(url:String=null)
		{
			super();
			super.autoSize = TextFieldAutoSize.LEFT;
			if (url)
			{
				load(url);
			}
			
		}
		public function load(url:String):void
		{
			var textLoader:URLLoader = new URLLoader();
			textLoader.addEventListener(Event.COMPLETE, textLoader_complete);
			
			try
			{
				textLoader.load(new URLRequest(url));
			}catch (err:Error)
			{
				this.text = "fault load "+ url;
			}
			
		}
		
		
		private function textLoader_complete(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, textLoader_complete);
			this.text = e.target.data;
		}
		
		
		override public function set text(value:String):void
		{
			
			var keyArr:Array;
			var i:int;
			
			super.text = "\r" + value.split("\r\n").join("\r");//избыточные переносы;;
			setTextFormat(BASE_FORMAT);
			
			colorBlock(COMMENT, COMMENT_COLOR);
			colorBlock(STRING, STRING_COLOR);
			colorBlock(NUMBER, NUMBER_COLOR, 1);
			colorBlock(REGEXP, REGEXP_COLOR);
			
			
			keyArr = PRIMARY_KEYWORD.split(" ");
			for (i = 0; i < keyArr.length; i++) 
			{
				colorBlock(new RegExp("\\W" + keyArr[i] + "\\W", "g"), PRIMARY_COLOR, 1);
			}
			
			keyArr = SECONADARY_KEYWORD.split(" ");
			for (i = 0; i < keyArr.length; i++) 
			{
				colorBlock(new RegExp("\\W" + keyArr[i] + "\\W", "g"), SECONDARY_COLOR, 1);
			}
		}
		//красит все вхождения regexp  цветом clr
		//есди задан crop, то крайние символы не красим
		private function colorBlock(regexp:RegExp, clr:uint, crop:int=0):void
		{
			var match:Object;
			while (match = regexp.exec(text))
			{
				var b:int = match.index + crop;
				var e:int = regexp.lastIndex - crop;
				
				if (b && e && b < super.text.length)
				{
					var fmt:TextFormat = getTextFormat(b);
					if (fmt.color == BASE_FORMAT.color)//не красим где уже покрашено
					{
						fmt.color = clr;
						setTextFormat(fmt, b, e);
						
					}
				}
			}
		}
	}
}