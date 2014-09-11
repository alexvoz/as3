/*
   The MIT License,
   Copyright (c) 2011. silin (http://silin.su#AS3)
 */
package silin.audio.equalizers
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;
	import silin.utils.Console;
	
	/**
	 * базовый класс эквалайзеров   <br/>
	 * если есть ссылка на sound, считаем через sound.extract и программный FFT,<br/>
	 * если нет то через SoundMixer.computeSpectrum<br/>
	 *
	 * @author silin
	 */
	public class Equalizer extends Sprite
	{
		/**
		 * максимальное число диапазонов
		 */
		public static const BANDS_MAX:int = 256;
		/**
		 * через сколько тактов enterFrame считать спектр
		 */
		public var omitFrames:uint = 4;
		/**
		 * ссылка на Sound,<br/>
		 * если задана, то считаем через sound.extract<br/>
		 * если нет, то через SoundMixer.computeSpectrum
		 */
		public var sound:Sound;
		/**
		 * ссылка на SoundChannel, в котором играет отображаемый саунд<br/>
		 * если есть, то отслеживаем soundChannel.position<br/>
		 * если нет берем, что дадут
		 */
		public var soundChannel:SoundChannel;
		/**
		 * загрубление частотного диапазона: 0-44кГц, 1-22кГц, 2-11кГц,...
		 */
		public var stretchFactor:int = 3;
		/**
		 * замедленность изменения, 1...
		 */
		public var easyFactor:Number = 2.62;
		
		private var _bands:uint = 8;
		private var _running:Boolean = false;
		
		protected var spectrumValues:Vector.<Number>;
		protected var bandWeights:Vector.<Number>;
		protected var defaultLevel:Number = 0.001;
		protected var level:Number;
		
		private var counter:uint = 0;
		private var targValues:Vector.<Number>;
		private var speсtrumLength:int = 256;
		// альтернативный FFT
		private var LOG_N:int = 9;// 
		private var fftElements:Vector.<FFTElement>; // Vector of linked list elements
		private var fftSize:int = 1 << LOG_N;//512;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 */
		public function Equalizer(bands:uint = 8)
		{
			
			_bands = Math.min(bands, BANDS_MAX);
			initFFT();
			targValues = new Vector.<Number>(BANDS_MAX, true);
			spectrumValues = new Vector.<Number>(BANDS_MAX, true);
			bandWeights = new Vector.<Number>(BANDS_MAX, true);
			start();
		}
		
		protected function onEnterFrame(event:Event = null):void
		{
			var i:int;
			counter++;
			if (counter % omitFrames == 0)
			{
				sound ? calcSoundExtract() : calcSoundMixerComputeSpectrum();
			}
			level = 0;
			for (i = 0; i < _bands; i++)
			{
				spectrumValues[i] += (targValues[i] - spectrumValues[i]) / easyFactor;
				level += spectrumValues[i] + defaultLevel;
			}
			for (i = 0; i < _bands; i++)
			{
				bandWeights[i] = (spectrumValues[i] + defaultLevel) / level;
				
			}
			level /= _bands;
			
			// рисуем только если это нативный вызов, а не super.onEnterFrame() из наследника
			if (event)
			{
				render();
			}
		}
		
		private function calcSoundExtract():void
		{
			var i:int, j:int;
			var ba:ByteArray = new ByteArray();
			
			var stretchSize:int = 1 << stretchFactor;
			var sampleLength:int = speсtrumLength * stretchSize;
			
			//fftLength = 32;
			//while (fftLength < _bands) fftLength *= 2;
			
			// если есть soundChannel, то читаем из текущей позиции, иначе как попало
			sound.extract(ba, sampleLength, soundChannel ? (soundChannel.position * 44.1) : -1);
			
			if (ba.length == sampleLength * 8)
			{
				// DEBUG
				//var t:int = getTimer();
				
				var data:Vector.<Number> = new Vector.<Number>(2 * speсtrumLength, true);
				
				ba.position = 0;
				var sumIn:Number = 0;
				for (i = 0; i < speсtrumLength; i++)
				{
					// долго, хотя вроде бы правильнее
					// на глаз большой разницы не видно
					/*
					var sumL:Number = 0, sumR:Number = 0;
					for (j = 0; j < stretchSize; j++)
					{
						sumL += ba.readFloat();
						sumR += ba.readFloat();
					}
					data[i] = sumL / stretchSize;
					data[i + spebtrumLength] = sumR / stretchSize;
					*/
					
					// существенно быстрее для больших stretchSize
					ba.position = i * stretchSize * 8;
					data[i] = ba.readFloat();
					data[i + speсtrumLength] = ba.readFloat();
					
					sumIn += data[i] * data[i] + data[i + speсtrumLength] * data[i + speсtrumLength];
					//sumIn += Math.abs(data[i]) + Math.abs(data[i + speсtrumLength]);
				}
				
				fft2(data);
				// DEBUG
				//var rT:int = getTimer() - t;
				//Console.log("read: " + rT, rT > 0, 0x800080);
				//t = getTimer();
				//fft2(data);
				//var cT:int = getTimer() - t;
				//Console.log("calc: " + cT, cT > 0, 0x00FFFF);
				
				
				
				var bandLength:int = speсtrumLength / _bands;
				
				var kNorm:Number = 1 /  (Math.sqrt(sumIn) || 1) / 4 / bandLength;
				//var kNorm:Number = Math.SQRT1_2 /  (sumIn || 1);// /  bandLength;
				
				
				for (i = 0; i < _bands; i++)
				{
					var bandSum:Number = 0;
					for (j = 0; j < bandLength; j++) bandSum += data[i * bandLength + j];
					bandSum *= kNorm;
					// TODO: отсечка зашкалов, костыль
					if (bandSum > 1) 
					{
						bandSum = 1 - .1 * Math.random();
						Console.log("rangeOut    ->" + bandSum, true);
					}
					//while (bandSum > 1) bandSum -= 0.5 * Math.random();
					
					targValues[i] = bandSum;
					
				}
					//debug
				/*if (Object(this).constructor == Equalizer)
				   {
				   var w:Number = 256;
				   var h:Number = 20;
				   graphics.clear();
				   graphics.lineStyle(0, color);
				   graphics.moveTo(0, 2*h);
				   for (i = 0; i < fftLength; i++)
				   {
				   graphics.lineTo(i * w / fftLength, h * (2 - k*data[i]));
				   } 
				 }*/
			}
		}
		
		private function calcSoundMixerComputeSpectrum():void
		{
			var i:int, j:int;
			var ba:ByteArray = new ByteArray();
			
			try
			{
				SoundMixer.computeSpectrum(ba, true, stretchFactor);
			}catch (err:Error)
			{
				return;
			}
			
			
			
			var bandLength:int = 256 / _bands;
			var k:Number = 0.5 / bandLength / Math.SQRT2;
			for (i = 0; i < _bands; i++)
			{
				var sum:Number = 0;
				ba.position = i * bandLength * 4;
				for (j = 0; j < bandLength; j++)
					sum += ba.readFloat();
				ba.position = 1024 + i * bandLength * 4;
				for (j = 0; j < bandLength; j++)
					sum += ba.readFloat();
				targValues[i] = sum * k;
			}
			//debug
		/*if (Object(this).constructor == Equalizer)
		   {
		
		   var h:Number = 20;
		   graphics.clear();
		   graphics.lineStyle(0, color);
		   graphics.moveTo(0, 2*h);
		   ba.position = 0;
		   for (i = 0; i < 256; i++)
		   {
		   graphics.lineTo(i, h * (2 - ba.readFloat()));
		   }
		 }*/
		}
		
		/**
		 * вывод результатов счета, заглушка для наследников
		 */
		protected function render():void
		{
		
		}
		
		/**
		 * стартует счет
		 */
		public function start():void
		{
			_running = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * останавливает счет, обнуляет данные
		 */
		public function stop():void
		{
			_running = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for (var i:int = 0; i < _bands; i++)
			{
				spectrumValues[i] = 0;
				targValues[i] = 0;
				bandWeights[i] = 0;
			}
			render();
		}
		
		/**
		 * true если обсчет включен
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * число диапазонов
		 */
		public function get bands():uint
		{
			return _bands;
		}
		
		public function set bands(value:uint):void
		{
			
			_bands = Math.min(value, BANDS_MAX);;
			
		}
		////////////////////////////////////////////
		// универсальный вариант FFT, годится для любой (1<<n, естественно) размерности анализа
		/*
		private function fft(dInOut:Vector.<Number>):void
		{
			var i:int, j:int, n:int, m:int, mmax:int, istep:int;
			var tempr:Number, tempi:Number, wtemp:Number, theta:Number, wpr:Number, wpi:Number, wr:Number, wi:Number;
			var data:Vector.<Number> = new Vector.<Number>(dInOut.length * 2 + 1, true);
			
			i = dInOut.length;
			while (i--)
			{
				data[i * 2] = 0;
				data[i * 2 + 1] = dInOut[i];
			}
			n = dInOut.length << 1;
			j = 1;
			i = 1;
			while (i < n)
			{
				if (j > i)
				{
					tempr = data[i];
					data[i] = data[j];
					data[j] = tempr;
					tempr = data[i + 1];
					data[i + 1] = data[j + 1];
					data[j + 1] = tempr;
				}
				m = n >> 1;
				while ((m >= 2) && (j > m))
				{
					j -= m;
					m = m >> 1;
				}
				j += m;
				i += 2;
			}
			mmax = 2;
			while (n > mmax)
			{
				istep = 2 * mmax;
				theta = -2 * Math.PI / mmax;
				wtemp = Math.sin(0.5 * theta);
				wpr = -2 * wtemp * wtemp;
				wpi = Math.sin(theta);
				wr = 1;
				wi = 0;
				m = 1;
				while (m < mmax)
				{
					i = m;
					while (i < n)
					{
						j = i + mmax;
						tempr = wr * data[j] - wi * data[j + 1];
						tempi = wr * data[j + 1] + wi * data[j];
						data[j] = data[i] - tempr;
						data[j + 1] = data[i + 1] - tempi;
						data[i] += tempr;
						data[i + 1] += tempi;
						i += istep;
					}
					wtemp = wr;
					wr = wtemp * wpr - wi * wpi + wr;
					wi = wi * wpr + wtemp * wpi + wi;
					m += 2;
				}
				mmax = istep;
			}
			
			i = dInOut.length / 2;
			while (i--)
			{
				dInOut[i] = Math.sqrt(data[i * 2] * data[i * 2] + data[i * 2 + 1] * data[i * 2 + 1]);
			}
			
			
		}
		*/
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		// более шустрый алгоритм (инициализация сязанного списка фиксированной длины)
		// при инициализации списка на лету нет преимущества перед классической реализацией
		// source: Gerald T. Beauregard, http://gerrybeauregard.wordpress.com/2010/08/03/an-even-faster-as3-fft/
		
		
		/*
		 * Performs in-place complex FFT.
		 *
		 * @param	xRe		Real part of input/output
		 * @param	xIm		Imaginary part of input/output
		 * @param	inverse	If true (INVERSE), do an inverse FFT
		 */
		public function fft2(dInOut:Vector.<Number>):void
		{
			var numFlies:uint = fftSize >> 1; // Number of butterflies per sub-FFT
			var span:uint = fftSize >> 1; // Width of the butterfly
			var spacing:uint = fftSize; // Distance between start of sub-FFTs
			var wIndexStep:uint = 1; // Increment for twiddle table index
			
			// Copy data into linked complex number objects
			// If it's an IFFT, we divide by N while we're at it
			var x:FFTElement = fftElements[0];
			var k:uint = 0;
			while (x)
			{
				x.re = dInOut[k++];
				x.im = 0;
				x = x.next;
				
			}
			
			// For each stage of the FFT
			for (var stage:uint = 0; stage < LOG_N; ++stage)
			{
				// Compute a multiplier factor for the "twiddle factors".
				// The twiddle factors are complex unit vectors spaced at
				// regular angular intervals. The angle by which the twiddle
				// factor advances depends on the FFT stage. In many FFT
				// implementations the twiddle factors are cached, but because
				// vector lookup is relatively slow in ActionScript, it's just
				// as fast to compute them on the fly.
				var wAngleInc:Number = wIndexStep * 2.0 * Math.PI / fftSize;
				
				var wMulRe:Number = Math.cos(wAngleInc);
				var wMulIm:Number = Math.sin(wAngleInc);
				
				for (var start:uint = 0; start < fftSize; start += spacing)
				{
					var xTop:FFTElement = fftElements[start];
					var xBot:FFTElement = fftElements[start + span];
					
					var wRe:Number = 1.0;
					var wIm:Number = 0.0;
					
					// For each butterfly in this stage
					for (var flyCount:uint = 0; flyCount < numFlies; ++flyCount)
					{
						// Get the top & bottom values
						var xTopRe:Number = xTop.re;
						var xTopIm:Number = xTop.im;
						var xBotRe:Number = xBot.re;
						var xBotIm:Number = xBot.im;
						
						// Top branch of butterfly has addition
						xTop.re = xTopRe + xBotRe;
						xTop.im = xTopIm + xBotIm;
						
						// Bottom branch of butterly has subtraction,
						// followed by multiplication by twiddle factor
						xBotRe = xTopRe - xBotRe;
						xBotIm = xTopIm - xBotIm;
						xBot.re = xBotRe * wRe - xBotIm * wIm;
						xBot.im = xBotRe * wIm + xBotIm * wRe;
						
						// Advance butterfly to next top & bottom positions
						xTop = xTop.next;
						xBot = xBot.next;
						
						// Update the twiddle factor, via complex multiply
						// by unit vector with the appropriate angle
						// (wRe + j wIm) = (wRe + j wIm) x (wMulRe + j wMulIm)
						var tRe:Number = wRe;
						wRe = wRe * wMulRe - wIm * wMulIm;
						wIm = tRe * wMulIm + wIm * wMulRe;
					}
				}
				
				numFlies >>= 1; // Divide by 2 by right shift
				span >>= 1;
				spacing >>= 1;
				wIndexStep <<= 1; // Multiply by 2 by left shift
			}
			
			// The algorithm leaves the result in a scrambled order.
			// Unscramble while copying values from the complex
			// linked list elements back to the input/output vectors.
			x = fftElements[0];
			while (x)
			{
				var target:uint = x.revTgt;
				dInOut[target] = Math.sqrt(x.re * x.re + x.im * x.im);
				
				x = x.next;
			}
		}
		
		// Allocate elements for linked list of complex numbers.
		private function initFFT():void
		{
			
			
			fftElements = new Vector.<FFTElement>(fftSize);
			var i:int = fftSize;
			
			while (i)
			{
				fftElements[--i] = new FFTElement();
				fftElements[i].revTgt = bitReverse(i, LOG_N);
				if (i < fftSize - 1) fftElements[i].next = fftElements[i + 1];
			}
		}
		/*
		 * Do bit reversal of specified number of places of an int
		 * For example, 1101 bit-reversed is 1011
		 *
		 * @param	x		Number to be bit-reverse.
		 * @param	numBits	Number of bits in the number.
		 */
		private function bitReverse(x:uint, numBits:uint):uint
		{
			var y:uint = 0;
			for (var i:uint = 0; i < numBits; i++)
			{
				y <<= 1;
				y |= x & 0x0001;
				x >>= 1;
			}
			return y;
		}
	}
}
//////
class FFTElement
{
	public var re:Number = 0.0; // Real component
	public var im:Number = 0.0; // Imaginary component
	public var next:FFTElement = null; // Next element in linked list
	public var revTgt:uint; // Target position post bit-reversal
	
}