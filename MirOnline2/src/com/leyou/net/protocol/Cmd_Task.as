package com.leyou.net.protocol {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.tools.print;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.utils.HexUtil;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.shop.ShopWnd;

	public class Cmd_Task {
		private static var isfirstNpc:Boolean=true;

		//单击npc 参数：npcid
		static public function cm_clickNpc(npcId:int):void {
			print("Npc的id_" + npcId);
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CLICKNPC, npcId, 0, 0, 0);
		}

		//商人说话  参数：napid、说话内容
		static public function sm_merchantSay(td:TDefaultMessage, body:String):void {
			if (isfirstNpc) {
				MyInfoManager.getInstance().talkNpcId=td.Recog;
				isfirstNpc=false;
				return;
			}

			if (UIManager.getInstance().chatWnd.hornFlag) {
				UIManager.getInstance().chatWnd.sendHorn(td.Recog);
				return;
			}

			if (body.indexOf("发送信息") == -1)
				UIManager.getInstance().taskWnd.serv_showTalk(td.Recog, body);

		}

		//单击任务功能按钮【单击杂货铺等等】 参数：npcID、命令字符串
		static public function cm_merchantDlgSelect(npcId:int, cmd:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_MERCHANTDLGSELECT, npcId, 0, 0, 0, cmd);
		}

		//商店翻页
		static public function cm_userGetDeailItem(npcId:int, page:uint):void {
//			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_USERGETDETAILITEM, npcId, page, 0, 0, 0);
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_USERGETDETAILITEM, npcId, page, 0, 0);
		}

		//返回 商品列表   
		static public function sm_sendGoodsList(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().taskWnd.serv_CLoseWind();

			var npcId:int=td.Recog;
			var goodCount:int=td.Tag;
			var goodIndex:int=td.Param;
			var itemArr:Vector.<TStdItem>=new Vector.<TStdItem>;
			var arr:Array=body.split("/");
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] == "")
					continue;
				itemArr.push(analysisTStdItem(arr[i]));
			}
			UIManager.getInstance().shopWnd.ser_ShowShopWnd(itemArr, npcId, goodCount, goodIndex);
		}

		static public function analysisTStdItem(str:String):TStdItem {
			var info:TStdItem=new TStdItem(NetEncode.getInstance().DecodeBuffer(str));
			return info;
		}

		//关闭npc面板
		static public function cm_closeNpcWin():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CLOSENPCWIN, 0, 0, 0, 0);
		}


		//购买东西【参数：npcID、道具索引从12开始、数量、道具名称】
		static public function cm_userBuyItem(npcId:int, itemIndex:int, count:int, itemName:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_USERBUYITEM, npcId, HexUtil.LoWord(itemIndex), HexUtil.HiWord(itemIndex), count, itemName);
//			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CLICKNPC, 0, 0, 0, 0);
		}

		//购买物品成功
		static public function sm_buyItem_success(td:TDefaultMessage, body:String):void {
			td.Recog; //钱数
//			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM,"购买成功！");
		}

		//购买物品-失败
		static public function sm_buyItem_fail(td:TDefaultMessage, body:String):void {
			switch (td.Recog) {
				//1: FrmDlg.DMessageDlg ('此物品被卖出.', [mbOk]);
				//2: FrmDlg.DMessageDlg ('您无法携带更多物品了.', [mbOk]);
				//3: FrmDlg.DMessageDlg ('您没有足够的钱来购买此物品.', [mbOk]);
			}
			UIManager.getInstance().shopWnd.buyFailed(td.Recog);
		}

		//钱改变
		static public function sm_goldChanged(td:TDefaultMessage, body:String):void {
			updataMoney(td.Recog, HexUtil.MakeLong(td.Param, td.Tag));
		}

		//统一处理更新	金币、元宝
		static public function updataMoney(coin:int=-1, gold:int=-1, integration:int=-1):void {
			(coin != -1) && (MyInfoManager.getInstance().baseInfo.gameCoin=coin);
			(gold != -1) && (MyInfoManager.getInstance().baseInfo.gameGold=gold);
			(integration != -1) && (MyInfoManager.getInstance().baseInfo.gameScore=integration);

			UIManager.getInstance().backPackWnd.updataMoney();
			UIManager.getInstance().marketWnd.updataGold();
		}

		//卖东西
		static public function cm_userSellItem(npcId:int, itemIndex:int, itemName:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_USERSELLITEM, npcId, HexUtil.LoWord(itemIndex), HexUtil.HiWord(itemIndex), 0, itemName);
		}

		//卖东西-ok
		static public function sm_userSellItem_ok(td:TDefaultMessage, body:String):void {
//			AlertWindow.showWin("物品出售成功");
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, "物品出售成功");
			updataMoney(td.Recog);
			MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemFromId);
			UIManager.getInstance().backPackWnd.updatOneGrid(MyInfoManager.getInstance().waitItemFromId);
			MyInfoManager.getInstance().resetWaitItem();
		}

		//卖东西-fail
		static public function sm_userSellItem_fail(td:TDefaultMessage, body:String):void {
			AlertWindow.showWin("您不能出售此物品");
//			'您不能出售此物品.'
		}

		//关闭npc对话框
		static public function sm_merchantdlgclose(td:TDefaultMessage, body:String):void {
			//			'您不能出售此物品.'
			UIManager.getInstance().taskWnd.serv_CLoseWind();
		}

		//结婚涉及到的
		static public function sm_closeBigDialogBox(td:TDefaultMessage, body:String):void {
			//			'您不能出售此物品.'
			UIManager.getInstance().taskWnd.serv_CLoseWind();
		}

	}
}
