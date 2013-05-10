package com.leyou.ui.team {
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Team;
	import com.leyou.ui.team.child.TeamListRender;
	
	import flash.events.MouseEvent;
	import flash.utils.describeType;

	public class TeamAddWnd extends AutoWindow {
		private var gridList:ScrollPane;
		private var inviteJoinBtn:NormalButton;

		private var renderArr:Vector.<TeamListRender>;

		public var selectName:String;

		public function TeamAddWnd() {
			super(LibManager.getInstance().getXML("config/ui/TeamAddWnd.xml"));
			this.init();
		}

		private function init():void {
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.inviteJoinBtn=this.getUIbyID("inviteJoinBtn") as NormalButton;

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

			this.renderArr.length=0;

			var tmp:String="";
			for each (livemodel in liveVec) {

				//去掉自己
				if (MyInfoManager.getInstance().name == livemodel.infoB.name || UIManager.getInstance().teamWnd.getTeamIndex(livemodel.infoB.name))
					continue;

				render=new TeamListRender;
				render.updataLivInfo(livemodel.infoB);
				render.y=i * render.height;
				this.gridList.addToPane(render);

				this.renderArr.push(render);

				if (livemodel.infoB.level == 0)
					tmp+=livemodel.infoB.name + "|";
				i++;
			}

			if (tmp != null && tmp!="") {
				tmp=tmp.replace(/\|$/g, "");
				Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_WEB_GET + "," + tmp + ",Level");
			}
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show();
			updata();

			var tw:TeamWnd=UIManager.getInstance().teamWnd;
			tw.x=(UIEnum.WIDTH - tw.width - this.width) / 2;
			this.x=tw.x + tw.width + 3;
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

			if (selectName == null)
				return;

			this.inviteJoinTeam(selectName);
//			if (UIManager.getInstance().teamWnd.teamerInfo.length > 0) {
//				Cmd_Team.cm_addGroupMember(selectName);
//			} else {
//				Cmd_Team.cm_createGroup(null);
//				Cmd_Team.cm_createGroup(selectName, true);
//			}
		}
		
		public function inviteJoinTeam(name:String):void{
			if (UIManager.getInstance().teamWnd.teamerInfo.length > 0) {
				Cmd_Team.cm_addGroupMember(name);
			} else {
				Cmd_Team.cm_createGroup(null);
				Cmd_Team.cm_createGroup(name, true);
			}
		}
	}
}
