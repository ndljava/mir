package com.leyou.net.protocol {
	import com.ace.ui.window.children.AlertWindow;
	import com.leyou.data.net.market.TShopInfo;
	import com.leyou.data.net.shop.TStdItem;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Market {

		//打开商铺，参数：标签页，页码
		static public function cm_openShop(type:int, page:uint=0):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_OPENSHOP, 0, page, type, 0);
		}

		static public function sm_sengShopItems(td:TDefaultMessage, body:String):void {
			td.Param; //共多少页

			var itemArr:Vector.<TShopInfo>=new Vector.<TShopInfo>;
			var arr:Array=body.split("/");
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] != "")
					itemArr.push(analysisTShopInfo(arr[i]));
			}
			UIManager.getInstance().marketWnd.addItem(itemArr, td.Param);
//			UIManager.getInstance().marketWnd.updata(itemArr,td.Param);
		}

		//特殊商品
		static public function sm_sengShopSpeciallyItems(td:TDefaultMessage, body:String):void {
			var itemArr:Vector.<TShopInfo>=new Vector.<TShopInfo>;
			var arr:Array=body.split("/");
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] != "")
					itemArr.push(analysisTShopInfo(arr[i]));
			}
			UIManager.getInstance().marketWnd.addHotItem(itemArr);
//			cm_buyShopItem(1,"龙纹剑");//测试
		}


		//买道具	参数：标签页
		static public function cm_buyShopItem(type:int, itemeName:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_BUYSHOPITEM, type, type, type, type, itemeName);
		}

		//买道具-ok
		static public function sm_buyShopItem_success(td:TDefaultMessage, body:String):void {

		}

		//买道具-fail
		static public function sm_buyShopItem_fail(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().noticeMidDownUproll.setNoticeStr(body,SystemNoticeEnum.IMG_WARN);
//			AlertWindow.showWin(body);
		}

		static public function analysisTShopInfo(str:String):TShopInfo {
			var info:TShopInfo=new TShopInfo(NetEncode.getInstance().DecodeBuffer(str));
			return info;
		}
	}
}