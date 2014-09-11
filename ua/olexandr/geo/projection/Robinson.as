/**
 * @author AS3Coder
 */

package ua.olexandr.geo.projection {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class Robinson {
		
		private var _pdfeArr:Array;
		private var _plenArr:Array;
		private var _target:DisplayObject;
		
		function Robinson(map:DisplayObject) {
			_pdfeArr = getPDFEArray();
			_plenArr = getPLENArray();
			_target = map;
		}
		
		/**
		 * Метод конвертирует географические координаты в декартовы
		 * @param	latitude 	<Number>		Широта
		 * @param	longitude 	<Number>		Долгота
		 * @return				<Point>			Декартовы координаты
		 */
		public function convert(latitude:Number, longitude:Number):Point {
			var xnu:Number;
			var ynu:Number;
			
			var cnu:Number;
			var hnu:Number;
			var nnu:Number;
			var snu:Number;
			var fnu:Number;
			var wnu:Number;
			var pnu:Number;
			var enu:Number;
			var vnu:Number;
			var gnu:Number;
			var tnu:Number;
			var jnu:Number;
			
			var lat:Number;
			var lon:Number;
			var ltn:Number;
			var lnn:Number;
			
			var znu:Number;
			
			var middle_num:Number;
			var center_num:Number;
			var padding_num:Number;
			
			middle_num = (_target.height / 100) * 49.980747015787447054293415479399;
			center_num = (_target.width / 100) * 47.2412109375;
			padding_num = (_target.width / 100) * 2.7587890625;
			
			lat = Math.abs(latitude);
			ltn = getLatitudeReduction(lat, 2);
			lon = Math.abs(longitude);
			
			jnu = Math.floor(lat);
			znu = Math.round(ltn * 100);
			cnu = _pdfeArr[znu];
			
			hnu = middle_num * cnu;
			nnu = middle_num - hnu;
			snu = middle_num + hnu;
			ynu = latitude < 0 ? snu : nnu;
			
			fnu = _plenArr[znu];
				
			tnu = _target.width / 2;
			wnu = tnu * fnu;
			pnu = (wnu / 180) * lon;
			
			gnu = (center_num + padding_num) - (padding_num * fnu);
				
			enu = gnu + pnu;
			vnu = gnu - pnu;
			xnu = longitude < 0 ? vnu : enu;
			
			return new Point(xnu, ynu);
		}
		
		/**
		 * Метод собирает и возвращает массив пропорций изменения величины широты
		 * @return				<Array>			Массив с пропорциями
		 */
		private function getPDFEArray():Array {
			var arr:Array;
			var brr:Array;
			
			var a:Number;
			var b:Number;
			var c:Number;
			var d:Number;
			var l:Number;
			
			arr = [];
			brr = [];
			brr[0] = 0.0000;
			brr[1] = 0.0620;
			brr[2] = 0.1240;
			brr[3] = 0.1860;
			brr[4] = 0.2480;
			brr[5] = 0.3100;
			brr[6] = 0.3720;
			brr[7] = 0.4340;
			brr[8] = 0.4958;
			brr[9] = 0.5571;
			brr[10] = 0.6176;
			brr[11] = 0.6769;
			brr[12] = 0.7346;
			brr[13] = 0.7903;
			brr[14] = 0.8435;
			brr[15] = 0.8936;
			brr[16] = 0.9394;
			brr[17] = 0.9761;
			brr[18] = 1.0000;
			
			l = brr.length;
			for (var i:int = 0; i < l; i++){
				arr.push(brr[i]);
				for (var q:Number = 1; q < 500; q++){
					a = brr[i + 1];
					b = brr[i];
					c = (a - b) / 500;
					d = b + c * q;
					arr.push(d)
				}
			}
			
			return arr;
		}
		
		/**
		 * Метод собирает и возвращает массив пропорций изменения величины долготы
		 * @return				<Array>			Массив с пропорциями
		 */
		private function getPLENArray():Array {
			var arr:Array;
			var brr:Array;
			var a:Number;
			var b:Number;
			var c:Number;
			var d:Number;
			var l:Number;
			
			arr = [];
			brr = [];
			brr[0] = 1.0000;
			brr[1] = 0.9986;
			brr[2] = 0.9954;
			brr[3] = 0.9900;
			brr[4] = 0.9822;
			brr[5] = 0.9730;
			brr[6] = 0.9600;
			brr[7] = 0.9427;
			brr[8] = 0.9216;
			brr[9] = 0.8962;
			brr[10] = 0.8679;
			brr[11] = 0.8350;
			brr[12] = 0.7986;
			brr[13] = 0.7597;
			brr[14] = 0.7186;
			brr[15] = 0.6732;
			brr[16] = 0.6213;
			brr[17] = 0.5722;
			brr[18] = 0.5322;
			l = brr.length;
			for (var i:int = 0; i < l; i++) {
				arr.push(brr[i]);
				for (var q:int = 1; q < 500; q++) {
					a = brr[i];
					b = brr[i + 1];
					c = (b - a) / 500;
					d = a + c * q;
					arr.push(d)
				}
			}
			
			return arr;
		}
		
		/**
		 * Метод сокращает и возвращает значение широты до указанной
		 * @param	latitude 	<Number>		Широта
		 * @param	reduction 	<Number>		Величина сокращения
		 * @return				<Number>
		 */
		private function getLatitudeReduction(latitude:Number, reduction:Number):Number {
			var str:String;
			
			str = '' + latitude;
			for (var i:int = 0; i < (str.length); i++){
				if (str.charAt(i) == '.')
					return Number(str.substr(0, i + reduction + 1))
			}
			
			return latitude;
		}
		
	}
}