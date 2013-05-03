package com.leyou.ui.skill {
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.skill.child.SkillGrid;
	import com.leyou.ui.skill.child.SkillListRender;
	import com.leyou.ui.skill.child.SkillShortCutBar;
	import com.leyou.ui.tools.child.ShortcutsGrid;
	
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
					if(arr[i].isLearn)
						num++;
				}
			} else {
				for (i=0; i < arr.length; i++) {
					this.renderArr[i].updata(arr[i]);
					if(arr[i].isLearn)
						num++;
				}
			}
			this.numLbl.text=num+"/"+arr.length;
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
			var p:Point=this.globalToLocal(new Point(_x, _y));
			this.shortCutBar.y=p.y - this.shortCutBar.height - 20;
			this.shortCutBar.status=true;
			this.currentIdx=idx;
			this.shortCutBar.update(UIManager.getInstance().toolsWnd.shortCutGrid);
			var idx:int=UIManager.getInstance().toolsWnd.checkSKill(idx, false)
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
		public function skillExpChange(id:int,exp:int,lv:int):void{
			for(var i:int=0;i<MyInfoManager.getInstance().skills.length;i++){
				if(MyInfoManager.getInstance().skills[i].skillId==id){
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
	}
}