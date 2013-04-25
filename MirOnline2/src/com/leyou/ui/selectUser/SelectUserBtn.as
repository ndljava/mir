package com.leyou.ui.selectUser {
	import com.ace.enum.PlayerEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	import com.leyou.ui.selectUser.info.SelectUserInfo;

	public class SelectUserBtn extends AutoSprite {
		public var userNameLbl:Label;
		public var userLvLbl:Label;
		public var userProLbl:Label;
		public var userCreatLbl:Label;
		public var userHeadImg:Image;

		public function SelectUserBtn() {
			super(LibManager.getInstance().getXML("config/ui/child/SelectUserBtn.xml"));
			this.init();
			this.mouseEnabled=this.mouseChildren=false;
		}

		private function init():void {
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.userNameLbl=this.getUIbyID("userNameLbl") as Label;
			this.userLvLbl=this.getUIbyID("userLvLbl") as Label;
			this.userProLbl=this.getUIbyID("userProLbl") as Label;
			this.userCreatLbl=this.getUIbyID("userCreatLbl") as Label;

			this.userNameLbl.text="";
			this.userNameLbl.visible=this.userLvLbl.visible=this.userProLbl.visible=false;
		}

		public function updata(info:SelectUserInfo):void {
			this.userNameLbl.text=info.name;
			this.userProLbl.text=info.race.toString();
			this.userLvLbl.text=info.level.toString()+"级";

			if (info.race == PlayerEnum.PRO_SOLDIER) {
				this.userProLbl.text="战士";
				if (info.sex == PlayerEnum.SEX_BOY)
					this.userHeadImg.updateBmp("ui/login/icon_m_zhans.png");
				else
					this.userHeadImg.updateBmp("ui/login/icon_f_zhans.png");
			} else if (info.race == PlayerEnum.PRO_MASTER) {
				this.userProLbl.text="法师";
				if (info.sex == PlayerEnum.SEX_BOY)
					this.userHeadImg.updateBmp("ui/login/icon_m_fas.png");
				else
					this.userHeadImg.updateBmp("ui/login/icon_f_fas.png");
			} else if (info.race == PlayerEnum.PRO_TAOIST) {
				this.userProLbl.text="道士";
				if (info.sex == PlayerEnum.SEX_BOY)
					this.userHeadImg.updateBmp("ui/login/icon_m_daos.png");
				else
					this.userHeadImg.updateBmp("ui/login/icon_f_daos.png");
			}
			this.userCreatLbl.visible=false;
			this.userNameLbl.visible=this.userLvLbl.visible=this.userProLbl.visible=true;

		}
	}
}