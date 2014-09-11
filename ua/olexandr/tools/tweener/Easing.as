package ua.olexandr.tools.tweener {
	
	public class Easing {
		
		private static const HALF_PI:Number = Math.PI * .5;
		private static const TWO_PI:Number = Math.PI * 2;
		
		public static function init():void {
			Tweener.registerEase("easenone", none);
			Tweener.registerEase("linear", none);
			
			Tweener.registerEase("easeinquad", quadIn);
			Tweener.registerEase("easeoutquad", quadOut);
			Tweener.registerEase("easeinoutquad", quadInOut);
			Tweener.registerEase("easeoutinquad",	quadInOut);
			
			Tweener.registerEase("easeincubic", cubicIn);
			Tweener.registerEase("easeoutcubic", cubicOut);
			Tweener.registerEase("easeinoutcubic", cubicInOut);
			Tweener.registerEase("easeoutincubic", cubicOutIn);
			
			Tweener.registerEase("easeinquart", quartIn);
			Tweener.registerEase("easeoutquart", quartOut);
			Tweener.registerEase("easeinoutquart", quartInOut);
			Tweener.registerEase("easeoutinquart", quartOutIn);
			
			Tweener.registerEase("easeinquint", quintIn);
			Tweener.registerEase("easeoutquint", quintOut);
			Tweener.registerEase("easeinoutquint", quintInOut);
			Tweener.registerEase("easeoutinquint", quintOutIn);
			
			Tweener.registerEase("easeinsextic", sexticIn);
			Tweener.registerEase("easeoutsextic", sexticOut);
			Tweener.registerEase("easeinoutsextic", sexticInOut);
			Tweener.registerEase("easeoutinsextic", sexticOutIn);
			
			Tweener.registerEase("easeinsine", sineIn);
			Tweener.registerEase("easeoutsine", sineOut);
			Tweener.registerEase("easeinoutsine", sineInOut);
			Tweener.registerEase("easeoutinsine",	sineOutIn);
			
			Tweener.registerEase("easeinexpo", expoIn);
			Tweener.registerEase("easeoutexpo", expoOut);
			Tweener.registerEase("easeinoutexpo", expoInOut);
			Tweener.registerEase("easeoutinexpo", expoOutIn);
			
			Tweener.registerEase("easeincirc", circIn);
			Tweener.registerEase("easeoutcirc", circOut);
			Tweener.registerEase("easeinoutcirc", circInOut);
			Tweener.registerEase("easeoutincirc",	circOutIn);
			
			Tweener.registerEase("easeinelastic", elasticIn);
			Tweener.registerEase("easeoutelastic", elasticOut);
			Tweener.registerEase("easeinoutelastic", elasticInOut);
			Tweener.registerEase("easeoutinelastic", elasticOutIn);
			
			Tweener.registerEase("easeinback", backIn);
			Tweener.registerEase("easeoutback", backOut);
			Tweener.registerEase("easeinoutback", backInOut);
			Tweener.registerEase("easeoutinback", backOutIn);
			
			Tweener.registerEase("easeinbounce", bounceIn);
			Tweener.registerEase("easeoutbounce", bounceOut);
			Tweener.registerEase("easeinoutbounce", bounceInOut);
			Tweener.registerEase("easeoutinbounce", bounceOutIn);
		}
		
		
		/**
		 * @param	t — текущее время
		 * @param	b — начальное значение x (обычно 0)
		 * @param	c — конечное значения x (обычно 1)
		 * @param	d — общая протяженность анимации
		 * @param	params
		 * @return
		 */
		
		/**
		 * with no easing.
		 */
		[Inline]
		public static function none(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * t / d + b;
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function quadIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * (t /= d) * t + b;
		}
		
		/**
		 * decelerating to zero velocity.
		 */
		[Inline]
		public static function quadOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * (t /= d) * (t - 2) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function quadInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return c * .5 * t * t + b;
			return -c * .5 * ((--t) * (t - 2) - 1) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function quadOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return quadOut(t * 2, b, c * .5, d, params);
			return quadIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function cubicIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * (t /= d) * t * t + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function cubicOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function cubicInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return c * .5 * t * t * t + b;
			return c * .5 * ((t -= 2) * t * t + 2) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function cubicOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return cubicOut(t * 2, b, c * .5, d, params);
			return cubicIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function quartIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * (t /= d) * t * t * t + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function quartOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function quartInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return c * .5 * t * t * t * t + b;
			return -c * .5 * ((t -= 2) * t * t * t - 2) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function quartOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return quartOut(t * 2, b, c * .5, d, params);
			return quartIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function quintIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * (t /= d) * t * t * t * t + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function quintOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function quintInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return c * .5 * t * t * t * t * t + b;
			return c * .5 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function quintOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return quintOut(t * 2, b, c * .5, d, params);
			return quintIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function sexticIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * (t /= d) * t * t * t * t * t + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function sexticOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * ((t = t / d - 1) * t * t * t * t * t - 1) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function sexticInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return c * .5 * t * t * t * t * t * t + b;
			return -c * .5 * ((t -= 2) * t * t * t * t * t - 2) + b;
			
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function sexticOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return sexticOut(t * 2, b, c * .5, d, params);
			return sexticIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function sineIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * Math.cos(t / d * HALF_PI) + c + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function sineOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * Math.sin(t / d * HALF_PI) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function sineInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * .5 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function sineOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return sineOut(t * 2, b, c * .5, d, params);
			return sineIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function expoIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function expoOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return (t == d) ? b + c : c * 1.001 * (-Math.pow(2, -10 * t / d) + 1) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function expoInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t == 0)
				return b;
			if (t == d)
				return b + c;
			if ((t /= d * .5) < 1)
				return c * .5 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
			return c * .5 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function expoOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return expoOut(t * 2, b, c * .5, d, params);
			return expoIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function circIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function circOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function circInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d * .5) < 1)
				return -c * .5 * (Math.sqrt(1 - t * t) - 1) + b;
			return c * .5 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function circOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return circOut(t * 2, b, c * .5, d, params);
			return circIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function elasticIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t == 0)
				return b;
			if ((t /= d) == 1)
				return b + c;
			var p:Number = !Boolean(params) || isNaN(params.period) ? d * .3 : params.period;
			var s:Number;
			var a:Number = !Boolean(params) || isNaN(params.amplitude) ? 0 : params.amplitude;
			if (!Boolean(a) || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			} else {
				s = p / TWO_PI * Math.asin(c / a);
			}
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p)) + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function elasticOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t == 0)
				return b;
			if ((t /= d) == 1)
				return b + c;
			var p:Number = !Boolean(params) || isNaN(params.period) ? d * .3 : params.period;
			var s:Number;
			var a:Number = !Boolean(params) || isNaN(params.amplitude) ? 0 : params.amplitude;
			if (!Boolean(a) || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			} else {
				s = p / TWO_PI * Math.asin(c / a);
			}
			return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * TWO_PI / p) + c + b);
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function elasticInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t == 0)
				return b;
			if ((t /= d * .5) == 2)
				return b + c;
			var p:Number = !Boolean(params) || isNaN(params.period) ? d * (.3 * 1.5) : params.period;
			var s:Number;
			var a:Number = !Boolean(params) || isNaN(params.amplitude) ? 0 : params.amplitude;
			if (!Boolean(a) || a < Math.abs(c)) {
				a = c;
				s = p / 4;
			} else {
				s = p / TWO_PI * Math.asin(c / a);
			}
			if (t < 1)
				return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p)) + b;
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p) * .5 + c + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function elasticOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return elasticOut(t * 2, b, c * .5, d, params);
			return elasticIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function backIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			var s:Number = !Boolean(params) || isNaN(params.overshoot) ? 1.70158 : params.overshoot;
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
	
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function backOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			var s:Number = !Boolean(params) || isNaN(params.overshoot) ? 1.70158 : params.overshoot;
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
	
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function backInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			var s:Number = !Boolean(params) || isNaN(params.overshoot) ? 1.70158 : params.overshoot;
			if ((t /= d * .5) < 1)
				return c * .5 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			return c * .5 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function backOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return backOut(t * 2, b, c * .5, d, params);
			return backIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/**
		 * accelerating from zero velocity.
		 */
		[Inline]
		public static function bounceIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return c - bounceOut(d - t, 0, c, d, params) + b;
		}
		
		/**
		 * decelerating from zero velocity.
		 */
		[Inline]
		public static function bounceOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if ((t /= d) < (1 / 2.75)) {
				return c * (7.5625 * t * t) + b;
			} else if (t < (2 / 2.75)) {
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			} else if (t < (2.5 / 2.75)) {
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			} else {
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
			}
		}
		
		/**
		 * acceleration until halfway, then deceleration.
		 */
		[Inline]
		public static function bounceInOut(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return bounceIn(t * 2, 0, c, d, params) * .5 + b;
			else
				return bounceOut(t * 2 - d, 0, c, d, params) * .5 + c * .5 + b;
		}
		
		/**
		 * deceleration until halfway, then acceleration.
		 */
		[Inline]
		public static function bounceOutIn(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			if (t < d * .5)
				return bounceOut(t * 2, b, c * .5, d, params);
			return bounceIn((t * 2) - d, b + c * .5, c * .5, d, params);
		}
		
		
		/*
		public static function sine(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return .5 * (1 - Math.cos(TWO_PI * t * c));
		}
		
		public static function sineAbsolute(t:Number, b:Number, c:Number, d:Number, params:Object):Number {
			return Math.abs(Math.cos(TWO_PI * t * c));
		}
		*/
	}
}
