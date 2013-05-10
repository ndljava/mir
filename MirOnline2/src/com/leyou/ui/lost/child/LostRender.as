package com.leyou.ui.lost.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.lostAndFind.TLostItemBind;
	import com.leyou.data.net.lostAndFind.TUserItem;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.ui.shop.child.ShopListRender;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LostRender extends Sprite {

		private var bg:ScaleBitmap;
		private var itemGrid:LostGrid;
		private var itemName:Label;
		private var playName:Label;

		private var info:TLostItemBind;

		private var isDown:Boolean=false;

		public function LostRender() {
			super();
			this.init();
		}

		private function init():void {
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bg.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.bg.setSize(165, 50);
			this.bg.x=-3;
			this.bg.y=-3;
			this.addChildAt(bg, 0);

			itemGrid=new LostGrid();
			this.addChild(itemGrid);

			itemGrid.x=5;
			itemGrid.y=5;

			this.itemName=new Label();
			this.addChild(this.itemName);

			this.itemName.x=itemGrid.x + itemGrid.width + 3;
			this.itemName.y=itemGrid.y;

			this.playName=new Label();
			this.addChild(this.playName);

			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseOver(e:MouseEvent):void {
			if (!(e.target is LostRender) || info == null)
				return;

			ItemTip.getInstance().show(UIManager.getInstance().lostWnd.getRenderToIndex(this), ItemEnum.TYPE_GRID_LOSTRENDER);
			ItemTip.getInstance().updataPs(e.stageX, e.stageY);
		}

		private function onMouseOut(e:MouseEvent):void {
			ItemTip.getInstance().hide();
			isDown=false;
		}

		private function onMouseDown(e:MouseEvent):void {
			isDown=true;
		}

		/**
		 *	拖拽释放
		 * @param e
		 *
		 */
		private function onMouseUp(e:MouseEvent):void {
			if (isDown) {
				if (info == null)
					return;

				if(info.sBindName!=MyInfoManager.getInstance().name){
					PopupManager.showAlert("非装备主人不能取回");
					return ;
				}
				
				Cmd_Task.cm_userGetBackLostItem(UIManager.getInstance().taskWnd.npcId, info.UserItem.MakeIndex, info.UserItem.toTClientItem().s.name, 1);
				isDown=false;
			} else {
				var g:GridBase=DragManager.getInstance().grid;
				if (g == null)
					g=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);

				if (g == null || g.data == null || g.data.s == null)
					return;

				PopupManager.showConfirm("确定提交" + g.data.s.name + "么?", okfunc);

				function okfunc():void {
					Cmd_Task.cm_userLostItem(UIManager.getInstance().taskWnd.npcId, g.data.MakeIndex, g.data.s.name);
				}
			}
		}

		public function updateInfo(info:*):void {
			this.info=TLostItemBind(info);

			if (info == null) {
				this.itemName.text="";
				this.playName.text="";

				itemGrid.updataInfo(null);
			} else {

				var titeminfo:TItemInfo=TableManager.getInstance().getItemInfo(this.info.UserItem.wIndex - 1);
				this.itemName.text=titeminfo.name + "";
				this.playName.text=this.info.sSendUserItem + "";

				itemGrid.updataInfo(titeminfo);           
				
				this.playName.x=this.width - this.playName.width - 5;
				this.playName.y=this.height - this.playName.height - 5;       
			}
		}

		public function isEmpty():Boolean {
			return info == null ? true : false;
		}

	}
}
