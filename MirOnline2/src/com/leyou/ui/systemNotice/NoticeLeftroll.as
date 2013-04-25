package com.leyou.ui.systemNotice {
	import com.ace.enum.UIEnum;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *屏幕上方向左滚动
	 * @author Administrator
	 *
	 */
	public class NoticeLeftroll extends Sprite {
		private var noticeArr:Array;
		private var lbl:Label;
		private var bg:Sprite;
		private var w:Number;
		private var msk:Shape;

		public function NoticeLeftroll() {
			super();
			this.init();
		}

		private function init():void {
			this.w=600;
			this.bg=new Sprite();
			this.noticeArr=new Array();
			this.lbl=new Label();
			this.lbl.maxChars=SystemNoticeEnum.PostCount;
			this.lbl.textColor=SystemNoticeEnum.PostColour;
			var format:TextFormat=new TextFormat();
			format.size=SystemNoticeEnum.PostSize;
			format.font=SystemNoticeEnum.PostFont;
			this.lbl.defaultTextFormat=format;
			this.lbl.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(this.lbl);
			this.msk=new Shape();
			this.msk.graphics.beginFill(0x050505, .5);
			this.msk.graphics.drawRect(0, 0, this.w, 30);
			this.msk.graphics.endFill();
			this.addChild(this.msk);
			this.lbl.mask=this.msk;
			this.lbl.x=300;
			this.lbl.y=2;
			this.addBg();
			this.lbl.visible=false;
			this.bg.visible=false;
		}

		private function addBg():void {
			this.bg.graphics.beginFill(0x000000, .5);
			this.bg.graphics.drawRect(0, 0, this.w, 30);
			this.bg.graphics.endFill();
			this.addChildAt(this.bg, 0);
		}

		public function setNoticeStr(str:String):void {
			if (str == null || str == "")
				return;
			if (this.lbl.hasEventListener(Event.ENTER_FRAME)) {
				this.noticeArr.push(str);
			} else {
				if (this.bg.hasEventListener(Event.ENTER_FRAME))
					this.bg.removeEventListener(Event.ENTER_FRAME, onBgChange);
				this.lbl.visible=true;
				this.bg.visible=true;
				this.bg.x=0;
				this.bg.width=this.w;
				this.lbl.htmlText=str;
				this.lbl.addEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
			}
		}

		private function onEnterFrameHandle(evt:Event):void {
			if (this.lbl.x <= -this.lbl.width) {
				this.lbl.x=this.bg.width;
				if (this.noticeArr.length <= 0) {
					this.clearMe();
					return;
				} else
					this.lbl.htmlText=this.noticeArr.shift();
			} else
				this.lbl.x-=SystemNoticeEnum.PostSpeed;
		}

		private function clearMe():void {
			this.lbl.htmlText="";
			this.lbl.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
			this.lbl.visible=false;
			this.bg.addEventListener(Event.ENTER_FRAME, onBgChange);
		}

		private function onBgChange(evt:Event):void {
			this.bg.x+=25;
			this.bg.width-=50;

			if (this.bg.width <= 0) {
				this.bg.removeEventListener(Event.ENTER_FRAME, onBgChange);
				this.bg.visible=false;
			}
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=10;
		}
	}
}