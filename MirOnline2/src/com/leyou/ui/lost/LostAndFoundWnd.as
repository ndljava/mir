package com.leyou.ui.lost {
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.net.lostAndFind.TLostItemBind;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.lost.child.LostRender;
	
	import flash.events.MouseEvent;

	public class LostAndFoundWnd extends AutoWindow {

		private var pageLbl:Label;
		private var prePageBtn:NormalButton;
		private var nextPageBtn:NormalButton;
		private var currentPage:int=1; //当前页

		public var countPage:int=0;
		
		private var renderArr:Vector.<LostRender>;

		public var itemData:Vector.<TLostItemBind>;

		public function LostAndFoundWnd() {
			super(LibManager.getInstance().getXML("config/ui/ShopWnd.xml"));
			this.init();
		}

		private function init():void {
			this.pageLbl=this.getUIbyID("pageLbl") as Label;
			this.prePageBtn=this.getUIbyID("prePageBtn") as NormalButton;
			this.nextPageBtn=this.getUIbyID("nextPageBtn") as NormalButton;

			this.prePageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.nextPageBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.renderArr=new Vector.<LostRender>();
			this.itemData=new Vector.<TLostItemBind>();

			var render:LostRender;
			for (var i:int=0; i < 12; i++) {
				render=new LostRender();
				this.addChild(render);
				this.renderArr.push(render);
				render.updateInfo(null);

				if (i % 2 == 0) {
					render.x=35;
				} else {
					render.x=35 + render.width;
				}

				render.y=60 + Math.floor(i / 2) * render.height;
			}
		}

		private function update():void {
			for (var i:int=0; i < this.renderArr.length; i++) {
				if (this.itemData.length > i)
					this.renderArr[i].updateInfo(this.itemData[i]);
				else
					this.renderArr[i].updateInfo(null);
			}
		}

		private function onClick(e:MouseEvent):void {
			if (e.target.name == "prePageBtn") {
				if (currentPage - 1 < 1)
					return;

				currentPage--;
			} else if (e.target.name == "nextPageBtn") {
				if (currentPage + 1 > countPage)
					return;

				currentPage++;
			}

			Cmd_Task.cm_userGetDetailLostItem(UIManager.getInstance().taskWnd.npcId, currentPage, "");
			this.pageLbl.text=currentPage + "/"+countPage;
		}

		public function getRenderToIndex(item:LostRender):int {
			if (item == null || this.renderArr.length <= 0)
				return -1;

			return this.renderArr.indexOf(item);
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);

			UIManager.getInstance().backPackWnd.show();
			this.x=(UIEnum.WIDTH - UIManager.getInstance().backPackWnd.width - this.width) / 2;
			UIManager.getInstance().backPackWnd.x=this.x + this.width;
			this.y=UIManager.getInstance().backPackWnd.y;
		}

		public function serv_updateData():void {
			this.show();
			update();
			
			this.pageLbl.text=currentPage + "/"+countPage;
		}
	}
}
