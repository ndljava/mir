package com.leyou.ui.systemNotice {
	import com.ace.enum.UIEnum;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.ui.systemNotice.child.NoticeItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 *跟随鼠标移动 
	 * @author Administrator
	 * 
	 */
	public class NoticeMouseFollow extends Sprite {
		private var item:NoticeItem;
		private var lbl:Label;
		private var list:Array;

		public function NoticeMouseFollow() {
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this,init();
		}
		
		private function init():void{
			this.list=new Array();
			this.item=new NoticeItem();
			this.item.callBack=timeOut;
			this.lbl=this.item.lbl;
			this.lbl.textColor=SystemNoticeEnum.Message1Colour;
			this.lbl.maxChars=SystemNoticeEnum.Message1Count;
			this.lbl.autoSize=TextFieldAutoSize.LEFT;
			var format:TextFormat=new TextFormat();
			format.size=SystemNoticeEnum.Message1Size;
			format.font=SystemNoticeEnum.Message1Font;
			this.lbl.defaultTextFormat=format;
			this.addChild(this.lbl);
		}
		public function setNoticeStr(str:String):void {
			if (this.list.length > 0)
				this.list.push(str);
			else {
				this.list.push(str);
				this.lbl.alpha=1;
				this.lbl.htmlText=str;
				this.item.countDown(SystemNoticeEnum.Message1TIME);
				this.lbl.addEventListener(Event.ENTER_FRAME, onEnterFramHandle);
			}
		}

		private function timeOut():void {
			this.list.shift();
			if (this.list.length <= 0) {
				this.lbl.htmlText="";
				this.lbl.alpha=1;
				this.lbl.removeEventListener(Event.ENTER_FRAME, onEnterFramHandle);
			} else {
				this.lbl.htmlText=this.list[0];
				this.lbl.alpha=1;
				this.item.countDown(SystemNoticeEnum.Message1TIME);
			}
		}

		private function onEnterFramHandle(evt:Event):void {
			this.lbl.x=this.stage.mouseX + 10;
			this.lbl.y=this.stage.mouseY + 10;
			if (this.lbl.x + this.lbl.width > UIEnum.WIDTH)
				this.lbl.x=UIEnum.WIDTH - this.lbl.width;
			else if (this.lbl.x < 0)
				this.lbl.x=0;
			if (this.lbl.y + this.lbl.height > UIEnum.HEIGHT)
				this.lbl.y=UIEnum.HEIGHT - this.lbl.height;
			else if (this.lbl.y < 0)
				this.lbl.y=0;
		}
	}
}