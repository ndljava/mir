package com.leyou.ui.systemNotice.child {
	import com.ace.enum.TickEnum;
	import com.ace.ui.lable.Label;
	import com.leyou.net.protocol.TDefaultMessage;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class NoticeItem {
		private var _lbl:Label;
		private var timer:Timer;
		private var enterFrameF:Boolean;
		private var timerSecond:Timer;
		private var countDFlag:int; //0：倒计时    1：正计时

		public var callBack:Function;

		public var dataObj:Object;
		public var id:int;

		public function NoticeItem():void {
			this._lbl=new Label();
			this._lbl.selectable=false;
			this._lbl.mouseEnabled=false;
			this.dataObj=new Object();
		}

		public function get lbl():Label {
			return this._lbl;
		}

		public function countDown(time:int):void {
			this.timer=new Timer(time);
			this.timer.addEventListener(TimerEvent.TIMER, onTimerHander);
			this.timer.start();
		}

		private function onTimerHander(evt:TimerEvent):void {
			this.timer.removeEventListener(TimerEvent.TIMER, onTimerHander);
			this._lbl.addEventListener(Event.ENTER_FRAME, this.onChange);
		}

		private function onChange(evt:Event):void {
			this._lbl.alpha-=.25;
			if (this._lbl.alpha <= 0) {
				this._lbl.removeEventListener(Event.ENTER_FRAME, this.onChange);
				if (this.callBack != null)
					this.callBack();
			}
		}

		public function clearEvent():void {
			if (this.timer && this.timer.hasEventListener(TimerEvent.TIMER)) {
				this.timer.stop();
				this.timer.removeEventListener(TimerEvent.TIMER, this.onTimerHander);
			}
			if (this._lbl.hasEventListener(Event.ENTER_FRAME))
				this._lbl.removeEventListener(Event.ENTER_FRAME, this.onChange);
			if (this.timerSecond && this.timerSecond.hasEventListener(TimerEvent.TIMER)) {
				this.timerSecond.stop();
				this.timerSecond.removeEventListener(TimerEvent.TIMER, onTimerSecondHander);
			}

		}


		/**
		 *显示倒计时时调用
		 * @param td
		 * @param body
		 *
		 */
		public function setStr(td:TDefaultMessage, body:String):void {
			if (this.timerSecond)
				this.clearEvent();
			this.dataObj.td=td;
			dataObj.body=body;
			var str:String=new String();
			if (body.indexOf("倒计时") > -1) { //倒计时
				this.setText();
				this.countDFlag=0;
				this.countDownScond(td.Tag);
			} else if (body.indexOf("正计时") > -1) { //正计时
				this.setText();
				this.countDFlag=1;
				this.countDownScond(td.Tag);
			}
			var he:String=td.Param.toString(16);
			this.lbl.textColor=uint(he);
		}

		/**
		 *显示信息
		 *
		 */
		private function setText():void {
			var str:String=new String();
			str=this.dataObj.body.substr(0, this.dataObj.body.indexOf(" "));
			str+=" " + getStringTime(this.dataObj.td.Tag);
			this._lbl.htmlText=str;
//			this._lbl.textColor=0xff00ff;
		}

		/**
		 *倒计时时调用的计时
		 * @param time
		 * @param interval
		 *
		 */
		public function countDownScond(time:int, interval:int=1000):void {
			this.timerSecond=new Timer(interval, time);
			this.timerSecond.start();
			this.timerSecond.addEventListener(TimerEvent.TIMER, onTimerSecondHander);
		}

		private function onTimerSecondHander(evt:Event):void {
			if (this.countDFlag == 0) { //倒计时
				(this.dataObj.td as TDefaultMessage).Tag--;
				this.setText();
				if ((this.dataObj.td as TDefaultMessage).Tag <= 0) {
					if (this.callBack != null) {
						this.clearEvent();
						this.callBack(id);
					}
				}
			} else if (this.countDFlag == 1) {
				this.dataObj.td.Tag++;
				this.setText();
				if (this.dataObj.td.Tag == 60 * 60 * 24) {
					this.clearEvent();
					this.callBack(id);
				}
			}
		}

		private function getStringTime(time:int):String {
			var str:String=new String();
			var _minite:int;
			var hour:int=0;
			var minite:int=0;
			var second:int=0;
			var day:int;

			second=time % 60; //秒
			_minite=(time - second) / 60;
			minite=_minite % 60; //分钟
			hour=(_minite - minite) / 60;
			day=Math.floor(hour / 24); //天
			hour=hour % 24; //小时
			if (day > 0)
				str=day + "天";
			if (hour > 0)
				str+=hour + "小时";
			if (minite > 0)
				str+=minite + "分钟";
			if (second > 0)
				str+=second + "秒";
			return str;
		}

	}
}