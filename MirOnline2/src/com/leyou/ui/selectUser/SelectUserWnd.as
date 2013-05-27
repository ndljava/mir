package com.leyou.ui.selectUser {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.GroupButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.event.ButtonEvent;
	import com.ace.ui.lable.Label;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.login.Cmd_Login;
	import com.leyou.ui.selectUser.info.SelectUserInfo;

	import flash.events.Event;
	import flash.events.MouseEvent;


	public class SelectUserWnd extends AutoSprite {
		private var begainBtn:NormalButton;
		private var selectBtn1:GroupButton;
		private var selectBtn2:GroupButton;
		private var userBtn1:SelectUserBtn;
		private var userBtn2:SelectUserBtn;


		private var selectName:String;

		public function SelectUserWnd() {
			super(LibManager.getInstance().getXML("config/ui/SelectUserWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.selectName="";

			this.userBtn1=new SelectUserBtn();
			this.userBtn2=new SelectUserBtn();
			this.userBtn1.x=312;
			this.userBtn1.y=203;
			this.userBtn2.x=312;
			this.userBtn2.y=373;
			this.addChild(this.userBtn1);
			this.addChild(this.userBtn2);

			this.begainBtn=this.getUIbyID("begainBtn") as NormalButton;
			this.selectBtn1=this.getUIbyID("selectBtn1") as GroupButton;
			this.selectBtn2=this.getUIbyID("selectBtn2") as GroupButton;

//			this.selectBtn1.visible=this.selectBtn2.visible=false;

			this.begainBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.selectBtn1.addEventListener(ButtonEvent.Switch_Change, onSelected);
			this.selectBtn2.addEventListener(ButtonEvent.Switch_Change, onSelected);
		}


		private function onSelected(evt:Event):void {
			if (this.selectBtn1.isOn) {
				if (this.userBtn1.userNameLbl.text != "") {
					Core.selectInfo.copy(this.arr[0]);
					this.selectName=this.userBtn1.userNameLbl.text;
					this.visible=true;
				} else {
					UIManager.getInstance().addCreatUserWnd();
					this.visible=false;
				}
			}
			if (this.selectBtn2.isOn) {
				if (this.userBtn2.userNameLbl.text != "") {
					this.selectName=this.userBtn2.userNameLbl.text;
					Core.selectInfo.copy(this.arr[1]);
					this.visible=true;
				} else {
					UIManager.getInstance().addCreatUserWnd();
					this.visible=false;
				}
			}
		}

		private function onClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "begainBtn":
					this.onBegainBtn();
					break;
			}
		}

		private function onBegainBtn():void {
			if (this.selectName != "") {
				Cmd_Login.cm_SelChr(this.selectName);
				this.arr=[];
			}
		}

		private var arr:Array=[];

		public function ser_updataUser(body:String):void {
//			return;
//			*123/0/2/1/0/tewste/2/1/0/1/    *123/0/2/1/0/sewewe/0/3/0/1/  *face/2/2/11/0/fwe323/2/5/0/1/
//			body=body.substring(1);
			var arr:Array=body.split("/");
			var info:SelectUserInfo;


			if (arr.length > 4) {
				info=new SelectUserInfo();
				info.name=arr[0];
				if (info.name.indexOf("*") != -1) {
					info.name=info.name.substring(1);
				}

				this.selectBtn1.turnOn(false);
				info.race=int(arr[1]);
				info.hair=int(arr[2]);
				info.level=int(arr[3]);
				info.sex=int(arr[4]);
				this.arr.push(info);

				this.userBtn1.updata(info);
				this.selectName=info.name;
				Core.selectInfo.copy(this.arr[0]);
			}

			if (arr.length > 8) {
				info=new SelectUserInfo();
				info.name=arr[5];
				info.race=int(arr[6]);
				info.hair=int(arr[7]);
				info.level=int(arr[8]);
				info.sex=int(arr[9]);
				this.arr.push(info);

				if (info.name.indexOf("*") != -1) {
					this.selectBtn2.turnOn(false);
					info.name=info.name.substring(1);
					this.selectName=info.name;
					Core.selectInfo.copy(info);
				}
				this.userBtn2.updata(info);

			}
		}

		override public function die():void {
			this.begainBtn.removeEventListener(MouseEvent.CLICK, onClick);
			this.parent.removeChild(this);
		}
	}
}