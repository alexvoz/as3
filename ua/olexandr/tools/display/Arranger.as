package ua.olexandr.tools.display {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ua.olexandr.constants.DirectionConst;
	/**
	 * ...
	 * @author Olexandr Fedorow
	 */
	public class Arranger {
		
		private static var _calc:Boolean = false;
		
		/**
		 * Рассчитывает ширину массива элементов
		 * @param	arr
		 * @param	space
		 * @param	start
		 * @param	direct
		 * @return
		 */
		[Inline]
		public static function calcWidth(arr:Array, space:Number = 0, start:Number = 0, direct:String = 'right'):Number {
			_calc = true;
			return arrangeByH(arr, space, start, direct);
		}
		
		/**
		 * Рассчитывает высоту массива элементов
		 * @param	arr
		 * @param	space
		 * @param	start
		 * @param	direct
		 * @return
		 */
		[Inline]
		public static function calcHeight(arr:Array, space:Number = 0, start:Number = 0, direct:String = 'bottom'):Number {
			_calc = true;
			return arrangeByV(arr, space, start, direct);
		}
		
		
		/**
		 * Расставляет массив элементов в линию
		 * @param	arr
		 * @param	space
		 * @param	start
		 * @param	direct
		 * @return
		 */
		[Inline]
		public static function arrangeByH(arr:Array, space:Number = 0, start:Number = 0, direct:String = 'right'):Number {
			if (direct != DirectionConst.LEFT) 
				direct = DirectionConst.RIGHT;
			
			var _result:Number = 0;
			var _x:Number = start;
			var _flag:Boolean = direct == DirectionConst.RIGHT;
			var _len:int = arr.length;
			
			if (_len) {
				var _item:DisplayObject;
				for (var i:int = 0; i < _len; i++ ) {
					if (arr[i] is DisplayObject) {
						_item = arr[i] as DisplayObject;
						
						_x = Math.round(_flag ? _x : _x - _item.width);
						
						if (!_calc)
							_item.x = _x;
						
						_x = Math.round(_flag ? (_x + _item.width + space) : (_x - space));
						_result += (_item.width + space);
					}
				}
				_result -= space;
			}
			
			if (_calc)
				_calc = false;
			
			return _result;
		}
		
		/**
		 * Расставляет массив элементов в столбец
		 * @param	arr
		 * @param	space
		 * @param	start
		 * @param	direct
		 * @return
		 */
		[Inline]
		public static function arrangeByV(arr:Array, space:Number = 0, start:Number = 0, direct:String = 'bottom'):Number {
			if (direct != DirectionConst.TOP)
				direct = DirectionConst.BOTTOM;
			
			var _result:Number = 0;
			var _y:Number = start;
			var _flag:Boolean = direct == DirectionConst.BOTTOM;
			var _len:int = arr.length;
			
			if (_len) {
				var _item:DisplayObject;
				for (var i:int = 0; i < _len; i++ ) {
					if (arr[i] is DisplayObject) {
						_item = arr[i] as DisplayObject;
						
						_y = Math.round(_flag ? _y : _y - _item.height);
						
						if (!_calc)
							_item.y = _y;
						
						_y = Math.round(_flag ? (_y + _item.height + space) : (_y - space));
						_result += (_item.height + space);
					}
				}
				_result -= space;
			}
				
			if (_calc)
				_calc = false;
			
			return _result;
		}
		
		/**
		 * Расставить в cols столбцов
		 * @param	arr
		 * @param	cols
		 * @param	space
		 * @param	start
		 * @return	количество строк
		 */
		[Inline]
		public static function arrangeRows(arr:Array, cols:int, spaceX:Number = 0, spaceY:Number = 0, startX:Number = 0, startY:Number = 0, align:String = 'CC'):int {
			var _len:int = arr.length;
			
			var _hash:Dictionary = new Dictionary(true);
			
			var _colsW:Array = [];
			var _rowsH:Array = [];
			
			var _item:DisplayObject;
			var _col:int, _row:int;
			var _w:Number, _h:Number;
			
			for (var i:int = 0; i < _len; i++ ) {
				if (arr[i] is DisplayObject) {
					_item = arr[i] as DisplayObject;
					
					_col = i % cols;
					_row = Math.floor(i / cols);
					
					_w = isNaN(_colsW[_col]) ? 0 : _colsW[_col];
					_colsW[_col] = Math.max(_w, Math.ceil(_item.width));
					
					_h = isNaN(_rowsH[_row]) ? 0 : _rowsH[_row];
					_rowsH[_row] = Math.max(_h, Math.ceil(_item.height));
					
					_hash[_item] = { col:_col, row:_row };
				}
			}
			
			var _colsX:Array = [startX];
			for (i = 1; i < _colsW.length; i++ )
				_colsX[i] = _colsX[i - 1] + _colsW[i - 1] + spaceX;
			
			var _rowsY:Array = [startY];
			for (i = 1; i < _rowsH.length; i++ )
				_rowsY[i] = _rowsY[i - 1] + _rowsH[i - 1] + spaceY;
			
			for (i = 0; i < _len; i++ ) {
				if (arr[i] is DisplayObject) {
					_item = arr[i] as DisplayObject;
					_col = _hash[_item].col;
					_row = _hash[_item].row;
					
					Aligner.align(_item, new Rectangle(	_colsX[_col], _rowsY[_row], _colsW[_col], _rowsH[_row]), align);
				}
			}
			
			_hash = null;
			
			return _rowsH.length;
		}
		
		/**
		 * Расставить в rows строк
		 * @param	arr
		 * @param	rows
		 * @param	space
		 * @param	start
		 * @return	количество строк
		 */
		[Inline]
		public static function arrangeCols(arr:Array, rows:int, spaceX:Number = 0, spaceY:Number = 0, startX:Number = 0, startY:Number = 0, align:String = 'CC'):int {
			var _len:int = arr.length;
			
			var _hash:Dictionary = new Dictionary(true);
			
			var _colsW:Array = [];
			var _rowsH:Array = [];
			
			var _item:DisplayObject;
			var _col:int, _row:int;
			var _w:Number, _h:Number;
			
			for (var i:int = 0; i < _len; i++ ) {
				if (arr[i] is DisplayObject) {
					_item = arr[i] as DisplayObject;
					
					_col = Math.floor(i / rows);
					_row = i % rows;
					
					_w = isNaN(_colsW[_col]) ? 0 : _colsW[_col];
					_colsW[_col] = Math.max(_w, Math.ceil(_item.width));
					
					_h = isNaN(_rowsH[_row]) ? 0 : _rowsH[_row];
					_rowsH[_row] = Math.max(_h, Math.ceil(_item.height));
					
					_hash[_item] = { col:_col, row:_row };
				}
			}
			
			var _colsX:Array = [startX];
			for (i = 1; i < _colsW.length; i++ )
				_colsX[i] = _colsX[i - 1] + _colsW[i - 1] + spaceX;
			
			var _rowsY:Array = [startY];
			for (i = 1; i < _rowsH.length; i++ )
				_rowsY[i] = _rowsY[i - 1] + _rowsH[i - 1] + spaceY;
			
			for (i = 0; i < _len; i++ ) {
				if (arr[i] is DisplayObject) {
					_item = arr[i] as DisplayObject;
					_col = _hash[_item].col;
					_row = _hash[_item].row;
					
					Aligner.align(_item, new Rectangle(	_colsX[_col], _rowsY[_row], _colsW[_col], _rowsH[_row]), align);
				}
			}
			
			_hash = null;
			
			return _colsW.length;
		}
		
	}

}