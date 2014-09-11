package ua.olexandr.modules.games {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ua.olexandr.games.renderers.SlidingPuzzleItem;
	import ua.olexandr.tools.tweener.Tweener;
	import ua.olexandr.utils.BitmapUtils;
	/**
	 * ...
	 * @author Fedorow Olexandr
	 */
	public class SlidingPuzzle extends Sprite{

		private var _source:Bitmap;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _interval:int = 1;

		private var _rows:int;
		private var _cols:int;
		
		private var _items:Dictionary;
		private var _idEmpty:int;
		
		/**
		 * 
		 * @param	$source
		 * @param	$width
		 * @param	$height
		 * @param	$cols
		 * @param	$rows
		 */
		public function SlidingPuzzle($source:DisplayObject, $width:Number, $height:Number, $cols:int = 4, $rows:int = 4) {

			_rows = Math.max(3, $rows);
			_cols = Math.max(3, $cols);
			
			_itemWidth = ($width - _interval * (_cols - 1)) / _cols;
			_itemHeight = ($height - _interval * (_rows - 1)) / _rows;
			_source = BitmapUtils.create($source, new Rectangle(0, 0, _itemWidth * _cols, _itemHeight * _rows));

			_items = new Dictionary();

			for (var i:int = 0; i < _cols * _rows - 1; i++) {
				var _rect:Rectangle = new Rectangle(i % _cols * _itemWidth, Math.floor(i / _cols) * _itemHeight, _itemWidth, _itemHeight);
				var _itemBitmap:Bitmap = BitmapUtils.create(_source, _rect, null, false);
				var _item:SlidingPuzzleItem = new SlidingPuzzleItem(_itemBitmap, i);
				addChild(_item);

				_items[i] = _item;
				_item.buttonMode = true;
				_item.addEventListener(MouseEvent.ROLL_OVER, itemOverHandler);
				_item.addEventListener(MouseEvent.ROLL_OUT, itemOutHandler);
				_item.addEventListener(MouseEvent.CLICK, itemClickHandler);
			}

			shuffle();
			checkWin();
		}

		private function shuffle():void {
			var _arr:Array = [];
			for (var i:int = 0; i < _cols * _rows; i++) _arr[i] = i;
			for (i = 0; i < _cols * _rows - 1; i++) {
				var _rnd:int = _arr.splice(Math.round(Math.random() * (_arr.length - 1)), 1);
				setPosition(_items[i] as SlidingPuzzleItem, _rnd, true);
			}
			_idEmpty = _arr[0];
		}

		private function setPosition($target:SlidingPuzzleItem, $idCurrent:int, $quick:Boolean = false):void {
			$target.idCurrent = $idCurrent;
			var _x:Number = ($idCurrent % _cols) * (_itemWidth + _interval);
			var _y:Number = Math.floor($idCurrent / _cols) * (_itemHeight + _interval);
			Tweener.removeTweens($target);
			Tweener.addTween($target, $quick ? 0 : .3, { x:_x, y:_y } );
		}

		private function itemOverHandler(e:MouseEvent):void {
			var _item:SlidingPuzzleItem = e.target as SlidingPuzzleItem;
			if (checkClick(_item)) _item.over();
		}

		private function itemOutHandler(e:MouseEvent):void {
			var _item:SlidingPuzzleItem = e.target as SlidingPuzzleItem;
			if (checkClick(_item)) _item.out();
		}

		private function itemClickHandler(e:MouseEvent):void {
			var _item:SlidingPuzzleItem = e.target as SlidingPuzzleItem;
			if (checkClick(_item)) {
				var _id:int = _idEmpty;
				_idEmpty = _item.idCurrent;
				setPosition(_item, _id);
			}
			checkWin();
		}
		
		private function checkClick($target:SlidingPuzzleItem):Boolean {
			var _item:SlidingPuzzleItem = $target;
			var _row:Boolean = Math.floor(_item.idCurrent / _cols) == Math.floor(_idEmpty / _cols) && (_item.idCurrent - 1 == _idEmpty || _item.idCurrent + 1 == _idEmpty);
			var _col:Boolean = _item.idCurrent % _cols == _idEmpty % _cols && (_item.idCurrent - _cols == _idEmpty || _item.idCurrent + _cols == _idEmpty);
			return _row || _col;
		}
		
		private function checkWin():void {
			var _win:Boolean = true;
			for (var i:int = 0; i < _cols * _rows - 1; i++) {
				var _item:SlidingPuzzleItem = _items[i];
				if (!_item.inHome()) {
					_win = false;
					break;
				}
			}
			for (i = 0; i < _cols * _rows - 1; i++) {
				_item = _items[i];
				_item.mouseEnabled = !(!checkClick(_item) || _win);
			}
		}

	}

}
