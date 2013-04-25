package com.leyou.ui.friend {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.friend.FriendInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.leyou.enum.FriendEnum;
	import com.leyou.ui.friend.child.FriendListRender;
	import com.leyou.utils.PlayerUtil;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class FriendWnd extends AutoWindow {
		private var gridList:ScrollPane;
		private var nameLbl:Label;
		private var moodInput:TextInput;
		private var memberLbl:Label;
		private var findBtn:NormalButton;
		private var findInput:TextInput;
		private var userHeadImg:Image;
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
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.moodInput=this.getUIbyID("moodInput") as TextInput;
			this.memberLbl=this.getUIbyID("memberLbl") as Label;
			this.findBtn=this.getUIbyID("findBtn") as NormalButton;
			this.findInput=this.getUIbyID("findInput") as TextInput;
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;

			this.findBtn.addEventListener(MouseEvent.CLICK, onFindBtnClick);

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);

			this.moodInput.addEventListener(FocusEvent.FOCUS_OUT, onMoodInputChage);
			this.testInfo();
			this.menuList=new MeunList(FriendEnum.FIREND_MENULIST_CONTAIN, [FriendEnum.PRIVATE_CHAT, FriendEnum.GROUP, FriendEnum.DELETE]);
			this.menuList.listClickFun=onMenuListClick;
		}

		public function updata(arr:Vector.<FriendInfo>):void {
			if (arr == null)
				return;
			var render:FriendListRender;
			this.renderArr=new Vector.<FriendListRender>;
			for (var i:int=0; i < arr.length; i++) {
				render=new FriendListRender();
				render.updata(arr[i]);
				render.y=i * FriendEnum.FRIENDLIST_RENDER_HEIGHT;
				this.gridList.addToPane(render);
				this.renderArr.push(render);
			}
		}

		//测试数据
		private function testInfo():void {
			this.friendInfo=new Vector.<FriendInfo>;
			for (var i:int=0; i < 21; i++) {
				var infor:FriendInfo=new FriendInfo();
				infor.name=i.toString();
				infor.lv=i;
				infor.mumber=i;
				infor.id=i;
				this.friendInfo.push(infor);
			}
		}

		//点击添加好友按钮
		private function onFindBtnClick(evt:MouseEvent):void {
			if (this.findInput.text == "")
				return;
		}

		//自定义心情内容改变
		private function onMoodInputChage(evt:Event):void {
			trace(this.moodInput.text);
		}

		public override function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			if (!this.isFristShow) {
				if (MyInfoManager.getInstance().name == null)
					this.nameLbl.text="";
				else
					this.nameLbl.text=MyInfoManager.getInstance().name
//				this.moodInput
//				this.memberLbl
				this.userHeadImg.updateBmp(PlayerUtil.getPlayerHeadImg(MyInfoManager.getInstance().race, MyInfoManager.getInstance().sex));
				this.updata(friendInfo);
				this.isFristShow=true;
			}
			super.show(toTop, toCenter);
		}

		//点击list
		private function onGridListClick(evt:MouseEvent):void {
			if (evt.target is FriendListRender) {
				var id:int=(evt.target as FriendListRender).id;
				this.currentClickRenderId=id;
				this.menuList.x=mouseX;
				this.menuList.y=mouseY;
				this.addChild(this.menuList);
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
			this.removeChild(menuList);
			switch (key) {
				case FriendEnum.PRIVATE_CHAT:
					//私聊
					break;
				case FriendEnum.DELETE:
					//删除
					break;
				case FriendEnum.GROUP:
					//组队
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
	}
}