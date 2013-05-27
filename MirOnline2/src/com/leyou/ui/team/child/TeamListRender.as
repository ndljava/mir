package com.leyou.ui.team.child {
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.team.TeamInfo;
	import com.leyou.manager.UIManager;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.friend.child.FriendListRender;
	import com.leyou.utils.PlayerUtil;

	public class TeamListRender extends AutoSprite {

		private var userHeadImg:Image;
		private var nameLbl:Label;
		private var levelLbl:Label;
		private var memberLbl:Label;
		private var selectScBtm:Image;
		private var timeLbl:Label;
		private var highLightSBM:ScaleBitmap;
		public var id:int;

		public function TeamListRender() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamDateBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.levelLbl=this.getUIbyID("levelLbl") as Label;
			this.memberLbl=this.getUIbyID("memberLbl") as Label;
			this.selectScBtm=this.getUIbyID("selectScBtm") as Image;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.highLightSBM=this.getUIbyID("highLightSBM") as ScaleBitmap;
			this.selectScBtm.visible=false;
			this.highLightSBM.visible=false;
		}

		public function set hightLight(flag:Boolean):void {
			this.selectScBtm.visible=flag;
			this.highLightSBM.visible=flag;
		}

		public function updataInfo(infor:TeamInfo):void {
			this.userNameLbl.text=infor.name + "";

//			var infomodel:LivingModel=UIManager.getInstance().mirScene.getPlayerByName(infor.name);
//			if (infomodel == null)
//				return;

			//var info:LivingInfo=infomodel.infoB;

			this.memLbl.text=infor.relevel+ "转" + infor.level+ "级" + "";
			this.lvLbl.text=infor.mapname + "";
			this.lasttimeLbl.text=infor.x + ":" + infor.y;
			this.id=infor.id;
			
			this.userHeadImg.updateBmp(PlayerUtil.getOtherPlayerHeadImg(infor.race, infor.sex));
		}

		public function updataLivInfo(info:LivingInfo):void {
			if (String(info.nameArr[4]) == "") {
				this.lvLbl.text="未加入行会";
				this.lvLbl.textColor=0xcccccc;
			} else {
				this.lvLbl.textColor=0xffff00;
				this.lvLbl.text=String(info.nameArr[4]).split("≮")[0] + "";
			}

			this.userNameLbl.text=info.name + "";
			this.memLbl.text=String(info.nameArr[3]).length + "转" + info.level.toString() + "级" + "";
			this.lasttimeLbl.text=info.member + " ";
			this.id=info.id;
			
			this.userHeadImg.updateBmp(PlayerUtil.getOtherPlayerHeadImg(info.race, info.sex));
		}

		public function get userNameLbl():Label {
			return nameLbl;
		}

		public function get memLbl():Label {
			return memberLbl;
		}

		public function get lvLbl():Label {
			return levelLbl;
		}

		public function get lasttimeLbl():Label {
			return this.timeLbl;
		}

		public function get username():String {
			return (this.userNameLbl.text || "");
		}

	}
}
