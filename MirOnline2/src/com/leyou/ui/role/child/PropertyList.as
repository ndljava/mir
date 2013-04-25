package com.leyou.ui.role.child {
	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.gameData.player.PlayerExtendInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.HexUtil;
	import com.leyou.manager.UIManager;

	public class PropertyList extends AutoSprite {
		private var dcLbl:Label; //攻击
		private var mcLbl:Label; //魔法
		private var scLbl:Label; //道术
		private var acLbl:Label; //防御
		private var macLbl:Label; //魔防
		private var hpLbl:Label; //体力
		private var mpLbl:Label; //魔法
		private var loadLbl:Label; //负重
		private var pkLbl:Label; //PK值
		private var gmPointLbl:Label; //游戏点
		private var fameLbl:Label; //声望值
		private var bgWeightLbl:Label; //背包重量
		private var wearWeightLbl:Label; //穿戴重量
		private var wristLbl:Label; //腕力

		private var hitPointLbl:Label; //精确度
		private var speedPointLbl:Label; //敏捷度
		private var antiMagicLbl:Label; //魔法防御
		private var antiPoisonLbl:Label; //中毒防御;
		private var poisonRecoverLbl:Label; //中毒恢复
		private var healthRecoverLbl:Label; //体力恢复
		private var mgRecoverLbl:Label; //魔法恢复

		public function PropertyList() {
			super(LibManager.getInstance().getXML("config/ui/property/PropertyNum.xml"));
			this.init();
		}

		private function init():void {
			this.dcLbl=this.getUIbyID("dcLbl") as Label;
			this.mcLbl=this.getUIbyID("mcLbl") as Label;
			this.scLbl=this.getUIbyID("scLbl") as Label;
			this.acLbl=this.getUIbyID("acLbl") as Label;
			this.macLbl=this.getUIbyID("macLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;
			this.loadLbl=this.getUIbyID("loadLbl") as Label;
			this.pkLbl=this.getUIbyID("pkLbl") as Label;
			this.gmPointLbl=this.getUIbyID("gmPointLbl") as Label;
			this.fameLbl=this.getUIbyID("fameLbl") as Label;
			this.bgWeightLbl=this.getUIbyID("bgWeightLbl") as Label;
			this.wearWeightLbl=this.getUIbyID("wearWeightLbl") as Label;
			this.wristLbl=this.getUIbyID("wristLbl") as Label;

			this.hitPointLbl=this.getUIbyID("hitPointLbl") as Label;
			this.speedPointLbl=this.getUIbyID("speedPointLbl") as Label;
			this.antiMagicLbl=this.getUIbyID("antiMagicLbl") as Label;
			this.antiPoisonLbl=this.getUIbyID("antiPoisonLbl") as Label;
			this.poisonRecoverLbl=this.getUIbyID("poisonRecoverLbl") as Label;
			this.healthRecoverLbl=this.getUIbyID("healthRecoverLbl") as Label;
			this.mgRecoverLbl=this.getUIbyID("mgRecoverLbl") as Label;

		}

		public function updateAddInfo(info:PlayerExtendInfo):void {
			this.hitPointLbl.text=info.hitPoint.toString();
			this.speedPointLbl.text=info.speedPoint.toString();
			this.antiMagicLbl.text="+" + info.antiMagic * 10 + "%";
			this.antiPoisonLbl.text="+" + info.antiPoison * 10 + "%";
			this.poisonRecoverLbl.text="+" + info.poisonRecover * 10 + "%";
			this.healthRecoverLbl.text="+" + info.healthRecover * 10 + "%";
			this.mgRecoverLbl.text="+" + info.spellRecover * 10 + "%";

		}

		public function updateBaseInfo(info:PlayerBasicInfo):void {
			this.dcLbl.text=HexUtil.LoWord(info.DC) + "-" + HexUtil.HiWord(info.DC);
			this.mcLbl.text=HexUtil.LoWord(info.MC) + "-" + HexUtil.HiWord(info.MC);
			this.scLbl.text=HexUtil.LoWord(info.SC) + "-" + HexUtil.HiWord(info.SC);
			this.acLbl.text=HexUtil.LoWord(info.AC) + "-" + HexUtil.HiWord(info.AC);
			this.macLbl.text=HexUtil.LoWord(info.MAC) + "-" + HexUtil.HiWord(info.MAC);
			this.hpLbl.text=info.HP + " / " + info.MaxHP;
			this.mpLbl.text=info.MP + " / " + info.MaxMP;
			this.loadLbl.text=info.MaxWearWeight.toString();
			this.pkLbl.text=info.pkValue.toString();
			this.gmPointLbl.text="暂时未找到" //游戏点
			this.fameLbl.text=info.creditValue.toString(); //声望值
			this.bgWeightLbl.text=info.Weight + " / " + info.MaxWeight;
			this.wearWeightLbl.text=info.WearWeight + "/" + info.MaxWearWeight;
			this.wristLbl.text=info.HandWeight + " / " + info.MaxHandWeight;
//			UIManager.getInstance().roleHeadWnd.updataHPMPInfo(HexUtil.LoWord(info.AC),HexUtil.HiWord(info.AC),HexUtil.LoWord(info.MAC),HexUtil.HiWord(info.MAC));
			UIManager.getInstance().roleHeadWnd.updateHealth();
		}
	}
}