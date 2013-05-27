package com.leyou.ui.friend {
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.enum.FriendEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.friend.child.FriendListRender;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FriendWnd extends AutoWindow implements IMenu {
		private var gridList:ScrollPane;
		private var findBtn:NormalButton;
		private var findInput:TextInput;
//		private var onlineNumLbl:Label;
		private var showOutLineChBox:CheckBox;
		private var friendTabBar:TabBar;

		private var isFristShow:Boolean;
		private var friendInfo:Vector.<FriendInfo>;
		private var currentClickRenderId:int;
		private var overRenderId:int=-1;
		private var renderArr:Vector.<FriendListRender>;
		private var enemyInfo:Vector.<FriendInfo>;

		public function FriendWnd() {
			super(LibManager.getInstance().getXML("config/ui/FriendWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.friendInfo=new Vector.<FriendInfo>;
			this.enemyInfo=new Vector.<FriendInfo>;
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.findBtn=this.getUIbyID("findBtn") as NormalButton;
			this.findInput=this.getUIbyID("findInput") as TextInput;
//			this.onlineNumLbl=this.getUIbyID("onlineNumLbl") as Label;
			this.friendTabBar=this.getUIbyID("friendTabBar") as TabBar;
			this.showOutLineChBox=this.getUIbyID("showOutLineChBox") as CheckBox;
			this.showOutLineChBox.turnOn(false);

			this.friendTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
			this.findBtn.addEventListener(MouseEvent.CLICK, onFindBtnClick);

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);


			this.showOutLineChBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);

			this.renderArr=new Vector.<FriendListRender>;
			var render:FriendListRender;
			for (var i:int=0; i < FriendEnum.FRIEND_MAX_NUM; i++) {
				render=new FriendListRender();
				render.id=i;
				render.y=i * (FriendEnum.FRIENDLIST_RENDER_HEIGHT + 1);
				this.gridList.addToPane(render);
				this.renderArr.push(render);
				this.renderArr[i].visible=false;
			}
			this.addEventListener(MouseEvent.CLICK, onWndClickFun);
		}

		public function updata(arr:Vector.<FriendInfo>):void {
			for (var i:int=0; i < FriendEnum.FRIEND_MAX_NUM; i++) {
				if (arr.length > i) {
					if ((arr[i].outLineTime.indexOf("在线") == -1 && this.showOutLineChBox.isOn) || arr[i].outLineTime.indexOf("在线") > -1) {
						this.renderArr[i].updata(arr[i]);
						this.renderArr[i].visible=true;
					} else {
						this.renderArr[i].visible=false;
					}
				} else {
					this.renderArr[i].visible=false;
				}
			}
		}

		//点击添加好友按钮
		private function onFindBtnClick(evt:MouseEvent):void {
			if (this.findInput.text != "") {
				if (this.friendInfo.length >= 10) {
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您的好友数量已到达上限10人，不能添加好友!", SystemNoticeEnum.IMG_WARN);
					return;
				}
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, FriendEnum.ADD_FRIEND + "," + this.findInput.text);
				this.findInput.text="";
			}
		}

		public override function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			if (!this.isFristShow) {
				this.requestFriendList();
				this.isFristShow=true;
			}
			super.show(toTop, toCenter);
		}

		public function requestFriendList():void {
			Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, FriendEnum.REQUEST_FRIENDLIST);
		}

		//点击list
		private function onGridListClick(evt:MouseEvent):void {
			if (evt.target is FriendListRender) {
				var id:int=(evt.target as FriendListRender).id;
				this.currentClickRenderId=id;
				var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>;
				menuArr.push(new MenuInfo(FriendEnum.FIREND_MENULIST_CONTAIN[0], FriendEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(FriendEnum.FIREND_MENULIST_CONTAIN[1], FriendEnum.CHECK));
				menuArr.push(new MenuInfo(FriendEnum.FIREND_MENULIST_CONTAIN[2], FriendEnum.GROUP));
				menuArr.push(new MenuInfo(FriendEnum.FIREND_MENULIST_CONTAIN[3], FriendEnum.SHIELD));
				menuArr.push(new MenuInfo(FriendEnum.FIREND_MENULIST_CONTAIN[4], FriendEnum.DELETE));
				MenuManager.getInstance().show(menuArr, this, this.localToGlobal(new Point(this.mouseX + 2, this.mouseY + 2)));
				evt.stopPropagation();
			}
		}

		//鼠标移入list
		private function onGridListOver(evt:MouseEvent):void {
			if (evt.target is FriendListRender) {
				var id:int=int((evt.target as FriendListRender).id);
				var render:FriendListRender;
				if (id != this.overRenderId) {
					if (this.overRenderId != -1) {
						render=this.getRenderById(overRenderId);
						render.hightLight=false;
					}
					this.overRenderId=id;
					render=this.getRenderById(overRenderId);
					if (render)
						render.hightLight=true;
				}
			}
		}

		//鼠标移出list
		private function onGridListOut(evt:MouseEvent):void {
			if (this.overRenderId != -1) {
				var render:FriendListRender=this.getRenderById(this.overRenderId);
				if (render)
					render.hightLight=false;
				this.overRenderId=-1;
			}
		}

		//点击菜单列表
		public function onMenuClick(key:int):void {
			var info:Vector.<FriendInfo>;
			if (this.friendTabBar.turnOnIndex == 0 || this.friendTabBar.turnOnIndex == -1)
				info=this.friendInfo;
			else if (this.friendTabBar.turnOnIndex == 1)
				info=this.enemyInfo;
			if (info == null)
				return;
			var name:String=info[this.currentClickRenderId].name;
			if (name == null)
				return;
			switch (key) {
				case FriendEnum.PRIVATE_CHAT:
					UIManager.getInstance().chatWnd.onClickPlayerName(name);
					//私聊
					break;
				case FriendEnum.DELETE:
					Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, FriendEnum.DELETE_FRIEND + "," + name + ",0");
					//删除
					break;
				case FriendEnum.GROUP:
					UIManager.getInstance().teamAddWnd.inviteJoinTeam(name);
					//组队
					break;
				case FriendEnum.CHECK: //查看
					if (UIManager.getInstance().mirScene.getPlayerByName(name)) {
						var id:int=UIManager.getInstance().mirScene.getPlayerByName(name).id;
						Cmd_Role.cm_queryUserState(id, UIManager.getInstance().mirScene.getPlayer(id).nowTilePt());
					}
					break;
				case FriendEnum.SHIELD: //屏蔽

					break;
			}
		}

		private function getRenderById(id:int):FriendListRender {
			if (renderArr == null)
				return null;
			for (var i:int=0; i < this.renderArr.length; i++) {
				if (this.renderArr[i].id == id) {
					return this.renderArr[i];
				}
			}
			return null;
		}

		//好友列表
		public function friendList(str:String):void {
			var i:int;
			this.friendInfo.length=0;
			str=str.replace(FriendEnum.RECEIVE_FRIENDLIST, "");
			if (int(str.substring(0, 1)) <= 0) {
//				this.onlineNumLbl.text="0/" + FriendEnum.FRIEND_MAX_NUM;
				this.updata(this.friendInfo);
				return;
			} else {
				str=str.substring(str.indexOf("|") + 1, str.length);
				var arr:Array=str.split(";");
				var onLine:Vector.<FriendInfo>=new Vector.<FriendInfo>;
				var outLine:Vector.<FriendInfo>=new Vector.<FriendInfo>;
				for (i=0; i < arr.length - 1; i++) {
					var frind:Array=(arr[i] as String).split(",");
					var info:FriendInfo=new FriendInfo();
					info.name=frind[0];
					info.race=frind[1];
					info.sex=frind[2];
					info.lv=frind[3];
					info.mumber=frind[4];
					info.outLineTime=frind[5];
					if (info.outLineTime.indexOf("在线") > -1)
						onLine.push(info);
					else {
						info.outLineTime=this.getOutLineTime(info.outLineTime);
						outLine.push(info);
					}
				}
				for (i=0; i < onLine.length; i++) {
					this.friendInfo.push(onLine[i]);
				}

				for (i=0; i < outLine.length; i++) {
					this.friendInfo.push(outLine[i]);
				}
//				this.onlineNumLbl.text=this.friendInfo.length + "/" + FriendEnum.FRIEND_MAX_NUM;
			}
			this.updata(this.friendInfo);
		}

		private function onCheckBoxClick(evt:MouseEvent):void {
			if (this.friendTabBar.turnOnIndex == 0 || this.friendTabBar.turnOnIndex == -1)
				this.updata(this.friendInfo);
		}

		private function onChangeIndex(evt:Event):void {
			switch (this.friendTabBar.turnOnIndex) {
				case 0:
					this.updata(this.friendInfo);
					this.showOutLineChBox.visible=true;
					break;
				case 1:
					this.updata(this.enemyInfo);
					this.showOutLineChBox.visible=false;
					break;
			}
		}

		private function getOutLineTime(t:String):String {
			var str:String=new String();
			var time:Array=t.split(" ");
			var year:Array=(time[0] as String).split("-");
			var day:Array=(time[1] as String).split(":");
//			var now:int=getTimer();
			var date:Date=new Date();
			if (date.fullYear > year[0])
				str=(date.fullYear - year[0]) + "年前";
			else if (date.month + 1 > year[1])
				str=(date.month - year[1]) + "月前";
			else if (date.date > year[2])
				str=(date.date - year[2]) + "天前";
			else if (date.hours > day[0])
				str=(date.hours - day[0]) + "小时前";
			else if (date.minutes > day[1])
				str=(date.minutes - day[1]) + "分钟前";
			else if (date.seconds > day[2])
				str=(date.seconds - day[2]) + "秒前";

			return str;
		}

		private function onWndClickFun(evt:MouseEvent):void {
//			this.menuList.visible=false;
		}
	}
}