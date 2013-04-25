package com.leyou.net.protocol {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.tools.print;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Stall {
		//单击摆摊
		static public function cm_btItem():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_BTITEM, 0, 0, 0, 1);
		}

		//拖放物品到摆摊界面
		static public function cm_btItem_add(makeIndex:int, price:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_BTITEM, makeIndex, 0, price, 0);
		}

		//确认摆摊
		static public function cm_btItem_confirm(name:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_BTITEM, 0, 0, 0, 2, name);
		}

		//单击摆摊、拖放物品到摆摊界面--返回
		static public function sm_btItem_success(td:TDefaultMessage, body:String):void {
			//单击摆摊返回
			if (td.Recog == 1) {
//				Cmd_Stall.cm_btItem_add(958528199,333);
//				Cmd_Stall.cm_btItem_confirm("我的摊位");

				UIManager.getInstance().stallWnd.serv_showStall();
			} else {
				//拖放返回，无返回值，自己临时保存
				UIManager.getInstance().stallWnd.serv_addItemGrid();
			}
			//确认摆摊无返回
		}

		//单击摆摊、拖放物品到摆摊界面--失败
		static public function sm_btItem_fail(td:TDefaultMessage, body:String):void {
			//单击摆摊返回
			if (td.Recog == 1) {

			}

			trace(body);
			//确认摆摊后，如果摆摊里物品数为空则失败
		}

		//拖放物品到摆摊界面--失败
		static public function sm_baitanItem_fail(td:TDefaultMessage, body:String):void {
			print("拖放失败");
		}

		//查看他人摊位
		static public function cm_clickhuman(playerId:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CLICKHUMAN, playerId, 0, 0, 0);
			UIManager.getInstance().stallWnd.selectPlayerID=playerId;
		}

		//查看他人摊位--返回
		static public function sm_btitem(td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");
			var cu:TClientItem;

			UIManager.getInstance().stallWnd.itemOtherDataArr.length=0;

			for (var i:int=0; i < arr.length; i++) {
				if (String(arr[i]).length < 100 || arr[i] == null || arr[i] == "") {
					continue;
				}
				cu=Cmd_backPack.analysisItem(arr[i]);
				UIManager.getInstance().stallWnd.itemOtherDataArr.push(cu);
			}

			UIManager.getInstance().stallWnd.serv_showOthStall();
		}

		//关闭摊位，会受到刷新背包协议
		static public function cm_canclebtitem():void {
//			Core.me.
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CANCLEBTITEM, 0, 0, 0, 0);
		}

		//购买别人的摊位物品
		static public function cm_buybtitem(makeIndex:int, price:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_BUYBTITEM, makeIndex, 0, price, 0);
		}

		//购买别人的摊位物品--ok  刷新摆摊列表

		//购买别人的摊位物品--fail	sm_menu_ok交易协议里注册过
	}
}