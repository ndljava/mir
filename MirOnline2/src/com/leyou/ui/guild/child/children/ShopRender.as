package com.leyou.ui.guild.child.children
{
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.utils.GuildUtils;

	public class ShopRender extends AutoSprite
	{
		private var nameLbl:Label; //道具名字
		private var playerNameLbl:Label;
		private var moneyKindLbl:Label;
		private var priceLbl:Label;
		private var hightLightSBP:ScaleBitmap; //选中时的高亮框

		private var itemGrid:GuildStoreGrid;

		public function ShopRender()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/child/ShopRender.xml"));
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void
		{
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.playerNameLbl=this.getUIbyID("playerNameLbl") as Label;
			this.moneyKindLbl=this.getUIbyID("moneyKindLbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;

			this.hightLightSBP=this.getUIbyID("hightLightSBP") as ScaleBitmap;
			this.renderSelectSta=false;

			this.itemGrid=new GuildStoreGrid();
			this.addChild(this.itemGrid);
			itemGrid.x=2;
			itemGrid.y=2;

			this.update(null);
		}

		public function update(info:TClientItem):void
		{
			if (info == null)
			{
				return;
			}

			this.itemGrid.updataInfo(info);
			this.nameLbl.text=info.s.name + "";

			var type:int=GuildUtils.getStoreTypeByItem(UIManager.getInstance().guildWnd.storeArr, info);

			switch (type)
			{
				case GuildEnum.CONTRIBUTION:
					this.playerNameLbl.text="";
					this.moneyKindLbl.text="";
					this.priceLbl.text="贡献值:"+info.nPrice + "";
					break;
				case GuildEnum.NICE:
					this.playerNameLbl.text=info.Name.replace(/\**/g, "") + " 的称号";
					this.moneyKindLbl.text="";
					this.priceLbl.text="";
					break;
				case GuildEnum.FIGHTSTORE:
					this.playerNameLbl.text="";
					this.moneyKindLbl.text="";
					this.priceLbl.text="";
					break;
				case GuildEnum.PERSONAL:
					this.playerNameLbl.text=info.Name.replace(/\**/g, "") + "";
					this.moneyKindLbl.text="";
					this.priceLbl.text="";
					break;
			}
		}

		//设置是否显示选中的高亮框 		
		public function set renderSelectSta(sta:Boolean):void
		{
			this.hightLightSBP.visible=sta;
		}
	}
}
