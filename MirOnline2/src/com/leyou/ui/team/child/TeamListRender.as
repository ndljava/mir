package com.leyou.ui.team.child {
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.team.TeamInfo;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.utils.PlayerUtil;

	public class TeamListRender extends AutoSprite {
		private var userHeadImg:Image;
		private var lvLbl:Label;
		private var userNameLbl:Label;
		private var memLbl:Label;
		private var memImg:Image;
		private var hightLightSBM:ScaleBitmap;
		private var _id:int;

		public function TeamListRender() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamDateBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.userNameLbl=this.getUIbyID("userNameLbl") as Label;
			this.memLbl=this.getUIbyID("memLbl") as Label;
			this.memImg=this.getUIbyID("memImg") as Image;
			this.hightLightSBM=this.getUIbyID("hightLightSBM") as ScaleBitmap;
			this.hightLightSBM.visible=false;
		}

		public function set hightLight(flag:Boolean):void {
			this.hightLightSBM.visible=flag;
		}

		public function updataInfo(infor:TeamInfo):void {
			this.userNameLbl.text=infor.name + "";
			this.memLbl.text=infor.member + "";
			this.lvLbl.text=infor.level.toString()+"";
			this._id=infor.id;
		}

		public function updataLivInfo(info:LivingInfo):void {
			this.lvLbl.text=info.level.toString()+"r";
			this.userNameLbl.text=info.name + "";
			this.memLbl.text=info.member + "";
			this._id=info.id;
		}

		public function get id():int {
			return this._id;
		}

		public function get username():String {
			return (this.userNameLbl.text || "");
		}

	}
}
