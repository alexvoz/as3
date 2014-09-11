package ua.olexandr.tools {
	import flash.geom.Point;
	import ua.olexandr.data.Array2D;
	
	public class AStar {
		
		private const RECT:Number = 1;
		private const DIAG:Number = Math.sqrt(RECT * 2);
		
		private const FULL:int = 0;
		private const STRAIGHT:int = 1;
		private const DIAGONAL:int = 2;
		
		private var _map:Array2D;
		private var _valid:Array;
		private var _discarded:Array;
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 */
		public function AStar(width:uint, height:uint) {
			_map = new Array2D(width, height);
			
			for (var x:int = 1; x <= width; x++) {
				for (var y:int = 1; y <= height; y++)
					_map.setValue(x, y, new AStarNode(x, y));
			}
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @return
		 */
		public function getEuclidianPath(start:Point, end:Point):Array {
			return getPath(start, end, calculateEuclidian, FULL);
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @return
		 */
		public function getManhathanPath(start:Point, end:Point):Array {
			return getPath(start, end, calculateManhathan, FULL);
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @return
		 */
		public function getOrthogonalStraightPath(start:Point, end:Point):Array {
			return getPath(start, end, calculateManhathan, STRAIGHT);
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 * @return
		 */
		public function getOrthogonalDiagonalPath(start:Point, end:Point):Array {
			return getPath(start, end, calculateManhathan, DIAGONAL);
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	walkable
		 */
		public function setNodeWalkable(x:int, y:int, walkable:Boolean):void {
			_map.getValue(x, y).walkable = walkable;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getNodeWalkable(x:int, y:int):Boolean {
			return _map.getValue(x, y).walkable;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getNodeCell(x:int, y:int):Point {
			return _map.getValue(x, y).cell;
		}
		
		
		private function resetMap():void {
			var _node:AStarNode;
			
			for (var x = 1; x <= _map.width; x++) {
				for (var y = 1; y <= _map.height; y++) {
					_node = _map.getValue(x, y);
					_node.g = _node.h = 0;
					_node.parent = null;
				}
			}
			
			_valid = [];
			_discarded = [];
		}
		
		private function getPath(start:Point, end:Point, distance:Function, searchType:int):Array {
			resetMap();
			
			var _pathFound:Boolean = false;
			var _currentNode:AStarNode = _map.getValue(start.x, start.y);
			var _startNode:AStarNode = _currentNode;
			var _endNode:AStarNode = _map.getValue(end.x, end.y);
			
			_currentNode.h = distance(_currentNode, _endNode);
			
			_valid.push(_currentNode);
			
			while (!_pathFound) {
				_valid.sortOn("fullCost", Array.NUMERIC);
				
				if (_valid.length <= 0)
					break;
				
				_currentNode = _valid.shift();
				
				if (_currentNode.cell.x == _endNode.cell.x && _currentNode.cell.y == _endNode.cell.y) {
					_pathFound = true;
					break;
				}
				
				_discarded.push(_currentNode);
				
				for each (var node:AStarNode in getNeighborhood(_currentNode, searchType)) {
					if (_valid.indexOf(node) == -1 && _discarded.indexOf(node) == -1) {
						_valid.push(node);
						node.parent = _currentNode;
						node.h = distance(node, _endNode);
						node.g = _currentNode.g;
					} else {
						var _fullCost:Number = _currentNode.g + node.fullCost;
						
						if (_fullCost < node.fullCost) {
							node.parent = _currentNode;
							node.g = _currentNode.g;
						}
					}
				}
			}
			
			if (_pathFound) {
				var _path:Array = [];
				
				_path.push(_currentNode.cell);
				
				while (_currentNode.parent && _currentNode.parent != _startNode) {
					_currentNode = _currentNode.parent;
					_path.push(_currentNode.cell);
				}
				
				return _path;
			}
			
			return null;
		}
		
		private function getNeighborhood(node2test:AStarNode, searchType:int):Array {
			var _neighborArr:Array = [];
			var _neighbor:AStarNode;
			var _x:uint = node2test.cell.x;
			var _y:uint = node2test.cell.y;
			
			for (var direction = 1; direction <= 8; direction++) {
				if (searchType == STRAIGHT || searchType == FULL) {
					switch (direction) {
						case 1: 
							_neighbor = checkNeighbor(_x - 1, _y, direction);
							break;
						case 2: 
							_neighbor = checkNeighbor(_x + 1, _y, direction);
							break;
						case 3: 
							_neighbor = checkNeighbor(_x, _y - 1, direction);
							break;
						case 4: 
							_neighbor = checkNeighbor(_x, _y + 1, direction);
							break;
					}
				}
				
				if (searchType == DIAGONAL || searchType == FULL) {
					switch (direction) {
						
						case 5: 
							_neighbor = checkNeighbor(_x - 1, _y - 1, direction);
							break;
						case 6: 
							_neighbor = checkNeighbor(_x - 1, _y + 1, direction);
							break;
						case 7: 
							_neighbor = checkNeighbor(_x + 1, _y - 1, direction);
							break;
						case 8: 
							_neighbor = checkNeighbor(_x + 1, _y + 1, direction);
							break;
					}
				}
				
				if (_neighbor != null)
					_neighborArr.push(_neighbor);
			}
			
			return _neighborArr;
		}
		
		private function checkNeighbor(x, y, d):AStarNode {
			if (x < 1 || x > _map.width || y < 1 || y > _map.height)
				return null;
			
			var _node:AStarNode = _map.getValue(x, y);
			var _cost:Number = (d >= 5 ? DIAG : RECT);
			
			if (_node.walkable) {
				_node.g += _cost;
				return _node;
			}
			
			return null;
		}
		
		
		private function calculateEuclidian(start:AStarNode, end:AStarNode):Number {
			return Math.sqrt(Math.pow((start.cell.x - end.cell.x), 2) + Math.pow((start.cell.y - end.cell.y), 2));
		}
		
		private function calculateManhathan(start:AStarNode, end:AStarNode):Number {
			return Math.abs(start.cell.x - end.cell.x) + Math.abs(start.cell.y - end.cell.y);
		}
		
	}
}

import bpe.structures.Point;

class AStarNode {
	
	public var cell:Point = new Point();
	
	public var g:Number = 0;
	public var h:Number = 0;
	
	public var walkable:Boolean = true;
	public var parent:AStarNode = null;
	
	public function AStarNode(x:int, y:int) {
		cell.x = x;
		cell.y = y;
		
		g = globalCost;
		h = heuristicsCost;
	}
	
	public function get fullCost():Number { return g + h }
	
}