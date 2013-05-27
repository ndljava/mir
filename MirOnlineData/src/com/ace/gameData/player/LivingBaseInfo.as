package com.ace.gameData.player {
	import com.ace.astarII.child.INode;
	import com.ace.enum.PlayerEnum;
	import com.ace.tools.print;

	import flash.geom.Point;

	public class LivingBaseInfo {
		public var _currentDir:int=0; //当前方向
		public var currentAct:String; //当前动作
		public var currentActIsLoop:Boolean;
		public var pathArr:Vector.<INode>; //路径
//		public var actArr:Array; //动作
		public var nextTile:Point; //下一个位置（tile坐标）
		public var nextPt:Point; //下一个位置（屏幕坐标）

		private var _moveLocked:Boolean; //移动锁定//野蛮冲撞是锁定人物
		public var dirLocked:Boolean; //方向锁定
		public var actLocked:Boolean; //动作锁定
		private var _speed:Number; //速度


		public var isMoveing:Boolean; //是否正在移动
		public var isAttacking:Boolean; //是否在攻击//动作完毕
		public var isHurting:Boolean; //是否在受伤
		public var isSpelling:Boolean; //是否在技能//动作完毕

		private var _waitHurt:Boolean; //等待受伤
		private var _waitFindPath:Boolean; //等待寻路
		private var _waitToTile:Point; //寻路的目标点

		//自动攻击
		private var _autoAttack:Boolean;
		public var attackTargetID:int=-1; //攻击目标玩家 
		public var cancelAttackTarget:Boolean; //取消攻击目标

		public var skillCdTime:int; //技能cd时间

		public function LivingBaseInfo() {
		}


		public function clearPath():void {
			while (this.pathArr.length) {
				this.pathArr.shift();
			}
		}

		public function get moveLocked():Boolean {
			return _moveLocked;
		}

		public function set moveLocked(value:Boolean):void {
			_moveLocked=value;
		}

		public function get speed():Number {
			return _speed;
		}

		public function set speed(value:Number):void {
			_speed=value;
		}

		public function get autoAttack():Boolean {
			return _autoAttack;
		}

		public function set autoAttack(value:Boolean):void {
			_autoAttack=value;
		}

		public function get waitFindPath():Boolean {
			return _waitFindPath;
		}

		public function get waitToTile():Point {
			return _waitToTile;
		}

		public function changeWaitToTile(pt:Point=null):void {
			if (pt) {
				this._waitToTile.x=pt.x;
				this._waitToTile.y=pt.y;
				this._waitFindPath=true;
			} else {
				this._waitFindPath=false;
			}
		}

		public function get waitHurt():Boolean {
			return _waitHurt;
		}

		public function changeHurt(value:Boolean=false):void {
			this._waitHurt=value
		}

		public function hasAttackTarget():Boolean {
			return this.attackTargetID != -1;
		}
	}
}