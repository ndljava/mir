package com.leyou.ui.systemNotice.child {
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class NoticeImgItem extends Sprite {
		private var lbl:Label;
		private var img:Image;
		private var bg:ScaleBitmap;
		private var timer:Timer;
		private var imgFlg:int;
		private var fromat:TextFormat;

		public var callBack:Function;

		public function NoticeImgItem(imgFlg:int) {
			super();
			this.imgFlg=imgFlg;
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.init();
		}

		private function init():void {
			this.fromat=new TextFormat();
			this.lbl=new Label();
			this.addChild(this.lbl);
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.8;
			this.addChildAt(this.bg, 0);
			this.lbl.autoSize=TextFieldAutoSize.LEFT;
			this.lbl.selectable=false;
			this.img=new Image();
			if (imgFlg == SystemNoticeEnum.IMG_WRONG) { //红色叹号
				this.img.updateBmp("ui/other/wrong.png");
				this.lbl.textColor=SystemNoticeEnum.IMG_WRONG_Colour;
				this.lbl.maxChars=SystemNoticeEnum.IMG_WRONG_Count;
				this.fromat=new TextFormat();
				this.fromat.size=SystemNoticeEnum.IMG_WRONG_Size;
				this.fromat.font=SystemNoticeEnum.IMG_WRONG_Font;
				this.lbl.defaultTextFormat=this.fromat;
			}
			if (imgFlg == SystemNoticeEnum.IMG_PROMPT) { //黄色叹号
				this.img.updateBmp("ui/other/prompt.png");
				this.lbl.textColor=SystemNoticeEnum.IMG_PROMPT_Colour;
				this.lbl.maxChars=SystemNoticeEnum.IMG_PROMPT_Count;
				this.fromat=new TextFormat();
				this.fromat.size=SystemNoticeEnum.IMG_PROMPT_Size;
				this.fromat.font=SystemNoticeEnum.IMG_PROMPT_Font;
				this.lbl.defaultTextFormat=this.fromat;
			}
			if (imgFlg == SystemNoticeEnum.IMG_WARN) { //蓝色叹号
				this.img.updateBmp("ui/other/warn.png");
				this.lbl.textColor=SystemNoticeEnum.IMG_WARN_Colour;
				this.lbl.maxChars=SystemNoticeEnum.IMG_WARN_Count;
				this.fromat=new TextFormat();
				this.fromat.size=SystemNoticeEnum.IMG_WARN_Size;
				this.fromat.font=SystemNoticeEnum.IMG_WARN_Font;
				this.lbl.defaultTextFormat=this.fromat;
			}
			this.addChild(this.img);
		}

		public function set lblText(str:String):void {
			this.lbl.htmlText=str;
			if (this.img.width + 20 + this.lbl.width < 300) {
				this.lbl.x=(300 - this.lbl.width) / 2;
				this.bg.setSize(300, this.img.height);
			} else {
				this.lbl.x=this.img.width + 10;
				this.bg.setSize(this.img.width + 20 + this.lbl.width, this.img.height);
			}
			this.lbl.y=(this.bg.height - this.lbl.height) / 2;
		}

		public function set textFromat(fromat:TextFormat):void {
			this.lbl.defaultTextFormat=fromat;
		}

		public function countDown(time:int):void {
			if(this.timer&&this.timer.hasEventListener(TimerEvent.TIMER))
				this.timer.removeEventListener(TimerEvent.TIMER, onTimerHander);
			this.timer=new Timer(time);
			this.timer.addEventListener(TimerEvent.TIMER, onTimerHander);
			this.timer.start();
			
		}

		private function onTimerHander(evt:TimerEvent):void {
			this.timer.removeEventListener(TimerEvent.TIMER, onTimerHander);
			this.lbl.addEventListener(Event.ENTER_FRAME, this.onChange);
		}

		private function onChange(evt:Event):void {
			this.alpha-=.05;
			if (this.alpha <= 0) {
				this.lbl.removeEventListener(Event.ENTER_FRAME, this.onChange);
				if (this.callBack != null)
					this.callBack();
			}
		}

		public function get text():String {
			return this.lbl.text;
		}

		public function clearEvent():void {
			if (this.timer && this.timer.hasEventListener(TimerEvent.TIMER))
				this.timer.removeEventListener(TimerEvent.TIMER, this.onTimerHander);
			if (this.lbl && this.lbl.hasEventListener(Event.ENTER_FRAME))
				this.lbl.removeEventListener(Event.ENTER_FRAME, this.onChange);
		}

	}
}