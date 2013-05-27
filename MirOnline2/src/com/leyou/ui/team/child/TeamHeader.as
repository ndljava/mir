package com.leyou.ui.team.child {
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.team.TeamInfo;
	import com.leyou.utils.PlayerUtil;

	public class TeamHeader extends AutoSprite {
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var typeLbl:Label;
		private var iconImg:Image;

		private var hp:Image;
		private var mp:Image;

		public function TeamHeader() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamHeadWnd.xml"));
			init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.typeLbl=this.getUIbyID("typeLbl") as Label;
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.hp=this.getUIbyID("iconHp") as Image;
			this.mp=this.getUIbyID("iconMp") as Image;
			//this.iconImg.bitmapData=null;
		}

		public function updateInfo(info:TeamInfo):void {
			this.nameLbl.text=info.name + "";
			this.lvLbl.text=info.level + "";
			this.typeLbl.text="" + PlayerUtil.getPlayerRaceByIdx(int(info.member), 1);
			this.iconImg.updateBmp(PlayerUtil.getPlayerHeadImg(info.race, info.sex));
		}

		public function updateHpandMp(player:LivingModel):void {
			if (player.infoB.baseInfo.MaxHP <= 0)
				return;

			this.hp.width=121;
			this.hp.height=12;

			//this.hp.width=(player.infoB.hp / player.infoB.baseInfo.MaxHP);
			//this.hp.scaleX=.6;
			this.hp.width=(player.infoB.hp / player.infoB.baseInfo.MaxHP) * this.hp.width;
		}

		public function get username():String {
			return this.nameLbl.text;
		}

	}
}
