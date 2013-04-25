package com.leyou.ui.systemNotice {
	import com.ace.enum.UIEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.ui.systemNotice.child.NoticeImgItem;
	import com.leyou.utils.FilterUtil;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *中间底部向上移动 
	 * @author Administrator
	 * 
	 */	
	public class NoticeMidDownUproll extends Sprite {
		private var list:Vector.<NoticeImgItem>;
		private var add:Vector.<NoticeImgItem>;

		public function NoticeMidDownUproll() {
			super();
			this.init();
		}

		private function init():void {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.list=new Vector.<NoticeImgItem>;
			this.add=new Vector.<NoticeImgItem>;
		}

		/**
		 *提示信息
		 * @param str 内容
		 * @param imgFlg 显示哪一种提示 SystemNoticeEnum.IMG_WRONG:int=0;//红色叉
		 *                          SystemNoticeEnum.IMG_WARN:int=1;//蓝色叹号
		 *                          SystemNoticeEnum.IMG_PROMPT:int=2;//黄色叹号
		 */
		public function setNoticeStr(str:String, imgFlg:int):void {
			var noticeItem:NoticeImgItem;
			if (imgFlg > 2)
				imgFlg == 2;
			if (this.checkStr(str))
				return;
			if (this.list.length == 4 && this.hasEventListener(Event.ENTER_FRAME) == false) {
				this.resetList();
			} else if (this.hasEventListener(Event.ENTER_FRAME) == true) {
				noticeItem=new NoticeImgItem(imgFlg);
				noticeItem.callBack=this.resetList;
				noticeItem.lblText=str;
				this.addChild(noticeItem);
				this.add.push(noticeItem);
				this.add[this.add.length - 1].alpha=0;
				this.add[this.add.length - 1].x=(UIEnum.WIDTH - this.list[0].width) / 2;
				this.add[this.add.length - 1].y=UIEnum.HEIGHT - 60;
				FilterUtil.showGlowFilter(this.add[this.add.length - 1], .2);
			} else {
				noticeItem=new NoticeImgItem(imgFlg);
				noticeItem.callBack=this.resetList;
				noticeItem.lblText=str;
				this.addChild(noticeItem);
				this.list.push(noticeItem);
				this.list[this.list.length - 1].alpha=0;
				this.list[this.list.length - 1].x=(UIEnum.WIDTH - this.list[0].width) / 2;
				this.list[this.list.length - 1].y=UIEnum.HEIGHT - 60;
				FilterUtil.showGlowFilter(this.list[this.list.length - 1], .5);
				this.resize();
			}
		}

		private function checkStr(str:String):Boolean {
			var i:int;
			for (i=0; i < this.list.length; i++) {
				if (this.list[i].text == str) {
					this.list[i].countDown(SystemNoticeEnum.IMG_PROMPT_TIME);
					return true;
				}
			}
			for (i=0; i < this.add.length; i++) {
				if (this.add[i].text == str)
					return true;
			}
			return false;
		}

		private function resetList():void {
			if (this.list[0] != null && this.list[0].parent != null) {
				this.list[0].clearEvent();
				this.removeChild(list[0]);
			}
			this.list.shift();
			if (this.list.length == 4)
				this.resize();
		}

		public function resize():void {
			if (!this.hasEventListener(Event.ENTER_FRAME))
				this.addEventListener(Event.ENTER_FRAME, onMoveNotice);
		}

		private function onMoveNotice(evt:Event):void {
			this.list[this.list.length - 1].alpha+=.1;
			if (this.list[this.list.length - 1].y <= UIEnum.HEIGHT - 65 - this.list[this.list.length - 1].height) {
				this.list[this.list.length - 1].alpha=1;
				this.list[this.list.length - 1].countDown(SystemNoticeEnum.IMG_PROMPT_TIME);
				if (this.add.length > 0) {
					if (this.list.length >= 4)
						this.resetList();
					this.list.push(this.add.shift());
					this.resize();
				} else
					this.removeEventListener(Event.ENTER_FRAME, onMoveNotice);
			} else {
				for (var i:int=this.list.length - 1; i >= 0; i--) {
					this.list[i].y=this.list[i].y - 2;
				}
			}
		}

	}
}