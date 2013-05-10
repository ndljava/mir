package com.leyou.ui.otherRole {
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.role.TUserStateInfo;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.role.child.Avator;
	import com.leyou.ui.role.child.EquipGrid;
	import com.leyou.utils.ItemUtil;

	public class OtherRoleWnd extends AutoWindow {
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var guildLbl:Label;
		private var gridArr:Object;
		private var roleInfo:TUserStateInfo;
		private var avator:Avator;

		public function OtherRoleWnd() {
			super(LibManager.getInstance().getXML("config/ui/OtherRoleWnd.xml"));
			this.init();
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.guildLbl=this.getUIbyID("guildLbl") as Label;

			this.gridArr=new Object();
			var equipGrid:EquipGrid;
			var i:int;
			for (i=0; i < 10; i++) {
				equipGrid=new EquipGrid();
				equipGrid.y=110 + (i % 5) * 70;
				equipGrid.x=32 + (i % 2) * 272;
				equipGrid.dataId=ItemUtil.getTypeByPos(i);
				equipGrid.gridType=ItemEnum.TYPE_GRID_OTHER_EQUIP;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
			for (i=0; i < 3; i++) {
				equipGrid=new EquipGrid();
				equipGrid.x=90 + i * (172 - 95);
				equipGrid.y=440;
				equipGrid.dataId=ItemUtil.getTypeByPos(i + 10);
				equipGrid.gridType=ItemEnum.TYPE_GRID_OTHER_EQUIP;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}

			this.avator=new Avator();
			this.avator.x=100 + 10;
			this.avator.y=100 + 50 + 10;
			this.addChild(this.avator);
		}

		public function updateInfo(info:TUserStateInfo):void {
			this.roleInfo=info;
//			this.nameLbl.textColor=info.NAMECOLOR;
			this.nameLbl.text=info.UserName;
			this.lvLbl.text=""; //暂时找不到等级属性
			this.raceLbl.text=""; //暂时找不到职业属性
			if (info.GuildName != "")
				this.guildLbl.text=info.GuildName + "  " + info.GuildRankName;
			else
				this.guildLbl.text="";

			for (var i:int=0; i < info.UseItems.length; i++) {
				var tInfo:TItemInfo=TableManager.getInstance().getItemInfo(info.UseItems[i].wIndex - 1);
//				if (tInfo != null) {
					if (i == ItemEnum.U_HORSE) {
						(this.gridArr[2] as EquipGrid).updataInfo(tInfo);
					} else if (i == ItemEnum.U_ZHULI) {
						(this.gridArr[4] as EquipGrid).updataInfo(tInfo);
					} else if (i == ItemEnum.U_ITEM) {
						(this.gridArr[0] as EquipGrid).updataInfo(tInfo);
					} else {
						(this.gridArr[i] as EquipGrid).updataInfo(tInfo);
					}
//				}
				this.updateAvator(i, tInfo);
				this.updateBody();
			}
		}

		//更新人物形象
		private function updateAvator(i:int, info:TItemInfo):void {
			if (i == ItemEnum.U_DRESS) { //衣服
				if (info !== null)
					this.avator.updateCloth(info.appr);
				else
					this.avator.updateCloth(0);
			}
			if (i == ItemEnum.U_HELMET || i == ItemEnum.U_ZHULI) { //头盔 斗笠
				if (info!= null)
					this.avator.updateHat(info.appr);
				else
					this.avator.updateHat(0);
			}
			if (i == ItemEnum.U_WEAPON) { //武器
				if (info != null)
					this.avator.updateWeapon(info.appr);
				else
					this.avator.updateWeapon(0);
			}
		}

		private function updateBody():void {
			var sex:int=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName).infoB.sex;
			this.avator.updateBody(sex);
		}

		public function get equipInfo():Vector.<TSClientItem> {
			return this.roleInfo.UseItems;
		}
	}
}