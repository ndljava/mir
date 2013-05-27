package com.leyou.ui.creatUser {
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.login.Cmd_Login;
	import com.leyou.ui.creatUser.child.UserBtn;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	public class CreatUserWnd extends AutoSprite {
		private var begainBtn:NormalButton;
		private var userBtnArr:Vector.<UserBtn>
		private var nameInput:TextInput;
		private var randomDicBtn:ImgButton;
		private var raceExplainImg:Image;
		private var selectHeadIdx:int;
		private var surNameArr:Array;
		private var manLastNameArr:Array;
		private var womenLastNameArr:Array;
		
		private var account:String;

		public function CreatUserWnd() {
			super(LibManager.getInstance().getXML("config/ui/CreatUserWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.begainBtn=this.getUIbyID("begainBtn") as NormalButton;
			this.nameInput=this.getUIbyID("nameInput") as TextInput;
			this.randomDicBtn=this.getUIbyID("randomDicBtn") as ImgButton;
			this.raceExplainImg=this.getUIbyID("raceExplainImg") as Image;
			this.selectHeadIdx=0;

			this.userBtnArr=new Vector.<UserBtn>;
			var userBtn:UserBtn;
			for (var i:int=0; i < 6; i++) {
				var race:int=Math.floor(i / 2);
				userBtn=new UserBtn(race, getSexByidx(i));
				userBtn.name=i.toString();
				if (i == 0)
					userBtn.setSelect(true);
				if (i % 2 == 0)
					userBtn.x=455;
				else
					userBtn.x=693 + 15;
				userBtn.y=185 + Math.ceil((i + 1) / 2 - 1) * 116;
				this.addChild(userBtn);
				this.userBtnArr.push(userBtn);
				userBtn.addEventListener(MouseEvent.CLICK, onHeadClick);
				userBtn.addEventListener(MouseEvent.MOUSE_OVER, onHeadOver);
				userBtn.addEventListener(MouseEvent.MOUSE_OUT, onHeadOut);
			}
			this.begainBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.randomDicBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			var ba:ByteArray=LibManager.getInstance().getBinary("config/ui/creatUser/playName_femalename.txt");
			var str:String=ba.readMultiByte(ba.length, "gb2132");
			this.womenLastNameArr=str.split("\r\n");

			ba=LibManager.getInstance().getBinary("config/ui/creatUser/playName_malename.txt");
			str=ba.readMultiByte(ba.length, "gb2132");
			this.manLastNameArr=str.split("\r\n");

			ba=LibManager.getInstance().getBinary("config/ui/creatUser/playName_surname.txt");
			str=ba.readMultiByte(ba.length, "gb2132");
			this.surNameArr=str.split("\r\n");

			this.nameInput.text=this.getRandomNameByIdx(this.selectHeadIdx);
			this.updataRaceExplainImg(this.userBtnArr[this.selectHeadIdx].race);
			this.account=Core.selectInfo.account;
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.currentTarget.name) {
				case "begainBtn":
					this.onLogin();
					break;
				case "randomDicBtn":
					this.nameInput.text=this.getRandomNameByIdx(this.selectHeadIdx);
					break;
			}
		}

		private function onHeadClick(evt:MouseEvent):void {
			var idx:int=int(evt.currentTarget.name);
			if (idx == this.selectHeadIdx)
				return;
			this.updataRaceExplainImg((evt.currentTarget as UserBtn).race);
			this.userBtnArr[this.selectHeadIdx].setSelect(false);
			this.selectHeadIdx=idx;
			this.userBtnArr[this.selectHeadIdx].setSelect(true);
			this.nameInput.text=this.getRandomNameByIdx(this.selectHeadIdx);
		}

		private function onHeadOver(evt:MouseEvent):void {
			var idx:int=int(evt.currentTarget.name);
			if (idx == this.selectHeadIdx)
				return;
			this.userBtnArr[idx].setSelect(true);
		}

		private function onHeadOut(evt:MouseEvent):void {
			var idx:int=int(evt.currentTarget.name);
			if (idx == this.selectHeadIdx)
				return;
			this.userBtnArr[idx].setSelect(false);
		}

		//登陆发协议
		private function onLogin():void {
			if (this.nameInput.text == "") {
				PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM,WindInfo.getInputInfo("请输入用户名!"),"creatUserAlset");//提示输入名字
				return;
			}
			//创建角色【账号 + '/' + 角色名称 + '/' + 头发 + '/' + 职业 + '/' + 性别】
			var str:String=new String();
			str=this.account+"/"+this.nameInput.text+"/"+0+"/"+this.userBtnArr[this.selectHeadIdx].race+"/"+this.userBtnArr[this.selectHeadIdx].sex;
			Cmd_Login.cm_newChr(str);
		}

		private function getSexByidx(idx:int):int {
			if (Math.ceil(idx % 2) == 0) {
				return PlayerEnum.SEX_GIRL;
			} else
				return PlayerEnum.SEX_BOY;
		}

		private function updataRaceExplainImg(race:int):void {
			switch (race) {
				case PlayerEnum.PRO_SOLDIER:
					this.raceExplainImg.updateBmp("ui/creatUser/creatPlayer_zs_txt.png");
					break;
				case PlayerEnum.PRO_MASTER:
					this.raceExplainImg.updateBmp("ui/creatUser/creatPlayer_fs_txt.png");
					break;
				case PlayerEnum.PRO_TAOIST:
					this.raceExplainImg.updateBmp("ui/creatUser/creatPlayer_ds_txt.png");
					break;
//				case PlayerEnum.PRO_RANGER:
//						this.raceExplainImg.updateBmp("ui/creatUser/creatPlayer_ds_txt.png");
//					break;
			}
		}

		private function getRandomNameByIdx(idx:int):String {
			var l:int;
			var name:String;
			if (this.userBtnArr[idx].sex == PlayerEnum.SEX_BOY) {
				l=Math.random() * (this.manLastNameArr.length - 1);
				name=this.manLastNameArr[l];
			}

			else if (this.userBtnArr[idx].sex == PlayerEnum.SEX_GIRL) {
				l=Math.random() * (this.womenLastNameArr.length - 1)
				name=this.womenLastNameArr[l];
			}
			name+="·";
			l=Math.random() * (this.surNameArr.length - 1);
			name+=this.surNameArr[l];
			return name;
		}

		override public function die():void {
			this.begainBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
			this.randomDicBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
			for (var i:int=0; i < this.userBtnArr.length; i++) {
				this.userBtnArr[i].removeEventListener(MouseEvent.CLICK, onHeadClick);
				this.userBtnArr[i].removeEventListener(MouseEvent.MOUSE_OVER, onHeadOver);
				this.userBtnArr[i].removeEventListener(MouseEvent.MOUSE_OUT, onHeadOut);
			}
			this.visible=false;
			this.parent.removeChild(this);
			UIManager.getInstance().selectUserWnd=null;
		}
	}
}