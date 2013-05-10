package com.leyou.ui.chat.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.UIManager;

	public class PrivateChatRender extends AutoSprite {
		private var combox:ChannelComboBox;
		private var privatePlayerArr:Array;

		public function PrivateChatRender() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatSecret.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.privatePlayerArr=new Array();
			this.combox=new ChannelComboBox(123, 22);
			this.combox.setBtnInputSta(true);
			this.combox.x=23;
			this.combox.y=0;
			this.addChild(this.combox);
			this.combox.setBtnInputColor(0xda70d6);
			this.combox.setInputMaxChar(7);
		}

		public function get chatPlayerName():String {
			if (this.combox.btnText == "")
				return "";
			else
				return this.combox.btnText + " ";
		}

		private function setComboxItem(arr:Array):void {
			if (arr == null)
				return;
			this.combox.clearItem();
			var c:Array=new Array();
			for (var i:int=0; i < arr.length; i++) {
				c.push(ChatEnum.COLOR_PRIVATE_UINT);
			}
			this.combox.setItem(arr, c);
		}

		public function checkPrivatePlayerName(n:String=null):void {
			var name:String;
			if (n == null)
				name=chatPlayerName;
			else
				name=n;
			if (name == "")
				return;
			name=this.checkName(name);
			var f:Boolean;
			for (var i:int=0; i < privatePlayerArr.length; i++) {
				if (this.privatePlayerArr[i] == name) {
					combox.setSelectTextByIdx(i);
					f=true;
				}
			}
			if (!f) {
				this.privatePlayerArr.push(name);
				if (this.privatePlayerArr.length > 5)
					this.privatePlayerArr.shift();
				this.combox.clearItem();
				this.setComboxItem(privatePlayerArr);
			}
		}

		public function onClickPlayerName(n:String):void {
			this.checkPrivatePlayerName(n);
			if (n == "" || n == null)
				return;
			n=this.checkName(n);
			for (var i:int=0; i < privatePlayerArr.length; i++) {
				if (this.privatePlayerArr[i] == n) {
					combox.setSelectTextByIdx(i);
					break;
				}
			}
			UIManager.getInstance().chatWnd.onStageEnter(false);
		}

		/**
		 *去掉名字的空格 和 等级
		 * @param n
		 * @return
		 *
		 */
		private function checkName(n:String):String {
			n=n.replace(/^\s*/g, "");
			n=n.replace(/\s*$/g, "");
			trace(n);
			if (n.indexOf("[") > -1)
				n=n.substring(0, n.indexOf("["));
			return n;
		}

		public function setComboxSta(sta:Boolean):void {
			this.combox.setItemSta(sta);
		}
	}
}