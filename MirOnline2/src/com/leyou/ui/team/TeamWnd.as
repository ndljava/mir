package com.leyou.ui.team {
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.team.TeamInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.enum.TeamEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Team;
	import com.leyou.ui.team.child.TeamListRender;
	import com.leyou.utils.PlayerUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TeamWnd extends AutoWindow {
		private var gridList:ScrollPane;
		private var creatTeamBtn:NormalButton;
		private var deleteMemBtn:NormalButton;
		private var addMemBtn:NormalButton;
		private var openTeamChBox:CheckBox;
		private var promoteTeamerBtn:NormalButton;
		private var quitBtn:NormalButton;
		public var teamerInfo:Vector.<TeamInfo>;
		private var overRenderId:int=-1;
		private var renderArr:Vector.<TeamListRender>;

		private var selectIndex:int=-1;

		public function TeamWnd() {
			super(LibManager.getInstance().getXML("config/ui/TeamWnd.xml"));
			this.init();
		}

		private function init():void {
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			//this.creatTeamBtn=this.getUIbyID("creatTeamBtn") as NormalButton;
			this.deleteMemBtn=this.getUIbyID("deleteMemBtn") as NormalButton;
			this.addMemBtn=this.getUIbyID("addMemBtn") as NormalButton;
			this.openTeamChBox=this.getUIbyID("openTeamChBox") as CheckBox;
			//this.promoteTeamerBtn=this.getUIbyID("promoteTeamerBtn") as NormalButton;
			this.quitBtn=this.getUIbyID("quitBtn") as NormalButton;

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGirdListOut);

			//this.creatTeamBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.deleteMemBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addMemBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.openTeamChBox.addEventListener(MouseEvent.CLICK, onClick);
			//this.promoteTeamerBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.quitBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.teamerInfo=new Vector.<TeamInfo>;
			//this.testInfo();

			//this.creatTeamBtn.setActive(false);
			//this.promoteTeamerBtn.setActive(false);

			this.renderArr=new Vector.<TeamListRender>;
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			this.updata(teamerInfo);
		}

		/**
		 * 返回玩家info
		 * @param id
		 * @return
		 *
		 */
		private function getTeamInfoByID(id:int):TeamInfo {
			var info:TeamInfo;
			for each (info in teamerInfo) {
				if (info.id == id)
					return info;
			}

			return null;
		}

		/**
		 * 判断玩家是否存在
		 * @param id
		 * @return
		 *
		 */
		public function getPlayInTeam(name:String):Boolean {
			return this.getTeamIndex(name);
		}

		public function updata(arr:Vector.<TeamInfo>):void {
			if (arr == null) {
				MyInfoManager.getInstance().hasTeam=false;
				return;
			}

			MyInfoManager.getInstance().hasTeam=true;
			var render:TeamListRender;

			for each (render in renderArr) {
				this.gridList.delFromPane(render);
			}

			this.renderArr.length=0;

			for (var i:int=0; i < arr.length; i++) {

				if (MyInfoManager.getInstance().name == arr[i].name)
					continue;

				render=new TeamListRender;
				render.updataInfo(arr[i]);
				render.y=this.renderArr.length * TeamEnum.TEAMLIST_RENDER_HEIGHT;
				this.gridList.addToPane(render);
				this.renderArr.push(render);
			}

			//更新头像
			UIManager.getInstance().teamListPanel.updateHead(arr);
		}

		private function onClick(evt:Event):void {
			switch (evt.target.name) {
				case "creatTeamBtn":
					Cmd_Team.cm_createGroup(null);
					break;
				case "deleteMemBtn":
					var tinfo:TeamInfo=getTeamInfoByID(selectIndex);
					if (tinfo == null)
						break;
					Cmd_Team.cm_delGroupMember(tinfo.name);
					break;
				case "addMemBtn":
					UIManager.getInstance().teamAddWnd.show();
					break;
				case "openTeamChBox":
					setTeamState(this.openTeamChBox.isOn);
					break;
				case "promoteTeamerBtn":
					break;
				case "quitBtn":
					Cmd_Team.cm_groupMode(0);
					break;
			}
		}

		/**
		 * 设置是否允许组队
		 * @param b
		 *
		 */
		public function setTeamState(b:Boolean):void {
			if (b)
				this.openTeamChBox.turnOn(true);
			else
				this.openTeamChBox.turnOff(true);

			Cmd_Team.cm_groupMode((b ? 1 : 0));
		}

		private function onGridListClick(evt:MouseEvent):void {
			if (evt.target is TeamListRender) {
				selectIndex=int((evt.target as TeamListRender).id);
			}
		}

		private function onGridListOver(evt:MouseEvent):void {
			if (evt.target is TeamListRender) {
				var id:int=int((evt.target as TeamListRender).id);
				var render:TeamListRender;
				if (id != this.overRenderId) {
					if (this.overRenderId != -1) {
						render=this.getRenderById(this.overRenderId);
						if (render)
							render.hightLight=false;
					}
					this.overRenderId=id;
					render=this.getRenderById(this.overRenderId);
					if (render)
						render.hightLight=true;
				}
					//trace(id);
			}
		}

		private function onGirdListOut(evt:MouseEvent):void {
			if (this.overRenderId != -1) {
				for each (var render:TeamListRender in renderArr) {
					if (render.id == selectIndex)
						render.hightLight=true;
					else
						render.hightLight=false;
				}
			}
		}

		private function getRenderById(id:int):TeamListRender {
			if (renderArr == null)
				return null;

			for (var i:int=0; i < this.renderArr.length; i++) {
				if (this.renderArr[i].id == id)
					return renderArr[i];
			}
			return null;
		}

		public function getTeamIndex(name:String):Boolean {
			if (teamerInfo.length == 0)
				return false;

			var info:TeamInfo;
			for each (info in teamerInfo) {
				if (info.name == name) {
					return true;
				}
			}

			return false;
		}

		/**
		 *	人物属性回调----聊天用
		 * @param str
		 *
		 */
		public function setTeamInfo(str:String):void {
			var arr:Array=str.split("=")[1].split("|");

			var tmp:Array=arr[0].split(",");
			var i:int=0;
			//是队友还是玩家     >2是队友
			if (tmp.length > 2) {
				var info:TeamInfo;
				for each (info in teamerInfo) {
					for (i=0; i < arr.length; i++) {
						tmp=arr[i].split(",");

						if (info.name == tmp[0]) {
							info.member=PlayerUtil.getPlayerMemberByid(tmp[1]);
							info.level=tmp[2];
						}
					}
				}
				updata(teamerInfo);
			} else {

				var liveVec:Vector.<LivingModel>=UIManager.getInstance().mirScene.getOtherPlayers();

				var lm:LivingModel;
				for each (lm in liveVec) {
					for (i=0; i < arr.length; i++) {
						tmp=arr[i].split(",");

						if (tmp[0] == lm.infoB.name) {
							//info.member=PlayerUtil.getPlayerMemberByid(tmp[1]);
							lm.infoB.level=tmp[1];
						}
					}
				}
			}

			UIManager.getInstance().teamAddWnd.updata();
		}

		/**
		 * 更新组队信息
		 *
		 */
		public function updateTeamInfo():void {
			this.updata(teamerInfo);
		}

		/**
		 * 添加好友
		 * @param body
		 *
		 */
		public function serv_AddTeam(body:String):void {
			if (body == null)
				return;

			teamerInfo.length=0;

			var i:int=0;
			var tinfo:TeamInfo;
			var strArr:Array=body.split("/");
			strArr.pop();

			var tmp:String="";
			while (i < strArr.length / 3) {

				tinfo=new TeamInfo;
				tinfo.name=strArr[i * 3];
				tinfo.id=i;
				tinfo.sex=strArr[i * 3 + 2];
				tinfo.race=strArr[i * 3 + 1];
				teamerInfo.push(tinfo);

				tmp+=tinfo.name;

				if (i < strArr.length / 3 - 1)
					tmp+="|";

				i++;
			}

			Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_WEB_GET + "," + tmp + ",MemberType|Level");
		}

		public function serv_RemoveAllTeam():void {
			teamerInfo.length=0;
			updata(teamerInfo);
			UIManager.getInstance().teamAddWnd.updata();
		}

		public function serv_RemoveTeam(name:String):void {
			var info:TeamInfo;
			for each (info in teamerInfo) {
				if (info.name == name) {
					var i:int=teamerInfo.indexOf(info);
					teamerInfo.splice(i, 1);
					break;
				}
			}

			if (teamerInfo.length == 1)
				teamerInfo.length=0;

			updata(teamerInfo);
			UIManager.getInstance().teamAddWnd.updata();
		}

	}
}
