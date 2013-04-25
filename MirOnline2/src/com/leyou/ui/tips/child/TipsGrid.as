package com.leyou.ui.tips.child {
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.leyou.data.tips.SkillTipsInfo;

	public class TipsGrid extends GridBase {
		public function TipsGrid(id:int=-1) {
			super(id);
		}
		override protected function init():void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;
			
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			//this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
		}
		
		override public function updataInfo(info:*):void {
			this.iconBmp.bitmapData=null;
			super.updataInfo(info);
			this.canMove=false;
			if(info!=null&&info is SkillTipsInfo){
				this.iconBmp.updateBmp("skillIco/" + (800 + info.Looks * 2) + ".png");
			}
			else if(info != null)
				this.iconBmp.updateBmp("items/" + info.Looks + ".png");
		}
	}
}