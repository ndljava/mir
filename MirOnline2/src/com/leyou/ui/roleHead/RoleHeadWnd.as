package com.leyou.ui.roleHead {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;

	public class RoleHeadWnd extends AutoSprite {
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
		
		public function RoleHeadWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleHeadWnd.xml"));
			this.y=-20;
			this.init();
			this.mouseEnabled=true;
			this.mouseChildren=true;
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
			
			this.btn1.text="和平";
			this.btn2.text="挂机";
			this.btn3.text="组队";
			
			this.btn1.addEventListener(MouseEvent.CLICK, onClick);
			this.btn2.addEventListener(MouseEvent.CLICK, onClick);
			this.btn3.addEventListener(MouseEvent.CLICK, onClick);
			
			this.addEventListener(MouseEvent.CLICK, onThisClick);
		}

		private function onThisClick(evt:MouseEvent):void {
			//evt.stopPropagation();
		}

		private function onClick(e:MouseEvent):void{
			switch(e.target.name){
				case "btn1Txt1":
					break;
				case "btn1Txt2":
					break;
				case "btn1Txt3":
					break;
			}
			
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

		public function updateLevel():void {
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}
	}
}