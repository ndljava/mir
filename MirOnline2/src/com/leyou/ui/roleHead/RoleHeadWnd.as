package com.leyou.ui.roleHead {
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.enum.RoleHeadEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.utils.PlayerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class RoleHeadWnd extends AutoSprite implements IMenu{
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

		private var hpSp:Sprite;
		private var mpSp:Sprite;

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

			this.hpSp=new Sprite();
			this.hpSp.x=98;
			this.hpSp.y=70;
//			this.hpSp.width=this.hmpW;
//			this.hpSp.height=this.hmpH;
			var hpBackImg:Image=this.getUIbyID("hpBackImg") as Image;
			hpBackImg.x=0;
			hpBackImg.y=0;
			this.hpSp.addChild(hpBackImg);
			this.addChild(this.hpSp);
			this.hpSp.addChild(this.hpImg);
			this.hpImg.x=0;
			this.hpImg.y=0;

			this.mpSp=new Sprite();
			this.mpSp.x=98;
			this.mpSp.y=86;
//			this.mpSp.width=this.hmpW;
//			this.mpSp.height=this.hmpH;
			var mpBackImg:Image=this.getUIbyID("mpBackImg") as Image;
			mpBackImg.x=0;
			mpBackImg.y=0;
			this.mpSp.addChild(mpBackImg);
			this.addChild(this.mpSp);
			this.mpSp.addChild(this.mpImg);
			this.mpImg.x=0;
			this.mpImg.y=0;
			this.hpSp.addEventListener(MouseEvent.MOUSE_OVER, onHpOverFun);
			this.hpSp.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.mpSp.addEventListener(MouseEvent.MOUSE_OVER, onMpOverFun);
			this.mpSp.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onThisClick(evt:MouseEvent):void {
			//evt.stopPropagation();
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "btn1Txt1":
					e.stopImmediatePropagation();
					var list:Vector.<MenuInfo>=new Vector.<MenuInfo>;
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[0],0));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[1],1));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[2],2));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[3],3));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[4],4));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[5],5));
					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[6],6));
//					list.push(new MenuInfo(RoleHeadEnum.MENU_LIST[7],7));
					MenuManager.getInstance().show(list,this,this.localToGlobal(new Point(e.target.x,e.target.y+(e.target as ImgLabelButton).height)));
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
			if(hhp<=0)
				hhp=1;
			this.hpImg.setWH(hhp, this.hmpH);

			var mmp:Number=(MyInfoManager.getInstance().baseInfo.MP / MyInfoManager.getInstance().baseInfo.MaxMP) * this.hmpW;
			if (mmp > this.hmpW)
				mmp=this.hmpW;
			if(mmp<=0)
				mmp=1;
			this.mpImg.setWH(mmp, this.hmpH);
		}

		public function updateLevel():void {
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}

		private function onHpOverFun(evt:MouseEvent):void {
			ItemTip.getInstance().showString((MyInfoManager.getInstance().baseInfo.HP + "/" + MyInfoManager.getInstance().baseInfo.MaxHP));
			var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
			ItemTip.getInstance().updataPs(p.x, p.y);
		}

		private function onMpOverFun(evt:MouseEvent):void {
			ItemTip.getInstance().showString((MyInfoManager.getInstance().baseInfo.MP + "/" + MyInfoManager.getInstance().baseInfo.MaxMP));
			var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
			ItemTip.getInstance().updataPs(p.x, p.y);
		}

		private function onMouseOut(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
		}
		
		public function onMenuClick(idx:int):void{
			if(idx>=0&&idx<8){
				var str:String=RoleHeadEnum.CHANGE_MODE+" "+idx;
				Cmd_Chat.cm_say(str);
			}
		}
		
		public function setMode(str:String):void{
			for(var i:int=0;i<RoleHeadEnum.MENU_LIST.length;i++){
				if(str.indexOf(RoleHeadEnum.MENU_LIST[i])>-1){
					this.btn1.text=(RoleHeadEnum.MENU_LIST[i] as String).substring(0,2);
					break;
				}
			}
		}
		
		
	}
}