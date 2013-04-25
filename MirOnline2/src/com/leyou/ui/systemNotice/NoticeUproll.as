package com.leyou.ui.systemNotice {
	import com.ace.enum.UIEnum;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.ui.systemNotice.child.NoticeItem;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *屏幕中间向上滚动
	 * @author Administrator
	 *
	 */
	public class NoticeUproll extends Sprite {
		private var list:Array;
		private var format:TextFormat;

		public function NoticeUproll() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.list=new Array();
			this.format=new TextFormat();
			this.format.size=SystemNoticeEnum.Message2Size;
			this.format.font=SystemNoticeEnum.Message2Font;
		}

		public function setNoticeStr(str:String):void {
			if (this.list.length == 5) {
				this.resetList();
			}
			var noticeItem:NoticeItem=new NoticeItem();
			noticeItem.callBack=this.resetList;
			var txt:Label=noticeItem.lbl;
			txt.defaultTextFormat=this.format;
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.htmlText=str;
			txt.selectable=false;
			txt.textColor=SystemNoticeEnum.Message2Colour;
			txt.maxChars=SystemNoticeEnum.Message2Count;
			this.addChild(txt);
			this.list.push(noticeItem);
			this.resize();
			noticeItem.countDown(SystemNoticeEnum.Message1TIME);
		}

		private function resetList():void {
			if (this.list[0] != null && (this.list[0] as NoticeItem).lbl.parent != null) {
				(this.list[0] as NoticeItem).clearEvent();
				this.removeChild((list[0] as NoticeItem).lbl);
			}
			this.list.shift();
			if (this.list.length == 5)
				this.resize();
		}

		public function resize():void {
			for (var i:int=this.list.length - 1; i >= 0; i--) {
				(this.list[i] as NoticeItem).lbl.x=(UIEnum.WIDTH - (this.list[i] as NoticeItem).lbl.width) / 2;
				(this.list[i] as NoticeItem).lbl.y=4 * (this.list[i] as NoticeItem).lbl.textHeight + 60 - (this.list.length - i) * (this.list[i] as NoticeItem).lbl.textHeight;
			}
		}
	}
}