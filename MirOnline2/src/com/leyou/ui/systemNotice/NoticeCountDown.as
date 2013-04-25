package com.leyou.ui.systemNotice {
	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.leyou.net.protocol.TDefaultMessage;
	import com.leyou.ui.systemNotice.child.NoticeItem;

	import flash.display.Sprite;

	/**
	 *右下角 倒计时显示
	 * @author Administrator
	 */
	public class NoticeCountDown extends Sprite {
		private var list:Vector.<NoticeItem>;
		private var bg:ScaleBitmap;

		public function NoticeCountDown() {
			this.init();
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}

		private function init():void {
			this.list=new Vector.<NoticeItem>;
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.8;
//			this.bg.x=UIEnum.WIDTH - 213;
//			this.bg.y=UIEnum.HEIGHT - 88 - 100;
//			this.addChildAt(this.bg, 0);
			this.resize();
		}

		private function resetStrArr(i:int=0):void {
			if (this.list[i].lbl != null && this.list[i].lbl.parent != null) {
				this.list[i].clearEvent();
				this.removeChild(list[i].lbl);
			}
			this.list.splice(i, 1);
			this.setPos();
		}

		private function checkStr(td:TDefaultMessage, str:String):int {
			var idx:int=-1;
			for (var i:int=0; i < this.list.length; i++) {
				if ((this.list[i].dataObj.td as TDefaultMessage).Ident == td.Ident && (this.list[i].dataObj.td as TDefaultMessage).Param == td.Param && (this.list[i].dataObj.td as TDefaultMessage).Recog == td.Recog) {
					idx=i;
					if (td.Tag == 0) {
						if (str.indexOf("正计时") != -1){
							if(td.Tag==0)
								this.resetStrArr(i);
							else {
								str=str.replace("正计时","倒计时");
								this.list[i].setStr(td, str);
							}
						}
						else
							this.resetStrArr(i);
					} else if (td.Tag > 0)
						this.list[i].setStr(td, str);
					break;
				}
			}
			return idx;
		}

		/**
		 *服务器发过来的倒计时 或者正计时
		 * @param td
		 * @param body
		 *
		 */
		public function ser_CountDown(td:TDefaultMessage, body:String):void {
			if (this.checkStr(td, body) != -1) {
				return;
			}
			if(body.indexOf("倒计时")>-1&&td.Tag==0)
				return;
			if (this.list.length >= 5) {
				this.resetStrArr();
			}
			var item:NoticeItem=new NoticeItem();
			item.setStr(td, body);
			item.callBack=this.resetStrArr;
			this.list.push(item);
			item.id=this.list.length - 1;
			this.addChild(item.lbl);
			this.setPos();

		}

		private function setPos():void {
			for (var i:int=0; i < this.list.length; i++) {
				this.list[i].lbl.y=(this.list[i].lbl.height + 5) * i;
			}
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - 213;
			this.y=UIEnum.HEIGHT - 88 - 100 - 60;
		}
	}
}