package com.leyou.ui.team {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Team;
	import com.leyou.ui.team.child.TeamListRender;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TeamAddWnd extends AutoWindow implements IMenu {
		private var gridList:ScrollPane;
		private var inviteJoinBtn:NormalButton;
		private var inputPlay:TextInput;

		private var renderArr:Vector.<TeamListRender>;

		public var selectName:String;

		public function TeamAddWnd() {
			super(LibManager.getInstance().getXML("config/ui/TeamAddWnd.xml"));
			this.init();
		}

		private function init():void {
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.inviteJoinBtn=this.getUIbyID("invitJoinBtn") as NormalButton;
			this.inputPlay=this.getUIbyID("inputPlay") as TextInput;

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);
			this.inviteJoinBtn.addEventListener(MouseEvent.CLICK, onInviteJoinBtnClick);

			this.renderArr=new Vector.<TeamListRender>;
		}

		public function updata():void {

			var liveVec:Vector.<LivingModel>=UIManager.getInstance().mirScene.getOtherPlayers();

			var livemodel:LivingModel;
			var render:TeamListRender;
			var i:int=0;

			for each (render in this.renderArr) {
				this.gridList.delFromPane(render);
			}

			this.gridList.updateUI(true);
			this.renderArr.length=0;

			var tmp:String="";
			for each (livemodel in liveVec) {

				//去掉自己
				if (MyInfoManager.getInstance().name == livemodel.infoB.name || UIManager.getInstance().teamWnd.getTeamIndex(livemodel.infoB.name))
					continue;

				render=new TeamListRender;
				render.updataLivInfo(livemodel.infoB);
				render.y=3+i * render.height;
				render.addEventListener(MouseEvent.CLICK, onClick);
				this.gridList.addToPane(render);
				
				this.renderArr.push(render);

				if (livemodel.infoB.level == 0)
					tmp+=livemodel.infoB.name + "|";
				i++;
			}

			if (tmp != null && tmp != "") {
				tmp=tmp.replace(/\|$/g, "");
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_WEB_GET + "," + tmp + ",Level");
			}
		}

		private function onClick(e:MouseEvent):void {
			var menuVec:Vector.<MenuInfo>=new Vector.<MenuInfo>();
			menuVec.push(new MenuInfo("招收", 1));
			menuVec.push(new MenuInfo("查看", 2));
			menuVec.push(new MenuInfo("私聊", 3));

			MenuManager.getInstance().show(menuVec, this, new Point(e.stageX, e.stageY));
		}

		public function onMenuClick(i:int):void {

			if (selectName == null)
				return;

			switch (i) {
				case 1:
					this.inviteJoinTeam(selectName);
					break;
				case 2:

					if (UIManager.getInstance().mirScene.getPlayerByName(selectName)) {
						var id:int=UIManager.getInstance().mirScene.getPlayerByName(selectName).id;
						Cmd_Role.cm_queryUserState(id, UIManager.getInstance().mirScene.getPlayer(id).nowTilePt());
					}
					break;
				case 3:
					UIManager.getInstance().chatWnd.onClickPlayerName(selectName);
					break;
			}

		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show();
			updata();

			var tw:TeamWnd=UIManager.getInstance().teamWnd;
			tw.x=(UIEnum.WIDTH - tw.width - this.width) / 2;
			this.x=tw.x + tw.width + 3;
		}

		override public function hide():void {
			super.hide();
			if (UIManager.getInstance().teamWnd.visible) {
				UIManager.getInstance().teamWnd.x=(UIEnum.WIDTH - UIManager.getInstance().teamWnd.width) / 2;
			}
		}

		private function onGridListClick(evt:MouseEvent):void {
			if (evt.target is TeamListRender) {
				selectName=TeamListRender(evt.target).username;
				TeamListRender(evt.target).hightLight=true;
			}
		}

		private function onGridListOver(evt:MouseEvent):void {
			if (evt.target is TeamListRender) {
				TeamListRender(evt.target).hightLight=true;
			}
		}

		private function onGridListOut(evt:MouseEvent):void {
			if (evt.target is TeamListRender) {

				TeamListRender(evt.target).hightLight=false;

				for each (var render:TeamListRender in renderArr) {
					if (render.username == selectName)
						render.hightLight=true;
					else
						render.hightLight=false;
				}
			}
		}

		/**
		 * 邀请组队
		 * @param evt
		 *
		 */
		private function onInviteJoinBtnClick(evt:MouseEvent):void {
			if (this.inputPlay.text != "") {
				this.inviteJoinTeam(this.inputPlay.text);
				this.inputPlay.text="";

				selectName="";
				for each (var render:TeamListRender in renderArr) {
					if (render.username == selectName)
						render.hightLight=true;
					else
						render.hightLight=false;
				}
				return;
			}
		}

		public function inviteJoinTeam(name:String):void {
			if (UIManager.getInstance().teamWnd.teamerInfo.length > 0) {
				Cmd_Team.cm_addGroupMember(name);
			} else {
				Cmd_Team.cm_createGroup(null);
				Cmd_Team.cm_createGroup(name, true);
			}
		}
		
		public function resize():void {
			this.y=(UIEnum.HEIGHT-this.height)/2;
		}
	}
}
