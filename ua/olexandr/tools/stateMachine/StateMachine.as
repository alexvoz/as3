package ua.olexandr.tools.stateMachine {
	import flash.events.*;
	import flash.utils.Dictionary; 

	[Event(name="enter", type="ua.olexandr.tools.stateMachine.StateMachineEvent")]
	[Event(name="transition complete", type="ua.olexandr.tools.stateMachine.StateMachineEvent")]
	[Event(name="transition denied", type="ua.olexandr.tools.stateMachine.StateMachineEvent")]
	[Event(name="exit", type="ua.olexandr.tools.stateMachine.StateMachineEvent")]
	public class StateMachine extends EventDispatcher {
		
		public var id:String
		public var parentState:State;
		public var parentStates:Array;
		public var path:Array;
		
		private var _state:String;
		private var _states:Dictionary;
		private var _outEvent:StateMachineEvent;
		
		/**
		 * Creates a generic StateMachine. Available states can be set with addState and initial state can be set using initialState setter.
		 * @example This sample creates a state machine for a player model with 3 states (Playing, paused and stopped)
		 * <pre>
		 *	playerSM = new StateMachine();
		 *
		 *	playerSM.addState("playing",{ enter: onPlayingEnter, exit: onPlayingExit, from:["paused","stopped"] });
		 *	playerSM.addState("paused",{ enter: onPausedEnter, from:"playing"});
		 *	playerSM.addState("stopped",{ enter: onStoppedEnter, from:"*"});
		 *	
		 *	playerSM.addEventListener(StateMachineEvent.TRANSITION_DENIED,transitionDeniedFunction);
		 *	playerSM.addEventListener(StateMachineEvent.TRANSITION_COMPLETE,transitionCompleteFunction);
		 *	
		 *	playerSM.initialState = "stopped";
		 * </pre> 
		 *
		 * @example This example shows the creation of a hierarchical state machine for the monster of a game
		 *	<pre>
		 *	monsterSM = new StateMachine()
		 *	
		 *	monsterSM.addState("idle",{enter:onIdle, from:"attack"})
		 *	monsterSM.addState("attack",{enter:onAttack, from:"idle"})
		 *	monsterSM.addState("melee attack",{parent:"atack", enter:onMeleeAttack, from:"attack"})
		 *	monsterSM.addState("smash",{parent:"melle attack", enter:onSmash})
		 *	monsterSM.addState("punch",{parent:"melle attack", enter:onPunch})
		 *	monsterSM.addState("missle attack",{parent:"attack", enter:onMissle})
		 *	monsterSM.addState("die",{enter:onDead, from:"attack", enter:onDie})
		 *	monsterSM.initialState = "idle"
		 *	</pre>
		*/
		public function StateMachine() {
			_states = new Dictionary();
		}

		/**
		 * Adds a new state
		 * @param stateName	The name of the new State
		 * @param stateData	A hash containing state enter and exit callbacks and allowed states to transition from
		 * The "from" property can be a string or and array with the state names or * to allow any transition
		**/
		public function addState(name:String, data:Object = null):void {
			if (name in _states) 
				trace("[StateMachine]", id, "Overriding existing state " + name);
				
			data ||= { };
			
			_states[name] = new State(name, data.from, data.enter, data.exit, _states[data.parent])
		}

		/**
		 * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
		 * These will only occour if no state is defined
		 * @param stateName	The name of the State
		**/
		public function initState(name:String):void {
			if (_state && name in _states) {
				_state = name;
				
				var _callback:StateMachineEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
				_callback.toState = name;
					
				if (_states[_state].root) {
					parentStates = _states[_state].parents
					for (var j:int = _states[_state].parents.length - 1; j >= 0; j--) {
						if (parentStates[j].enter) {
							_callback.currentState = parentStates[j].name
							parentStates[j].enter.call(null,_callback)
						}
					}
				}
			
				if (_states[_state].enter) {
					_callback.currentState = _state
					_states[_state].enter.call(null, _callback)
				}
				
				_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
				_outEvent.toState = name;
				dispatchEvent(_outEvent);
			}
		}

		public function getStateByName(name:String):State {
			for each(var s:State in _states) {
				if (s.name == name)
					return s;
			}
			
			return null;
		}
		
		/**
		 * Verifies if a transition can be made from the current state to the state passed as param
		 * @param stateName	The name of the State
		**/
		public function canChangeStateTo(stateName:String):Boolean {
			return (stateName != _state && (_states[stateName].from.indexOf(_state) != -1 || _states[stateName].from == "*"));
		}

		/**
		 * Discovers the how many "exits" and how many "enters" are there between two
		 * given states and returns an array with these two integers
		 * @param stateFrom The state to exit
		 * @param stateTo The state to enter
		**/
		public function findPath(stateFrom:String, stateTo:String):Array {
			// Verifies if the states are in the same "branch" or have a common parent
			var fromState:State = _states[stateFrom];
			var c:int = 0;
			var d:int = 0;
			while (fromState) {
				d = 0;
				var toState:State = _states[stateTo];
				while (toState) {
					if(fromState == toState) {
						// They are in the same brach or have a common parent Common parent
						return [c,d];
					}
					d++;
					toState = toState.parent;
				}
				c++;
				fromState = fromState.parent;
			}
			// No direct path, no commom parent: exit until root then enter until element
			return [c, d];
		}

		/**
		 * Changes the current state
		 * This will only be done if the intended state allows the transition from the current state
		 * Changing states will call the exit callback for the exiting state and enter callback for the entering state
		 * @param stateTo	The name of the state to transition to
		**/
		public function changeState(stateTo:String):void {
			// If there is no state that maches stateTo
			if (!(stateTo in _states)) {
				trace("[StateMachine]", id, "Cannot make transition: State " + stateTo +" is not defined");
				return;
			}
			
			// If current state is not allowed to make this transition
			if(!canChangeStateTo(stateTo)) {
				//trace("[StateMachine]", id, "Transition to " + stateTo +" denied");
				_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED);
				_outEvent.fromState = _state;
				_outEvent.toState = stateTo;
				_outEvent.allowedStates = _states[stateTo].from;
				dispatchEvent(_outEvent);
				return;
			}
			
			// call exit and enter callbacks (if they exits)
			path = findPath(_state, stateTo);
			if (path[0] > 0) {
				var _exitCallback:StateMachineEvent = new StateMachineEvent(StateMachineEvent.EXIT_CALLBACK);
				_exitCallback.toState = stateTo;
				_exitCallback.fromState = _state;
				
				if (_states[_state].exit) {
					_exitCallback.currentState = _state;
					_states[_state].exit.call(null, _exitCallback);
				}
				parentState = _states[_state];
				for(var i:int=0; i<path[0]-1; i++) {
					parentState = parentState.parent;
					if (parentState.exit != null) {
						_exitCallback.currentState = parentState.name;
						parentState.exit.call(null,_exitCallback);
					}
				}
			}
			var oldState:String = _state;
			_state = stateTo;
			if (path[1] > 0) {
				var _enterCallback:StateMachineEvent = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
				_enterCallback.toState = stateTo;
				_enterCallback.fromState = oldState;
				
				if(_states[stateTo].root) {
					parentStates = _states[stateTo].parents
					for (var k:int = path[1] - 2; k >= 0; k--) {
						if (parentStates[k] && parentStates[k].enter) {
							_enterCallback.currentState = parentStates[k].name;
							parentStates[k].enter.call(null,_enterCallback);
						}
					}
				}
				if (_states[_state].enter) {
					_enterCallback.currentState = _state;
					_states[_state].enter.call(null, _enterCallback);
				}
			}
			//trace("[StateMachine]",id,"State Changed to " + _state);
			
			// Transition is complete. dispatch TRANSITION_COMPLETE
			_outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
			_outEvent.fromState = oldState ;
			_outEvent.toState = stateTo;
			dispatchEvent(_outEvent);
		}
		
		/**
		 * Getters for the current state
		 */
		public function get state():String { return _states[_state]; }
		
	}
}