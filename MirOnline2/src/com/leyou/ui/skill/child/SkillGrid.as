package com.leyou.ui.skill.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.ui.cdTimer.CDTimer;

	public class SkillGrid extends GridBase {
		private var numLbl:Label;
		
		private var cd:CDTimer;
		private var isCD:Boolean;
		private var cdRemaindTime:int;

		public function SkillGrid() {
			super();
		}

		override protected function init():void {
			super.init();
			this.isLock=true;
			this.gridType=ItemEnum.TYPE_GRID_SKILL;

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.numLbl=new Label("1", FontEnum.STYLE_NAME_DIC["White10right"]);
			this.numLbl.x=30;
			this.numLbl.y=23;
			this.numLbl.text="";
			this.addChild(this.numLbl);

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/mainUI/icon_skill.png");
			
			this.cd=new CDTimer(this.width,this.height);
			this.cd.cdEndFun=this.cdEnd;
			this.cd.enterFrameFun=this.cdEnterFrame;
			this.addChild(this.cd);
			this.cd.visible=false;
		}

		override public function updataInfo(info:*):void {
			super.updataInfo(info);
			this.dataId=MyInfoManager.getInstance().skills.indexOf(info);
			this.isLock=false;
			if (info.isLearn == false) {
				var tSkill:TSkillInfo=TableManager.getInstance().getSkillInfo(info.skillId);
//				this.numLbl.text="0";
				this.iconBmp.updateBmp("skillIco/" + (800 + tSkill.effectType * 2) + ".png");
			} else {
//				this.numLbl.text=info.level.toString();
				this.iconBmp.updateBmp("skillIco/" + (800 + info.def.btEffect * 2) + ".png");
			}
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;
			ItemTip.getInstance().show(this.dataId, this.gridType);
			ItemTip.getInstance().updataPs($x, $y);
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			//只有主动技能才能设置快捷键 暂时先不做
			UIManager.getInstance().skillWnd.setShortCutBarPos($x, $y, this.dataId);
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			ItemTip.getInstance().hide();
		}
		
		/**
		 *设置显示快捷键 
		 * @param num
		 * 
		 */		
		public function setShortCutKeyNum(num:int):void{
			if(num>=0)
				this.numLbl.text=String(num);
			else this.numLbl.text="";
		}
		
		public function cdTime(time:int=2000):void {
			if (this.isCD == true){
				if(this.cdRemaindTime<time){
					this.cd.stop();
					this.cd.start(time);
					this.cd.visible=true;
					this.isCD=true;
					this.mouseEnabled=false;
				}
				return;
			}
			this.cd.start(time);
			this.isCD=true;
			this.mouseEnabled=false;
			this.cd.visible=true;
		}
		
		public function cdEnd():void {
			this.isCD=false;
			this.mouseEnabled=true;
			this.cd.visible=false;
		}
		
		private function cdEnterFrame(t:int):void{
			this.cdRemaindTime=t;
		}
	}
}