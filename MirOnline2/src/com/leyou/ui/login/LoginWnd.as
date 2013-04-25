package com.leyou.ui.login {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.HideInput;
	import com.leyou.config.Core;
	import com.leyou.manager.ShareObjManage;
	import com.leyou.net.NetGate;
	import com.leyou.net.protocol.login.Cmd_Login;
	import com.leyou.ui.selectUser.info.SelectUserInfo;

	import flash.events.MouseEvent;

	public class LoginWnd extends AutoSprite {
		private var userNameTinput:HideInput;
		private var userPwdTinput:HideInput;
		private var loginBtn:NormalButton;
		private var rememberNameCheBox:CheckBox;

		public function LoginWnd() {
			super(LibManager.getInstance().getXML("config/ui/LoginWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.userNameTinput=this.getUIbyID("userNameTinput") as HideInput;
			this.userPwdTinput=this.getUIbyID("userPwdTinput") as HideInput;
			this.loginBtn=this.getUIbyID("loginBtn") as NormalButton;
			this.rememberNameCheBox=this.getUIbyID("rememberNameCheBox") as CheckBox;
			this.rememberNameCheBox.turnOn(false); //默认选中

			this.loginBtn.addEventListener(MouseEvent.CLICK, onClick);

//			this.userNameTinput.text="face41";//注意以后该类如果只是名称修改的话，不要提交
//			this.userNameTinput.text="face3";
//			this.userPwdTinput.text="asdfasdf";
			this.readName();
		}

		private function onClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "loginBtn":
					this.onLogin();
					break;
			}
		}

		private function onLogin():void {
			NetGate.getInstance().Connect(Core.serverIp, Core.loginPort, onConnect);
			this.saveName();
		}

		private function onConnect():void {
			if (Core.selectInfo == null)
				Core.selectInfo=new SelectUserInfo();
			Core.selectInfo.account=this.userNameTinput.text;
			Cmd_Login.cm_Login(this.userNameTinput.text, this.userPwdTinput.text);
		}

		public function saveName():void {
			var obj:Object=new Object();
			if (this.rememberNameCheBox.isOn) {
				obj.playerName=this.userNameTinput.text;
				obj.passWord=this.userPwdTinput.text;
			} else {
				obj.playerName="";
				obj.passWord="";
			}
			ShareObjManage.getInstance().saveFile("name", obj);
		}

		private function readName():void {
			var obj:Object=ShareObjManage.getInstance().readFile("name");
			if (obj != null) {
				if (obj.playerName != null && obj.playerName != "")
					this.userNameTinput.text=obj.playerName;
				if (obj.passWord != null && obj.passWord != "")
					this.userPwdTinput.text=obj.passWord;
			} else
				this.userNameTinput.text="请输入用户名";
		}

		override public function die():void {
			this.loginBtn.removeEventListener(MouseEvent.CLICK, onClick);
			if (this.parent != null)
				this.parent.removeChild(this);
		}

	}

}