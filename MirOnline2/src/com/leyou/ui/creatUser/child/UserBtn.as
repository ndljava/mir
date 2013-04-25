package com.leyou.ui.creatUser.child {
	import com.ace.enum.PlayerEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;

	public class UserBtn extends AutoSprite {
		private var selectImg:Image;
		private var headImage:Image;
		private var _sex:int;
		private var _race:int;

		public function UserBtn(race:int, sex:int) {
			super(LibManager.getInstance().getXML("config/ui/creatUser/UserBtn.xml"));
			this._race=race;
			this._sex=sex;
			this.init();
			this.mouseEnabled=true;
			this.selectImg.visible=false;
		}

		private function init():void {
			this.selectImg=this.getUIbyID("selectImg") as Image;
			this.headImage=this.getUIbyID("headImg") as Image;
			if (this._race == PlayerEnum.PRO_SOLDIER) {
				if (this._sex == PlayerEnum.SEX_GIRL)
					this.headImage.updateBmp("ui/login/icon_f_zhans.png");
				else
					this.headImage.updateBmp("ui/login/icon_m_zhans.png");
			} else if (this._race == PlayerEnum.PRO_MASTER) {
				if (this._sex == PlayerEnum.SEX_GIRL)
					this.headImage.updateBmp("ui/login/icon_f_fas.png");
				else
					this.headImage.updateBmp("ui/login/icon_m_fas.png");
			} else if (this._race == PlayerEnum.PRO_TAOIST) {
				if (this._sex == PlayerEnum.SEX_GIRL)
					this.headImage.updateBmp("ui/login/icon_f_daos.png");
				else
					this.headImage.updateBmp("ui/login/icon_m_daos.png");
			} 
//			else if (this._race == PlayerEnum.PRO_RANGER) {
//				if (this._sex == PlayerEnum.SEX_GIRL) {
//
//				} else {
//
//				}
//			}
		}

		public function setSelect(flag:Boolean):void {
			this.selectImg.visible=flag;
		}

		public function get race():int {
			return this._race;
		}

		public function get sex():int {
			return this._sex;
		}
	}
}