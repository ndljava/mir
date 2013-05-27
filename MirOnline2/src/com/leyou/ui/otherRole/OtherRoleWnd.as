package com.leyou.ui.otherRole {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.data.net.role.TUserStateInfo;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.role.child.Avator;
	import com.leyou.ui.role.child.EquipGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;

	public class OtherRoleWnd extends AutoWindow implements IMenu{
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var guildLbl:Label;
		private var gridArr:Object;
		private var roleInfo:TUserStateInfo;
		private var avator:Avator;
		private var theTitleLbl:Label;
		private var reLifeLbl:Label;
//		private var nameTextFiled:TextField;
		private var nameSp:Sprite;
		private var guildSp:Sprite;
		private var titleSp:Sprite;
//		private var menuList:MeunList;
		private var currentClickSPN:String;
//		private var info:TUserStateInfo;

		public function OtherRoleWnd() {
			super(LibManager.getInstance().getXML("config/ui/OtherRoleWnd.xml"));
			this.init();
		}

		private function init():void {
			var guildScaBtm:ScaleBitmap=this.getUIbyID("guildScaBtm") as ScaleBitmap;
			var nameScaBtm:ScaleBitmap=this.getUIbyID("nameScaBtm") as ScaleBitmap;
			var titleScaBtm:ScaleBitmap=this.getUIbyID("titleScaBtm") as ScaleBitmap;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.guildLbl=this.getUIbyID("guildLbl") as Label;
			this.theTitleLbl=this.getUIbyID("titleLbl") as Label;
			this.reLifeLbl=this.getUIbyID("reLifeLbl") as Label;
		
			this.gridArr=new Object();
			var equipGrid:EquipGrid;
			var i:int;
			for (i=0; i < 10; i++) {
				equipGrid=new EquipGrid();
				equipGrid.y=177 + (i % 5) * 56;
				equipGrid.x=37 + (i % 2) * 218;
				equipGrid.dataId=ItemUtil.getTypeByPos(i);
				equipGrid.gridType=ItemEnum.TYPE_GRID_OTHER_EQUIP;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
			for (i=0; i < 3; i++) {
				equipGrid=new EquipGrid();
				equipGrid.x=89 + i * (60);
				equipGrid.y=444;
				equipGrid.dataId=ItemUtil.getTypeByPos(i + 10);
				equipGrid.gridType=ItemEnum.TYPE_GRID_OTHER_EQUIP;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}

			this.avator=new Avator();
			this.avator.x=78;
			this.avator.y=250;
			this.addChild(this.avator);
			
			
			
			
			this.nameSp=new Sprite();
			this.addChild(this.nameSp);
			this.nameSp.x=nameScaBtm.x;
			this.nameSp.y=nameScaBtm.y;
			nameScaBtm.x=nameScaBtm.y=0;
			this.nameSp.addChild(nameScaBtm);
			this.nameLbl.x=2;
			this.nameLbl.y=0;
			this.nameSp.addChild(this.nameLbl);
			this.nameSp.name="nameSp";
			this.nameSp.addEventListener(MouseEvent.CLICK,this.onLblClickFun);
			
			this.guildSp=new Sprite();
			this.guildSp.name="guildSp";
			this.guildSp.x=guildScaBtm.x;
			this.guildSp.y=guildScaBtm.y;
			guildScaBtm.x=guildScaBtm.y=0;
			this.guildSp.addChild(guildScaBtm);
			this.guildLbl.x=2;
			this.guildLbl.y=0;
			this.guildSp.addChild(this.guildLbl);
			this.addChild(this.guildSp);
			this.guildSp.addEventListener(MouseEvent.CLICK,this.onLblClickFun);
			
			this.titleSp=new Sprite();
			this.titleSp.name="titleSp";
			this.titleSp.x=titleScaBtm.x;
			this.titleSp.y=titleScaBtm.y;
			titleScaBtm.x=titleScaBtm.y=0;
			this.titleSp.addChild(titleScaBtm);
			this.theTitleLbl.x=2;
			this.theTitleLbl.y=0;
			this.titleSp.addChild(this.theTitleLbl);
			this.addChild(this.titleSp);
			this.titleSp.addEventListener(MouseEvent.CLICK,this.onLblClickFun);
//			this.menuList=new MeunList(["复制"],[0]);
//			this.menuList.listClickFun=onMenuListClick;
//			this.addChild(this.menuList);
//			this.menuList.visible=false;
//			this.nameLbl.visible=false;
//			this.nameTextFiled=new TextField();
//			this.nameTextFiled.width=this.nameLbl.width;
//			this.nameTextFiled.height=this.nameTextFiled.height;
//			this.nameTextFiled.selectable=true;
//			this.nameTextFiled.textColor=this.nameLbl.textColor;
//			this.nameTextFiled.x=this.nameLbl.x;
//			this.nameTextFiled.y=this.nameLbl.y;
//			this.addChild(this.nameTextFiled);
		}

		public function updateInfo(info:TUserStateInfo):void {
			this.roleInfo=info;
			this.nameLbl.text=info.UserName;
//			this.nameTextFiled.text=info.UserName;
			this.lvLbl.text=""; //暂时找不到等级属性
			this.raceLbl.text=""; //暂时找不到职业属性
			if (info.GuildName != "")
				this.guildLbl.text=info.GuildName;
			else
				this.guildLbl.text="";
			this.theTitleLbl.text=info.GuildRankName;
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
			}
			this.updateBody();
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
				if (info != null)
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
			this.lvLbl.text="";
			this.reLifeLbl.text="";
			if (this.roleInfo.UserName == "匿名玩家") {
				return;
			}
			var info:LivingModel=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName);
			var sex:int=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName).infoB.sex;
			this.avator.updateBody(sex);
			
			var lv:int=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName).infoB.level;
			this.lvLbl.text=lv+"级";
			var arr:Array=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName).infoB.nameArr;
			if(arr!=null&&arr[3]!=null)
				this.reLifeLbl.text=(arr[3] as String).length+"级";
			var race:int=UIManager.getInstance().mirScene.getPlayerByName(this.roleInfo.UserName).infoB.race;
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(race);
		}

		public function get equipInfo():Vector.<TSClientItem> {
			return this.roleInfo.UseItems;
		}
		
		private function onLblClickFun(evt:MouseEvent):void{
			evt.stopPropagation();
//			this.menuList.visible=false;
			switch(evt.target.name){
				case "nameSp"://名字
					this.currentClickSPN="nameSp";
					break;
				case "guildSp":
					this.currentClickSPN="guildSp";
					if(this.guildLbl.text=="")
						return;
					break;
				case "titleSp":
					this.currentClickSPN="titleSp";
					if(this.theTitleLbl.text=="")
						return;
					break;
			}
			var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>;
			menuArr.push(new MenuInfo("复制",0));
			MenuManager.getInstance().show(menuArr,this,this.localToGlobal(new Point(this.mouseX+2,this.mouseY+2)));
//			this.menuList.visible=true;
//			this.menuList.x=this.mouseX+5;
//			this.menuList.y=this.mouseY+5;
		}
		
		public function onMenuClick(ket:int):void{
//			this.menuList.visible=false;
			switch(this.currentClickSPN){
				case "nameSp"://名字
					System.setClipboard(this.nameLbl.text);
					break;
				case "guildSp":
					System.setClipboard(this.guildLbl.text);
					break;
				case "titleSp":
					System.setClipboard(roleInfo.GuildRankName);
					break;
			}
		}
	}
}