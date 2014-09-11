/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.utils 
{
	
	import flash.display.*;
	import flash.external.*;
	import flash.text.*;
	import flash.utils.setTimeout;
	/**
	 * отладочная утилита; <br/>
	 * лог в тектфилд и/или консоль FireBug и/или стандартный трейс; <br/>
	 * для вывода в текстфилд необходим  вызов Console.register() 
	 * @author silin
	 */
	public class Console
	{
		
		public static const TRACE:int = 1;
		public static const PANEL:int = 2;
		public static const FIREBUG:int = 4;
		/**
		 * получатели вывода: Console.TRACE | Console.PANEL | Console.FIREBUG
		 */
		private static var _output:int = PANEL;
		/**
		 * формат текста
		 */
		public static var format:TextFormat = new TextFormat("_sans", 11, 0x404040);
		
		private static var win:Window;
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Console()
		{
			throw(new Error("Console is a static class and should not be instantiated."))
		}

		public static function clear():void
		{
			win.tf.text = "";
		}
		/**
		 * выодит arg в консоль FireBug, тектфилд или стандартный трейс<br/>
		 * в зависимости от состояния output<br/>
		 * если mark truе, выделят красным
		 * @param	arg
		 * @param	mark
		 */
		public static function log(arg:Object, mark:Boolean=false, clr:int=-1):void
		{
			if (!output) 
			{
				return;
			}
			
			//дублируем в trace
			if (output & TRACE) 
			{
				trace(mark ?"3:"+arg  : arg);
				
			}
			
			var str:String = arg ? arg.toString() : "";
			//вывод в тестфилд
			if (win && (output & PANEL))
			{
				var b:int = win.tf.text.length;
				win.tf.appendText(str + "\n");
				var e:int = win.tf.text.length;
				win.tf.scrollV = win.tf.maxScrollV;
				var fmt:TextFormat = new TextFormat(format.font, format.size, format.color);
				if (mark)
				{
					fmt.color = clr > -1 ? clr:0xC00000;
				}
				win.tf.setTextFormat(fmt, b, e);
			}
			
			//вывод в консоль FireBug
			if (ExternalInterface.available && (output & FIREBUG))
			{
				if (mark)
				{
					ExternalInterface.call( 'function(val){ console.warn(val);}', str);
				}else
				{
					ExternalInterface.call( 'function(val){ console.log(val);}', str)
				}
			}
		}
		
		
		/**
		 * привязка к stage, нужна для вывода в пвнель;<br/>
		 * здесь же задаем размеры панели
		 * @param	stage
		 * @param	width
		 * @param	height
		 */
		public static function register(stage:Stage, width:Number = 240, height:Number = 320):void
		{
			if (win) return;
			
			win = new Window(width, height);
			stage.addChild(win);
			output |= PANEL;//включаем вывод в тектфилд 
			
		}
		
		
		
		/**
		 * куда выводить лог:  TRACE | PANEL | FIREBUG
		 */
		static public function get output():int { return _output; }
		static public function set output(value:int):void 
		{
			_output = value;
			//прячем окно, если нет вывода в текстфилд
			if (win)
			{
				win.visible = Boolean(_output & PANEL);
			}
			
			
		}
		
		static public function get x():Number 
		{
			return win.x;
		}
		
		static public function set x(value:Number):void 
		{
			win.x = value;
		}
		
		static public function get y():Number 
		{
			return win.y
		}
		
		static public function set y(value:Number):void 
		{
			win.y = value;
		}
		
		
		
		
		
		
	}
}
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.ui.*;
import silin.utils.*;
class Window extends Sprite
{
	
	public const barHeight:Number = 20;
	public var tf:TextField = new TextField();
	
	
	private const header:Sprite = new Sprite();
	private const minimazeButton:Sprite = new Sprite();
	private const body:Sprite = new Sprite();
	private const grip:Sprite = new Sprite();
	private const gripSize:int = 20;
	
	public function Window(width:Number, height:Number)
	{
		x = 10;
		y = 10;
		
		
		body.graphics.clear();
		body.graphics.lineStyle(0, 0x808080);
		body.graphics.beginFill(0xFFFFFF, 0.75);
		body.graphics.drawRect(0, 0, width, height);
		body.graphics.endFill();
		
		header.graphics.lineStyle(0, 0x808080);
		header.graphics.beginFill(0xEEEEEE);
		header.graphics.drawRect(0, 0, width, barHeight);
		header.graphics.endFill();
		header.buttonMode = true;
		
		
		
		minimazeButton.buttonMode = true;
		minimazeButton.x = width - barHeight;
		
		minimazeButton.graphics.lineStyle(0, 0x808080);
		minimazeButton.graphics.beginFill(0xDDDDDD);
		minimazeButton.graphics.drawRect(0, 0, barHeight, barHeight);
		minimazeButton.graphics.endFill();
		
		minimazeButton.graphics.beginFill(0xC0C0C0);
		minimazeButton.graphics.drawRect(4, 4, barHeight - 8, 4);
		
		
		grip.graphics.beginFill(0xF5F5F5);
		grip.graphics.lineTo(0, -gripSize);
		grip.graphics.lineTo( -gripSize, 0);
		grip.graphics.endFill();
		
		grip.graphics.lineStyle(2, 0xC0C0C0);
		grip.graphics.moveTo( -0.55 * gripSize, -0.1 * gripSize);		
		grip.graphics.lineTo( -0.1 * gripSize, -0.55 * gripSize);		
		
		grip.graphics.moveTo( -0.3 * gripSize, -0.1 * gripSize);		
		grip.graphics.lineTo( -0.1 * gripSize, -0.3 * gripSize);		
		
		grip.x = width;
		grip.y = height;
		grip.buttonMode = true;
		grip.addEventListener(MouseEvent.MOUSE_DOWN, grip_mouseDown);
		
		
		tf.width = width;
		tf.height = height-barHeight;
		tf.y = barHeight;
		tf.multiline = true;
		
		addChild(body);
		addChild(tf);
		addChild(header);
		addChild(grip);
		header.addChild(minimazeButton);
		
		header.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		minimazeButton.addEventListener(MouseEvent.CLICK, onCloseButClick);
		
		var consolMenu:ContextMenu = new ContextMenu();
		
		var clearItem:ContextMenuItem = new ContextMenuItem("clear output");
		clearItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenu_selectClearItem);
		consolMenu.hideBuiltInItems();
		consolMenu.customItems = [clearItem];
		header.contextMenu = consolMenu;
		
	}
	
	private function grip_mouseDown(e:MouseEvent):void 
	{
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
	}
	
	private function stage_mouseUp(e:MouseEvent):void 
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
	}
	
	private function stage_mouseMove(e:MouseEvent):void 
	{
		
		var w:Number = body.mouseX;// - grip.mouseX;
		var h:Number = body.mouseY;// -grip.mouseY;
		
		body.graphics.clear();
		body.graphics.lineStyle(0, 0x808080);
		body.graphics.beginFill(0xFFFFFF, 0.75);
		body.graphics.drawRect(0, 0, w, h);
		body.graphics.endFill();
		
		header.graphics.clear();
		header.graphics.lineStyle(0, 0x808080);
		header.graphics.beginFill(0xEEEEEE);
		header.graphics.drawRect(0, 0, w, barHeight);
		header.graphics.endFill();
		header.buttonMode = true;
		
		grip.x = w;
		grip.y = h;
		
		tf.width = w;
		tf.height = h - barHeight;
		
		minimazeButton.x = w - barHeight;
		
	}
	
	private function contextMenu_selectClearItem(event:ContextMenuEvent):void 
	{
		Console.clear();
	}
	
	
	
	private function onCloseButClick(evnt:MouseEvent):void 
	{
		tf.visible = !tf.visible;
		body.visible = tf.visible;
		grip.visible = tf.visible;
		minimazeButton.graphics.clear();
		minimazeButton.graphics.lineStyle(0, 0x808080);
		minimazeButton.graphics.beginFill(0xDDDDDD);
		minimazeButton.graphics.drawRect(0, 0, barHeight, barHeight);
		minimazeButton.graphics.endFill();
		
		minimazeButton.graphics.beginFill(0xC0C0C0);
		minimazeButton.graphics.drawRect(4, 4, barHeight - 8, body.visible ? 4: barHeight - 8);
		
		
	}
	
	private function onMouseDown(evnt:MouseEvent):void 
	{
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		parent.addChild(this);
	}
	
	private function onMouseUp(evnt:MouseEvent):void 
	{
		stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
}