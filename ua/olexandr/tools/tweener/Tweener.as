package ua.olexandr.tools.tweener {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class Tweener {
		
		public static var autoOverwrite:Boolean = true;
		
		private static var _controller:Sprite; // Used to ensure the stage copy is always accessible (garbage collection)
		
		private static var _engineExists:Boolean = false; // Whether or not the engine is currently running
		private static var _inited:Boolean = false; // Whether or not the class has been initiated
		private static var _currentTime:Number; // The current time. This is generic for all tweenings for a "time grid" based update
		private static var _currentTimeFrame:Number; // The current frame. Used on frame-based tweenings
		
		private static var _tweenList:Array; // List of active tweens
		
		private static var _timeScale:Number = 1; // Time scale (default = 1)
		
		private static var _easingList:Object; // List of "pre-fetched" easing functions
		private static var _specialPropertyList:Object; // List of special properties
		private static var _specialPropertyModifierList:Object; // List of special property modifiers
		private static var _specialPropertySplitterList:Object; // List of special property splitters
		
		/**
		 * Adds a new tweening.
		 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
		 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties that should be tweened and their values
		 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
		 * @param		.delay				Number				Delay time (defaults 0)
		 * @param		.useFrames			Boolean				Whether to use frames instead of seconds for time control (defaults false)
		 * @param		.ease				String/Function		Type of ease equation... (defaults to "easeoutsine")
		 * @param		.onStart			Function			* Direct property, See the TweenListObj class
		 * @param		.onUpdate			Function			* Direct property, See the TweenListObj class
		 * @param		.onComplete			Function			* Direct property, See the TweenListObj class
		 * @param		.onOverwrite		Function			* Direct property, See the TweenListObj class
		 * @param		.onStartParams		Array				* Direct property, See the TweenListObj class
		 * @param		.onUpdateParams		Array				* Direct property, See the TweenListObj class
		 * @param		.onCompleteParams	Array				* Direct property, See the TweenListObj class
		 * @param		.onOverwriteParams	Array				* Direct property, See the TweenListObj class
		 * @param		.rounded			Boolean				* Direct property, See the TweenListObj class
		 * @param		.skipUpdates		Number				* Direct property, See the TweenListObj class
		 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
		 */
		public static function addTween(p_scopes:Object, p_time:Number = 0, p_parameters:Object = null):Boolean {
			if (!Boolean(p_scopes))
				return false;
			
			var i:Number, j:Number, istr:String;
			
			var rScopes:Array = (p_scopes is Array) ? p_scopes.concat() : [p_scopes];
			
			// make properties chain ("inheritance")
			var p_obj:Object = TweenListObj.makePropertiesChain(p_parameters);
			
			// Creates the main engine if it isn't active
			if (!_inited)
				init();
			
			if (!_engineExists || !Boolean(_controller))
				startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...
			
			// Creates a "safer", more strict tweening object
			var rTime:Number = (isNaN(p_time) ? 0 : p_time); // Real time
			var rDelay:Number = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay
			
			// Creates the property list; everything that isn't a hardcoded variable
			var rProperties:Array = []; // Object containing a list of PropertyInfoObj instances
			var restrictedWords:Object = {overwrite: true, time: true, delay: true, useFrames: true, skipUpdates: true, ease: true, easeParams: true, onStart: true, onUpdate: true, onComplete: true, onOverwrite: true, onError: true, rounded: true, onStartParams: true, onUpdateParams: true, onCompleteParams: true, onOverwriteParams: true, onStartScope: true, onUpdateScope: true, onCompleteScope: true, onOverwriteScope: true, onErrorScope: true};
			var modifiedProperties:Object = { };
			for (istr in p_obj) {
				if (!restrictedWords[istr]) {
					// It's an additional pair, so adds
					if (_specialPropertySplitterList[istr]) {
						// Special property splitter
						var splitProperties:Array = _specialPropertySplitterList[istr].splitValues(p_obj[istr], _specialPropertySplitterList[istr].parameters);
						for (i = 0; i < splitProperties.length; i++) {
							if (_specialPropertySplitterList[splitProperties[i].name]) {
								var splitProperties2:Array = _specialPropertySplitterList[splitProperties[i].name].splitValues(splitProperties[i].value, _specialPropertySplitterList[splitProperties[i].name].parameters);
								for (j = 0; j < splitProperties2.length; j++) {
									rProperties[splitProperties2[j].name] = {valueStart: undefined, valueComplete: splitProperties2[j].value, arrayIndex: splitProperties2[j].arrayIndex, isSpecialProperty: false};
								}
							} else {
								rProperties[splitProperties[i].name] = {valueStart: undefined, valueComplete: splitProperties[i].value, arrayIndex: splitProperties[i].arrayIndex, isSpecialProperty: false};
							}
						}
					} else if (_specialPropertyModifierList[istr] != undefined) {
						// Special property modifier
						var tempModifiedProperties:Array = _specialPropertyModifierList[istr].modifyValues(p_obj[istr]);
						for (i = 0; i < tempModifiedProperties.length; i++) {
							modifiedProperties[tempModifiedProperties[i].name] = {modifierParameters: tempModifiedProperties[i].parameters, modifierFunction: _specialPropertyModifierList[istr].getValue};
						}
					} else {
						// Regular property or special property, just add the property normally
						rProperties[istr] = {valueStart: undefined, valueComplete: p_obj[istr]};
					}
				}
			}
			
			// Verifies whether the properties exist or not, for warning messages
			for (istr in rProperties) {
				if (_specialPropertyList[istr] != undefined) {
					rProperties[istr].isSpecialProperty = true;
				} else {
					if (rScopes[0][istr] == undefined) {
						printError("The property '" + istr + "' doesn't seem to be a normal object property of " + String(rScopes[0]) + " or a registered special property.");
					}
				}
			}
			
			// Adds the modifiers to the list of properties
			for (istr in modifiedProperties) {
				if (rProperties[istr] != undefined) {
					rProperties[istr].modifierParameters = modifiedProperties[istr].modifierParameters;
					rProperties[istr].modifierFunction = modifiedProperties[istr].modifierFunction;
				}
				
			}
			
			var rEase:Function; // Real ease
			
			if (typeof p_obj.ease == "string") {
				// String parameter, ease names
				var ease:String = p_obj.ease.toLowerCase();
				rEase = _easingList[ease];
			} else {
				// Proper ease function
				rEase = p_obj.ease;
			}
			if (!Boolean(rEase))
				rEase = _easingList["easeoutsine"];
			
			var nProperties:Object;
			var nTween:TweenListObj;
			var myT:Number;
			
			for (i = 0; i < rScopes.length; i++) {
				// Makes a copy of the properties
				nProperties = { };
				for (istr in rProperties) {
					nProperties[istr] = new PropertyInfoObj(rProperties[istr].valueStart, rProperties[istr].valueComplete, rProperties[istr].valueComplete, rProperties[istr].arrayIndex, {}, rProperties[istr].isSpecialProperty, rProperties[istr].modifierFunction, rProperties[istr].modifierParameters);
				}
				
				if (p_obj.useFrames == true) {
					nTween = new TweenListObj( /* scope			*/rScopes[i],  /* timeStart		*/_currentTimeFrame + (rDelay / _timeScale),  /* timeComplete		*/_currentTimeFrame + ((rDelay + rTime) / _timeScale),  /* useFrames		*/true,  /* ease				*/rEase, p_obj.easeParams);
				} else {
					nTween = new TweenListObj( /* scope			*/rScopes[i],  /* timeStart		*/_currentTime + ((rDelay * 1000) / _timeScale),  /* timeComplete		*/_currentTime + (((rDelay * 1000) + (rTime * 1000)) / _timeScale),  /* useFrames		*/false,  /* ease				*/rEase, p_obj.easeParams);
				}
				
				nTween.properties = nProperties;
				nTween.onStart = p_obj.onStart;
				nTween.onUpdate = p_obj.onUpdate;
				nTween.onComplete = p_obj.onComplete;
				nTween.onOverwrite = p_obj.onOverwrite;
				nTween.onError = p_obj.onError;
				nTween.onStartParams = p_obj.onStartParams;
				nTween.onUpdateParams = p_obj.onUpdateParams;
				nTween.onCompleteParams = p_obj.onCompleteParams;
				nTween.onOverwriteParams = p_obj.onOverwriteParams;
				nTween.onStartScope = p_obj.onStartScope;
				nTween.onUpdateScope = p_obj.onUpdateScope;
				nTween.onCompleteScope = p_obj.onCompleteScope;
				nTween.onOverwriteScope = p_obj.onOverwriteScope;
				nTween.onErrorScope = p_obj.onErrorScope;
				nTween.rounded = p_obj.rounded;
				nTween.skipUpdates = p_obj.skipUpdates;
				
				// Remove other tweenings that occur at the same time
				if (p_obj.overwrite == undefined ? autoOverwrite : p_obj.overwrite)
					removeTweensByTime(nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete); // Changed on 1.32.74
				
				// And finally adds it to the list
				_tweenList.push(nTween);
				
				// Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
				if (rTime == 0 && rDelay == 0) {
					myT = _tweenList.length - 1;
					updateTweenByIndex(myT);
					removeTweenByIndex(myT);
				}
			}
			
			return true;
		}
		
		/**
		 * Remove an specified tweening of a specified object the tweening list, if it conflicts with the given time.
		 * @param		p_scope				Object						List of objects affected
		 * @param		p_properties		Object 						List of properties affected (PropertyInfoObj instances)
		 * @param		p_timeStart			Number						Time when the new tween starts
		 * @param		p_timeComplete		Number						Time when the new tween ends
		 * @return							Boolean						Whether or not it actually deleted something
		 */
		public static function removeTweensByTime(p_scope:Object, p_properties:Object, p_timeStart:Number, p_timeComplete:Number):Boolean {
			var removed:Boolean = false;
			var removedLocally:Boolean;
			
			var i:uint;
			var tl:uint = _tweenList.length;
			var pName:String;
			
			for (i = 0; i < tl; i++) {
				if (Boolean(_tweenList[i]) && p_scope == _tweenList[i].scope) {
					// Same object...
					if (p_timeComplete > _tweenList[i].timeStart && p_timeStart < _tweenList[i].timeComplete) {
						// New time should override the old one...
						removedLocally = false;
						for (pName in _tweenList[i].properties) {
							if (Boolean(p_properties[pName])) {
								// Same object, same property
								// Finally, remove this old tweening and use the new one
								if (Boolean(_tweenList[i].onOverwrite)) {
									var eventScope:Object = Boolean(_tweenList[i].onOverwriteScope) ? _tweenList[i].onOverwriteScope : _tweenList[i].scope;
									try {
										_tweenList[i].onOverwrite.apply(eventScope, _tweenList[i].onOverwriteParams);
									} catch (e:Error) {
										handleError(_tweenList[i], e, "onOverwrite");
									}
								}
								_tweenList[i].properties[pName] = undefined;
								delete _tweenList[i].properties[pName];
								removedLocally = true;
								removed = true;
							}
						}
						if (removedLocally) {
							// Verify if this can be deleted
							if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0)
								removeTweenByIndex(i);
						}
					}
				}
			}
			
			return removed;
		}
		
		/**
		 * Remove tweenings from a given object from the tweening list.
		 * @param		p_tween				Object		Object that must have its tweens removed
		 * @param		(2nd-last params)	Object		Property(ies) that must be removed
		 * @return							Boolean		Whether or not it successfully removed this tweening
		 */
		public static function removeTweens(p_scope:Object, ... args):Boolean {
			// Create the property list
			var properties:Array = [];
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && properties.indexOf(args[i]) == -1) {
					if (_specialPropertySplitterList[args[i]]) {
						//special property, get splitter array first
						var sps:SpecialPropertySplitter = _specialPropertySplitterList[args[i]];
						var specialProps:Array = sps.splitValues(p_scope, null);
						for (var j:uint = 0; j < specialProps.length; j++) {
							//trace(specialProps[j].name);
							properties.push(specialProps[j].name);
						}
					} else {
						properties.push(args[i]);
					}
				}
			}
			
			// Call the affect function on the specified properties
			return affectTweens(removeTweenByIndex, p_scope, properties);
		}
		
		/**
		 * Remove all tweenings from the engine.
		 * @return					<code>true</code> if it successfully removed any tweening, <code>false</code> if otherwise.
		 */
		public static function removeAllTweens():Boolean {
			if (!Boolean(_tweenList))
				return false;
			var removed:Boolean = false;
			var i:uint;
			for (i = 0; i < _tweenList.length; i++) {
				removeTweenByIndex(i);
				removed = true;
			}
			return removed;
		}
		
		/**
		 * Pause tweenings for a given object.
		 * @param		p_scope				Object that must have its tweens paused
		 * @param		(2nd-last params)	Property(ies) that must be paused
		 * @return					<code>true</code> if it successfully paused any tweening, <code>false</code> if otherwise.
		 */
		public static function pauseTweens(p_scope:Object, ... args):Boolean {
			// Create the property list
			var properties:Array = [];
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && properties.indexOf(args[i]) == -1)
					properties.push(args[i]);
			}
			// Call the affect function on the specified properties
			return affectTweens(pauseTweenByIndex, p_scope, properties);
		}
		
		/**
		 * Pause all tweenings on the engine.
		 * @return					<code>true</code> if it successfully paused any tweening, <code>false</code> if otherwise.
		 * @see #resumeAllTweens()
		 */
		public static function pauseAllTweens():Boolean {
			if (!Boolean(_tweenList))
				return false;
			var paused:Boolean = false;
			var i:uint;
			for (i = 0; i < _tweenList.length; i++) {
				pauseTweenByIndex(i);
				paused = true;
			}
			return paused;
		}
		
		/**
		 * Resume tweenings from a given object.
		 * @param		p_scope				Object		Object that must have its tweens resumed
		 * @param		(2nd-last params)	Object		Property(ies) that must be resumed
		 * @return							Boolean		Whether or not it successfully resumed something
		 */
		public static function resumeTweens(p_scope:Object, ... args):Boolean {
			// Create the property list
			var properties:Array = [];
			var i:uint;
			for (i = 0; i < args.length; i++) {
				if (typeof(args[i]) == "string" && properties.indexOf(args[i]) == -1)
					properties.push(args[i]);
			}
			// Call the affect function on the specified properties
			return affectTweens(resumeTweenByIndex, p_scope, properties);
		}
		
		/**
		 * Resume all tweenings on the engine.
		 * @return <code>true</code> if it successfully resumed any tweening, <code>false</code> if otherwise.
		 * @see #pauseAllTweens()
		 */
		public static function resumeAllTweens():Boolean {
			if (!Boolean(_tweenList))
				return false;
			var resumed:Boolean = false;
			var i:uint;
			for (i = 0; i < _tweenList.length; i++) {
				resumeTweenByIndex(i);
				resumed = true;
			}
			return resumed;
		}
		
		/**
		 * Splits a tweening in two
		 * @param		p_tween				Number		Object that must have its tweens split
		 * @param		p_properties		Array		Array of strings containing the list of properties that must be separated
		 * @return							Number		The index number of the new tween
		 */
		public static function splitTweens(p_tween:Number, p_properties:Array):uint {
			// First, duplicates
			var originalTween:TweenListObj = _tweenList[p_tween];
			var newTween:TweenListObj = originalTween.clone(false);
			
			// Now, removes tweenings where needed
			var i:uint;
			var pName:String;
			
			// Removes the specified properties from the old one
			for (i = 0; i < p_properties.length; i++) {
				pName = p_properties[i];
				if (Boolean(originalTween.properties[pName])) {
					originalTween.properties[pName] = undefined;
					delete originalTween.properties[pName];
				}
			}
			
			// Removes the unspecified properties from the new one
			var found:Boolean;
			for (pName in newTween.properties) {
				found = false;
				for (i = 0; i < p_properties.length; i++) {
					if (p_properties[i] == pName) {
						found = true;
						break;
					}
				}
				if (!found) {
					newTween.properties[pName] = undefined;
					delete newTween.properties[pName];
				}
			}
			
			// If there are empty property lists, a cleanup is done on the next updateTweens() cycle
			_tweenList.push(newTween);
			return (_tweenList.length - 1);
		
		}
		
		/**
		 * Remove a specific tweening from the tweening list.
		 * @param		p_tween				Number		Index of the tween to be removed on the tweenings list
		 * @return							Boolean		Whether or not it successfully removed this tweening
		 */
		public static function removeTweenByIndex(i:Number, p_finalRemoval:Boolean = false):Boolean {
			_tweenList[i] = null;
			if (p_finalRemoval)
				_tweenList.splice(i, 1);
			return true;
		}
		
		/**
		 * Pauses a specific tween.
		 * @param		p_tween				Number		Index of the tween to be paused
		 * @return							Boolean		Whether or not it successfully paused this tweening
		 */
		public static function pauseTweenByIndex(p_tween:Number):Boolean {
			var tTweening:TweenListObj = _tweenList[p_tween]; // Shortcut to this tweening
			if (tTweening == null || tTweening.isPaused)
				return false;
			tTweening.timePaused = getCurrentTweeningTime(tTweening);
			tTweening.isPaused = true;
			
			return true;
		}
		
		/**
		 * Resumes a specific tween.
		 * @param		p_tween				Number		Index of the tween to be resumed
		 * @return							Boolean		Whether or not it successfully resumed this tweening
		 */
		public static function resumeTweenByIndex(p_tween:Number):Boolean {
			var tTweening:TweenListObj = _tweenList[p_tween]; // Shortcut to this tweening
			if (tTweening == null || !tTweening.isPaused)
				return false;
			var cTime:Number = getCurrentTweeningTime(tTweening);
			tTweening.timeStart += cTime - tTweening.timePaused;
			tTweening.timeComplete += cTime - tTweening.timePaused;
			tTweening.timePaused = undefined;
			tTweening.isPaused = false;
			
			return true;
		}
		
		/**
		 * Initiates the Tweener--should only be ran once.
		 */
		public static function init(... rest):void {
			_inited = true;
			
			// Registers all default equations
			_easingList = { };
			Easing.init();
			
			// Registers all default special properties
			_specialPropertyList = { };
			_specialPropertyModifierList = { };
			_specialPropertySplitterList = { };
		}
		
		/**
		 * Adds a new function to the available ease list "shortcuts".
		 * @param		p_name				String		Shorthand ease name
		 * @param		p_function			Function	The proper equation function
		 */
		public static function registerEase(p_name:String, p_function:Function):void {
			if (!_inited)
				init();
			
			_easingList[p_name] = p_function;
		}
		
		/**
		 * Adds a new special property to the available special property list.
		 * @param		p_name				Name of the "special" property.
		 * @param		p_getFunction		Function that gets the value.
		 * @param		p_setFunction		Function that sets the value.
		 */
		public static function registerSpecialProperty(p_name:String, p_getFunction:Function, p_setFunction:Function, p_parameters:Array = null, p_preProcessFunction:Function = null):void {
			if (!_inited)
				init();
			var sp:SpecialProperty = new SpecialProperty(p_getFunction, p_setFunction, p_parameters, p_preProcessFunction);
			_specialPropertyList[p_name] = sp;
		}
		
		/**
		 * Adds a new special property modifier to the available modifier list.
		 * @param		p_name				Name of the "special" property modifier.
		 * @param		p_modifyFunction	Function that modifies the value.
		 * @param		p_getFunction		Function that gets the value.
		 */
		public static function registerSpecialPropertyModifier(p_name:String, p_modifyFunction:Function, p_getFunction:Function):void {
			if (!_inited)
				init();
			var spm:SpecialPropertyModifier = new SpecialPropertyModifier(p_modifyFunction, p_getFunction);
			_specialPropertyModifierList[p_name] = spm;
		}
		
		/**
		 * Adds a new special property splitter to the available splitter list.
		 * @param		p_name				Name of the "special" property splitter.
		 * @param		p_splitFunction		Function that splits the value.
		 */
		public static function registerSpecialPropertySplitter(p_name:String, p_splitFunction:Function, p_parameters:Array = null):void {
			if (!_inited)
				init();
			var sps:SpecialPropertySplitter = new SpecialPropertySplitter(p_splitFunction, p_parameters);
			_specialPropertySplitterList[p_name] = sps;
		}
		
		/**
		 * Updates the time to enforce time grid-based updates.
		 */
		public static function updateTime():void {
			_currentTime = getTimer();
		}
		
		/**
		 * Updates the current frame count
		 */
		public static function updateFrame():void {
			_currentTimeFrame++;
		}
		
		/**
		 * Ran once every frame. It's the main engine; updates all existing tweenings.
		 */
		public static function onEnterFrame(e:Event):void {
			updateTime();
			updateFrame();
			var hasUpdated:Boolean = false;
			hasUpdated = updateTweens();
			if (!hasUpdated)
				stopEngine(); // There's no tweening to update or wait, so it's better to stop the engine
		}
		
		/**
		 * Sets the new time scale.
		 * @param		p_time				Number		New time scale (0.5 = slow, 1 = normal, 2 = 2x fast forward, etc)
		 */
		public static function setTimeScale(p_time:Number):void {
			var i:Number;
			var cTime:Number;
			
			if (isNaN(p_time))
				p_time = 1;
			if (p_time < 0.00001)
				p_time = 0.00001;
			if (p_time != _timeScale) {
				if (_tweenList != null) {
					// Multiplies all existing tween times accordingly
					for (i = 0; i < _tweenList.length; i++) {
						cTime = getCurrentTweeningTime(_tweenList[i]);
						_tweenList[i].timeStart = cTime - ((cTime - _tweenList[i].timeStart) * _timeScale / p_time);
						_tweenList[i].timeComplete = cTime - ((cTime - _tweenList[i].timeComplete) * _timeScale / p_time);
						if (_tweenList[i].timePaused != undefined)
							_tweenList[i].timePaused = cTime - ((cTime - _tweenList[i].timePaused) * _timeScale / p_time);
					}
				}
				// Sets the new timescale value (for new tweenings)
				_timeScale = p_time;
			}
		}
		
		/**
		 * Finds whether or not an object has any tweening.
		 * @param		p_scope		Target object.
		 * @return					<code>true</code> if there's a tweening occuring on this object (paused, delayed, or active), <code>false</code> if otherwise.
		 */
		public static function isTweening(p_scope:Object):Boolean {
			if (!Boolean(_tweenList))
				return false;
			var i:uint;
			
			for (i = 0; i < _tweenList.length; i++) {
				if (Boolean(_tweenList[i]) && _tweenList[i].scope == p_scope) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Returns an array containing a list of the properties being tweened for this object.
		 * @param		p_scope		Target object.
		 * @return					Total number of properties being tweened (including delayed or paused tweens).
		 */
		public static function getTweens(p_scope:Object):Array {
			if (!Boolean(_tweenList))
				return [];
			var i:uint;
			var pName:String;
			var tList:Array = [];
			
			for (i = 0; i < _tweenList.length; i++) {
				if (Boolean(_tweenList[i]) && _tweenList[i].scope == p_scope) {
					for (pName in _tweenList[i].properties)
						tList.push(pName);
				}
			}
			return tList;
		}
		
		/**
		 * Returns the number of properties being tweened for a given object.
		 * @param		p_scope		Target object.
		 * @return					Total number of properties being tweened (including delayed or paused tweens).
		 */
		public static function getTweenCount(p_scope:Object):Number {
			if (!Boolean(_tweenList))
				return 0;
			var i:uint;
			var c:Number = 0;
			
			for (i = 0; i < _tweenList.length; i++) {
				if (Boolean(_tweenList[i]) && _tweenList[i].scope == p_scope) {
					c += AuxFunctions.getObjectLength(_tweenList[i].properties);
				}
			}
			return c;
		}
		
		/**
		 * Get the current tweening time (no matter if it uses frames or time as basis), given a specific tweening
		 * @param		p_tweening				TweenListObj		Tween information
		 */
		public static function getCurrentTweeningTime(p_tweening:Object):Number {
			return p_tweening.useFrames ? _currentTimeFrame : _currentTime;
		}
		
		/**
		 * Output an error message
		 * @param		p_message				String		The error message to output
		 */
		public static function printError(p_message:String):void {
			//
			trace("## [Tweener] Error: " + p_message);
		}
		
		
		private static function affectTweens(p_affectFunction:Function, p_scope:Object, p_properties:Array):Boolean {
			var affected:Boolean = false;
			var i:uint;
			
			if (!Boolean(_tweenList))
				return false;
			
			for (i = 0; i < _tweenList.length; i++) {
				if (_tweenList[i] && _tweenList[i].scope == p_scope) {
					if (p_properties.length == 0) {
						p_affectFunction(i);
						affected = true;
					} else {
						var affectedProperties:Array = [];
						var j:uint;
						for (j = 0; j < p_properties.length; j++) {
							if (Boolean(_tweenList[i].properties[p_properties[j]]))
								affectedProperties.push(p_properties[j]);
						}
						if (affectedProperties.length > 0) {
							var objectProperties:uint = AuxFunctions.getObjectLength(_tweenList[i].properties);
							if (objectProperties == affectedProperties.length) {
								p_affectFunction(i);
								affected = true;
							} else {
								var slicedTweenIndex:uint = splitTweens(i, affectedProperties);
								p_affectFunction(slicedTweenIndex);
								affected = true;
							}
						}
					}
				}
			}
			return affected;
		}
		
		private static function updateTweens():Boolean {
			if (_tweenList.length == 0)
				return false;
			var i:int;
			for (i = 0; i < _tweenList.length; i++) {
				if (_tweenList[i] == undefined || !_tweenList[i].isPaused) {
					if (!updateTweenByIndex(i))
						removeTweenByIndex(i);
					if (_tweenList[i] == null) {
						removeTweenByIndex(i, true);
						i--;
					}
				}
			}
			
			return true;
		}
		
		private static function updateTweenByIndex(i:Number):Boolean {
			var tTweening:TweenListObj = _tweenList[i];
			
			if (!tTweening || !Boolean(tTweening.scope))
				return false;
			
			var isOver:Boolean = false;
			var mustUpdate:Boolean;
			
			var nv:Number;
			
			var t:Number;
			var b:Number;
			var c:Number;
			var d:Number;
			
			var pName:String;
			var eventScope:Object;
			
			var tScope:Object;
			var cTime:Number = getCurrentTweeningTime(tTweening);
			var tProperty:Object;
			
			if (cTime >= tTweening.timeStart) {
				tScope = tTweening.scope;
				
				mustUpdate = tTweening.skipUpdates < 1 || !tTweening.skipUpdates || tTweening.updatesSkipped >= tTweening.skipUpdates;
				
				if (cTime >= tTweening.timeComplete) {
					isOver = true;
					mustUpdate = true;
				}
				
				if (!tTweening.hasStarted) {
					if (Boolean(tTweening.onStart)) {
						eventScope = Boolean(tTweening.onStartScope) ? tTweening.onStartScope : tScope;
						try {
							tTweening.onStart.apply(eventScope, tTweening.onStartParams);
						} catch (e2:Error) {
							handleError(tTweening, e2, "onStart");
						}
					}
					var pv:Number;
					for (pName in tTweening.properties) {
						if (tTweening.properties[pName].isSpecialProperty) {
							if (Boolean(_specialPropertyList[pName].preProcess)) {
								tTweening.properties[pName].valueComplete = _specialPropertyList[pName].preProcess(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].originalValueComplete, tTweening.properties[pName].extra);
							}
							pv = _specialPropertyList[pName].getValue(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
						} else {
							pv = tScope[pName];
						}
						tTweening.properties[pName].valueStart = isNaN(pv) ? tTweening.properties[pName].valueComplete : pv;
					}
					mustUpdate = true;
					tTweening.hasStarted = true;
				}
				
				if (mustUpdate) {
					for (pName in tTweening.properties) {
						tProperty = tTweening.properties[pName];
						
						if (isOver) {
							nv = tProperty.valueComplete;
						} else {
							if (tProperty.hasModifier) {
								t = cTime - tTweening.timeStart;
								d = tTweening.timeComplete - tTweening.timeStart;
								nv = tTweening.ease(t, 0, 1, d, tTweening.easeParams);
								nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
							} else {
								t = cTime - tTweening.timeStart;
								b = tProperty.valueStart;
								c = tProperty.valueComplete - tProperty.valueStart;
								d = tTweening.timeComplete - tTweening.timeStart;
								nv = tTweening.ease(t, b, c, d, tTweening.easeParams);
							}
						}
						
						if (tTweening.rounded)
							nv = Math.round(nv);
						if (tProperty.isSpecialProperty) {
							_specialPropertyList[pName].setValue(tScope, nv, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
						} else {
							tScope[pName] = nv;
						}
					}
					
					tTweening.updatesSkipped = 0;
					
					if (Boolean(tTweening.onUpdate)) {
						eventScope = Boolean(tTweening.onUpdateScope) ? tTweening.onUpdateScope : tScope;
						try {
							tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
						} catch (e3:Error) {
							handleError(tTweening, e3, "onUpdate");
						}
					}
				} else {
					tTweening.updatesSkipped++;
				}
				
				if (isOver && Boolean(tTweening.onComplete)) {
					eventScope = Boolean(tTweening.onCompleteScope) ? tTweening.onCompleteScope : tScope;
					try {
						tTweening.onComplete.apply(eventScope, tTweening.onCompleteParams);
					} catch (e4:Error) {
						handleError(tTweening, e4, "onComplete");
					}
				}
				
				return !isOver;
			}
			
			return true;
		}
		
		private static function startEngine():void {
			_engineExists = true;
			_tweenList = [];
			
			_controller = new Sprite();
			_controller.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
			
			_currentTimeFrame = 0;
			updateTime();
		}
		
		private static function stopEngine():void {
			_engineExists = false;
			_tweenList = null;
			_currentTime = 0;
			_currentTimeFrame = 0;
			_controller.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
			_controller = null;
		}
		
		private static function handleError(pTweening:TweenListObj, pError:Error, pCallBackName:String):void {
			if (Boolean(pTweening.onError) && (pTweening.onError is Function)) {
				var eventScope:Object = Boolean(pTweening.onErrorScope) ? pTweening.onErrorScope : pTweening.scope;
				try {
					pTweening.onError.apply(eventScope, [pTweening.scope, pError]);
				} catch (metaError:Error) {
					printError(String(pTweening.scope) + " raised an error while executing the 'onError' handler. Original error:\n " + pError.getStackTrace() + "\nonError error: " + metaError.getStackTrace());
				}
			} else {
				if (!Boolean(pTweening.onError))
					printError(String(pTweening.scope) + " raised an error while executing the '" + pCallBackName + "'handler. \n" + pError.getStackTrace());
			}
		}
	
	}
}
