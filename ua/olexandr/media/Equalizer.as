package ua.olexandr.media {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class Equalizer extends Sprite {
		private var _template:Array;
		private var _equaGraph:BitmapData;			// Здесь будет вырисовываться изображение
		private var _oldData:Array = new Array();	// Здесь будут результаты прредыдущего частотного анализа
		private var _rowCol:uint;					// Цвет колонок
		private var _bgCol:uint;					// Цвет фона
		private var _wRow:int;						// Ширина колонки
		private var _nRow:int;						// Кол-во колонок
		private var _w:int;							// Ширина
		private var _h:int;							// Высота
		private var _K:int;							// Коэфициент (чем > тем столбцы взлетают выше)
		
		/* Описываем функцию - конструктор класса
		Параметры: 
			ширина					- int	пикс		рекомменд. ширина = (ширина столбца + 1)*число столбцов + 1)
			высота					- int	пикс
			ширина столбца			- int	пикс
			число столбцов			- int	пикс		1 - 127
			цвет фона				- uint	16			0x[FF]FFFFFF	0xFF[FFFFFF]
			цвет столбцов			- uint	16			Прозрачность	Цвет RGB
			[задержка обновления]	- int	Милисекунд	рекоменд. задержка обновления = 30 милисек.
			[коэфициент]			- int	чем > тем столбцы взлетают выше    рекоменд. коэфициент < высота/10
		*/
		public function Equalizer(w:int,h:int,wRow:int,nRow:int,bgCol:uint,rowCol:uint,refDelay:int = 30, K:int = 10) {
			_template = [];
			for (var i:int = 0; i < 512; i++)
				_template[i] = 0;
			
			_bgCol = bgCol;		//Сохраним переданные значения
			_rowCol = rowCol;	//в переменных класса
			_wRow = wRow;
			_nRow = nRow;
			_w = w;
			_h = h;
			_K = K;
			
			
			_equaGraph = new BitmapData(_w, _h, true, _bgCol);	// Создаем изображение нужного размера
															// и цвета фона
			
			var bitmap:Bitmap = new Bitmap(_equaGraph);		// Прорисовываем наш рисунок на экране
			addChild(bitmap);								// и делаем его видимым
			
			var timer:Timer = new Timer(refDelay);					// Создаем новый обьект класса Timer
			timer.addEventListener(TimerEvent.TIMER, onTimer);		// задаем функцию - слушатель события
			timer.start();											// и запускаем таймер.
																	// В качестве параметра Timer принимает
																	// необходимый интервал в милисекундах.
		}
		
		/*Описываем функцию - слушатель события таймера.
		Она будет обновлять показания эквалайзера
		В параметрах, принимаемых функцией необходимо указать
		переменную типа TimerEvent, если этого не сделать - получим ошибку выполнения.
		*/
		private function onTimer(event:TimerEvent):void {
			var spectrum:ByteArray = new ByteArray();	// Объявляем переменную - контейнер для данных 
														// о проигрываемой звуковой волне.
			var array:Array = _template.concat();		// Массив, в который будет расшифровываться байтовый.
													// массив spectrum, это будет делать функция byteToReal.
			
			try {
				SoundMixer.computeSpectrum(spectrum);	// Считываем данные о спектральном составе звука в контейнер.
														// Этот метод возвращает байтовый массив (byteArray), 
														// в котором содержатся 512 значений одиночной точности (float),
														// 1-ые 256 для левого канала, 2-ые 256 для правого.
														// Каждое float - число состоит из 4 байтов, итого 512*4=2048байт
				array = byteToReal(spectrum);			// Расшифровываем байтовые данные в массив array.
			} catch (e:Error) {
				trace(e.message)
			}
			
			array = FFT(array, 256);				// Производим быстрое преобразование Фурье для расшифрованой
													// звуковой волны. Оно возвращает массив пар комплексных чисел
													// так, что a[n]=Re(z), а a[n+1]=Im(z) при четном n>0.
													// a[0] и a[1] - служебные значения. Они не нужны.
			array = сomplexToReal(array);			// Переводим комплексные пары в вещественные числа.
													// Результатом будет массив из 127 вещественых чисел.
			
			
			_equaGraph.fillRect(_equaGraph.rect, _bgCol); // Очищаем изображение эквалайзера

			for (var s:int = 0; s<_nRow; s++) {	// Запускаем цикл, отрисовывающий nRow столбцов эквалайзера
			// Отрисовываем каждый столбец как прямоугольник, считывая каждую четную ячейку массива (начиная со 2),
			// т.к функция преобразования Фурье фозвращает комплексные числа, вещественная часть которых
			// находится в четных ячейках, а мнимая в нечетных. Используется только вещественная часть.
			// Считанные значения усредняются с массивом, сохраненном в памяти при предыдущем проходе и умножаются на K.
				_equaGraph.fillRect(new Rectangle(s*(_wRow+1)+1, _h-1-(Math.abs(_oldData[s])+Math.abs(array[s]))*_K,_wRow,(Math.abs(_oldData[s])+Math.abs(array[s]))*_K), _rowCol);
			}
			_oldData = array; 	// Копируем массив в переменную. При следующем вызове onTimer значения 
								// из этого и обновленного массивов будут усреднены (среднее арифметическое).
								// Это немного сгладит эквалайзер и сделает его приятней на вид :)
		}
		
		/*Описываем функцию, которая будет расшифровывать байтовые данные от computeSpectrum.
		В качестве параметра она принимает байтовый массив.
		Возвращает массив из 256 значений (соответствующие значения для левого и правого канала усреднены)
		*/
		private function byteToReal(arr:ByteArray):Array {
			var realArr:Array = new Array();		// Создаем массив для результата расшифровки
			for (var i:int=0; i<256; i++) {			// Расшифровываем первые 256 значений - левый канал
				realArr[i] = arr.readFloat();
			}
			for (var k:int=0; k<256; k++) {						// Расшифровываем остальные 256 значений - правый
				realArr[k] = (arr.readFloat() + realArr[k]) / 2;// Здесь значения для левого и правого канала 
																// складываются и делятся на 2 (среднее арифметическое)
			}
			return realArr;	//Возвращаем результат
		}
		
		/*Описываем функцию, которая будет переводить комплексные пары в вещественные
		В качестве параметра она принимает массив пар вещ. число - мнимое число.
		Возвращает массив из 127 значений
		*/
		private function сomplexToReal(arr:Array):Array {
			// i = 1 т.к 0 и 1 ячейки массива - служебные
			for (var i:int = 1; i <= 128; i++)
				arr[i - 1] = Math.sqrt(arr[i * 2] * arr[i * 2] + arr[i * 2 + 1] * arr[i * 2 + 1]);//Находим модуль комплексного числа
			
			arr.splice(127);	// Отрезаем от массива лишние элементы, начиная от 127
			return arr;
		}
		
		/* Данная функция будет просчитывать быстрое преобразование фурье
		Она была переведена с исходника на языке Pascal.
		В качестве 1го параметра принимает массив со значениями звуковой волны
		2-й параметр - число элементов в передаваемом массиве. Оно обязательно должно быто степенью двойки
		для данной функции.
		Возвращает массив комплексных значений амплитуды на соответствующих частотах.
		Комментировать ее не стану.
		*/
		private function FFT(a:Array, tnn:int):Array {
			if (a[1] + a[128] == 0) {
				return a;
			}
			var twr:Number;
			var twi:Number;
			var twpr:Number;
			var twpi:Number;
			var twtemp:Number;
			var ttheta:Number;
			var i:int;
			var i1:int;
			var i2:int;
			var i3:int;
			var i4:int;
			var c1:Number;
			var c2:Number;
			var h1r:Number;
			var h1i:Number;
			var h2r:Number;
			var h2i:Number;
			var wrs:Number;
			var wis:Number;
			var nn:int;
			var ii:int;
			var jj:int;
			var n:int;
			var mmax:int;
			var m:int;
			var j:int;
			var istep:int;
			var isign:int;
			var wtemp:Number;
			var wr:Number;
			var wpr:Number;
			var wpi:Number;
			var wi:Number;
			var theta:Number;
			var tempr:Number;
			var tempi:Number;
			var tmp:Number;
			
			ttheta = 2 * Math.PI / tnn;
			c1 = .5;
			c2 = -.5;
			
			isign = 1;
			
			n = tnn;
			nn = tnn / 2;
			j = 1;
			ii = 1;
			while (ii <= nn) {
				i = 2 * ii - 1;
				if (j > i) {
					tempr = a[j - 1];
					tempi = a[j];
					a[j - 1] = a[i - 1];
					a[j] = a[i];
					a[i - 1] = tempr;
					a[i] = tempi;
				}
				m = nn;
				while (m >= 2 && j > m) {
					j = j - m;
					m = m / 2;
				}
				j = j + m;
				ii++;
			}
			mmax = 2;
			while (n > mmax) {
				istep = 2 * mmax;
				theta = 2 * Math.PI / (isign * mmax);
				tmp = Math.sin(0.5 * theta);
				wpr = -2 * tmp * tmp;
				wpi = Math.sin(theta);
				wr = 1;
				wi = 0;
				ii=1;
				while (ii <= mmax / 2) {
					m = 2 * ii - 1;
					jj = 0;
					while (jj <= (n - m) / istep) {
						i = m + jj * istep;
						j = i + mmax;
						tempr = wr * a[j - 1] - wi * a[j];
						tempi = wr * a[j] + wi * a[j - 1];
						a[j - 1] = a[i - 1] - tempr;
						a[j] = a[i] - tempi;
						a[i - 1] = a[i - 1] + tempr;
						a[i] = a[i] + tempi;
						jj++;
					}
					wtemp = wr;
					wr = wr * wpr - wi * wpi + wr;
					wi = wi * wpr + wtemp * wpi + wi;
					ii++;
				}
				mmax = istep;
			}
			
			
			tmp = Math.sin(.5 * ttheta);
			twpr = -2 * tmp * tmp;
			twpi = Math.sin(ttheta);
			twr = 1 + twpr;
			twi = twpi;
			i=2;
			while (i <= tnn / 4 + 1) {
				i1 = i + i - 2;
				i2 = i1 + 1;
				i3 = tnn + 1 - i2;
				i4 = i3 + 1;
				wrs = twr;
				wis = twi;
				h1r = c1 * (a[i1] + a[i3]);
				h1i = c1 * (a[i2] - a[i4]);
				h2r = -c2 * (a[i2] + a[i4]);
				h2i = c2 * (a[i1] - a[i3]);
				a[i1] = h1r + wrs * h2r - wis * h2i;
				a[i2] = h1i + wrs * h2i + wis * h2r;
				a[i3] = h1r - wrs * h2r + wis * h2i;
				a[i4] = -h1i + wrs * h2i + wis * h2r;
				twtemp = twr;
				twr = twr * twpr - twi * twpi + twr;
				twi = twi * twpr + twtemp * twpi + twi;
				i++;
			}
			h1r = a[0];
			a[0] = h1r + a[1];
			a[1] = h1r - a[1];

			return a;
		}
	}
}