package com.leyou.ui.skill.child {
	import com.ace.astar.child.Grid;
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.manager.UIManager;
	
	import flash.events.MouseEvent;

	public class SkillShortCutBar extends AutoSprite {
		private var cancelBtn:NormalButton;
		private var gridArr:Vector.<ShortCutBarGrid>;
		private var obj:Object;

		public function SkillShortCutBar() {
			super(LibManager.getInstance().getXML("config/ui/skill/skillShortCutBar.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void {
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.gridArr=new Vector.<ShortCutBarGrid>;
			var grid:ShortCutBarGrid;
			for (var i:int=0; i < 10; i++) {
				grid=new ShortCutBarGrid();
				grid.x=5 + i % 5 * 43;
				grid.y=34 + (Math.ceil((i + 1) / 5) - 1) * 43;
				if(i==9)
					grid.id=0;
				else grid.id=i+1;
				if(grid.id>0&&grid.id<8)
					grid.numberLbl=grid.id+"";
				else {
					if(grid.id==8)
						grid.numberLbl="Q";
					else if(grid.id==9)
						grid.numberLbl="W";
					else if(grid.id==0)
						grid.numberLbl="E";
				}
				this.gridArr.push(grid);
				this.addChild(grid);
			}
			this.obj=new Object();
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "cancelBtn":
					UIManager.getInstance().skillWnd.shortCutCancel();
					status=false;
					break;
			}
		}

		public function set status(bo:Boolean):void {
			if (bo)
				this.visible=true;
			else
				this.visible=false;
		}

		public function update(obj:Object):void {
			for(var i:* in obj){
				if(!(obj[i] as GridBase).isEmpty)
					this.gridArr[i].setIcon((obj[i] as GridBase).itemBmp);
				else this.gridArr[i].reset();
			}
		}
		
		public function set cancelBtnSta(sta:Boolean):void{
			this.cancelBtn.visible=sta;
		}
		
		public function selectImgSta(idx:int):void{
			for(var i:int=0;i<this.gridArr.length;i++){
				if(i==idx)
					this.gridArr[i].selectSta=true;
				else this.gridArr[i].selectSta=false;
			}
		}
	}
}