package com.leyou.ui.roleHead {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PlayerUtil;

	public class RoleHeadWnd extends AutoSprite {
		private var userheadImg:Image;
		private var hpImg:Image;
		private var mpImg:Image;
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var hmpW:Number;
		private var hmpH:Number;

		public function RoleHeadWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleHeadWnd.xml"));
			this.y=-20;
			this.init();
		}

		private function init():void {
			this.hmpW=152;
			this.hmpH=14;
			this.userheadImg=this.getUIbyID("userheadImg") as Image;
			this.hpImg=this.getUIbyID("hpImg") as Image;
			this.mpImg=this.getUIbyID("mpImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
		}

		//更新显示信息
		public function updataInfo(info:PlayerInfo):void {
			this.nameLbl.text=info.name;
			this.lvLbl.text=info.level.toString();
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(info.race, 1);
			this.userheadImg.updateBmp(PlayerUtil.getPlayerHeadImg(info.race, info.sex));
		}

		//更新 生命值 魔法值
		public function updateHealth():void {
			var hhp:Number=(MyInfoManager.getInstance().baseInfo.HP / MyInfoManager.getInstance().baseInfo.MaxHP) * this.hmpW;
			if (hhp > this.hmpW)
				hhp=this.hmpW;
			this.hpImg.setWH(hhp, this.hmpH);

			var mmp:Number=(MyInfoManager.getInstance().baseInfo.MP / MyInfoManager.getInstance().baseInfo.MaxMP) * this.hmpW;
			if (mmp > this.hmpW)
				mmp=this.hmpW;
			this.mpImg.setWH(mmp, this.hmpH);
		}
		public function updateLevel():void{
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}
	}
}