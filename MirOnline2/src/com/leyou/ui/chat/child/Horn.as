package com.leyou.ui.chat.child {
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.leyou.utils.FilterUtil;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Horn extends Sprite {

		public var timeOutFun:Function;

		private var bg:ScaleBitmap;
		private var textField:RichTextFiled;
		private var timer:Timer;

		public function Horn() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.init();
		}

		private function init():void {
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.8;
			this.addChildAt(this.bg, 0);
			this.textField=new RichTextFiled(294, 100, true);
			this.addChild(this.textField);
			this.status=false;
		}

		public function setStr(str:String):void {

			this.textField.clearContain();
			this.textField.appendHtmlText(str);
			this.bg.setSize(294, this.textField.height + 3);
			this.status=true;
			this.countDown(10000);
		}

		private function set status(bool:Boolean):void {
			this.visible=bool;
			if (bool) {
				FilterUtil.showGlowFilter(this, .2);
			}
		}

		public function countDown(time:int):void {
			this.timer=new Timer(time);
			this.timer.addEventListener(TimerEvent.TIMER, onTimerHander);
			this.timer.start();
		}

		private function onTimerHander(evt:TimerEvent):void {
			this.timer.removeEventListener(TimerEvent.TIMER, onTimerHander);
			this.status=false;
			if (this.timeOutFun != null)
				this.timeOutFun();
		}

	}
}