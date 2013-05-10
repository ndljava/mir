package com.leyou.ui.friend {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.enum.FriendEnum;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.friend.child.FriendListRender;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class FriendWnd extends AutoWindow {
		private var gridList:ScrollPane;
//		private var nameLbl:Label;
//		private var moodInput:TextInput;
//		private var memberLbl:Label;
		private var findBtn:NormalButton;
		private var findInput:TextInput;
//		private var userHeadImg:Image;
		private var onlineNumLbl:Label;
		private var showOutLineChBox:CheckBox;

		private var isFristShow:Boolean;
		private var friendInfo:Vector.<FriendInfo>;
		private var menuList:MeunList;
		private var currentClickRenderId:int;
		private var overRenderId:int=-1;
		private var renderArr:Vector.<FriendListRender>;

		public function FriendWnd() {
			super(LibManager.getInstance().getXML("config/ui/FriendWnd.xml"));
			this.init();
		}

		private function init():void {
			this.friendInfo=new Vector.<FriendInfo>;
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
//			this.nameLbl=this.getUIbyID("nameLbl") as Label;
//			this.moodInput=this.getUIbyID("moodInput") as TextInput;
//			this.memberLbl=this.getUIbyID("memberLbl") as Label;
			this.findBtn=this.getUIbyID("findBtn") as NormalButton;
			this.findInput=this.getUIbyID("findInput") as TextInput;
//			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.onlineNumLbl=this.getUIbyID("onlineNumLbl") as Label;
			this.showOutLineChBox=this.getUIbyID("showOutLineChBox") as CheckBox;
			this.showOutLineChBox.turnOn(false);

			this.findBtn.addEventListener(MouseEvent.CLICK, onFindBtnClick);

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);

			this.showOutLineChBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);

//			this.moodInput.addEventListener(FocusEvent.FOCUS_OUT, onMoodInputChage);
//			this.testInfo();
			this.menuList=new MeunList(FriendEnum.FIREND_MENULIST_CONTAIN, [FriendEnum.PRIVATE_CHAT, FriendEnum.CHECK, FriendEnum.GROUP, FriendEnum.SHIELD, FriendEnum.DELETE,]);
			this.menuList.listClickFun=onMenuListClick;
			this.addChild(this.menuList);
			this.menuList.visible=false;

			this.renderArr=new Vector.<FriendListRender>;
			var render:FriendListRender;
			for (var i:int=0; i < FriendEnum.FRIEND_MAX_NUM; i++) {
				render=new FriendListRender();
				render.id=i;
				render.y=i * FriendEnum.FRIENDLIST_RENDER_HEIGHT;
				this.gridList.addToPane(render);
				this.renderArr.push(render);
				this.renderArr[i].visible=false;
			}
		}

		public function updata(arr:Vector.<FriendInfo>):void {
			for (var i:int=0; i < FriendEnum.FRIEND_MAX_NUM; i++) {
				if (arr.length > i) {
					if ((arr[i].outLineTime.indexOf("在线") == -1 && this.showOutLineChBox.isOn) || arr[i].outLineTime.indexOf("在线") > -1) {
						this.renderArr[i].updata(arr[i]);
						this.renderArr[i].visible=true;
					} else
						this.renderArr[i].visible=false;
				} else {
					this.renderArr[i].visible=false;
				}
			}
		}

		//点击添加好友按钮
		private function onFindBtnClick(evt:MouseEvent):void {
			if (this.findInput.text != "") {
				if (this.friendInfo.length >= 10) {
					UIManager.getInstance().noticeMidDownUproll.setNoticeStr("您的好友数量已到达上限10人，不能在添加好友!", SystemNoticeEnum.IMG_WARN);
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
				this.menuList.x=mouseX;
				this.menuList.y=mouseY;
				this.menuList.visible=true;
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
		private function onMenuListClick(key:int, contian:String):void {
			this.menuList.visible=false;
			var name:String=this.friendInfo[this.currentClickRenderId].name;
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
				this.onlineNumLbl.text="0/"+FriendEnum.FRIEND_MAX_NUM;
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
					else
						outLine.push(info);
				}
				for (i=0; i < onLine.length; i++) {
					this.friendInfo.push(onLine[i]);
				}

				for (i=0; i < outLine.length; i++) {
					this.friendInfo.push(outLine[i]);
				}
				this.onlineNumLbl.text=this.friendInfo.length+ "/" + FriendEnum.FRIEND_MAX_NUM;
			}
			this.updata(this.friendInfo);
		}

		private function onCheckBoxClick(evt:MouseEvent):void {
			this.updata(this.friendInfo);
		}
	}
}