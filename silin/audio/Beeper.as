/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package  silin.audio
{
	import flash.events.*;
	import flash.media.*;
	import flash.utils.setTimeout;
	/**
	 * окончание генерации/воспроизведения сигнала
	 * @eventType flash.events.Event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	/**
	 * Sound c генератором тона <br/>
	 * возможность выстраивать цепочки последовательного воспроизведения <br/>
	 * временные параметры с точностю до тика (~0,07 с для DATA_LENGTH = 3072) <br/>
	 * @example
	 * <pre>
	 * new Beeper()
	 *	.beep().pause().beep()
	 *	.pause(0.3)
	 *	.trill([500, 400], 8)
	 *	.pause()
	 *	.melody("C:0.2,D:0.2,E:0.2,C:0.2,D:0.3,C:0.2")
	 *	.play();
	 * </pre>
	 * @author silin
	 */
	public class Beeper extends Sound 
	{
		/**
		 * до
		 */
		public static const C:Number = 261.63;
		/**
		 * до диез
		 */
		public static const C$:Number = 277.18;
		/**
		 * ре
		 */
		public static const D:Number = 293.66;
		/**
		 * ре диез
		 */
		public static const D$:Number = 311.13;
		/**
		 * ми
		 */
		public static const E:Number = 329.63;
		/**
		 * фа
		 */
		public static const F:Number = 349.23;
		/**
		 * фа диез
		 */
		public static const F$:Number = 369.99;
		/**
		 * соль
		 */
		public static const G:Number = 392.00;
		/**
		 * соль диез
		 */
		public static const G$:Number = 415.30;
		/**
		 * ля
		 */
		public static const A:Number = 440;
		/**
		 * си бемоль
		 */
		public static const B:Number = 466.16;
		/**
		 * си
		 */
		public static const H:Number = 493.88;
		/**
		 * тишина
		 */
		public static const MUTE:Number = 0;
		
		
		/**
		 * размер порции данных для SampleDataEvent.SAMPLE_DATA (2048..8192)
		 */
		public static var DATA_LENGTH:int = 3072;
		
		/**
		 * уровень по умолчанию
		 */
		//public static const VOLUME:Number = 0.25;
		
		public static const SQUAREWAVE:int = 0;
		public static const SAWTOOTH:int = 1;
		public static const SINEWAVE:int = 2;
		
		
		/**
		 * форма сигнала (SQUAREWAVE, SAWTOOTH, SINEWAVE)
		 */
		public var waveType:Number = SQUAREWAVE;
		
		/**
		 * уровень, 0..1
		 */
		public var volume:Number;
		
		/**
		 * зацикливание
		 */
		public var loop:Boolean = false;
		//======================================================================
		private var _queue:Vector.<BeepData> = new Vector.<BeepData>();
		private var _tick:Number;
		private var _frequency:Number = 0;
		private var _period:int;
		private var _tickCounter:int = 2;
		private var _soundChannel:SoundChannel;
		
		private const pi2:Number = 2 * Math.PI;
		
		
		
		/**
		 * constructor
		 */
		public function Beeper(duration:Number = 0, frequency:Number = 1e3, volume:Number = 0.25, vaweType:int = SQUAREWAVE) 
		{
			super();
			this.volume = volume;
			this.waveType = vaweType;
			_tick = DATA_LENGTH / 44100;// 0.06965986394557823
			if (duration)
			{
				beep(duration, frequency);
				play();
			}
			
		}
		
		
		//SAMPLE_DATA========================================================
		private function onSampleData(event:SampleDataEvent):void 
		{
			
			
			if (!_tickCounter)
			{
				// _queue ?
				if (_queue.length)
				{
					var data:BeepData = _queue.shift();
					//looping
					if (loop) _queue.push(data);
					_frequency = data.frequency;
					//trace( "_frequency : " + _frequency );
					_period = 44100 / _frequency;
					_tickCounter = Math.round(data.duration / _tick) || 1;
					
				}else
				{
					setTimeout(clear, _tick * 1.25e3);
					return;
				}
			}
				
			for ( var i:int = 0; i < DATA_LENGTH;  i++ ) 
			{
				var sample:Number = 0;
				if (_frequency)
				{
					var fp:Number = ((i + event.position) % _period) / _period;
					switch(waveType)
					{
						case SQUAREWAVE: sample = fp < 0.5 ? 1: -1;	break;
						case SAWTOOTH: sample = 1 - fp * 2; break;
						case SINEWAVE: sample =  Math.sin(fp * pi2); break;
					}
				}
				
				sample *= volume;
				
				event.data.writeFloat(sample);		
				event.data.writeFloat(sample);		
			}	
			_tickCounter--;
			
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
			if (!hasEventListener(SampleDataEvent.SAMPLE_DATA))
			{
				addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_soundChannel = super.play();
			}
			return _soundChannel;
			
		}
		
		/**
		 * останавливает воспроизведение
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
		 * останавливает и очищает очередь заданий
		 */
		public function clear():void
		{
			stop();
			_soundChannel = null;
			_queue = new Vector.<BeepData>();
			_tickCounter = 0;
		}
		
		
		/**
		 * пауза
		 * @param	duration	длительность, сек
		 * @return	
		 */
		public function pause(duration:Number=0):Beeper
		{
			return beep(duration, 0);
			
		}
		
		/**
		 * одиночный тон
		 * @param	frequency	частота, Гц
		 * @param	duration	длительность, сек
		 * @return	
		 */
		public function beep(duration:Number = 0, frequency:Number = 1e3):Beeper
		{
			_queue.push(new BeepData(duration, frequency));
			return this;
		}
		
		/**
		 * последовательность из массива <br/>
		 * @param	frequencies		массив частот, Гц
		 * @param	repeat			число повторений
		 * @param	duration		длительность каждого, сек
		 * @return
		 */
		public function trill(frequencies:Array/*Number*/, repeat:int = 1, duration:Number=0):Beeper
		{
			for (var i:int = 0; i < repeat; i++) 
			{
				for (var j:int = 0; j < frequencies.length; j++) 
				{
					beep(duration, frequencies[j]);
				}
			}
			return this;
		}
		
		/**
		 * мелодия <br/>
		 * строка типа "C:0.4,D:0.4",	"C,D,e,F", "500,200", "C:0.5,100:0.1,0:2,200" тоже проходят
		 * @param	notes		строка в стиле "нота:длительность,.." 
		 * @param	octave		октава (множитель частот)
		 * @return
		 */
		public function melody(notes:String, octave:Number = 1):Beeper
		{
			notes = notes.split(" ").join("").toUpperCase();
			var commands:Array = notes.split(",");
			for (var i:int = 0; i < commands.length; i++) 
			{
				var item:Array = commands[i].split(":");
				var frequency:Number = octave * (Number(item[0]) || Beeper[item[0]]);
				var duration:Number = Number(item[1]);
				beep(duration, frequency);
			}
			return this;
		}
		//================================================================================
		/**
		 * true для активного счета/воспроизведения
		 */
		public function get running():Boolean { return hasEventListener(SampleDataEvent.SAMPLE_DATA); }
		
		
		
	}

}

//===========================================================================================
class BeepData
{
	public var frequency:Number;
	public var duration:Number;
	public function BeepData(duration:Number, frequency:Number)
	{
		this.frequency = frequency;
		this.duration = duration;
	}
}