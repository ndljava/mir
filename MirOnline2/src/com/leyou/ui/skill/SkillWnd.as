package com.leyou.ui.skill {
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.DragManager;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.SkillEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.skill.child.SkillGrid;
	import com.leyou.ui.skill.child.SkillListRender;
	import com.leyou.ui.skill.child.SkillShortCutBar;
	import com.leyou.ui.tools.child.ShortcutsGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SkillWnd extends AutoWindow {
		public var initOK:Boolean;
		private var gridList:ScrollPane;
		private var numLbl:Label;
		private var renderArr:Vector.<SkillListRender>;
		private var shortCutBar:SkillShortCutBar;
		private var currentIdx:int=-1;

		public function SkillWnd() {
			super(LibManager.getInstance().getXML("config/ui/SkillWnd.xml"));
			this.init();
		}

		private function init():void {
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.numLbl=this.getUIbyID("numLbl") as Label;

			this.shortCutBar=new SkillShortCutBar();
			this.shortCutBar.x=0;
			this.addToPane(this.shortCutBar);
			this.shortCutBar.visible=false;
			this.renderArr=new Vector.<SkillListRender>;
			MouseManager.getInstance().addFun(MouseEvent.MOUSE_UP, onStageMouseUP);
		}

		public function updata(arr:Vector.<TClientMagic>, frist:Boolean=false):void {
			this.initOK=true;
			var i:int;
			var num:int;
			if (frist) {
				var render:SkillListRender;
				for (i=0; i < arr.length; i++) {
					render=new SkillListRender();
					render.y=i * SkillListRender.RENDER_WIDTH;
					this.renderArr.push(render);
					this.gridList.addToPane(render);
					render.updata(arr[i]);
					if (arr[i].isLearn)
						num++;
				}
			} else {
				for (i=0; i < arr.length; i++) {
					this.renderArr[i].updata(arr[i]);
					if (arr[i].isLearn)
						num++;
				}
			}
			this.numLbl.text=num + "/" + arr.length;
		}

		/**
		 *显示设置快捷键组件
		 * @param _x
		 * @param _y
		 * @param idx //当前点击的格子的idx
		 *
		 */
		public function setShortCutBarPos(_x:Number, _y:Number, idx:int):void {
			if (MyInfoManager.getInstance().skills[idx].isLearn == false) {
//				AlertWindow.showWin("您还没有学会此技能，不能设置快捷键");
				UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您还没有学会此技能，不能设置快捷键", SystemNoticeEnum.IMG_WARN);
				return;
			}
			else {
				var id:int=MyInfoManager.getInstance().skills[idx].def.wMagicId;
				if(TableManager.getInstance().getSkillInfo(id).delay<=0){
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("此技能为被动技能，不能设置快捷键", SystemNoticeEnum.IMG_WARN);
					return;
				}
			}
			var p:Point=this.globalToLocal(new Point(_x, _y));
			this.shortCutBar.y=p.y - this.shortCutBar.height - 20;
			this.shortCutBar.status=true;
			this.currentIdx=idx;
			this.shortCutBar.update(UIManager.getInstance().toolsWnd.shortCutGrid);
			idx=UIManager.getInstance().toolsWnd.checkSKill(idx, false)
			if (idx != -1) {
				this.shortCutBar.cancelBtnSta=true;

			} else
				this.shortCutBar.cancelBtnSta=false;
			this.shortCutBar.selectImgSta(idx);

		}

		/**
		 *将技能显示到快捷栏上
		 * @param idx 快捷栏的idx
		 *
		 */
		public function setSkillShortCut(idx:int):void {
			UIManager.getInstance().toolsWnd.checkSKill(this.renderArr[this.currentIdx].grid.gridId);
			if (idx == 0)
				idx=9;
			else
				idx--;
			(UIManager.getInstance().toolsWnd.shortCutGrid[idx] as ShortcutsGrid).switchHandler(this.renderArr[this.currentIdx].grid);
			this.shortCutBar.status=false;
		}

		public function shortCutCancel():void {
			UIManager.getInstance().toolsWnd.checkSKill(this.currentIdx);
		}

		public function getSkillGrid(idx:int):SkillGrid {
			if (this.renderArr[idx])
				return this.renderArr[idx].grid;
			return null;
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(true, true);
			if (this.renderArr.length == 0) {
				this.updata(MyInfoManager.getInstance().skills, true);
			}
		}

		/**
		 * 技能的熟练度更新
		 * @param id
		 * @param exp
		 *
		 */
		public function skillExpChange(id:int, exp:int, lv:int):void {
			for (var i:int=0; i < MyInfoManager.getInstance().skills.length; i++) {
				if (MyInfoManager.getInstance().skills[i].skillId == id) {
					MyInfoManager.getInstance().skills[i].curTrain=exp;
					MyInfoManager.getInstance().skills[i].level=lv;
					this.renderArr[i].updata(MyInfoManager.getInstance().skills[i]);
					break;
				}
			}
		}

		/**
		 *设置技能格子的快捷键的显示
		 * @param gridDate 格子的数据id
		 * @param shortCutNum
		 *
		 */
		public function setSkillGridShortCut(gridDateId:int, shortCutNum:int):void {
			if (gridDateId >= 0)
				this.renderArr[gridDateId].grid.setShortCutKeyNum(shortCutNum);
		}

		/**
		 *使用技能时 检查是否需要自动穿道具
		 * @param info
		 *
		 */
		public function checkUseItem(mgicId:int):void {
			var equip:Vector.<TClientItem>=MyInfoManager.getInstance().equips;
			var binfo:TClientItem;
			var id:Array;
			if (SkillEnum.SKILL_USE_SIGN.indexOf(mgicId) > -1) { //使用符
				if (equip[ItemEnum.U_BUJUK] == null || equip[ItemEnum.U_BUJUK].s == null || equip[ItemEnum.U_BUJUK].s.name.indexOf("护身符") == -1) {
					id=getItemIdByName("护身符");
					if (id[0] > -1)
						(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, id[1]) as BackpackGrid).onUse();
//						UIManager.getInstance().backPackWnd.useItem(id[0]);
				}
			} else if (SkillEnum.SKILL_USE_DRYG.indexOf(mgicId) > -1) { //使用药水
				if (equip[ItemEnum.U_BUJUK] == null || equip[ItemEnum.U_BUJUK].s == null || (equip[ItemEnum.U_BUJUK].s.name.indexOf("黄色药粉") == -1 && equip[ItemEnum.U_BUJUK].s.name.indexOf("灰色药粉") == -1)) {
					var idd:Array=getItemIdByName("黄色药粉");
					id=getItemIdByName("灰色药粉");
					if (idd[0] != -1 && id[0] != -1) {
						if (idd[1] > id[1])
							(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, id[1]) as BackpackGrid).onUse();
//							UIManager.getInstance().backPackWnd.useItem(id[0]);
						else
							(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, idd[1]) as BackpackGrid).onUse();
//							UIManager.getInstance().backPackWnd.useItem(idd[0]);
					} else if (idd[0] != -1)
						(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, idd[1]) as BackpackGrid).onUse();
//						UIManager.getInstance().backPackWnd.useItem(idd[0]);
					else if (id[0] != -1)
						(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, id[1]) as BackpackGrid).onUse();
//						UIManager.getInstance().backPackWnd.useItem(id[0]);
				} else if (equip[ItemEnum.U_BUJUK].s.name.indexOf("黄色药粉") > -1) {
					id=getItemIdByName("灰色药粉");
					if (id[0] > -1)
						(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, id[1]) as BackpackGrid).onUse();
//						UIManager.getInstance().backPackWnd.useItem(id[0]);
				} else if (equip[ItemEnum.U_BUJUK].s.name.indexOf("灰色药粉") > -1) {
					id=getItemIdByName("黄色药粉");
					if (id[0] > -1)
						(DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, id[1]) as BackpackGrid).onUse();
//						UIManager.getInstance().backPackWnd.useItem(id[0]);
				}
			}
		}

		private function getItemIdByName(n:String):Array {
			var idarr:Array=[-1, -1];
			var equip:Vector.<TClientItem>=MyInfoManager.getInstance().backpackItems;
			for (var i:int=0; i < equip.length; i++) {
				if (equip[i].s != null && equip[i].s.name.indexOf(n) > -1) {
					idarr[0]=equip[i].s.id;
					idarr[1]=i
					break;
				}
			}
			return idarr;
		}

		public function setCD(info:TClientMagic):void {
			var time:int=TableManager.getInstance().getSkillInfo(info.def.wMagicId).delay;
			var i:int=MyInfoManager.getInstance().skills.indexOf(info);
			this.renderArr[i].grid.cdTime(time);
			if(time<SkillEnum.SKILL_PUBLIC_CD_TIME)
				return;
			for (i=0; i < this.renderArr.length; i++) {
				var inf:TClientMagic=MyInfoManager.getInstance().skills[i];
				if (i != MyInfoManager.getInstance().skills.indexOf(info)) {
					if(!this.renderArr[i].grid.isCD)
						this.renderArr[i].grid.cdTime(SkillEnum.SKILL_PUBLIC_CD_TIME);
//					var t:int;
//					if (inf.isLearn) {
//						t=TableManager.getInstance().getSkillInfo(inf.def.wMagicId).delay;
//					} else
//						t=TableManager.getInstance().getSkillInfo(inf.skillId).delay;
//
//					if (time < t)
//						this.renderArr[i].grid.cdTime(time);
//					else
//						this.renderArr[i].grid.cdTime(t);
				} 
//				else
//					this.renderArr[i].grid.cdTime(time);
			}
		}

		private function onStageMouseUP(evt:MouseEvent):void {
			this.shortCutBar.status=false;
		}

		
	}
}