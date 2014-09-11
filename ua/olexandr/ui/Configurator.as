package ua.olexandr.ui {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import ua.olexandr.ui.components.*;
	
	public class Configurator extends EventDispatcher {
		
		protected var loader:URLLoader;
		protected var parent:DisplayObjectContainer;
		protected var idMap:Object;
		
		public function Configurator(parent:DisplayObjectContainer) {
			this.parent = parent;
			idMap = new Object();
		}
		
		public function loadXML(url:String):void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(url));
		}
		
		public function parseXMLString(string:String):void {
			try {
				var xml:XML = new XML(string);
				parseXML(xml);
			} catch (e:Error) {
				
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function parseXML(xml:XML):void {
			for (var i:int = 0; i < xml.children().length(); i++) {
				var comp:XML = xml.children()[i];
				var compInst:Component = parseComp(comp);
				if (compInst != null) {
					parent.addChild(compInst);
				}
			}
		}
		
		public function getCompById(id:String):Component {
			return idMap[id];
		}
		
		
		private function onLoadComplete(event:Event):void {
			parseXMLString(loader.data as String);
		}
		
		private function parseComp(xml:XML):Component {
			var compInst:Object;
			var specialProps:Object = {};
			try {
				var classRef:Class = getDefinitionByName("ua.olexandr.ui.components." + xml.name()) as Class;
				compInst = new classRef();
				
				var id:String = trim(xml.@id.toString());
				if (id != "") {
					compInst.name = id;
					idMap[id] = compInst;
					
					if (parent.hasOwnProperty(id)) {
						parent[id] = compInst;
					}
				}
				
				if (xml.@event.toString() != "") {
					var parts:Array = xml.@event.split(":");
					var eventName:String = trim(parts[0]);
					var handler:String = trim(parts[1]);
					if (parent.hasOwnProperty(handler)) {
						compInst.addEventListener(eventName, parent[handler]);
					}
				}
				
				for each (var attrib:XML in xml.attributes()) {
					var prop:String = attrib.name().toString();
					if (compInst.hasOwnProperty(prop)) {
						if (compInst[prop] is Boolean) {
							compInst[prop] = attrib == "true";
						} else if (prop == "value" || prop == "lowValue" || prop == "highValue" || prop == "choice") {
							specialProps[prop] = attrib;
						} else {
							compInst[prop] = attrib;
						}
					}
				}
				
				for (prop in specialProps) {
					compInst[prop] = specialProps[prop];
				}
				
				for (var j:int = 0; j < xml.children().length(); j++) {
					var child:Component = parseComp(xml.children()[j]);
					if (child != null) {
						compInst.addChild(child);
					}
				}
			} catch (e:Error) {
				
			}
			return compInst as Component;
		}
		
		private function trim(s:String):String {
			return s.replace(/^\s+|\s+$/gs, '');
		}
		
		Accordion;
		Calendar;
		CheckBox;
		ColorChooser;
		ComboBox;
		FPSMeter;
		HBox;
		HRangeSlider;
		HScrollBar;
		HSlider;
		HUISlider;
		IndicatorLight;
		InputText;
		Knob;
		Label;
		List;
		ListItem;
		Meter;
		NumericStepper;
		Panel;
		ProgressBar;
		PushButton;
		RadioButton;
		RangeSlider;
		RotarySelector;
		ScrollBar;
		ScrollPane;
		Slider;
		Style;
		Text;
		TextArea;
		UISlider;
		VBox;
		VRangeSlider;
		VScrollBar;
		VSlider;
		VUISlider;
		WheelMenu;
		Window;
	}
}