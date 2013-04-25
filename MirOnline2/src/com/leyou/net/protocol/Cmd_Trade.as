package com.leyou.net.protocol {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.utils.HexUtil;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Trade {
		/**
		 * 发起交易
		 */
		static public function cm_dealTry():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_DEALTRY, 0, 0, 0, 0);
		}

		/**
		 * 发起交易--成功
		 */
		static public function sm_dealMenu(td:TDefaultMessage, body:String):void {
			//body要交易的玩家角色名称
			trace("发起交易成功");
			UIManager.getInstance().tradeWnd.serv_showPanel(body);
		}

		/**
		 * 发起交易--失败【两个玩家面对面才能进行相关交易】
		 */
		static public function sm_dealtry_fail(td:TDefaultMessage, body:String):void {
			//无返回值			两个玩家面对面才能进行相关交易.
			trace("发起交易--失败");
			//UIManager.getInstance().tradeWnd.open();
		}

		/**
		 * 取消交易
		 */
		static public function cm_dealCancel():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_DEALCANCEL, 0, 0, 0, 0);
		}

		/**
		 * 取消交易-返回
		 */
		static public function sm_dealCancel(td:TDefaultMessage, body:String):void {
			//无返回值
			UIManager.getInstance().tradeWnd.serv_CancelTrade()
		}

		/**
		 * 自己拖放物品
		 */
		static public function cm_dealAddItem(info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_DEALADDITEM, info.MakeIndex, 0, 0, 0, info.s.name);
		}

		/**
		 * 自己拖放物品-ok
		 */
		static public function sm_dealAddItem_ok(td:TDefaultMessage, body:String):void {
			//无返回值
			UIManager.getInstance().tradeWnd.serv_UpdataSelfItem();
		}

		/**
		 * 自己拖放物品-fail
		 */
		static public function sm_dealAddItem_fail(td:TDefaultMessage, body:String):void {
			//无返回值
			trace("自己拖放物品-fail");
		}

		/*****************************************************************************************************************/ ///
		/**
		 * 自己拖回物品
		 * 【调试：】☆☆☆☆☆☆☆ 【警告！暂时还没有该类[767]交易的金币或物品不可以取回，要取回请取消再重新交易！】 ☆☆☆☆☆☆☆
		 */
		static public function cm_dealDelItem(info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_DEALDELITEM, info.MakeIndex, 0, 0, 0, info.s.name);
		}

		/**
		 * 自己拖回物品-ok
		 */
		static public function sm_dealDelItem_ok(td:TDefaultMessage, body:String):void {
			//无返回值
		}

		/**
		 * 自己拖回物品-fail
		 */
		static public function sm_dealDelItem_fail(td:TDefaultMessage, body:String):void {
			//无返回值
		}

		/***********************************************************************************************************************************************************/
		/**
		 * 对方【拖放】物品时，收到的协议
		 */
		static public function sm_dealRemoteAddItem(td:TDefaultMessage, body:String):void {
			var info:TClientItem=Cmd_backPack.analysisItem(body); //道具
			UIManager.getInstance().tradeWnd.serv_UpdatePlayerItem(info);
		}

		/**
		 * 对方【拖走】物品时，收到的协议
		 */
		static public function sm_dealRemoteDelItem(td:TDefaultMessage, body:String):void {
			var info:TClientItem=Cmd_backPack.analysisItem(body); //道具
		}

		/**
		 * 自己放钱
		 */
		static public function cm_dealChgGold(gold:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_DEALCHGGOLD, gold, 0, 0, 0);
		}

		//自己放钱-ok
		static public function sm_dealChgGold_ok(td:TDefaultMessage, body:String):void {
			var dealGold:int=td.Recog; //要交易的金币
			MyInfoManager.getInstance().baseInfo.gameGold=HexUtil.MakeLong(td.Param, td.Tag); //自己背包的
			UIManager.getInstance().tradeWnd.serv_setSelfGold(dealGold);
		}

		//自己放钱-fail
		static public function sm_dealChgGold_fail(td:TDefaultMessage, body:String):void {
			var dealGold:int=td.Recog; //要交易的金币
			MyInfoManager.getInstance().baseInfo.gameGold=HexUtil.MakeLong(td.Param, td.Tag); //自己背包的
			UIManager.getInstance().tradeWnd.serv_setSelfGold();
		}

		//对方放钱时，收到的协议
		static public function sm_dealRemoteChgGold(td:TDefaultMessage, body:String):void {
			var dealGold:int=td.Recog; //要交易的金币
			UIManager.getInstance().tradeWnd.serv_setPlayGold(dealGold);
		}

		/**
		 * 交易确认
		 */
		static public function cm_dealEnd():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_DEALEND, 0, 0, 0, 0);
		}

		//交易成功
		static public function sm_dealSuccess(td:TDefaultMessage, body:String):void {
			//无返回值
			UIManager.getInstance().tradeWnd.serv_TradeEnd();
		}

		static public function sm_menu_ok(td:TDefaultMessage, body:String):void {
			//无返回值
			AlertWindow.showWin(body);
		}

	}
}
