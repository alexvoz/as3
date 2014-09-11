package ru.scarbo.gui.core
{
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author Scarbo
	 */
	public class BasicFormat extends TextFormat
	{
		//font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null, indent:Object = null, leading:Object = null
		public function BasicFormat(format:String = null)
		{
			if (format) {
				var arr:Array = format.split(',');
				var length:uint = arr.length;
				for (var i:uint = 0; i < length; i++) {
					var item:Array = arr[i].split(':');
					var prop:String = item[0].split(' ').join('');
					var val:String = item[1].split('#').join('0x');
					this[prop] = val;
				}
			}
		}

	}

}

