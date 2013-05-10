package com.leyou.net.protocol {
	import com.ace.gameData.player.MyInfoManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	//装备锻造合成
	public class Cmd_Forge {

		//打开合成面板
		static public function sm_openmItemWin(td:TDefaultMessage, body:String):void {
			td.Param, td.Tag //x、y坐标
			body; //内容

			if (td.Recog == 1) {
				UIManager.getInstance().forgeWnd.serv_show(body);
			}

			if (td.Recog == 2) {

			}
		}

		//背包>首饰合成
		static public function cm_fifItem(makeIndex:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_FIFITEM, makeIndex, 0, 0, 0);
		}

		//背包>首饰合成--ok
		static public function sm_fifItem_succ(td:TDefaultMessage, body:String):void {
			//无参数
			trace(body)
			
			UIManager.getInstance().forgeWnd.updateOneGrid();
		}

		//背包>首饰合成--fail
		static public function sm_fifItem_fail(td:TDefaultMessage, body:String):void {
			//无参数
			trace(body)
			MyInfoManager.getInstance().resetWaitItem();
		}

		//首饰合成>背包
		static public function cm_delfIfitem(makeIndex:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_DELFIFITEM, makeIndex, 0, 0, 0);
		}

		//确认合成
		static public function cm_fifItemOk():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_FIFITEMOK, 0, 0, 0, 0);
		}

	}
}
