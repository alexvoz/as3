/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.audio 
{
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;
	
	/**
	 * окончание генерации/воспроизведения сигнала
	 * @eventType flash.events.Event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * Sound с синтезатором звуковых эффектов </br>
	 * порт алгоритма <a href="http://www.drpetter.se/project_sfxr.html" target="_blank">drpetter.se/project_sfxr.html</a>
	 * @author silin
	 * @example
	 * <pre>
	 * var synth:Synthesizer = new Synthesizer( { envSustain:0.32, envDecay:0.17, freqBase:0.55, freqSlide:0.27 } );
	 * synth.play();
	 * </pre>
	 */
	public class Synthesizer extends Sound 
	{
		public static const SQUAREWAVE:int = 0;
		public static const SAWTOOTH:int = 1;
		public static const SINEWAVE:int = 2;
		public static const NOISE:int = 3;
		
		/**
		 * дефолтовый уровень
		 */
		public static var VOLUME:Number = 0.25;
		
		/**
		 *  размер порции данных для SampleDataEvent.SAMPLE_DATA (2048..8192)
		 */
		public static var DATA_LENGTH:int = 4096;
		
		/**
		 * форма сигнала (SQUAREWAVE, SAWTOOTH, SINEWAVE, NOISE)
		 */
		public var waveType:int = SQUAREWAVE;
		
		/**
		 * длительность нарастания
		 */
		public var envAttack:Number = 0;
		
		/**
		 * длительность основной части
		 */
		public var envSustain:Number = 0.1;
		
		/**
		 * длиельность спада
		 */
		public var envDecay:Number = 0.4;
		
		/**
		 * исходная частота
		 */
		public var freqBase:Number = 0.3;
		
		/**
		 * сдвиг частоты
		 */
		public var freqSlide:Number = 0;
		
		/**
		 * интенсивность сдвига частоты
		 */
		public var freqDelta:Number = 0;
		
		/**
		 * глубина вибрато
		 */
		public var vibDepth:Number = 0;
		
		/**
		 * скорость вибрато
		 */
		public var vibSpeed:Number = 0;
		
		/**
		 * смена частоты
		 */
		public var changeAmount:Number = 0;
		
		/**
		 * скорость смены частоты
		 */
		public var changeSpeed:Number = 0;
		
		/**
		 * сдвиг фазера
		 */
		public var phaserOffset:Number = 0;
		
		/**
		 * дрейф фазера
		 */
		public var phaserSweep:Number = 0;
		
		/**
		 * зацикливание
		 */
		public var loop:Boolean = false; 
		
		/**
		 * уровень
		 */
		public var volume:Number = VOLUME;
		
		/**
		 * считать и кешировать данные при инициализации <br/>
		 * или не кешировать, a считать по мере воспроизведения
		 */
		public var cacheData:Boolean = true;
		//====================================================
		private var _arpTime:int;
		private var _arpLimit:int;
		private var _fperiod:Number;
		private var _period:int;
		private var _arpMod:Number;
		private var _fslide:Number;
		private var _fdslide:Number;
		private var _vibAmp:Number;
		private var _vibPhase:Number;
		private var _vibSpeed:Number;
		private var _envTime:int;
		private var _envLength:Vector.<int> = new Vector.<int>(3, true);
		private var _envStage:int;
		private var _envVol:Number;
		private var _fphase:Number;
		private var _fdphase:Number;
		private var _iphase:int;
		private var _phase:int;
		private var _phaserBuffer:Vector.<Number> = new Vector.<Number>(1024, true);
		private var _noiseBuffer:Vector.<Number> = new Vector.<Number>(32, true);
		private var _ipp:int;
		//--------------------------------------------------------
		private var _playingSample:Boolean;
		private var _soundChannel:SoundChannel;
		private var _sampleByteArray:ByteArray;
		private var _mute:Boolean;
		
		/**
		 * constructor
		 * @param	initObj		инициализирующий объект <br/>
		 * { waveType:0, envAttack:0, envSustain:0.10, envDecay:0.40, freqBase:0.30 } <br/>
		 * "0,0,0.10,0.40,0.30" <br/>
		 * [0,0,0.10,0.40,0.30] <br/>
		 * @param	cacheData	флаг кеширования данных
		 */
		public function Synthesizer(initObj:Object = null, cacheData:Boolean = true)
		{
			super();
			this.cacheData = cacheData;
			resetParams();
			// строка и массив по initByString, объект и null по initByObject
			try {var len:int = initObj.length;} catch (err:Error) { }
			len ? initByString(String(initObj)) : initByObject(initObj);
			update();
		}
		
		/**
		 * установка параметров из строки <br/>
		 * "waveType,envAttack,envSustain,envDecay,freqBase,freqSlide,freqDelta,vibDepth,vibSpeed,changeAmount,changeSpeed,phaserOffset,phaserSweep"<br/>
		 *	нулевые параметры в конце строки не обязательны 
		 * @param	str
		 */
		public function initByString(str:String):void
		{
			
			var params:Array = [
				"waveType", "envAttack", "envSustain", "envDecay", 
				"freqBase", "freqSlide" , "freqDelta" , "vibDepth" ,
				"vibSpeed" , "changeAmount" , "changeSpeed" ,
				"phaserOffset" , "phaserSweep"
			];
			
			var arr:Array = str.split(" ").join("").split(",");
			for (var i:int = 0, obj:Object = { }; i < params.length; i++) obj[params[i]] = Number(arr[i]) || 0;
			initByObject(obj);
		}
		
		/**
		 * установка параметров из объекта
		 * @param	initObj
		 */
		public function initByObject(initObj:Object):void
		{
			
			for (var par:String in initObj)
			{
				if (Object(this).hasOwnProperty(par))
				{
					this[par] = initObj[par];
				}
			}
		}
		
		/**
		 * установка дефолтных параметров
		 */
		public function resetParams():void
		{
			waveType = SQUAREWAVE;
			
			envAttack = 0;
			envSustain = 0.1;
			envDecay = 0.4;
			
			freqBase = 0.3;
			freqSlide = 0;
			freqDelta = 0;
			
			vibDepth = 0;
			vibSpeed = 0;
			
			phaserOffset = 0;
			phaserSweep = 0;
			
			changeAmount = 0;
			changeSpeed = 0;
		}
		
		/**
		 * сброс в исходное состояние <br/>
		 * (для cacheData=true пересчет данных )
		 */
		public function update():void
		{
			resetSample();
			if (cacheData)
			{
				_sampleByteArray = new ByteArray();
				while (_playingSample) _sampleByteArray.writeBytes(calcData());
			}
			else
			{
				_sampleByteArray = null;
			}
		}
		
		// ONLY FOR CACHEDATA===========FLUENT INTERFACE==================
		/**
		 * добавляет сэмпл (только для режима cacheData=true)
		 * @param	initObj инициализирующий объект|строка|массив
		 * @return	
		 */
		public function chain(initObj:Object):Synthesizer
		{
			// только для варианта с кешированием
			if (!cacheData) throw( new Error("chain is available only for cacheData mode"));
			// установка параметров
			try { var len:int = initObj.length; } catch (err:Error) { }
			len ? initByString(String(initObj)) : initByObject(initObj);
			//инициализация алгоритма
			resetSample();
			//пишем
			while (_playingSample) _sampleByteArray.writeBytes(calcData());
			// fluent
			return this;
		}
		
		/**
		 * добавляет паузу (только для режима cacheData=true)
		 * @param	time	время, с
		 * @return	
		 */
		public function pause(time:Number):Synthesizer
		{
			if (!cacheData) throw( new Error("pause is available only for cacheData mode"));
			return chain( { freqBase:0, envAttack:0, envDecay:0, envSustain:time } );
		}
		//==================================FLUENT INTERFACE==================
		
		
		//SAMPLE_DATA/////////////////////////////////////////////////////////
		private function onSampleData(event:SampleDataEvent):void 
		{
			//trace( "Synthesizer.onSampleData > event : " + getTimer() );
			
			var data:ByteArray;
			//данные из кеша 
			if (cacheData)
			{
				
				var len:int = 8 * DATA_LENGTH;
				data = new ByteArray();
				
				if (_sampleByteArray.bytesAvailable >= len)
				{
					_sampleByteArray.readBytes(data, 0, len);
					event.data.writeBytes(data);
					
				}else
				{
					if (loop)
					{
						_sampleByteArray.position = 0;
						_sampleByteArray.readBytes(data, 0, len);
						event.data.writeBytes(data);
						
					}else
					{
						//clear();
						setTimeout(stop, DATA_LENGTH / 40);
					}
				}
			}
			// считаем очередную порцию
			else
			{
				event.data.writeBytes(calcData());
				if (!_playingSample)
				{
					if (loop)
					{
						resetSample()
					}else
					{
						setTimeout(stop, DATA_LENGTH / 40);
					}
				}	
			}
		}	
		
		/**
		 * запускает воспроизведение
		 * @param	startTime
		 * @param	loops
		 * @param	sndTransform
		 * @return
		 */
		override public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel
		{
			if(cacheData) _sampleByteArray.position = 0;
			if (!hasEventListener(SampleDataEvent.SAMPLE_DATA)) 
			{
				resetSample();
				addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_soundChannel=super.play();
			}
			return _soundChannel;
		}
		
		
		/**
		 * останавливает счет/воспроизведение
		 */
		public function stop():void
		{
			try	
			{
				_soundChannel.stop();
			}
			catch (err:Error) { }
				
			removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * останавливает и обнуляет кеш
		 */
		public function clear():void
		{
			_soundChannel = null;
			_sampleByteArray = null;
			stop();
		}
		
		//считает DATA_LENGTH точек сэмпла
		private function calcData():ByteArray
		{
			var i:int;
			var ba:ByteArray = new ByteArray();
			
			for (i = 0; i < DATA_LENGTH; i++)
			{
				if (!_playingSample ) 
				{
					ba.writeFloat(0);
					ba.writeFloat(0);
					continue;
				}
				
				// frequency envelopes/arpeggios
				_arpTime++;
				
				if(_arpLimit!=0 && _arpTime>=_arpLimit)
				{
					_arpLimit = 0;
					_fperiod *= _arpMod;
					
				}
				_fslide += _fdslide;
				_fperiod *= _fslide;
				var  rfperiod:Number = _fperiod;
				if(_vibAmp>0)
				{
					_vibPhase += _vibSpeed;
					rfperiod = _fperiod * (1 + Math.sin(_vibPhase) * _vibAmp);
				}
				_period = int(rfperiod);
				if (_period < 8) _period = 8;
				
				_envTime++;
				if (_envTime > _envLength[_envStage])
				{
					_envTime=0;
					_envStage++;
					if(_envStage==3)
						_playingSample=false;
				}
				
				if (_mute)
				{
					ba.writeFloat(0);
					ba.writeFloat(0);
					continue;
				}
				
				switch(_envStage)
				{
					case 0: _envVol = _envTime / _envLength[0]; break;
					case 1:_envVol = 1; break;
					case 2:_envVol = 1 - _envTime / _envLength[2]; break;
				}
				
				// phaser step
				_fphase += _fdphase;
				_iphase = _fphase>0 ? _fphase : -_fphase;
				if (_iphase > 1023) _iphase = 1023;
				
				// 8x supersampling
				var  ssample:Number = 0;
				for (var si:int = 0; si < 8; si++) 
				{
					var  sample:Number = 0;
					_phase++;
					
					if(_phase>=_period)
					{
						_phase=0;
						if (waveType == NOISE)
						{
							for (var j:int = 0; j < 32; j++) 
							{
								_noiseBuffer[j] = 1 - 2 * Math.random();
							}
						}
					}
					// base waveform
					var  fp:Number = _phase / _period;
					switch(waveType)
					{
						case SQUAREWAVE: // square
							sample = fp < 0.5 ? 1: -1;
						break;
						case SAWTOOTH: // sawtooth
							sample = 1 - fp * 2;
						break;
						case SINEWAVE: // sine
							sample =  Math.sin(fp * 2 * Math.PI);
						break;
						case NOISE: // noise
							sample = _noiseBuffer[int(_phase * 32 / _period)];
						break;
					}
					
					// phaser
					_phaserBuffer[_ipp & 1023] = sample;
					sample += _phaserBuffer[(_ipp - _iphase + 1024) & 1023];
					_ipp = (_ipp + 1) & 1023;
					
					// final accumulation and envelope application
					ssample += sample * _envVol;
				}
				var val:Number = ssample / 8 * volume;
				
				ba.writeFloat(val);
				ba.writeFloat(val);
			}
			//return buffer;
			return ba;
		}
		
		//инициализация алгоритма
		private function resetSample():void
		{
			_playingSample = true;
			_phase = 0;
				
			_mute = freqBase == 0;
			
			_fperiod = 100 / (freqBase * freqBase + 0.001);
			_period = int(_fperiod);
			
			_fslide = 1 - freqSlide * freqSlide * freqSlide * 0.01;
			_fdslide = -freqDelta * freqDelta * freqDelta * 0.000001;
			_arpMod = (changeAmount >= 0) ? 
				(1 - changeAmount * changeAmount * 0.9) : (1 +  changeAmount * changeAmount * 10);
			
				
			_arpTime = 0;
			_arpLimit = (changeSpeed == 1) ? 
				0 : (1 - changeSpeed) * (1 - changeSpeed) * 20000 + 32;
			
			
			// reset vibrato
			_vibPhase = 0;
			_vibSpeed = vibSpeed * vibSpeed * 0.01;
			_vibAmp = vibDepth * 0.5;
			// reset envelope
			_envVol = 0;
			_envStage = 0;
			_envTime = 0;
			_envLength[0] = int(envAttack * envAttack * 1e5);
			_envLength[1] = int(envSustain * envSustain * 1e5);
			_envLength[2] = int(envDecay * envDecay * 1e5);

			_fphase = (phaserOffset < 0) ? 
				phaserOffset * phaserOffset * 1020 : -phaserOffset * phaserOffset * 1020;
			
			
			_fdphase = (phaserSweep < 0) ? 
				phaserSweep * phaserSweep : -phaserSweep * phaserSweep;
			
			_iphase = (_fphase > 0) ? 
				_fphase : - _fphase;
				
			_ipp=0;
			for (var i:int = 0; i < 1024; i++) _phaserBuffer[i] = 0;
			for (var j:int = 0; j < 32; j++) _noiseBuffer[j] = 1 - 2 * Math.random();
			
			
		}
		//=================================================================
		/**
		 * true для активного счета/воспроизведения
		 */
		public function get running():Boolean { return _playingSample; }
		
		
	}

}