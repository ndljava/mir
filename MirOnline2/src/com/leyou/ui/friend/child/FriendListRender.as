package com.leyou.ui.friend.child {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.friend.FriendInfo;

	public class FriendListRender extends AutoSprite {
		private var userHeadImg:Image;
		private var nameLbl:Label;
		private var levelLbl:Label;
		private var memberLbl:Label;
		private var highLightSBM:ScaleBitmap;
		private var _id:int;

		public function FriendListRender() {
			super(LibManager.getInstance().getXML("config/ui/friend/FriendDateBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.levelLbl=this.getUIbyID("levelLbl") as Label;
			this.memberLbl=this.getUIbyID("memberLbl") as Label;
			this.highLightSBM=this.getUIbyID("highLightSBM") as ScaleBitmap;
			this.highLightSBM.visible=false;
		}

		public function updata(infor:FriendInfo):void {
//			this.userHeadImg
			this.nameLbl.text=infor.name;
			this.levelLbl.text=infor.lv.toString();
			this.memberLbl.text=infor.mumber.toString();
			this._id=infor.id;
		}

		public function set hightLight(flag:Boolean):void {
			this.highLightSBM.visible=flag;
		}

		public function get id():int {
			return this._id;
		}
	}
}