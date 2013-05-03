package com.leyou.ui.team {
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.team.TeamInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.team.child.TeamHeader;

	public class TeamListPanel extends SpriteNoEvt {

		private var teamHeadVec:Vector.<TeamHeader>;

		private var headList:ScrollPane;

		public function TeamListPanel() {
			super();
			init();
		}

		private function init():void {
			teamHeadVec=new Vector.<TeamHeader>;
			headList=new ScrollPane(220, 300);
			this.addChild(headList);
			this.y=120;

			this.headList.visible=false;

			this.mouseChildren=true;
		}

		public function AddHead(info:TeamInfo):void {
			if (info == null)
				return;

			var head:TeamHeader=new TeamHeader();
			head.updateInfo(info);

			teamHeadVec.push(head);
		}

		public function delHead():void {

		}

		public function updateHead(info:Vector.<TeamInfo>):void {

			var head:TeamHeader;
			for each (head in teamHeadVec) {
				this.headList.delFromPane(head);
			}

			teamHeadVec.length=0;

			var tinfo:TeamInfo;
			for each (tinfo in info) {
				if (tinfo != null && MyInfoManager.getInstance().name != tinfo.name) {
					head=new TeamHeader();
					head.updateInfo(tinfo);
					head.scaleX=head.scaleY=.8;

					this.headList.addToPane(head);
					head.y=teamHeadVec.length * (head.height - 10);
					teamHeadVec.push(head);
				}
			}

			if (teamHeadVec.length > 0)
				this.headList.visible=true;

			updateHpandMp();
		}

		/**
		 * 更新血量 和法力
		 *
		 */
		public function updateHpandMp():void {
			var liv:LivingModel;
			var head:TeamHeader;
			for each (head in teamHeadVec) {
				if (head.username != "") {
					liv=UIManager.getInstance().mirScene.getPlayerByName(head.username);
					if (liv != null)
						head.updateHpandMp(liv);
				}
			}
		}

	}
}
