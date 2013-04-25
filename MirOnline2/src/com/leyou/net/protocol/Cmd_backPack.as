package com.leyou.net.protocol {
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.tools.print;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.utils.HexUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.NetEnum;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.utils.ItemUtil;

	public class Cmd_backPack {

		/**
		 *正在被背包使用的格子
		 */
		private static var bagUseItem:TClientItem;

		private static var isstore:Boolean=false;
		
		//存放道具到背包包括仓库的
		static public function pushBackpackItem(type:String, td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");
			var cu:TClientItem;

			for (var i:int=0; i < arr.length; i++) {
				if (String(arr[i]).length < 100) {
					continue;
				}

				cu=analysisItem(arr[i]);

				if (type == ItemEnum.TYPE_GRID_BACKPACK) {
					MyInfoManager.getInstance().backpackItems[i]=cu; //如果是背包
				} else {
					MyInfoManager.getInstance().backpackItems[i + ItemEnum.BACKPACK_GRID_TOTAL]=cu; //如果是仓库
				}
			}

			if (type == ItemEnum.TYPE_GRID_BACKPACK) {
				UIManager.getInstance().backPackWnd.refresh(); //如果是背包
				UIManager.getInstance().ser_initUI();
			} else {
				UIManager.getInstance().storageWnd.refresh(); //如果是仓库
			}
		}

		static public function analysisItem(str:String, isStall:Boolean=false):TClientItem {
			var scu:TSClientItem;
			var cu:TClientItem;
			scu=new TSClientItem(NetEncode.getInstance().DecodeBuffer(str));
			var info:TItemInfo=TableManager.getInstance().getItemInfo(scu.wIndex - 1);
			//				GetItemAddValue(scu, StdItem);    
			cu=new TClientItem();
			cu.s=info;
			cu.copyScu(scu, isStall);
			return cu;
		}

		//获取高级属性
		static public function GetItemAddValue(scu:TSClientItem, info:TItemInfo):void {
			//应该返回copy的数据，否则本地配置文件被修改
			switch (info.type) {
				case 5:
				case 6:
					break;
				default:
					break;
			}
		}

		//查询包裹物品 背包
		static public function cm_queryBagItems():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_QUERYBAGITEMS, 0, 0, 0, 0);
		}

		//获取背包数据
		static public function sm_bagItems(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().resetBack(ItemEnum.TYPE_GRID_BACKPACK);
			pushBackpackItem(ItemEnum.TYPE_GRID_BACKPACK, td, body);
		}

		//背包添加物品
		static public function sm_addItem(td:TDefaultMessage, body:String):void {

			var cu:TClientItem=analysisItem(body);
			var ps:int;

			//如果正在使用
			if (MyInfoManager.getInstance().waitItemUse != -1 && bagUseItem==null) {
				bagUseItem=cu;
				return;
			}

			if ((MyInfoManager.getInstance().waitItemToId == -1)) {
				ps=MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK, cu); //如果背包不为空，查找位置放置（没有交换功能）
			} else if (MyInfoManager.getInstance().itemIsJustFill(MyInfoManager.getInstance().waitItemToId)) {
				ps=MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK, cu, MyInfoManager.getInstance().waitItemToId); //如果背包为空，直接添加到该位置
			} else {
				ps=MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK, cu); //如果背包不为空，查找位置放置（没有交换功能）
			}

			//叠加
			if (MyInfoManager.getInstance().waitItemFromId != -1 && !isstore) {
				MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemFromId);
				MyInfoManager.getInstance().resetWaitItem();
			}
			
			UIManager.getInstance().backPackWnd.refresh();
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, cu.s.name + "被发现");
		}

		//背包删除物品
		static public function sm_delItem(td:TDefaultMessage, body:String):void {
			var info:TClientItem=analysisItem(body);
			UIManager.getInstance().roleWnd.serv_removeItem(info);
			UIManager.getInstance().stallWnd.serv_removeItem(info);
		}

		static public function sm_updateItem(td:TDefaultMessage, body:String):void {
			var info:TClientItem=analysisItem(body);
			var idx:int=MyInfoManager.getInstance().getEquipIdxById(info.s.id);
			if (idx >= 0) {
				MyInfoManager.getInstance().equips[idx]=info;
//				UIManager.getInstance().roleWnd.gridInfo[idx]=info;
			}
		}

		//道具数量改变
		static public function sm_itemChangeCount(td:TDefaultMessage, body:String):void {
			var info:TClientItem;
			for (var i:int=0; i < MyInfoManager.getInstance().backpackItems.length; i++) {
				info=MyInfoManager.getInstance().backpackItems[i];
				if (info.MakeIndex == td.Recog) {
					info.Addvalue[0]=td.Param;
					UIManager.getInstance().backPackWnd.updatOneGrid(i);
					UIManager.getInstance().toolsWnd.updataShortcutGrid(info.s.id);
					return;
				}
			}
		}

		static public function cm_addStarItem():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_ADDSTARITEM, 0, NetEnum.NPC_STORAGE, 0, 0);
		}

		/*	//和npc说话
			static public function sm_merchantSay(td:TDefaultMessage, body:String):void {
				MyInfoManager.getInstance().talkNpcId=td.Recog;
				CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_MERCHANTDLGSELECT, td.Recog, 0, 0, 0, NetEnum.OPEN_STORAGE); //打开仓库
			}*/

		//物品叠加
		static public function cm_bothItem(makeIndex1:int, makeIndex2:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_BOTHITEM, makeIndex1, makeIndex2, 0, 0);
		}

		//丢弃道具
		static public function cm_dropItem(makeIndex:int, itemName:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_DROPITEM, makeIndex, 0, 0, 0, itemName);
		}

		//丢弃道具-ok
		static public function sm_dropItem_success(td:TDefaultMessage, body:String):void {
			body; //道具名称
			td.Recog; //道具id
			trace("丢弃道具" + body);

			UIManager.getInstance().backPackWnd.dropOneGridByMakeIndex(td.Recog);
		}

		//丢弃道具-fail
		static public function sm_dropItem_fail(td:TDefaultMessage, body:String):void {
			body; //道具名称
			td.Recog; //道具id
			trace("丢弃道具--fail" + body);
		}

		//拆分道具
		static public function cm_fenItem(makeIndex:int, num:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_FENITEM, makeIndex, num, 0, 0);
		}

		//获取仓库数据
		static public function sm_saveItemList(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().taskWnd.serv_CLoseWind();
			MyInfoManager.getInstance().resetBack(ItemEnum.TYPE_GRID_STORAGE);
			pushBackpackItem(ItemEnum.TYPE_GRID_STORAGE, td, body);
		}

		//背包转仓库
		static public function cm_userStorageItem(npcId:int, info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_USERSTORAGEITEM, npcId, HexUtil.LoWord(info.MakeIndex), HexUtil.HiWord(info.MakeIndex), 0, info.s.name);
		}

		//背包转仓库-ok
		static public function sm_storage_ok(td:TDefaultMessage, body:String):void {
			var ps:int;
			var cu:TClientItem;

			//如果仓库为空，存到该地方，并且置空背包
			if (MyInfoManager.getInstance().itemIsJustFill(MyInfoManager.getInstance().waitItemToId)) {
				MyInfoManager.getInstance().switchItems(MyInfoManager.getInstance().waitItemFromId, MyInfoManager.getInstance().waitItemToId);
				UIManager.getInstance().backPackWnd.updatOneGrid(MyInfoManager.getInstance().waitItemFromId);
				UIManager.getInstance().storageWnd.updatOneGrid(MyInfoManager.getInstance().waitItemToId);
				MyInfoManager.getInstance().resetWaitItem();
				return;

			} else {
				//如果仓库不为空，找地方存放,并且置空背包
				cu=MyInfoManager.getInstance().backpackItems[MyInfoManager.getInstance().waitItemFromId];
				ps=MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_STORAGE, cu);
				UIManager.getInstance().storageWnd.updatOneGrid(ps);
			}

			UIManager.getInstance().backPackWnd.mouseChildren=true;
			MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemFromId);
			UIManager.getInstance().backPackWnd.updatOneGrid(MyInfoManager.getInstance().waitItemFromId);
		}

		//背包转仓库-仓库已满
		static public function sm_storage_full(td:TDefaultMessage, body:String):void {
			print("仓库已满");
			MyInfoManager.getInstance().resetWaitItem();
			UIManager.getInstance().backPackWnd.mouseChildren=true;
		}

		//背包转仓库-fail
		static public function sm_storage_fail(td:TDefaultMessage, body:String):void {
			print("存放失败！");
			MyInfoManager.getInstance().resetWaitItem();
			UIManager.getInstance().backPackWnd.mouseChildren=true;
		}

		//仓库转背包
		static public function cm_userTakeBackStorageItem(npcId:int, info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_USERTAKEBACKSTORAGEITEM, npcId, HexUtil.LoWord(info.MakeIndex), HexUtil.HiWord(info.MakeIndex), 0, info.s.name);
			isstore=true;
		}

		//仓库转背包-ok
		static public function sm_takeBackStorageItem_ok(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemFromId);
			UIManager.getInstance().storageWnd.updatOneGrid(MyInfoManager.getInstance().waitItemFromId);
			MyInfoManager.getInstance().resetWaitItem();
			isstore=false;
			UIManager.getInstance().storageWnd.mouseChildren=true;
		}

		//仓库转背包-fail
		static public function sm_takeBackStorageItem_fail(td:TDefaultMessage, body:String):void {
			print("取回失败！");
			MyInfoManager.getInstance().resetWaitItem();
			isstore=false;
			UIManager.getInstance().storageWnd.mouseChildren=true;
		}

		//仓库转背包-背包已满
		static public function sm_takeBackStorageItem_fullBag(td:TDefaultMessage, body:String):void {
			//print("背包已满");
			MyInfoManager.getInstance().resetWaitItem();
			isstore=false;
			UIManager.getInstance().storageWnd.mouseChildren=true;
		}

		//显示道具
		static public function sm_itemShow(td:TDefaultMessage, body:String):void {
//			print("道具显示：" + td.Recog, td.Param, td.Tag, td.Series, body);
			UIManager.getInstance().mirScene.addItem(td.Recog, td.Param, td.Tag, td.Series);
		}

		//隐藏道具
		static public function sm_itemHide(td:TDefaultMessage, body:String):void {
//			print("道具消失：" + td.Recog, td.Param, td.Tag, body);
			UIManager.getInstance().mirScene.removeItem(td.Recog);
		}

		//拾取道具
		static public function cm_pickup(px:int, py:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_PICKUP, 0, px, py, 0);
		}

		//穿衣
		static public function cm_takeOnItem(info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_TAKEONITEM, info.MakeIndex, ItemUtil.getTakeOnPosition(info.s.type), 0, 0, info.s.name);
		}

		//穿衣成功
		static public function sm_takeOn_ok(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().roleWnd.takeOnEquip(MyInfoManager.getInstance().waitItemUse);

			if (bagUseItem != null)
				MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK, bagUseItem, MyInfoManager.getInstance().waitItemUse);
			else
				MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemUse);

			UIManager.getInstance().backPackWnd.updatOneGrid(MyInfoManager.getInstance().waitItemUse);
			MyInfoManager.getInstance().resetWaitUse();
			bagUseItem=null;
			UIManager.getInstance().roleWnd.resetDragPos();
		}

		//穿衣失败
		static public function sm_takeOn_fail(td:TDefaultMessage, body:String):void {
			var info:TClientItem=MyInfoManager.getInstance().backpackItems[MyInfoManager.getInstance().waitItemUse];
			AlertWindow.showWin(info.s.name + "使用失败");
			MyInfoManager.getInstance().waitItemUse=-1;
			UIManager.getInstance().roleWnd.resetDragPos();
		}

		//吃药
		static public function cm_eat(info:TClientItem):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_EAT, info.MakeIndex, 0, 0, 0, info.s.name);
		}

		//吃药成功
		static public function sm_eat_ok(td:TDefaultMessage, body:String):void {
			trace("吃药成功");
			//if (MyInfoManager.getInstance().waitItemUse != -1)
			//	UIManager.getInstance().backPackWnd.delOneGridByID(MyInfoManager.getInstance().waitItemUse);
			
			//为了使工具栏与背包同步显示
			var wait:int=MyInfoManager.getInstance().backpackItems[MyInfoManager.getInstance().waitItemUse].s.id;
			
			if (bagUseItem != null)
				MyInfoManager.getInstance().addItem(ItemEnum.TYPE_GRID_BACKPACK, bagUseItem, MyInfoManager.getInstance().waitItemUse);
			else
				MyInfoManager.getInstance().resetItem(MyInfoManager.getInstance().waitItemUse);
			
			UIManager.getInstance().backPackWnd.refresh();
			bagUseItem=null;
			MyInfoManager.getInstance().resetWaitUse();
			//更新工具栏
			UIManager.getInstance().toolsWnd.updataShortcutGrid(wait);
		}

		//吃药失败
		static public function sm_eat_fail(td:TDefaultMessage, body:String):void {
			trace("吃药失败");
			//AlertWindow.showWin("吃药失败");
			MyInfoManager.getInstance().resetWaitUse()
		}

		//向客户端发送游戏币,游戏点,金刚石,灵符数量
		static public function sm_gameGoldName(td:TDefaultMessage, body:String):void {
//			MyInfoManager.getInstance().exInfo.gameGold=td.Recog;
			Cmd_Task.updataMoney(-1, td.Recog, td.Series);
		}



	}
}
