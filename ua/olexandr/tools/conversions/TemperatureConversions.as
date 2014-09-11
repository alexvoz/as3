package ua.olexandr.tools.conversions {
	/**
	 * ...
	 * @author @author Olexandr Fedorow,
	 * @copy Copyright (c) 2012
	 * @link http://www.olexandr.org
	 * @link www.olexandr@gmail.com
	 * @version 0.1
	 */
	public class TemperatureConversions {
		
		// °C = (°F - 32) * (5 / 9)
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function fehrenheitToCelsius(temp:Number):Number {
			return (temp - 32) * (9 / 5); ﻿
		}
		
		// °F = (°C * (9 / 5)) + 32
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function celsiusToFehrenheit(temp:Number):Number {
			return (temp * (9 / 5)) + 32;﻿  
		}
		
		// °K = ((°F - 32) * (5 / 9)) - 273
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function fehrenheitToKelvin(temp:Number):Number {
			return celsiusToKelvin(fehrenheitToCelsius(temp));﻿  
		}
		
		// °K = °C + 273
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function celsiusToKelvin(temp:Number):Number {
			return temp - 273;﻿
		}
		
		// °F = ((°K + 273) * (9 / 5)) + 32
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function kelvinToFehrenheit(temp:Number):Number {
			return celsiusToFehrenheit(kelvinToCelsius(temp));﻿
		}
		
		// °C = °K + 273
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function kelvinToCelsius(temp:Number):Number {
			return temp + 273;
		}
		
		// °R = °F - 459.67
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function fehrenheitToRankine(temp:Number):Number {
			return temp - 459.67;﻿
		}
		
		// °R = (°C * (9 / 5)) + 32) - 459.67
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function celciusToRankine(temp:Number):Number {
			return celsiusToFehrenheit(temp) - 459.67;﻿
		}
		
		// °R = ((°K + 273) * (9 / 5)) + 32) - 459.67
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function kelvinToRankine(temp:Number):Number {
			return celciusToRankine(kelvinToCelsius(temp));﻿
		}
		
		// °F = ((°K + 273) * (9 / 5)) + 32
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function rankineToFehrenheit(temp:Number):Number {
			return temp + 459.67;
		}
		
		// °C =((°R + 459.67) - 32) * (5 / 9)
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function rankineToCelsius(temp:Number):Number {
			return fehrenheitToCelsius(rankineToFehrenheit(temp));
		}
		
		// °K = °R + 273
		/**
		 * 
		 * @param	temp
		 * @return
		 */
		[Inline]
		public static function rankineToKelvin(temp:Number):Number {
			return fehrenheitToKelvin(rankineToFehrenheit(temp));﻿
		}
		
	}

}

