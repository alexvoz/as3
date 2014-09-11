/**
 * @author			Ahmed Nuaman (http://www.ahmednuaman.com)
 * @author			Olexandr Fedorow
 * @langversion		3
 *
 * This work is licenced under the Creative Commons Attribution-Share Alike 2.0 UK: England & Wales License.
 * To view a copy of this licence, visit http://creativecommons.org/licenses/by-sa/2.0/uk/ or send a letter
 * to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.
 */
package ua.olexandr.display.effects {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Reflection extends Sprite {
		
		public function Reflection(target:DisplayObject) {
			var _contentM:Matrix = new Matrix();
			_contentM.translate(0, -target.height);
			_contentM.scale(1, -1);
			
			var _bmpData:BitmapData = new BitmapData(target.width, target.height, true, 0x00FFFFFF);
			_bmpData.draw(target, _contentM);
			
			var _content:Sprite = new Sprite();
			_content.graphics.beginBitmapFill(_bmpData);
			_content.graphics.drawRect(0, 0, target.width, target.height);
			_content.graphics.endFill();
			_content.cacheAsBitmap = true;
			addChild(_content);
			
			
			var _maskM:Matrix = new Matrix();
			_maskM.createGradientBox(target.width, target.height, Math.PI * 1.5, 0, (target.height / 1.5) * -1);
			
			var _mask:Shape = new Shape();
			_mask.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [0, .8], [0, 255], _maskM);
			_mask.graphics.drawRect(0, 0, target.width, target.height);
			_mask.graphics.endFill();
			_mask.cacheAsBitmap = true;
			addChild(_mask);
			
			_content.mask = _mask;
		}
	}
	
}