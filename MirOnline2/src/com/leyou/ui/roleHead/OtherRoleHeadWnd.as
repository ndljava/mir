package com.leyou.ui.roleHead {
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.data.net.role.TUserStateInfo;
	import com.leyou.enum.FriendEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Team;
	import com.leyou.utils.PlayerUtil;

	import flash.events.MouseEvent;

	public class OtherRoleHeadWnd extends AutoSprite implements IMenu {

		private var userheadImg:Image;
		private var hpImg:Image;
		private var mpImg:Image;
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var hmpW:Number;
		private var hmpH:Number;

		private var btn1:ImgLabelButton;
		private var btn2:ImgLabelButton;
		private var btn3:ImgLabelButton;

		private var playid:int=-1;

		public function OtherRoleHeadWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleHeadWnd.xml"));
			this.y=-20;
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;

			this.visible=false;
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

			this.btn1=this.getUIbyID("btn1Txt1") as ImgLabelButton;
			this.btn2=this.getUIbyID("btn1Txt2") as ImgLabelButton;
			this.btn3=this.getUIbyID("btn1Txt3") as ImgLabelButton;

			this.btn1.text="查看";
			this.btn2.text="组队";
			this.btn3.text="好友";

			this.btn1.addEventListener(MouseEvent.CLICK, onClick);
			this.btn2.addEventListener(MouseEvent.CLICK, onClick);
			this.btn3.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.CLICK, onThisClick);

			this.x=UIManager.getInstance().roleHeadWnd.width + 100;
		}

		private function onThisClick(evt:MouseEvent):void {
			//trace("tttt", evt.target);
			if (evt.target is OtherRoleHeadWnd) {

				return;
				var arr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
				arr.push(new MenuInfo("", 1));
				arr.push(new MenuInfo("", 2));
				arr.push(new MenuInfo("", 3));

					//MenuManager.getInstance().show(arr,this,);
			}
			evt.stopPropagation();
		}

		public function onMenuClick(i:int):void {
			switch (i) {
				case 1:

					break;
				case 2:

					break;
				case 3:

					break;
				case 4:

					break;
			}
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "btn1Txt1":
					//					UIManager.getInstance().otherRoleWnd.updateInfo(info);
					//					UIManager.getInstance().otherRoleWnd.show(true, true);
					Cmd_Role.cm_queryUserState(playid, UIManager.getInstance().mirScene.getPlayer(playid).nowTilePt());
					break;
				case "btn1Txt2":
					if (UIManager.getInstance().teamWnd.teamerInfo.length > 0) {
						Cmd_Team.cm_addGroupMember(this.nameLbl.text);
					} else {
						Cmd_Team.cm_createGroup(null);
						Cmd_Team.cm_createGroup(this.nameLbl.text, true);
					}
					break;
				case "btn1Txt3":
					//					Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, FriendEnum.ADD_FRIEND + "," +info.UserName);
					break;
			}
		}

		//更新显示信息
		public function updataInfo(playerId:int):void {
			var pinfo:LivingInfo=UIManager.getInstance().mirScene.getPlayer(playerId).infoB;
			if (pinfo == null)
				return;

			this.playid=playerId;

			this.visible=true;
			this.nameLbl.text=pinfo.name;
			this.lvLbl.text=pinfo.level.toString();
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(pinfo.race, 1);
			this.userheadImg.updateBmp(PlayerUtil.getPlayerHeadImg(pinfo.race, pinfo.sex));
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

		public function updateLevel():void {
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}
	}
}
