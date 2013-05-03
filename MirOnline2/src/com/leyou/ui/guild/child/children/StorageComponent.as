package com.leyou.ui.guild.child.children
{
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Guild;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class StorageComponent extends AutoSprite implements IMenu
	{

		private var itemGridArr:Vector.<GuildStoreGrid>

		private var selectIndex:int=-1;

		private var nextBtn:NormalButton;
		private var pervBtn:NormalButton;
		private var prvLbl:Label;
		private var nextLbl:Label;

		private var _currentPage:int=0;
		private var countPage:int=0;

		public function StorageComponent()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/child/StorageRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void
		{
			this.nextBtn=this.getUIbyID("nextBtn") as NormalButton;
			this.pervBtn=this.getUIbyID("prvBtn") as NormalButton;
			this.nextLbl=this.getUIbyID("nextLbl") as Label;
			this.prvLbl=this.getUIbyID("prvLbl") as Label;

			this.itemGridArr=new Vector.<GuildStoreGrid>();

			var itemGrid:GuildStoreGrid;
			for (var i:int=0; i < 96; i++)
			{
				itemGrid=new GuildStoreGrid();
				this.addChild(itemGrid);

				if (i < 48)
				{
					itemGrid.x=7 + this.itemGridArr.length % 8 * (itemGrid.width + 3);
					itemGrid.y=10 + Math.floor(this.itemGridArr.length / 8) * (itemGrid.height + 3);
				}
				else
				{
					itemGrid.x=350 + this.itemGridArr.length % 8 * (itemGrid.width + 3);
					itemGrid.y=10 + Math.floor(Math.floor(this.itemGridArr.length % 48) / 8) * (itemGrid.height + 3);
				}

				itemGrid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

				this.itemGridArr.push(itemGrid);
			}

			this.pervBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.nextBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "prvBtn":
					_currentPage-=2;
					if (_currentPage <= 0)
						_currentPage=0;

					break;
				case "nextBtn":
					if (_currentPage < countPage-1)
						_currentPage+=2;
					break;
			}

			Cmd_Guild.cm_guildStroage(GuildEnum.STOREBEG);
		}

		private function onMouseDown(e:MouseEvent):void
		{
			//["贡献", "称号", "战备", "个人"]
			var menuarr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
			menuarr.push(new MenuInfo("贡献",0));
			menuarr.push(new MenuInfo("称号",1));
			menuarr.push(new MenuInfo("战备",2));
			menuarr.push(new MenuInfo("个人",3));
			
			MenuManager.getInstance().show(menuarr,this,new Point(e.stageX,e.stageY));
			
			selectIndex=this.itemGridArr.indexOf(e.target);
		}

		public function onMenuClick(i:int):void
		{
			var tc:TClientItem=UIManager.getInstance().guildWnd.storeArr[GuildEnum.STOREBEG][_currentPage + Math.floor(this.selectIndex / 48)][this.selectIndex];
			if (tc == null)
				return;

			switch (i)
			{
				case 0:
					PopupManager.showConfirmInput("请输入领取此物品所需要的贡献度:", function(i:int):void
					{
						if (i > 0)
						{
							Cmd_Guild.cm_guildStroageType(1, tc.MakeIndex, i);
							Cmd_Guild.cm_guildStroage(1);
							Cmd_Guild.cm_guildStroage(2);
							Cmd_Guild.cm_guildStroage(3);
							Cmd_Guild.cm_guildStroage(4);
							Cmd_Guild.cm_guildStroage(5);
						}
					});
					break;
				case 1:
					PopupManager.showConfirmInput("请输入领取此物品所需要的行会编号:", function(i:int):void
					{
						if (i > 0)
						{
							Cmd_Guild.cm_guildStroageType(2, tc.MakeIndex, i);
							Cmd_Guild.cm_guildStroage(1);
							Cmd_Guild.cm_guildStroage(2);
							Cmd_Guild.cm_guildStroage(3);
							Cmd_Guild.cm_guildStroage(4);
							Cmd_Guild.cm_guildStroage(5);
						}
					});
					break;
				case 2:
					Cmd_Guild.cm_guildStroageType(3, tc.MakeIndex);
					Cmd_Guild.cm_guildStroage(1);
					Cmd_Guild.cm_guildStroage(2);
					Cmd_Guild.cm_guildStroage(3);
					Cmd_Guild.cm_guildStroage(4);
					Cmd_Guild.cm_guildStroage(5);
					break;
				case 3:
					PopupManager.showConfirmInput("请输入领取此物品玩家名称:", function(str:String):void
					{
						if (str != "")
						{
							Cmd_Guild.cm_guildStroageType(4, tc.MakeIndex, 0, str);
							Cmd_Guild.cm_guildStroage(1);
							Cmd_Guild.cm_guildStroage(2);
							Cmd_Guild.cm_guildStroage(3);
							Cmd_Guild.cm_guildStroage(4);
							Cmd_Guild.cm_guildStroage(5);
						}
					});
					break;
			}

		 
		}


		public function updateGrid():void
		{
			countPage=UIManager.getInstance().guildWnd.storeArr[GuildEnum.STOREBEG].length;

			var cPage:int=(_currentPage == 0 ? _currentPage + 1 : _currentPage);

			this.prvLbl.text=cPage + "/" + countPage;
			this.nextLbl.text=(cPage + 1) + "/" + countPage;

			var tc:Vector.<TClientItem>;
			if (_currentPage <= countPage - 1)
				tc=UIManager.getInstance().guildWnd.storeArr[GuildEnum.STOREBEG][_currentPage];

			for (var i:int=0; i < 48; i++)
			{
				if (tc != null && i < tc.length)
				{
					this.itemGridArr[i].updataInfo(tc[i]);
					this.itemGridArr[i].dataId=i;
				}
				else
				{
					this.itemGridArr[i].updataInfo(null);
				}
			}

			if (_currentPage + 1 <= countPage - 1)
				tc=UIManager.getInstance().guildWnd.storeArr[GuildEnum.STOREBEG][_currentPage + 1];

			for (i=0; i < 48; i++)
			{
				if (tc != null && i < tc.length)
				{
					this.itemGridArr[48 + i].updataInfo(tc[i]);
					this.itemGridArr[48 + i].dataId=i;
				}
				else
				{
					this.itemGridArr[48 + i].updataInfo(null);
				}
			}
		}

		public function get currentPage():int
		{
			return _currentPage + Math.floor(this.selectIndex / 48);
		}


	}
}
