package com.leyou.ui.skill.child {
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SkillEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	
	import flash.events.MouseEvent;

	public class SkillListRender extends AutoSprite {
		public static const RENDER_WIDTH:int=50;

		private var skillGrid:SkillGrid;
		private var nameLbl:Label;
		private var levelLbl:Label;
		private var trainLbl:Label;
		private var desLbl:Label;
		private var studyBtn:NormalButton;

		public function SkillListRender() {
			super(LibManager.getInstance().getXML("config/ui/skill/SkillListRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.skillGrid=new SkillGrid();
			this.skillGrid.x=5;
			this.skillGrid.y=4;
			this.addChild(this.skillGrid);

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.levelLbl=this.getUIbyID("levelLbl") as Label;
			this.trainLbl=this.getUIbyID("trainLbl") as Label;
			this.desLbl=this.getUIbyID("desLbl") as Label;
			this.studyBtn=this.getUIbyID("studyBtn") as NormalButton;

			this.studyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.studyBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			this.studyBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);

		}

		public function updata(info:TClientMagic):void {
			this.skillGrid.updataInfo(info);
			var tSkill:TSkillInfo;
			if (info.isLearn == false) {
				tSkill=TableManager.getInstance().getSkillInfo(info.skillId);
				if (tSkill == null)
					return;
				this.nameLbl.text=tSkill.name;
				this.levelLbl.text="0";
				this.trainLbl.text="0";
				this.desLbl.text=tSkill.descr;
			} else {
				tSkill=TableManager.getInstance().getSkillInfo((info as TClientMagic).def.wMagicId);
				var exp:int;
				if (info.level == 0)
					exp=tSkill.lv1Train;
				else if (info.level == 1)
					exp=tSkill.lv2Train;
				else if (info.level == 2)
					exp=tSkill.lv3Train;
				this.nameLbl.text=info.def.sMagicName;
				this.levelLbl.text=info.level.toString();
				if (info.level < 3)
					this.trainLbl.text=info.curTrain + "/" + exp;
				else if (info.level >= 3)
					this.trainLbl.text="-";
				this.desLbl.text=tSkill.descr;

				if (info.level >= 3) {
					this.studyBtn.text="满级";
					if (this.studyBtn.hasEventListener(MouseEvent.CLICK))
						this.studyBtn.removeEventListener(MouseEvent.CLICK, this.onBtnClick);
				} else {
					this.studyBtn.text="练习";
					if (this.studyBtn.hasEventListener(MouseEvent.CLICK))
						this.studyBtn.removeEventListener(MouseEvent.CLICK, this.onBtnClick);
				}
			}
		}

		override public function get height():Number {
			return this.studyBtn.height;
		}

		public function get grid():SkillGrid {
			return this.skillGrid;
		}
		private var indo:PlayerInfo;

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.currentTarget.name) {
				case "studyBtn":
					var skillInfo:TSkillInfo=TableManager.getInstance().getSkillInfo(MyInfoManager.getInstance().skills[this.grid.dataId].skillId);
					if (skillInfo == null)
						return;
					if (MyInfoManager.getInstance().level < skillInfo.needLv1) {
//						AlertWindow.showWin("您的等级不足 " + skillInfo.needLv1 + "，不能学习此技能");
						UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您的等级不足 " + skillInfo.needLv1 + "，不能学习此技能", SystemNoticeEnum.IMG_PROMPT);
					} else {
						var item:TItemInfo=TableManager.getInstance().getItemByName(skillInfo.name);
						if (item != null) {
							if (MyInfoManager.getInstance().itemTotalNum(item.id) <= 0)
//								AlertWindow.showWin("您没有技术能书 " + item.name);
								UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您没有技术能书 " + item.name, SystemNoticeEnum.IMG_PROMPT);
							else { //发送学习技能的指令
								UIManager.getInstance().backPackWnd.useItem(item.id);
							}
						}
					}
					break;
			}
		}

		private function onBtnOver(evt:MouseEvent):void {
			ItemTip.getInstance().show(this.skillGrid.dataId, SkillEnum.TYPS_SKILLBTN_TIPS);
			ItemTip.getInstance().updataPs(this.stage.mouseX, this.stage.mouseY);
		}

		private function onBtnOut(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
		}

	}
}