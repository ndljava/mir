package com.leyou.ui.systemNotice {
	import com.ace.enum.UIEnum;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.systemNotice.child.NoticeItem;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 *屏幕下方 技能栏上方 
	 * @author Administrator
	 * 
	 */
	public class NoticeMidDown extends Sprite {
		private var list:Array;
		private var item:NoticeItem;
		private var lbl:Label;

		public function NoticeMidDown() {
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.init();
		}

		private function init():void {
			var format:TextFormat=new TextFormat();
			format.size=SystemNoticeEnum.Message4Size;
			format.font=SystemNoticeEnum.Message4Font;
			this.list=new Array();
			this.item=new NoticeItem();
			this.item.callBack=timeOut;
			this.lbl=this.item.lbl;
			this.lbl.defaultTextFormat=format;
			this.lbl.autoSize=TextFieldAutoSize.LEFT;
			this.lbl.textColor=SystemNoticeEnum.Message4Colour;
			this.lbl.maxChars=SystemNoticeEnum.Message4Count;
			this.addChild(this.lbl);
			this.resize();
		}

		public function setNoticeStr(str:String):void {
			if (this.list.length > 0) {
				this.list.push(str);
			} else {
				this.lbl.htmlText=str;
				this.lbl.alpha=1;
				this.list.push(str);
				this.item.countDown(SystemNoticeEnum.Message4TIME);
			}
		}

		private function timeOut():void {
			this.list.shift();
			if (this.list.length <= 0) {
				this.lbl.htmlText="";
				this.item.clearEvent()
			} else {
				this.lbl.htmlText=this.list[0];
				this.lbl.alpha=1;
				this.item.countDown(SystemNoticeEnum.Message4TIME);
			}
		}

		public function resize():void {
			this.lbl.x=(UIEnum.WIDTH - this.width) / 2;
			this.lbl.y=UIManager.getInstance().toolsWnd.y - 50;
		}
	}
}