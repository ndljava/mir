package com.leyou.manager {
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class TimerManager {

		private var dic:Dictionary=new Dictionary(true);

		private var _i:int=0;

		private static var _instance:TimerManager;
		private var _timer:Timer;

		public function TimerManager() {
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		public static function getInstance():TimerManager {
			if (_instance == null)
				_instance=new TimerManager();

			return _instance;
		}

		private function onTimer(e:TimerEvent):void {
			if (length() <= 0) {
				_timer.stop();
				_timer.reset();
			}

			var func:Function;
			for each (func in dic) {
				func();
			}
		}

		public function add(f:Function, key:String=null):void {

			if (search(f))
				return;

			if (key == null)
				dic[_i]=f;
			else
				dic[key]=f;

			if (!_timer.running)
				_timer.start();

			_i++;
		}

		public function search(f:Function):Boolean {
			var _f:Function;
			for each (_f in dic) {
				if (_f == f) {
					return true;
				}
			}

			return false;
		}

		public function remove(f:Function):void {
			var _f:String;
			for (_f in dic) {
				if (dic[_f] == f) {
					dic[_f] == null;
					delete dic[_f];
					break;
				}
			}
		}
		
		public function removeBykey(key:String):void {
			var _f:String;
			for (_f in dic) {
				if (_f == key) {
					dic[_f] == null;
					delete dic[_f];
					break;
				}
			}
		}

		public function removeAll():void {
			var key:String;
			for (key in dic) {
				dic[key] == null;
				delete dic[key];
			}
			
			stop();
			reset();
		}

		public function start():void {
			_timer.start();
		}

		public function stop():void {
			_timer.stop();
		}

		public function reset():void {
			_timer.reset();
		}

		public function length():int {
			var i:int=0;
			var f:Function;
			for each (f in dic) {
				i++
			}

			return i;
		}


	}
}
