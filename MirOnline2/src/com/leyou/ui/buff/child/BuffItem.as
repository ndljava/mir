package com.leyou.ui.buff.child {
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.utils.TipsUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class BuffItem extends Sprite {
		public var id:int;
		private var _iconIdx:int;
		private var _time:int;
		public var icon:Image;
		public var tipsStr:String;
		public var timeOutFun:Function;

//		private var timer:Timer;
		private var timerFlag:int;
		private var tipSta:Boolean;

		public function BuffItem() {
			this.init();
		}

		private function init():void {
			this.icon=new Image();
			this.addChild(this.icon);
			this.id=-1;
			this._time=0;
			this.tipsStr="";
			this.addEventListener(MouseEvent.MOUSE_OVER, onOverFun);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOutFun);
		}

		private function onOverFun(evt:MouseEvent):void {
			this.tipSta=true;
			this.showTips(getTimeStr(this._time - this.timerFlag));
			var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
			ItemTip.getInstance().updataPs(p.x, p.y);
		}

		private function onOutFun(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
			this.tipSta=false;
		}

		private function showTips(t:String):void {
			var str:String=this.tipsStr;
			while (str.indexOf("\\") != -1)
				str=str.replace("\\", "\n");
			str=t + "\n" + TipsUtil.getColorStr(str, TipsEnum.COLOR_BLUE);
			ItemTip.getInstance().showString(str);
		}

		public function clearMe():void {
			this.timeStop();
			if (this.hasEventListener(MouseEvent.MOUSE_OVER))
				this.removeEventListener(MouseEvent.MOUSE_OVER, onOverFun);
			if (this.hasEventListener(MouseEvent.MOUSE_OUT))
				this.removeEventListener(MouseEvent.MOUSE_OUT, onOutFun);
			this.id=-1;
			this._time=0;
			this.icon=null;
			this.tipsStr=null;
			ItemTip.getInstance().hide();

		}

		public function timeStart():void {
			this.timerFlag=0;
			TimerManager.getInstance().add(onTimeFun);
//			this.timer=new Timer(1000, this._time);
//			this.timer.start();
//			this.timer.addEventListener(TimerEvent.TIMER, onTimeFun);

		}

		public function timeStop():void {
//			if (this.timer)
//				this.timer.stop();
//			if (this.timer.hasEventListener(TimerEvent.TIMER))
//				this.timer.removeEventListener(TimerEvent.TIMER, onTimeFun);
			TimerManager.getInstance().remove(onTimeFun);
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onTimeFun(evt:TimerEvent=null):void {
			this.timerFlag++;
			if (this.tipSta)
				this.showTips(getTimeStr(this._time - this.timerFlag));
			if (this._time - this.timerFlag <= 10) {
//				if (this.alpha == 1)
//					this.alpha=.5;
//				else
//					this.alpha=1;
				if (!this.hasEventListener(Event.ENTER_FRAME))
					this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (this.timerFlag >= this._time) {
				TimerManager.getInstance().remove(onTimeFun);
//				this.timer.stop();
//				this.timer.removeEventListener(TimerEvent.TIMER, onTimeFun);
				if (this.timeOutFun != null) {
					this.timeOutFun(this);
				}
				if (this.hasEventListener(Event.ENTER_FRAME))
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function onEnterFrame(evt:Event):void {
			if (this.alpha > 0)
				this.alpha-=.03;
			else
				this.alpha=1;
		}

		public function set time(t:int):void {
			this._time=t;
		}

		public function get time():int{
			return this._time;
		}
		private function getTimeStr(t:int):String {
			var str:String=new String();
			if (t > 60 * 60)
				str="长期";
			else {
				var _t:int;
				var s:int=t % 60;
				var m:int=Math.floor(t / 60);
				str=m + "分" + s + "秒";
			}
			return TipsUtil.getColorStr(str, TipsEnum.COLOR_YELLOW);
		}

		public function set iconIdx(idx:int):void {
			this._iconIdx=idx;
			this.icon.updateBmp("ico/buffer/" + idx + ".png");
		}

		public function get iconIdx():int {
			return this._iconIdx;
		}


	}
}