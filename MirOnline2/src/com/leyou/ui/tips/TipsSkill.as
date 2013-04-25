package com.leyou.ui.tips {
	import com.ace.enum.FontEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.ace.utils.HexUtil;
	import com.leyou.data.tips.SkillTipsInfo;
	import com.leyou.enum.TipsEnum;
	import com.leyou.ui.tips.child.TipsGrid;
	import com.leyou.utils.TipsUtil;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class TipsSkill extends Sprite {
		private var lbl:Label;
		private var bg:ScaleBitmap;
		private var w:Number;
		private var grid:TipsGrid;
		private var info:SkillTipsInfo;

		public function TipsSkill() {
			super();
			this.init();
		}

		private function init():void {
			this.info=new SkillTipsInfo();
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.alpha=.8;
			this.addChildAt(this.bg, 0);
			this.w=182;
			this.lbl=new Label();
			this.lbl.width=this.w - 2;
			this.lbl.wordWrap=true;
			this.lbl.multiline=true;
			this.lbl.x=2;
			this.lbl.y=2;
			this.addChild(this.lbl);
			var format:TextFormat=new TextFormat();
			format.size=12;
			this.lbl.defaultTextFormat=format;
			this.grid=new TipsGrid();
			this.grid.x=141;
			this.grid.y=3;
			this.addChild(this.grid);

		}

		private function updateInfo(info:SkillTipsInfo):void {
			if (info == null)
				return;
			var item:TItemInfo;
			this.lbl.htmlText=TipsUtil.getColorStr(info.name, TipsEnum.COLOR_YELLOW);
			if (info.skillLv == -1) {
				this.lbl.htmlText+=TipsUtil.getColorStr("学习条件:", TipsEnum.COLOR_BLUE);
				if (MyInfoManager.getInstance().level >= info.limit)
					this.lbl.htmlText+=TipsUtil.getColorStr("     人物等级达到" + info.limit + "级", TipsEnum.COLOR_GREEN);
				else
					this.lbl.htmlText+=TipsUtil.getColorStr("     人物等级达到" + info.limit + "级", TipsEnum.COLOR_RED);
				item=TableManager.getInstance().getItemByName(info.name);
				if (item != null) {
					var num:int=MyInfoManager.getInstance().itemTotalNum(item.id);
					if (MyInfoManager.getInstance().itemTotalNum(item.id) <= 0)
						this.lbl.htmlText+=(TipsUtil.getColorStr("     需要技能书《" + info.name + "》", TipsEnum.COLOR_RED));
					else
						this.lbl.htmlText+=(TipsUtil.getColorStr("     需要技能书《" + info.name + "》", TipsEnum.COLOR_GREEN));
				}
			}else{
				this.lbl.htmlText+=TipsUtil.getColorStr("当前等级："+info.skillLv+"级",TipsEnum.COLOR_WHITE);
				if(info.skillLv==3){
					this.lbl.htmlText+=TipsUtil.getColorStr("该技能已达到满级",TipsEnum.COLOR_WHITE);
				}
				else if(info.skillLv<3){
					this.lbl.htmlText+=TipsUtil.getColorStr("熟练程度："+ info.proficiency, TipsEnum.COLOR_GREEN);
					this.lbl.htmlText+=TipsUtil.getColorStr("该技能最高可提升至3级",TipsEnum.COLOR_GREEN);
				}
				this.lbl.htmlText+=TipsUtil.getColorStr("使用条件：",TipsEnum.COLOR_BLUE);
				var mp:int=MyInfoManager.getInstance().baseInfo.MP;//玩家魔法值
				mp=HexUtil.LoWord(mp);
				if(mp>=info.useMagic)
					this.lbl.htmlText+=TipsUtil.getColorStr("     每次消耗"+info.useMagic+"点魔法值",TipsEnum.COLOR_GREEN);
				else this.lbl.htmlText+=TipsUtil.getColorStr("     每次消耗"+info.useMagic+"点魔法值",TipsEnum.COLOR_RED);
				if(TipsEnum.skill[info.name]!=null){
					if(TipsUtil.checkItem(TipsEnum.skill[info.name].item,TipsEnum.skill[info.name].num)){
						if((TipsEnum.skill[info.name].item as Array).length==2)
							this.lbl.htmlText+=TipsUtil.getColorStr("     每次消耗"+TipsEnum.skill[info.name].num+"张【护身符】",TipsEnum.COLOR_GREEN);
						else this.lbl.htmlText+=TipsUtil.getColorStr("     需要【灰色/黄色药粉】",TipsEnum.COLOR_GREEN);
					}
					else {
						if((TipsEnum.skill[info.name].item as Array).length==2)
							this.lbl.htmlText+=TipsUtil.getColorStr("     每次消耗"+TipsEnum.skill[info.name].num+"张【护身符】",TipsEnum.COLOR_RED);
						else this.lbl.htmlText+=TipsUtil.getColorStr("     需要【灰色/黄色药粉】",TipsEnum.COLOR_RED);
					}
				}
				if(info.skillLv<3){
					this.lbl.htmlText+=TipsUtil.getColorStr("升级条件：",TipsEnum.COLOR_BLUE);
					if (MyInfoManager.getInstance().level >= info.limit)
						this.lbl.htmlText+=TipsUtil.getColorStr("     人物等级达到" + info.limit + "级", TipsEnum.COLOR_GREEN);
					else
						this.lbl.htmlText+=TipsUtil.getColorStr("     人物等级达到" + info.limit + "级", TipsEnum.COLOR_RED);
					this.lbl.htmlText+=TipsUtil.getColorStr("     熟练度达到"+info.needDru,TipsEnum.COLOR_RED);
				}
			}
			if (info.instruction != null || info.instruction != "")
				this.lbl.htmlText+=TipsUtil.getColorStr(info.instruction, TipsEnum.COLOR_BLUE);
			this.lbl.htmlText+=TipsUtil.getColorStr(info.shortDer,TipsEnum.COLOR_YELLOW);
			this.grid.visible=true;
			this.grid.updataInfo(info);
			this.bg.setSize(this.w, this.lbl.height + 3);
		}

		/**
		 * 技能tips
		 * @param info
		 * @param flag 0技能面板 1:快捷键
		 *
		 */
		public function skillWndTip(info:TClientMagic, flag:int=0):void {
			this.info.clearMe();
			var skill:TSkillInfo;
			if (info.isLearn) {
				this.info.name=info.def.sMagicName;
				skill=TableManager.getInstance().getSkillInfo(info.def.wMagicId);
				var needProficiency:int;
				if (skill) {
					if (info.level == 0) {
						this.info.limit=skill.needLv1;
						needProficiency=skill.lv1Train;
					} else if (info.level == 1) {
						this.info.limit=skill.needLv2;
						needProficiency=skill.lv2Train;
					} else if (info.level == 2) {
						this.info.limit=skill.needLv3;
						needProficiency=skill.lv3Train;
					}
					this.info.instruction=skill.descr;
				}
				this.info.skillLv=info.level;
				if (info.level == 3)
					this.info.proficiency="-";
				else
					this.info.proficiency=info.curTrain + "/" + needProficiency;
				this.info.useMagic=info.def.wSpell;
				this.info.Looks=info.def.btEffect;
				this.info.needDru=needProficiency;
			} else if (info.isLearn == false) {
				skill=TableManager.getInstance().getSkillInfo(info.skillId);
				if (skill) {
					this.info.name=skill.name;
					this.info.limit=skill.needLv1;
					this.info.instruction=skill.descr;
					this.info.skillLv=-1;
					this.info.proficiency=String(0);
					this.info.Looks=skill.effectType;
				}
			}
			if (flag == 0) //技能面板
				this.info.shortDer="(点击图标设置快捷键)";
			else
				this.info.shortDer="(拖拽技能图标改变快捷键)";
			this.updateInfo(this.info);
		}

		public function skillBtnTip(info:TClientMagic):void {
			var arr:Array=new Array();
			if (info.isLearn) {
				arr.push(TipsUtil.getColorStr(info.def.sMagicName, TipsEnum.COLOR_YELLOW));
				if ((info as TClientMagic).level == 3) {
					arr.push(TipsUtil.getColorStr("该技能已达到最高等级", TipsEnum.COLOR_GREEN));
					this.updateBtnInfo(arr);
				} else {
					arr.push(TipsUtil.getColorStr("该技能最高可提升至3级", TipsEnum.COLOR_GREEN));
					arr.push(TipsUtil.getColorStr("强化条件：", TipsEnum.COLOR_GREEN));

					arr=arr.concat(getStation(info.level + 1, TableManager.getInstance().getSkillInfo(info.def.wMagicId)));
				}
			} else {
				var tSkill:TSkillInfo=TableManager.getInstance().getSkillInfo(info.skillId);
				if (tSkill) {
					arr.push(TipsUtil.getColorStr(tSkill.name, TipsEnum.COLOR_YELLOW));
					arr.push(TipsUtil.getColorStr("学习条件：", TipsEnum.COLOR_GREEN));
					var item:TItemInfo=TableManager.getInstance().getItemByName(tSkill.name);
					if (item != null) {
						var num:int=MyInfoManager.getInstance().itemTotalNum(item.id);
						if (MyInfoManager.getInstance().itemTotalNum(item.id) <= 0)
							arr.push(TipsUtil.getColorStr("需要物品：" + tSkill.name + "(技能书)", TipsEnum.COLOR_RED));
						else
							arr.push(TipsUtil.getColorStr("需要物品：" + tSkill.name + "(技能书)", TipsEnum.COLOR_GREEN));
					}
					arr=arr.concat(getStation(1, tSkill));
				}
			}
			this.updateBtnInfo(arr);
		}

		private function updateBtnInfo(arr:Array):void {
			this.lbl.htmlText="";
			for (var i:int=0; i < arr.length; i++) {
				this.lbl.htmlText+=arr[i];
			}
			this.bg.setSize(170, this.lbl.height + 3);
			this.grid.visible=false;
		}

		private function getStation(lv:int, info:TSkillInfo):Array {
			var arr:Array=new Array();
			if (info == null)
				return arr;
			var needLv:int;
			switch (lv) {
				case 1:
					needLv=info.needLv1;
					break;
				case 2:
					needLv=info.needLv2;
					break;
				case 3:
					needLv=info.needLv3;
					break;

			}
			if (MyInfoManager.getInstance().level >= needLv)
				arr.push(TipsUtil.getColorStr("人物等级：" + needLv, TipsEnum.COLOR_GREEN));
			else
				arr.push(TipsUtil.getColorStr("人物等级：" + needLv, TipsEnum.COLOR_RED));
			return arr;
		}
	}
}