package com.leyou.manager {
	import com.ace.ICommon.IResize;
	import com.ace.enum.UIEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.manager.LayerManager;
	import com.ace.manager.ResizeManager;
	import com.leyou.config.Core;
	import com.leyou.game.scene.MirScene;
	import com.leyou.ui.backpack.BackpackWnd;
	import com.leyou.ui.backpack.BatchUsedMessageWnd;
	import com.leyou.ui.backpack.SplitMessageWnd;
	import com.leyou.ui.backpack.child.BagDropPanel;
	import com.leyou.ui.backpack.child.BagSplitPanel;
	import com.leyou.ui.backpack.child.DiscardMessageWnd;
	import com.leyou.ui.chat.ChatWnd;
	import com.leyou.ui.creatUser.CreatUserWnd;
	import com.leyou.ui.friend.FriendWnd;
	import com.leyou.ui.guild.GuildWnd;
	import com.leyou.ui.guild.ManageMessageWnd;
	import com.leyou.ui.guild.SellMessageWnd;
	import com.leyou.ui.guild.child.GuildAddContributPanel;
	import com.leyou.ui.loadingWnd.LoadingWnd;
	import com.leyou.ui.login.LoginWnd;
	import com.leyou.ui.map.MapWnd;
	import com.leyou.ui.market.FittingRoomWnd;
	import com.leyou.ui.market.MarketWnd;
	import com.leyou.ui.role.PropertyPointWnd;
	import com.leyou.ui.role.PropertyWnd;
	import com.leyou.ui.role.RoleWnd;
	import com.leyou.ui.roleHead.RoleHeadWnd;
	import com.leyou.ui.selectUser.SelectUserWnd;
	import com.leyou.ui.setting.SettingWnd;
	import com.leyou.ui.shop.ShopWnd;
	import com.leyou.ui.skill.SkillWnd;
	import com.leyou.ui.smallMap.SmallMapWnd;
	import com.leyou.ui.stall.StallWnd;
	import com.leyou.ui.storage.StorageWnd;
	import com.leyou.ui.systemNotice.NoticeCountDown;
	import com.leyou.ui.systemNotice.NoticeLeftroll;
	import com.leyou.ui.systemNotice.NoticeMidDown;
	import com.leyou.ui.systemNotice.NoticeMidDownUproll;
	import com.leyou.ui.systemNotice.NoticeMouseFollow;
	import com.leyou.ui.systemNotice.NoticeUproll;
	import com.leyou.ui.task.TaskWnd;
	import com.leyou.ui.team.TeamAddWnd;
	import com.leyou.ui.team.TeamListPanel;
	import com.leyou.ui.team.TeamWnd;
	import com.leyou.ui.tools.ToolsWnd;
	import com.leyou.ui.trade.TradeWnd;

	public class UIManager implements IResize {
		private static var instance:UIManager;

		public var loginWnd:LoginWnd;
		public var selectUserWnd:SelectUserWnd;
		public var chatWnd:ChatWnd;
		public var toolsWnd:ToolsWnd;
		public var mirScene:MirScene;
		public var backPackWnd:BackpackWnd;
		public var backPackSplitWnd:BagSplitPanel;
		public var backPackDropWnd:BagDropPanel;
		public var storageWnd:StorageWnd;
		public var skillWnd:SkillWnd;
		public var friendWnd:FriendWnd;
		public var roleWnd:RoleWnd;
		public var propertyWnd:PropertyWnd;
		public var settingWnd:SettingWnd;
		public var teamWnd:TeamWnd;
		public var teamAddWnd:TeamAddWnd;
		public var teamListPanel:TeamListPanel;
		public var shopWnd:ShopWnd;
		public var marketWnd:MarketWnd;
		public var fittingRoomWnd:FittingRoomWnd;
		public var tradeWnd:TradeWnd;
		public var guildWnd:GuildWnd;
		public var guildAddCtbWnd:GuildAddContributPanel
		public var taskWnd:TaskWnd;
		public var manageMessageWnd:ManageMessageWnd;
		public var splitMessageWnd:SplitMessageWnd;
		public var batchUsedMessageWnd:BatchUsedMessageWnd;
		public var discardMessagewnd:DiscardMessageWnd;
		public var sellMessageWnd:SellMessageWnd;
		public var stallWnd:StallWnd;
		public var roleHeadWnd:RoleHeadWnd;
		public var smallMapWnd:SmallMapWnd;
		public var mapWnd:MapWnd;
		public var noticeUproll:NoticeUproll;
		public var noticeLeftroll:NoticeLeftroll;
		public var noticeMidDown:NoticeMidDown;
		public var noticeMouseFollow:NoticeMouseFollow;
		public var loadingWnd:LoadingWnd;
		public var noticeMidDownUproll:NoticeMidDownUproll;
		public var noticeCountDown:NoticeCountDown;
		public var creatUserWnd:CreatUserWnd;
		public var propertyPointWnd:PropertyPointWnd;


		public static function getInstance():UIManager {
			if (!instance)
				instance=new UIManager();

			return instance;
		}


		public function UIManager() {
			this.init();
		}


		private function init():void {
//			this.addCreatUserWnd();
//			return;
			this.loginWnd=new LoginWnd();
			this.loginWnd.x=(UIEnum.WIDTH - 1024) / 2;
			this.loginWnd.y=(UIEnum.HEIGHT - 768) / 2;
			LayerManager.getInstance().gameLayer.addChildAt(this.loginWnd, 0);
		}

		//选择角色
		public function addSelectUserWnd():void {
			if(this.selectUserWnd==null){
				this.selectUserWnd=new SelectUserWnd();
				this.selectUserWnd.x=(UIEnum.WIDTH - 1024) / 2;
				this.selectUserWnd.y=(UIEnum.HEIGHT - 768) / 2;
				LayerManager.getInstance().gameLayer.addChildAt(this.selectUserWnd, 0);
			}
			else this.selectUserWnd.visible=true;
		}

		//创建角色
		public function addCreatUserWnd():void {
			if(this.creatUserWnd==null)
				this.creatUserWnd=new CreatUserWnd();
			LayerManager.getInstance().gameLayer.addChildAt(this.creatUserWnd, 0);
		}

		//显示加载面板
		public function addLoadingWnd():void {
			if (this.loadingWnd == null) {
				this.loadingWnd=new LoadingWnd();
				LayerManager.getInstance().gameLayer.addChildAt(this.loadingWnd, 0);
			} else {
				this.loadingWnd.visible=true;
				this.loadingWnd.setProgress(0, 100);
			}
		}

		//隐藏加载面板
		public function hideLoadingWnd():void {
			if (this.loadingWnd != null)
				this.loadingWnd.visible=false;
		}

		//进入场景
		public function addSceneWnd():void {
			this.mirScene=new MirScene();
			SceneCore.sceneModel=this.mirScene;
			LayerManager.getInstance().gameLayer.addChildAt(this.mirScene, 0);


			this.mapWnd=new MapWnd();
			LayerManager.getInstance().windowLayer.addChild(this.mapWnd);

			this.smallMapWnd=new SmallMapWnd();
			this.smallMapWnd.resize();
			LayerManager.getInstance().mainLayer.addChild(this.smallMapWnd);

			ResizeManager.getInstance().addToOnResize(this);
			if (Core.bugTest)
				return;

			this.chatWnd=new ChatWnd();
			this.toolsWnd=new ToolsWnd();
			this.backPackWnd=new BackpackWnd();
			this.backPackDropWnd=new BagDropPanel();
			this.backPackSplitWnd=new BagSplitPanel();
			this.storageWnd=new StorageWnd();
			this.skillWnd=new SkillWnd();
			this.friendWnd=new FriendWnd();
			this.roleWnd=new RoleWnd();
			this.propertyWnd=new PropertyWnd();
			this.settingWnd=new SettingWnd();
			this.teamWnd=new TeamWnd();
			this.teamAddWnd=new TeamAddWnd();
			this.teamListPanel=new TeamListPanel();
			this.shopWnd=new ShopWnd();
			this.marketWnd=new MarketWnd();
			this.fittingRoomWnd=new FittingRoomWnd();
			this.tradeWnd=new TradeWnd();
			this.guildWnd=new GuildWnd();
			this.guildAddCtbWnd=new GuildAddContributPanel();
			this.taskWnd=new TaskWnd();
			this.manageMessageWnd=new ManageMessageWnd();
			this.splitMessageWnd=new SplitMessageWnd();
			this.batchUsedMessageWnd=new BatchUsedMessageWnd();
			this.discardMessagewnd=new DiscardMessageWnd();
			this.sellMessageWnd=new SellMessageWnd();
			this.stallWnd=new StallWnd();
			this.roleHeadWnd=new RoleHeadWnd();
			this.noticeUproll=new NoticeUproll();
			this.noticeLeftroll=new NoticeLeftroll();
			this.noticeMidDown=new NoticeMidDown();
			this.noticeMouseFollow=new NoticeMouseFollow();
			this.loadingWnd=new LoadingWnd();
			this.noticeMidDownUproll=new NoticeMidDownUproll();
			this.noticeCountDown=new NoticeCountDown();
			this.propertyPointWnd=new PropertyPointWnd();

			this.toolsWnd.resize();
			this.chatWnd.resize();
			this.noticeUproll.resize();
			this.noticeLeftroll.resize();
			this.noticeMidDown.resize();
			this.noticeCountDown.resize();


			LayerManager.getInstance().windowLayer.addChild(this.backPackWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backPackSplitWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backPackDropWnd);
			LayerManager.getInstance().windowLayer.addChild(this.storageWnd);
			LayerManager.getInstance().windowLayer.addChild(this.skillWnd);
			LayerManager.getInstance().windowLayer.addChild(this.friendWnd);

			LayerManager.getInstance().windowLayer.addChild(this.propertyWnd);
			LayerManager.getInstance().windowLayer.addChild(this.settingWnd);
			LayerManager.getInstance().windowLayer.addChild(this.teamWnd);
			LayerManager.getInstance().windowLayer.addChild(this.teamAddWnd);
			LayerManager.getInstance().windowLayer.addChild(this.shopWnd);
			LayerManager.getInstance().windowLayer.addChild(this.marketWnd);
			LayerManager.getInstance().windowLayer.addChild(this.fittingRoomWnd);
			LayerManager.getInstance().windowLayer.addChild(this.tradeWnd);
			LayerManager.getInstance().windowLayer.addChild(this.guildWnd);
			LayerManager.getInstance().windowLayer.addChild(this.guildAddCtbWnd);
			LayerManager.getInstance().windowLayer.addChild(this.taskWnd);
			LayerManager.getInstance().windowLayer.addChild(this.manageMessageWnd);
			LayerManager.getInstance().windowLayer.addChild(this.splitMessageWnd);
			LayerManager.getInstance().windowLayer.addChild(this.batchUsedMessageWnd);
			LayerManager.getInstance().windowLayer.addChild(this.discardMessagewnd);
			LayerManager.getInstance().windowLayer.addChild(this.sellMessageWnd);
			LayerManager.getInstance().windowLayer.addChild(this.stallWnd);
			LayerManager.getInstance().windowLayer.addChild(this.roleWnd);
			LayerManager.getInstance().windowLayer.addChild(this.propertyPointWnd);


			LayerManager.getInstance().mainLayer.addChild(this.chatWnd);
			LayerManager.getInstance().mainLayer.addChild(this.toolsWnd);
			LayerManager.getInstance().mainLayer.addChild(this.roleHeadWnd);
			LayerManager.getInstance().mainLayer.addChild(this.teamListPanel);

			LayerManager.getInstance().mainLayer.addChild(this.noticeUproll);
			LayerManager.getInstance().mainLayer.addChild(this.noticeLeftroll);
			LayerManager.getInstance().mainLayer.addChild(this.noticeMidDown);
			LayerManager.getInstance().mainLayer.addChild(this.noticeMouseFollow);
			LayerManager.getInstance().mainLayer.addChild(this.noticeMidDownUproll);
			LayerManager.getInstance().mainLayer.addChild(this.noticeCountDown);




		}

		public function ser_initUI():void {
			if (!this.toolsWnd.initOk && this.skillWnd.initOK && this.backPackWnd.initOK)
				this.toolsWnd.readData();
		}

		public function onResize():void {
			this.smallMapWnd.resize();
			if (Core.bugTest)
				return;
			this.toolsWnd.resize();
			this.chatWnd.resize();
			this.noticeUproll.resize();
			this.noticeLeftroll.resize();
			this.noticeMidDown.resize();
			this.noticeCountDown.resize();
		}

	}
}