package ua.olexandr.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ua.olexandr.constants.AlignConst;
	
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class BitmapUtils {
		
		/**
		 *
		 * @param	bitmap
		 * @param	smoothing
		 * @return
		 */
		[Inline]
		public static function toSprite(bitmap:Bitmap, smoothing:Boolean = false):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.addChild(new Bitmap(bitmap.bitmapData.clone(), "auto", smoothing));
			return sprite;
		}
		
		/**
		 *
		 * @param	sprite
		 * @param	smoothing
		 * @return
		 */
		[Inline]
		public static function fromSprite(sprite:Sprite, smoothing:Boolean = false):Bitmap {
			var bitmapData:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00FFFFFF);
			bitmapData.draw(sprite);
			return new Bitmap(bitmapData, "auto", smoothing);
		}
		
		/**
		 *
		 * @param	source
		 * @param	region
		 * @return
		 */
		[Inline]
		public static function crop(source:DisplayObject, region:Rectangle):BitmapData {
			var _rect:Rectangle = new Rectangle(0, 0, region.width, region.height);
			
			var _bmpData:BitmapData = new BitmapData(region.width, region.height);
			_bmpData.draw(source, new Matrix(1, 0, 0, 1, -region.x, -region.y), null, null, _rect, true);
			
			return _bmpData;
		}
		
		/**
		 *
		 * @param	source
		 * @return
		 */
		[Inline]
		public static function drawWithBounds(source:DisplayObject):BitmapData {
			var _rect:Rectangle = source.getBounds(source);
			var _mat:Matrix = new Matrix();
			_mat.translate(-_rect.left, -_rect.top);
			
			var _bmpData:BitmapData = new BitmapData(_rect.width, _rect.height);
			_bmpData.draw(source, _mat);
			
			return _bmpData;
		}
		
		/**
		 *
		 * @param	source
		 * @param	angle
		 * @return
		 */
		[Inline]
		public static function rotate(source:BitmapData, angle:Number):BitmapData {
			var _m:Matrix = new Matrix();
			_m.rotate(GeomUtils.degreesToRadians(angle));
			_m.translate(source.width, source.height);
			
			var _bmpData:BitmapData = new BitmapData(source.width, source.height, source.transparent);
			_bmpData.draw(source, _m);
			return _bmpData;
		}
		
		/**
		 *
		 * @param	bitmap
		 */
		[Inline]
		public static function dispose(bitmap:Bitmap):void {
			if (bitmap) {
				if (bitmap.parent)
					bitmap.parent.removeChild(bitmap);
				
				if (bitmap.bitmapData) {
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
				}
				
				bitmap = null;
			}
		}
		
		/**
		 *
		 * @param	bmpData
		 * @param	x
		 * @param	y
		 * @return
		 */
		[Inline]
		public static function isOpacity(bmpData:BitmapData, x:Number, y:Number):Boolean {
			return Boolean(bmpData.getPixel32(x, y) >> 24 & 0xFF > 0);
		}
		
		/**
		 *
		 * @param	bmpData
		 * @return
		 */
		[Inline]
		public static function trim(bmpData:BitmapData, corner:String = "TL"):BitmapData {
			var _blankColor:uint;
			switch (corner) {
				case AlignConst.TR:  {
					_blankColor = bmpData.getPixel32(bmpData.width - 1, 0);
					break;
				}
				case AlignConst.BL:  {
					_blankColor = bmpData.getPixel32(0, bmpData.height - 1);
					break;
				}
				case AlignConst.BR:  {
					_blankColor = bmpData.getPixel32(bmpData.width - 1, bmpData.height - 1);
					break;
				}
				default:  {
					_blankColor = bmpData.getPixel32(0, 0);
				}
			}
			
			var _rect:Rectangle = bmpData.rect.clone();
			var _x:int = 0;
			var _y:int = 0;
			
			topOuter: for (_y = 0; _y < bmpData.height; _y++) {
				for (_x = 0; _x < bmpData.width; _x++) {
					if (_blankColor != bmpData.getPixel32(_x, _y))
						break topOuter;
				}
				_rect.top++;
			}
			
			bottomOuter: for (_y = bmpData.height - 1; _y >= _rect.top; _y--) {
				for (_x = 0; _x < bmpData.width; _x++) {
					if (_blankColor != bmpData.getPixel32(_x, _y))
						break bottomOuter;
				}
				_rect.bottom--;
			}
			
			leftOuter: for (_x = 0; _x < bmpData.width; _x++) {
				for (_y = _rect.top; _y < _rect.bottom; _y++) {
					if (_blankColor != bmpData.getPixel32(_x, _y))
						break leftOuter;
				}
				_rect.left++;
			}
			
			rightOuter: for (_x = bmpData.width - 1; _x >= _rect.left; _x--) {
				for (_y = _rect.top; _y < _rect.bottom; _y++) {
					if (_blankColor != bmpData.getPixel32(_x, _y))
						break rightOuter;
				}
				_rect.right--;
			}
			
			if (_rect.width <= 0 || _rect.height <= 0)
				return bmpData.clone();
			
			var _bmpData:BitmapData = new BitmapData(_rect.width, _rect.height, bmpData.transparent, 0x00000000);
			_bmpData.copyPixels(bmpData, _rect, new Point(0, 0), null, null, true);
			return _bmpData;
		}
		
		/**
		 *
		 * @param	source
		 * @param	clip
		 * @param	region
		 * @param	scaling
		 * @return
		 */
		[Inline]
		public static function create(source:DisplayObject, clip:Rectangle, region:String = null, scaling:Boolean = true):Bitmap {
			
			var _scale:Number = scaling ? Math.max(clip.width / source.width, clip.height / source.height) : 1;
			var _matrix:Matrix = new Matrix(_scale, 0, 0, _scale);
			
			if (region) {
				switch (region) {
					case AlignConst.TL:  {
						_matrix.tx = 0;
						_matrix.ty = 0;
						break;
					}
					case AlignConst.TC:  {
						_matrix.tx = -(source.width * _scale - clip.width) / 2;
						_matrix.ty = 0;
						break;
					}
					case AlignConst.TR:  {
						_matrix.tx = -(source.width * _scale - clip.width);
						_matrix.ty = 0;
						break;
					}
					case AlignConst.CL:  {
						_matrix.tx = 0;
						_matrix.ty = -(source.height * _scale - clip.height) / 2;
						break;
					}
					case AlignConst.CC:  {
						_matrix.tx = -(source.width * _scale - clip.width) / 2;
						_matrix.ty = -(source.height * _scale - clip.height) / 2;
						break;
					}
					case AlignConst.CR:  {
						_matrix.tx = -(source.width * _scale - clip.width);
						_matrix.ty = -(source.height * _scale - clip.height) / 2;
						break;
					}
					case AlignConst.BL:  {
						_matrix.tx = 0;
						_matrix.ty = -(source.height * _scale - clip.height);
						break;
					}
					case AlignConst.BC:  {
						_matrix.tx = -(source.width * _scale - clip.width) / 2;
						_matrix.ty = -(source.height * _scale - clip.height);
						break;
					}
					case AlignConst.BR:  {
						_matrix.tx = -(source.width * _scale - clip.width);
						_matrix.ty = -(source.height * _scale - clip.height);
						break;
					}
				}
			} else {
				_matrix.tx = -clip.x;
				_matrix.ty = -clip.y;
			}
			
			var _rect:Rectangle = new Rectangle(0, 0, clip.width, clip.height);
			var _bmd:BitmapData = new BitmapData(clip.width, clip.height, true, 0xFFFFFF);
			_bmd.draw(source, _matrix, null, null, _rect, true);
			
			return new Bitmap(_bmd);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	pattern
		 * @param	alpha
		 */
		[Inline]
		public static function fillPattern(target:Bitmap, pattern:BitmapData):void {
			var rr:Rectangle = new Rectangle(0, 0, pattern.width, pattern.height);
			var tx:uint = Math.ceil(target.bitmapData.width / pattern.width);
			var ty:uint = Math.ceil(target.bitmapData.height / pattern.height);
			
			for (var i:uint = 0; i < tx; i++) {
				for (var j:uint = 0; j < ty; j++)
					target.bitmapData.copyPixels(pattern, rr, new Point(i * pattern.width, j * pattern.height));
			}
		}
	
	}

}
