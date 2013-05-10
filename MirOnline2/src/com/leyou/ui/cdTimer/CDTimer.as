package com.leyou.ui.cdTimer {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class CDTimer extends Sprite {
		private var cdMask:Sprite;
		private var radius:Number;
		private var w:Number;
		private var h:Number;
		private var delayTime:int;
		private var perAngle:Number;
		private var initTime:int;
		private var idx:int;
		private var masker:Sprite;

		public var cdEndFun:Function;
		public var enterFrameFun:Function;

		public function CDTimer(w:Number, h:Number) {
//			this.width=w+2;
//			this.height=h+2;
			this.w=w;
			this.h=h;
			this.init();
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}

		private function init():void {
			this.cdMask=new Sprite();
			var r:Number=((w-7) / 2) * ((w-7) / 2) + ((h-7) / 2) * ((h-7) / 2)
			this.radius=Math.sqrt(r);
			this.cdMask.x=(w+4) / 2;
			this.cdMask.y=(h+4) / 2;
			this.cdMask.graphics.beginFill(0x000000);
			this.cdMask.alpha=.7;
			this.cdMask.graphics.drawCircle(0, 0, this.radius);
			this.cdMask.graphics.moveTo(0, 0);
			this.addChild(cdMask);

			this.masker=new Sprite();
			this.masker.graphics.beginFill(0xffffff);
			this.masker.graphics.drawRect(0, 0, this.w-2, this.h-2);
			this.mask=this.masker;
			this.masker.x=2;
			this.masker.y=2;
			this.addChild(masker);
//			this.reset();
			this.width=this.w-4;
			this.height=this.h-4;
		}

		public function reset():void {
//			this.init();
//			this.cdMask.graphics.beginFill(0x000000);
//			this.cdMask.alpha=.7;
			this.cdMask.graphics.clear();
			this.cdMask.graphics.beginFill(0x000000);
			this.cdMask.alpha=.7;
			this.cdMask.graphics.lineTo(0,this.radius)
			this.cdMask.graphics.moveTo(0, 0);
			this.cdMask.graphics.drawCircle(0, 0, this.radius);
			this.cdMask.graphics.moveTo(0, 0);
//			this.masker.graphics.beginFill(0xffffff);
//			this.masker.graphics.drawRect(0, 0, this.w-2, this.h-2);
//			this.mask=this.masker;
			this.idx=0;
		}

		public function start(time:int):void {
			this.delayTime=time;
			this.perAngle=360 / (32) / (this.delayTime / 1000);
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
			this.initTime=getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
		}

		public function stop():void {
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandle);
			this.idx=0;
			if (cdEndFun != null)
				cdEndFun();
			this.reset();
		}

		private function onEnterFrameHandle(evt:Event):void {
			var angle:Number=this.idx * this.perAngle;
			angle=(angle / 180) * Math.PI - 1/2 * Math.PI;
			var toX:Number=radius * Math.cos(angle);
			var toY:Number=radius * Math.sin(angle);
			this.cdMask.graphics.lineTo(toX, toY);
			this.idx++;
			if(this.enterFrameFun!=null)
				this.enterFrameFun(this.delayTime-(getTimer() - this.initTime));
			if (this.delayTime <= getTimer() - this.initTime) {
				this.stop();
			}
			
		}





	}
}