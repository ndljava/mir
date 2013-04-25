package com.leyou.ui.guild {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.HexUtil;
	import com.leyou.enum.GuildEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.TDefaultMessage;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.guild.child.GuildMainPanel;
	import com.leyou.ui.guild.child.GuildMemberPanel;
	import com.leyou.ui.guild.child.GuildPurviewPanel;
	import com.leyou.ui.guild.child.GuildShopPanel;
	import com.leyou.ui.guild.child.GuildStoragePanel;
	import com.leyou.ui.guild.child.GuildWagePanel;
	import com.leyou.utils.GuildUtils;

	import flash.events.Event;
	import flash.system.System;
	import flash.system.SystemUpdater;

	import org.osmf.net.NetClient;

	public class GuildWnd extends AutoWindow {

		private var guidTabBar:TabBar;
		private var menberNumLab:Label;
		private var onLineNumLab:Label;
		private var devoteLab:Label;
		private var goldIngotLab:Label;
		private var guildMainPanel:GuildMainPanel;
		private var guildMemberPanel:GuildMemberPanel;
		private var guildPurviewPanel:GuildPurviewPanel;
		private var guildStoragePanel:GuildStoragePanel;
		private var guildShopPanel:GuildShopPanel;
		private var guildWagePanel:GuildWagePanel;

		/**
		 * 商店数据
		 */
		public var storeArr:Vector.<Vector.<Vector.<TClientItem>>>;
		/**
		 * 商店资金
		 */
		public var storeFund:int=0;
		/**
		 * 商店贡献度
		 */
		public var storeContribute:int=0;

		/**
		 * 会员数据
		 */
		public var memberArr:Array=[];

		/**
		 * 主页数据
		 */
		public var guildContent:Array=[];

		/**
		 * 行会等级
		 */
		public var guildLv:int=0;

		/**
		 *行会人数
		 */
		public var guildMemeberNum:int=0;
		/**
		 *  行会人数 上线
		 */
		public var guildMemeberTopNum:int=0;
		/**
		 *	行业存储元宝
		 * GetGuidValue(self) 返回：
			在线人数，当前地图人数，行会元宝，储备元宝，行会金币，行会贡献
		*/
		private var guildStore:Array=[];

		/**
		 * 仓库翻页数组
		 */
		public var storePageArr:Array=[];

		/**
		 * 商店执行顺序
		 */
		public var storeShopExecIndex:int=0;

		public function GuildWnd() {
			super(LibManager.getInstance().getXML("config/ui/GuildWnd.xml"));
			this.init();
		}

		private function init():void {
			this.guidTabBar=this.getUIbyID("guidTabBar") as TabBar;
			this.menberNumLab=this.getUIbyID("menberNumLab") as Label;
			this.onLineNumLab=this.getUIbyID("onLineNumLab") as Label;
			this.devoteLab=this.getUIbyID("devoteLab") as Label;
			this.goldIngotLab=this.getUIbyID("goldIngotLab") as Label;

			this.guidTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);

			this.guildMainPanel=new GuildMainPanel();
			this.guildMemberPanel=new GuildMemberPanel();
			this.guildPurviewPanel=new GuildPurviewPanel();
			this.guildStoragePanel=new GuildStoragePanel();
			this.guildShopPanel=new GuildShopPanel();
			this.guildWagePanel=new GuildWagePanel();

			this.guidTabBar.addToTab(guildMainPanel, 0);
			this.guidTabBar.addToTab(guildMemberPanel, 1);
			this.guidTabBar.addToTab(guildPurviewPanel, 2);
			this.guidTabBar.addToTab(guildStoragePanel, 3);
			this.guidTabBar.addToTab(guildShopPanel, 4);
			this.guidTabBar.addToTab(guildWagePanel, 5);

			this.storeArr=new Vector.<Vector.<Vector.<TClientItem>>>();

			this.storeArr[0]=new Vector.<Vector.<TClientItem>>();
			this.storeArr[GuildEnum.CONTRIBUTION]=new Vector.<Vector.<TClientItem>>(); //贡献
			this.storeArr[GuildEnum.NICE]=new Vector.<Vector.<TClientItem>>(); //称号
			this.storeArr[GuildEnum.FIGHTSTORE]=new Vector.<Vector.<TClientItem>>(); //战备
			this.storeArr[GuildEnum.PERSONAL]=new Vector.<Vector.<TClientItem>>(); //个人
			this.storeArr[GuildEnum.STOREBEG]=new Vector.<Vector.<TClientItem>>(); //仓库
			this.storeArr[GuildEnum.UNNAMEABLE]=new Vector.<Vector.<TClientItem>>(); //?
		}

		/**
		 * 更新相关数据
		 * @param arr
		 *
		 */
		public function updateData(arr:Array):void {
			guildStore=arr;

			this.menberNumLab.text=arr[0] + "";
			this.onLineNumLab.text=arr[1] + "";

			//this.devoteLab=this.getUIbyID("devoteLab") as Label;
			//this.goldIngotLab=this.getUIbyID("goldIngotLab") as Label;

			this.guildMainPanel.goldTxt=arr[2] + "";
			this.guildMainPanel.storeTxt=arr[3] + "";

			storeFund=arr[4];
			storeContribute=arr[5];

			if (guildContent.length > 0) {
				this.devoteLab.text=guildContent[2] + "";
				this.guildMainPanel.updateData(guildContent);
			}
		}

		/**
		 * 获取mainpanel 的选择索引
		 * @return
		 *
		 */
		public function get tabMainStoreIndex():int {
			return this.guildMainPanel.selectStoreBtnIndex;
		}

		/**
		 *获取输入的数量
		 * @return
		 *
		 */
		public function get tabMainInputNum():int {
			return this.guildMainPanel.inputGoldNum;
		}

		/**
		 * 当前仓库的页数
		 * @return
		 *
		 */
		public function get currentStorePage():int {
			return this.guildStoragePanel.currentPage;
		}

		private function onTabBarChangeIndex(evt:Event):void {
			switch (this.guidTabBar.turnOnIndex) {
				case 0:
					Cmd_Guild.cm_guildStroage(5);
					Cmd_Guild.cm_guildMemberList();
					Cmd_Guild.cm_guildHome();
					break;
				case 1:
					Cmd_Guild.cm_guildMemberList();
					break;
				case 2:
					break;
				case 3:
					Cmd_Guild.cm_guildStroage(5);
					break;
				case 4:
					if (storeShopExecIndex == 0) {
						Cmd_Guild.cm_guildStroage(1);
						Cmd_Guild.cm_guildStroage(2);
						Cmd_Guild.cm_guildStroage(3);
						Cmd_Guild.cm_guildStroage(4);

						storeShopExecIndex=1;
						this.guidTabBar.setTabActive(4, false);
					}

					break;
				case 5:

					break;
			}
		}

		/**
		 * 打开行会面板
		 */
		public function serv_showGuild(body:String):void {
			guildContent=GuildUtils.getHomeContent(body);

			if (this.guidTabBar.turnOnIndex != 0) {
				this.guidTabBar.turnToTab(0);
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETGUILDVALUE);
			}

			if (memberArr.length == 0)
				return;

			this.guildMainPanel.updateData(guildContent);

			super.show();
		}

		/**
		 * 更新会员列表
		 *
		 */
		public function serv_updateMemberList(body:String):void {
			memberArr=GuildUtils.getMemberContent(body);

			this.guildMemberPanel.updateList();
			this.guildPurviewPanel.updateData();

			this.guildMainPanel.updateData(guildContent);

			this.menberNumLab.text="" + guildMemeberNum;

		}


		/**
		 *	更新商店数据
		 *
		 */
		public function serv_updateStore(td:TDefaultMessage, body:String, page:int=0):void {
			var totalCount:int=Math.max(2, (HexUtil.HiWord(td.nSessionID) + 2) / 96 * 2); //页数 
			//			td.Recog; //行会gold
			var type:int=HexUtil.LoWord(td.Param); //类型
			var count:int=HexUtil.HiWord(td.Param); ////页数

			storeFund=td.Tag; //行会资金
			storeContribute=td.Series; //行会贡献度

			var arr:Array=body.split("/");
			var cu:TClientItem;

			for (var i:int=0; i < totalCount; i++) {
				if (storeArr[type].length == i) {
					storeArr[type][i]=new Vector.<TClientItem>();
				}
			}

			storeArr[type][page].length=0;

			for (i=0; i < arr.length; i++) {
				if (String(arr[i]).length < 100) {
					continue;
				}

				if (type < 5) {
					cu=Cmd_backPack.analysisItem(arr[i], true);
				} else {
					cu=Cmd_backPack.analysisItem(arr[i]);
				}

				storeArr[type][page].push(cu);
			}

			this.guildStoragePanel.updateData();
			this.guildShopPanel.updateData();

			if (type == 4)
				this.guidTabBar.setTabActive(4, true);
		}

	}
}
