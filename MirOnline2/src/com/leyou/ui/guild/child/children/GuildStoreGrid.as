package com.leyou.ui.guild.child.children {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.utils.GuildUtils;

	public class GuildStoreGrid extends GridBase {
		public function GuildStoreGrid(id:int=-1) {
			super(id);
		}

		override protected function init():void {
			super.init();
			this.isLock=false;
			//this.canMove=false;

			this.gridType=ItemEnum.TYPE_GRID_GUILD;

			this.iconBmp.x=(40 - 28) >> 1;
			this.iconBmp.y=(40 - 30) >> 1;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			//this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
		}

		override public function updataInfo(info:*):void {
			super.updataInfo(info);


			if (info != null) {
				//this.dataId=UIManager.getInstance().guildWnd.storeArr[5].indexOf(info);
				this.iconBmp.updateBmp("items/" + TClientItem(info).s.appr + ".png");
			} else {
				//this.dataId=-1;
				this.iconBmp.bitmapData=null;
			}
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);
			if (this.isEmpty)
				return;
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
		}

		override public function switchHandler(fromItem:GridBase):void {

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				super.switchHandler(fromItem);

				MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;

				var tc:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId] as TClientItem;
				if (tc == null)
					return;

				var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
				if (arr == null)
					return;

				Cmd_Guild.cm_addGuildItem(tc.MakeIndex, (arr[0] == "1" ? 0 : 2));
			}
//			else if (fromItem.gridType == ItemEnum.TYPE_GRID_GUILD)
//			{
//				super.switchHandler(fromItem);
//				
//				MyInfoManager.getInstance().waitItemFromId=fromItem.dataId;
//				
//				var tc:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId] as TClientItem;
//				if (tc == null)
//					return;
//				
//				var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
//				if (arr == null)
//					return;
//				
//				Cmd_Guild.cm_addGuildItem(tc.MakeIndex, (arr[0] == "1" ? 0 : 2));
//			}
//			
		}

	}
}
