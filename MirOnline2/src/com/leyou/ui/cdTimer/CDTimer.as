package com.leyou.ui.cdTimer {
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sampler.getInvocationCount;
	import flash.utils.getTimer;

	public class CDTimer extends Sprite {
		private var cdMask:Shape;
		private var radius:Number;
		private var w:Number;
		private var h:Number;
		private var delayTime:int;
		private var perAngle:Number;
		private var initTime:int;
		private var idx:int;
		private var masker:Shape;

		public var cdEndFun:Function;

		public function CDTimer(w:Number, h:Number, time:int) {
			this.w=w;
			this.h=h;
			this.delayTime=time;
			this.perAngle=360 / (32) / (this.delayTime / 1000);
			this.init();
		}

		private function init():void {
			this.cdMask=new Shape();
			var r:Number=(w / 2) * (w / 2) + (h / 2) * (h / 2)
			this.radius=Math.sqrt(r);   
			this.cdMask.x=w / 2;
			this.cdMask.y=h / 2;
			this.cdMask.graphics.beginFill(0x000000);
			this.cdMask.alpha=.7;
			this.cdMask.graphics.drawCircle(0, 0, this.radius);
			this.cdMask.graphics.moveTo(0, 0);
			this.addChild(cdMask);

			this.masker=new Shape();
			this.masker.graphics.beginFill(0xffffff);
			this.masker.graphics.drawRect(0, 0, this.w, this.h);
			this.mask=this.masker;
			this.masker.x=2;
			this.masker.y=2;
			this.addChild(masker);
		}

		public function start():void {

			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
			this.initTime=getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
		}

		public function stop():void {
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
			this.idx=0;
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
			if (cdEndFun != null)
				cdEndFun();
		}

		private function onEnterFrameHandle(evt:Event):void {
			this.idx++;
			var angle:Number=this.idx * this.perAngle;
			angle=angle / 180 * Math.PI - 1 / 2 * Math.PI;
			var toX:Number=radius * Math.cos(angle);
			var toY:Number=radius * Math.sin(angle);
			this.cdMask.graphics.lineTo(toX, toY);
			if (this.delayTime <= getTimer() - this.initTime) {
				this.stop();
			}
		}
	}
}