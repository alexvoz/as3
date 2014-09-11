/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.gadgets.book
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	


	/**
	 * генерится когда страница перевернута и прибыла на место
	 * @eventType silin.book.events.BookEvent
	 */
	[Event(name = "flip", type = "silin.book.events.BookEvent")]

	/**
	 * генерится при смене страницы(разворота)
	 * @eventType silin.book.events.BookEvent
	 */
	[Event(name = "changePage", type = "silin.book.events.BookEvent")]

	/**
	 * имитация листания страниц <br/>
	 * листается только за нижнию часть страниц<br/>
	 * 
	 *
	 * @author silin
	 * @langversion 3.0
     * @playerversion 9.0.115
	 */
	public class Book extends Sprite
	{
		/**
		 * режим переворачивания сразу на заданную страницу
		 */
		public static const JUMP:String = "jump";
		/**
		 * режим постраничного переворачивания до заданной страницы
		 */
		public static const LEAF:String = "leaf";
		//////////////////////DIRECT PROPS
		/**
		 * режим переворачивания: <br/>
		 * LEAF-перелистывание по одной;<br/>
		 * JUMP-сразу пачкой.
		 */
		public var mode:String = JUMP;
		
		/**
		 * класс диплейОбжекта для прелоадера контента страниц
		 */
		public var preloaderIcon:Class;
		/**
		 * класс диплейОбжекта для для отображения облома загрузки
		 */
		public var errorIcon:Class;

		//приваты сеттеров
		private var _paper:BitmapData;
		private var _wheelLeaf:Boolean = true;
		private var _mouseLeaf:Boolean = true;
		private var _contentLeaf:Boolean = true;
		private var _turnSpeed:Number = 6;

		////////////////////////TEMPLATES
		private var _leftPage:PageTemplet = new PageTemplet();
		private var _rightPage:PageTemplet = new PageTemplet();
		private var _backSide:PageTemplet = new PageTemplet();
		private var _nextSide:PageTemplet = new PageTemplet();

		private var _backMask:PageMask=new PageMask();
		private var _nextMask:PageMask=new PageMask();
		private var _rightMask:PageMask = new PageMask();

		private var _shadow:Shape=new Shape();

		////////////////////////////DIMENTIONS
		private var _pageW:Number;
		private var _pageH:Number;
		private var _pageD:Number;
		private var _bookW:Number;

		////////////////////////////////CONTROLS
		private var _targetPoint:Point = new Point();
		private var _cornerPoint:Point = new Point();
		private var _autoPoint:Point = new Point();
		private var _bottomPoint:Point = new Point();
		private var _mouseDownPoint:Point;
		private var _pagePoints:Array;
		private var _flipTarget:int = -1;//-1 нет вертелки

		//////////////////////////////////FLAGS
		private var _dir:Boolean;
		private var _drag:Boolean=false;
		private var _changed:Boolean = false;//страница сменилась во время манипуляций
		
		//////////////////////////////////DECOR
		static private const SHADOW:DropShadowFilter = new DropShadowFilter(3, 140, 0x666666, 0.3, 16, 16);
		static private const GLOW:GlowFilter = new GlowFilter(0x666666, 0.5, 5, 5, 2, 3);
		static private const BLUR:BlurFilter = new BlurFilter(16, 16);

		/////////////////////////////////////DATA
		private var _currentPage:int=-1;
		private var _dataProvider:Array/*PageContent*/=[];
		
		//////////////////////////////////LOAD QUEUE
		private var _queueArr:Array;
		
		/**
		 * constructor
		 */
		public function Book(width:Number=0, height:Number=0)
		{
			_leftPage.filters = [GLOW];
			_rightPage.mask = _rightMask;
			_rightPage.filters = [GLOW];
			_nextSide.mask = _nextMask;
			_backSide.mask = _backMask;
			_backSide.filters = [SHADOW];
			_shadow.filters = [BLUR];

			addChild(_leftPage);
			addChild(_rightPage);
			addChild(_shadow);
			addChild(_nextSide);
			addChild(_backSide);
			addChild(_rightMask);
			addChild(_nextMask);
			addChild(_backMask);
			
			if (width && height)
			{
				setSize(width, height);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		/**
		 * установка размеров
		 * @param	pageWidth
		 * @param	pageHeight
		 */
		public function setSize(pageWidth:Number, pageHeight:Number):void
		{

			_pageW = pageWidth;
			_pageH = pageHeight;
			_pageD = Math.sqrt(_pageW * _pageW + _pageH * _pageH);
			_bookW = 2 * _pageW;

			_rightPage.x = _pageW;
			_nextSide.x = _pageW;

			_targetPoint = new Point(_bookW, _pageH);
			_cornerPoint = new Point(_bookW, _pageH);
			_autoPoint = null;

			_leftPage.y = _pageH;
			_rightPage.y = _pageH;
			_backSide.y = _pageH;
			_nextSide.y = _pageH;

			_rightPage.setSize(_pageW, _pageH);
			_leftPage.setSize(_pageW, _pageH);
			_backSide.setSize(_pageW, _pageH);
			_nextSide.setSize(_pageW, _pageH);

		}
		/**
		 * добавляет страницу(экземпляр PageContent) в конец
		 * @param	data
		 */
		public function addPage(data:PageContent):void
		{
			
			_dataProvider.push(data);
			startRender();
			//update();
			
			//добавляем индекс в очередь загрузки
			_queueArr.push(_dataProvider.length - 1 );
			//если очередь была пуста (загрузка закончилась уже), то стартуем загрузку
			if (_queueArr.length == 1)
			{
				loadCurrent();
			}
		}
		
		/**
		 * переход на страницу num 
		 * @param	num
		 */
		public function gotoPage(num:int):void
		{
			mode == JUMP ? jumpToPage(num) : leafToPage(num);
		}
		
		/**
		 * переход на следующую
		 */
		public function nextPage():void
		{
			jumpToPage(currentPage + 2);
		}
		
		/**
		 * переход на предыдущую
		 */
		public function prevPage():void
		{
			jumpToPage(currentPage-2);
		}
		
		/**
		 * переход последнюю страницу
		 */
		public function lastPage():void
		{
			gotoPage(length - 1);
		}
		
		/**
		 * переход на первую страницу
		 */
		public function firstPage():void
		{
			gotoPage(0);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//инициализация листенеров при добавлении на сцену
		private function onStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);

			if(_wheelLeaf) addEventListener(MouseEvent.MOUSE_WHEEL, omMouseWheel);
			if(_mouseLeaf) addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
		}

		//глобальный MouseUp
		private function onStageMouseUp(e:MouseEvent):void
		{
			
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseDrag);
			
			var rightSide:Boolean = (mouseX > _pageW);
			
			if (!_drag) return;//если отпускаем не по делу
			_drag = false;
			_targetPoint = new Point( rightSide ? 2 * _pageW : 0, _pageH);

			// меняем разворот, если отпустили на другой стороне
			if (_dir != rightSide)  {
				//TODO: посмотреть повнимательнее нужна ли проверка
				//if ((!rightSide && _currentPage <= length - 2) || (rightSide && _currentPage > 0))
				_currentPage += rightSide ? -2 : 2;
				dispatchEvent(new BookEvent(BookEvent.CHANGE_PAGE, _currentPage));
				_changed = true;

			}else {
				_dir = !_dir;
			}
		}

		//обработчик колеса мыши
		private function omMouseWheel(evnt:MouseEvent):void
		{
			evnt.delta < 0 ? nextPage() : prevPage();
		}
		
		//локальный MouseDown самой книги
		private function onMouseDown(e:MouseEvent):void
		{
			//ситуация: не ворочаем за кконтент и клик риходится на кого-то из детей
			if (!_contentLeaf && e.target != this) return;
			
			//стартуем переворачивание только если потянули, а иначе пусть будет клик или что там еще  надо
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseDrag);
		}
		
		//обработчик движения мыши в нажатом состоянии
		private function onMouseDrag(evnt:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseDrag);
			_dir = mouseX > _pageW;
			
			//некуда крутить
			if (_dir && currentPage > length - 3 || !_dir && currentPage == 0) return;
			
			_flipTarget = -1;
			_drag=true;
			_targetPoint=new Point(_dir ? 0 : _bookW, _pageH);
			_cornerPoint = new Point(_dir ? _bookW : 0, _pageH);

			//расставляем контент
			if (_dir)
			{
				setContent(currentPage+3, currentPage+2, currentPage, currentPage+1);
			}else{
				setContent(currentPage+1, currentPage, currentPage-2, currentPage-1);
			}
			startRender();// _needRender = true;
			render();
		}

		//расставляет битмапы по местам
		private function setContent(next:int, back:int, left:int, right:int):void
		{

			if (next > length-1) next = -1;
			if (back > length-1) back = -1;
			if (left > length-1) left = -1;
			if (right > length-1) right = -1;

			_nextSide.setContent(next);
			_backSide.setContent(back);
			_leftPage.setContent(left);
			_rightPage.setContent(right);

		}

		//переворот на заданную
		private function jumpToPage(page:int):void
		{

			if (running) return; //игнор во время переворота

			var dn:int = page - (page % 2) - currentPage;//на сколько вертеть (с учетом нечета)
			var valid:Boolean = dn != 0 && page >= 0 && page < length;

			if (!valid) return;//не надо ничего
			_dir = dn > 0;

			_autoPoint = new Point(0.25 * _pageW, _pageH / 2);
			_cornerPoint = new Point(_dir ? 2 * _pageW:0, _pageH);
			_targetPoint = new Point(_dir ? 0 : 2 * _pageW, _pageH);

			var oldPage:int = currentPage;
			currentPage += dn;
			if (_dir )
			{
				setContent(currentPage + 1, currentPage, oldPage, oldPage + 1);
			}else{

				setContent(oldPage + 1, oldPage, currentPage, currentPage + 1);
			}
			dispatchEvent(new BookEvent(BookEvent.CHANGE_PAGE, _currentPage));
			_changed = true;
			startRender();// _needRender = true;
			_flipTarget = -1;//прекращаем последовательное перелистывание

		}

		// старт перелистывания
		private function leafToPage(page:int):void
		{

			_flipTarget = 2 * Math.floor(page / 2);// совместимость с currentPage
			nextFlip();

		}
		//следующий шаг, если включена листалка
		private function nextFlip():void
		{
			if (_flipTarget == currentPage)
			{
				_flipTarget = -1;
				return;
			}

			var tmpTarget:int = _flipTarget;//jumpToPage обнуляет _flipTarget, а здесь этого не надо
			currentPage > _flipTarget ? prevPage() : nextPage();
			_flipTarget = tmpTarget;

		}

		private function startRender():void
		{
			addEventListener(Event.ENTER_FRAME, render);
		}

		private function stopRender():void
		{
			removeEventListener(Event.ENTER_FRAME, render);
		}

		private function render(e:Event=null):void
		{
			//TODO: искать, где рагьше сроку запускается render
			//if (!_dataProvider) return;

			var mtrx:Matrix;
			var gr:Graphics;

			//if (!_needRender)	return;

			if(_drag) {
				_targetPoint = _autoPoint || new Point(Math.max(0, Math.min(mouseX, _bookW - 8)), mouseY);
			}
			var pos:Number = _cornerPoint.x / _bookW;
			var easy:Number = 1 + (_dir ? 1.25 * pos : 1 - pos) * _turnSpeed;
			

			if(_autoPoint){
				_autoPoint.x += (_targetPoint.x - _autoPoint.x) / easy;
				_autoPoint.y += (_targetPoint.y - _autoPoint.y) / easy;
			}
			var  targ:Point = _autoPoint || _targetPoint;

			_cornerPoint.x += (targ.x - _cornerPoint.x) / easy;
			_cornerPoint.y += (targ.y - _cornerPoint.y) / easy;

			////////нижняя точка отрыва страницы////////////////////////////////////////////////////
			_bottomPoint = new Point(Math.max((_bookW + _cornerPoint.x)/2,_pageW),_pageH);// нельзя оторвать нижний переплет

			////центральный угол
			setDist(_cornerPoint, _bottomPoint, _bookW - _bottomPoint.x);//не дальше ширины..
			setDist(_cornerPoint, new Point(_pageW, 0), _pageD);//не дальще диагонали от верхнего переплета
			//разворачиваем-ставим
			_backSide.rotation = Math.max( -40, 180 / Math.PI * angle(_bottomPoint, _cornerPoint));
			_backSide.x = _cornerPoint.x;
			_backSide.y = _cornerPoint.y;

			//коррекция.. шаманство, канеш, но инче че-то никак
			var dPoint:Point = _backSide.pointToParent(new Point(_pageW, -_pageH));

			var corrX:Number = _pageW - dPoint.x;
			if(corrX>0){
				_backSide.x = _cornerPoint.x += corrX;
				_backSide.y = _cornerPoint.y -= dPoint.y;
				_bottomPoint.x += corrX;
			}

			_pagePoints = [new Point(0, 0), new Point(0, -_pageH), new Point(_pageW, -_pageH), new Point(_pageW, 0)];
			for (var i:int = 0; i < 4; i++)
			{
				_pagePoints[i] = _backSide.pointToParent(_pagePoints[i]);
			}

			var xR:Point = getRightCross();
			var xT:Point = getTopCross();

			//nextPage mask
			var nextMaskArr:Array = [_bottomPoint, new Point(_bookW, _pageH)];
			if(xR){
				nextMaskArr.push(xR);
			}else{
				nextMaskArr.push(new Point(_bookW, 0));
				nextMaskArr.push(xT);
			}
			_nextMask.drawPoly(nextMaskArr);

			//_backSide mask
			var backMaskArr:Array = [_cornerPoint, _bottomPoint];
			if(xR){
				backMaskArr.push(xR);
			}else{
				backMaskArr.push(xT);
				backMaskArr.push(_pagePoints[1]);
			}
			_backMask.drawPoly(backMaskArr);

			//_rightPage mask
			var backCover:Boolean = _backSide.page == length - 1;

			var rightMaskArr:Array = [new Point(_pageW, 0), new Point(_pageW, _pageH)];
			if (backCover)
			{
				rightMaskArr.push(_bottomPoint);
				if (xR) rightMaskArr.push(xR,new Point(_bookW, 0));
				rightMaskArr.push(xT);

			}else
			{
				rightMaskArr.push(new Point(_bookW, _pageH), new Point(_bookW, 0));

			}

			_rightMask.drawPoly(rightMaskArr);

			////SHADOW
			var kAdabt:Number = _cornerPoint.x < _pageW ? _cornerPoint.x / _pageW : 1;

			var sw:Number = Point.distance(_cornerPoint, _bottomPoint);
			var sw1:Number = xR ? 0 : Point.distance(xT, _pagePoints[1]);
			sw *= kAdabt;
			sw1 *= kAdabt;
			var sh:Number = Point.distance(_bottomPoint, xR || xT);

			_shadow.rotation = 270 + 180 / Math.PI * angle(_bottomPoint, xR || xT);

			var fi:Number = -Math.PI / 180 * _shadow.rotation;

			mtrx= new Matrix();
			mtrx.createGradientBox(sw, sh, fi, 0, 0);

			gr = _shadow.graphics;
			gr.clear();
			gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0.1, 0], [0x00, 0xCC],	mtrx);
			gr.lineTo(sw, 0);
			gr.lineTo(sw1, -sh);
			gr.lineTo(0, -sh);
			gr.lineTo(0, 0);
			gr.endFill();
			_shadow.x = _bottomPoint.x;
			_shadow.y = _bottomPoint.y;

			//////SHADE

			var maxAlpha:Number=_cornerPoint.x/_pageW;//макс. альфа
			var tp:Point=backMaskArr[3]||backMaskArr[2];
			fi= Math.atan2(backMaskArr[2].x+tp.x-_bottomPoint.x-_cornerPoint.x,backMaskArr[2].y+tp.y-_bottomPoint.y-_cornerPoint.y);
			sw=Math.max(Point.distance(_bottomPoint,_cornerPoint),Point.distance(_pagePoints[1],xT))+10;
			sh = _pageH;

			gr = _backSide.shade.graphics;
			gr.clear();
			mtrx = new Matrix();
			mtrx.createGradientBox(sw, sh, fi, 0, 0);
			gr.beginGradientFill(GradientType.LINEAR,	[0, 0xFFFFFF, 0], [0.05, 0.25 * kAdabt, 0.05], [0, 0x66, 0xff],	mtrx );
			gr.moveTo( -5, 0);
			gr.lineTo(sw, 0);
			gr.lineTo(sw, sh);
			gr.lineTo( -5, sh);
			gr.lineTo( -5, 0);
			gr.endFill();
			gr.endFill();

			//нет драга, BR приехал, TR довернулся до нормального угла
			if (!_drag && Point.distance(_cornerPoint, _targetPoint) < 1 && _shadow.rotation >= 0)
			{

				currentPage = _currentPage;
				_autoPoint = null;
				_shadow.graphics.clear();

				//если приехали на другую станицу, диспатчим событие
				if (_changed) {
					dispatchEvent(new BookEvent(BookEvent.FLIP, currentPage));
					_changed = false;
					
				}

				//TODO:без render() дергается все, надо разбираться: рекурсия как бы некомильфо
				if (_flipTarget >= 0) //если включена последовательная листалка, запускаем следующий переворот
				{

					nextFlip();
					_backMask.clear();
					_nextMask.clear();
					render();
					
				}else//или останавливаем все
				{
					setContent( -1, -1, _currentPage, _currentPage + 1);
					stopRender();
				}

			}
		}
		//*************************************
		//			UTILS
		//*************************************

		//подвигает t к p если та дальше от нее чем d
		private function setDist(t:Point, p:Point, d:Number):void
		{
			var r:Number=Point.distance(t,p);
			var fi:Number=angle(t,p);
			if(r>d ) {
				t.x=p.x+d*Math.cos(fi);
				t.y=p.y+d*Math.sin(fi);
			}
		}

		//направление p1 на p2, радианы
		private function angle(p1:Point, p2:Point):Number
		{
			return Math.atan2(p1.y-p2.y,p1.x-p2.x);
		}

		//пересечение с верхней кромкой
		private function getTopCross():Point
		{
			var p3:Point = _pagePoints[1];
			var p4:Point = _pagePoints[2];
			var x:Number;
			if(Math.abs(p4.y-p3.y)<30) {
				x = _bottomPoint.x + (_pagePoints[1].x - _pagePoints[0].x) / 2;
			}else{
				var b:Number = (p4.y - p3.y) / (p4.x - p3.x);
				var a:Number = p3.y - b * p3.x;
				x = -a / b;
			}
			if(x<_pageW)x=_pageW;
			return new Point(x,0);
		}

		//пересечение с правой кромкой
		private function getRightCross():Point
		{
			var p3:Point = _pagePoints[0];
			var p4:Point = _pagePoints[1];
			if (p4.x == p3.x) return p4.x == 2 * _pageW ? new Point(_bookW, 0) : null;
			var b:Number = (p4.y - p3.y) / (p4.x - p3.x);
			var p:Point = new Point(2 * _pageW, p3.y + b * (2 * _pageW - p3.x));
			if (p.y<0 || p.y>_pageH) return null;
			return p;
		}

		

		//****************************************
		//			LOADING QUEUE
		//****************************************
		//создает очередь загрузки и запускает, если есть чего
		private function createQueue():void
		{
			_queueArr = [];
			var data:PageContent;
			for (var i:int = 0; i < _dataProvider.length; i++)
			{
				data = _dataProvider[i];
				//если есть урл, пихаем в очередь
				if (data && data.url)_queueArr.push(i);
			}
			if (_queueArr.length)
			{
				_queueArr.sort(sortFunction);
				loadCurrent();
			}
			
			
			
		}
		//грузит первую из очереди
		private function loadCurrent():void
		{
			
				
			var content:PageContent = _dataProvider[_queueArr.shift()];
			
			content.addEventListener(Event.COMPLETE, shiftQueue);
			content.addEventListener(IOErrorEvent.IO_ERROR, shiftQueue);
			
			
			
			content.load();
			
			
		}
		
		//обработчик зпгрузки/ошибки 
		private function shiftQueue(evnt:Event):void
		{
			evnt.target.removeEventListener(Event.COMPLETE, shiftQueue);
			evnt.target.removeEventListener(IOErrorEvent.IO_ERROR, shiftQueue);
			
			PageContent(evnt.target).centerLoaderContent(pageWidth, pageHeight);
			
			
			
			if (_queueArr.length) 
			{
				_queueArr.sort(sortFunction);
				loadCurrent();
			}

		}
		
		

		//по удаленности от текущей
		private function sortFunction(a:int, b:int):Number
		{
			return Math.abs(currentPage - a) < Math.abs(currentPage - b) ? -1 : 1;
		}

		//************************************************************
		//		GET_SET PROPS
		//*************************************************************
		/**
		 * ширина листа
		 */
		public function get pageWidth():Number { return _pageW; }
		/**
		 * высота листа
		 */
		public function get pageHeight():Number { return _pageH; }

		/**
		 * текущая  левая страница (0,2,4..)
		 */
		public function get currentPage():int { return _currentPage; }
		public function set currentPage(value:int):void
		{
			//отсчет всегда по левой четной
			value = value - value % 2;
			if (value != _currentPage)
			{
				_currentPage = value;
				setContent( -1, -1, _currentPage, _currentPage + 1);
				//render();
				dispatchEvent(new BookEvent(BookEvent.CHANGE_PAGE, _currentPage));
			}
		}
		/**
		 * общее число страниц (включая отсутствующие - нулевую, например )
		 */
		public function get length():int { return _dataProvider.length; }

		/**
		 * массив PageContent 
		 */
		public function get dataProvider():Array/*PageContent*/ { return _dataProvider; }
		public function set dataProvider(value:Array/*PageContent*/):void
		{
			_dataProvider = value;
			//спускаем ссылку темплетам
			_leftPage.dataProvider = value;
			_rightPage.dataProvider = value;
			_backSide.dataProvider = value;
			_nextSide.dataProvider = value;
			
			//определяем мувики прелоадера и ишибки загрузки, если есть
			var preloader:DisplayObject;
			var error:DisplayObject;
			
			
			for (var i:int = 0; i < _dataProvider.length; i++) 
			{
				var pageContent:PageContent = _dataProvider[i];
				if (pageContent && pageContent.url) {
					if (preloaderIcon)
					{
						preloader = new preloaderIcon();
						preloader.x = pageWidth / 2;
						preloader.y = pageHeight / 2;
						pageContent.preloaderIcon = preloader;
					}
					if (errorIcon)
					{
						error = new errorIcon();
						error.x = pageWidth / 2;
						error.y = pageHeight / 2;
						pageContent.errorIcon = error;
					}
					
				}
			}
			
			//запускаем загрузку
			createQueue();
			//включаем обсчет
			startRender();
		}

		/**
		 * темп переворачивания в диапазоне 0...10 (default 5); <br/>
		 * 0 - без анимации.
		 */
		public function get speed():Number { return 11 - _turnSpeed; }
		public function set speed(value:Number):void
		{

			_turnSpeed = 11 - value;
			
			if (_turnSpeed < 0 || _turnSpeed >= 11)
			{
				_turnSpeed = 0;
			}

		}
		/**
		 * true если страница в состоянии автопереворота
		 */
		public function get running():Boolean {
			return _autoPoint != null;
		}
		
		/**
		 *
		 * BitmapData "бумаги" (подложки всех страниц)
		 */
		public function get paper():BitmapData { return _paper; }
		public function set paper(value:BitmapData):void
		{
			_paper = value;

			_leftPage.paper = value;
			_rightPage.paper = value;
			_backSide.paper = value;
			_nextSide.paper = value;
		}
		
		/**
		 * надо ли листать колесом мыши
		 */
		public function get wheelLeaf():Boolean { return _wheelLeaf; }
		public function set wheelLeaf(value:Boolean):void
		{
			_wheelLeaf = value;
			_wheelLeaf ? addEventListener(MouseEvent.MOUSE_WHEEL, omMouseWheel) : removeEventListener(MouseEvent.MOUSE_WHEEL, omMouseWheel);

		}
		/**
		 * надо ли листать мышкой
		 */
		public function get mouseLeaf():Boolean { return _mouseLeaf; }
		public function set mouseLeaf(value:Boolean):void 
		{
			_mouseLeaf = value;
			_mouseLeaf ? addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown) : removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		/**
		 * надо ли листать при клике-драге по активному (mouseEnabled=true) коненту страниц
		 */
		public function get contentLeaf():Boolean { return _contentLeaf; }
		public function set contentLeaf(value:Boolean):void 
		{
			_contentLeaf = value;
			
		}

		

	}

}
