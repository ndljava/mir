package com.leyou.ui.backpack.child {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.net.protocol.Cmd_backPack;
	
	import flash.events.MouseEvent;

	public class BagSplitPanel extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var slider:HSlider;
		private var numStep:TextInput;

		private var currentGrid:BackpackGrid;

		private var oldGrid:BackpackGrid;
		private var newGrid:BackpackGrid;

		private var tc:TClientItem;

		public function BagSplitPanel() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd02.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.slider=this.getUIbyID("splitHSlider") as HSlider;
			this.numStep=this.getUIbyID("numStep") as TextInput;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.numStep.text="";

			this.currentGrid=new BackpackGrid(-1);
			this.currentGrid.isLock=false;
			this.addChild(this.currentGrid);
			this.currentGrid.x=22;
			this.currentGrid.y=50;

			this.oldGrid=new BackpackGrid(-1);
			this.addChild(this.oldGrid);
			this.oldGrid.x=130;
			this.oldGrid.y=50;

			this.newGrid=new BackpackGrid(-1);
			this.addChild(this.newGrid);
			this.newGrid.x=180;
			this.newGrid.y=50;

			this.currentGrid.mouseChildren=false;
			this.currentGrid.mouseEnabled=false;
			this.oldGrid.mouseChildren=false;
			this.newGrid.mouseChildren=false;
			this.oldGrid.mouseEnabled=false;
			this.newGrid.mouseEnabled=false;
		}

		private function updateGrid(info:TClientItem):void {
			this.currentGrid.updataInfo(info);
			this.oldGrid.updataInfo(info);
			this.newGrid.updataInfo(info);

			this.oldGrid.numLable=0;
			this.newGrid.numLable=0;
		}

		public function showPanel(info:TClientItem):void {
			updateGrid(info);
			this.tc=info;
			super.show();
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "confirmBtn":
					if (this.numStep.text != null && this.numStep.text != "")
						Cmd_backPack.cm_fenItem(tc.MakeIndex, int(this.numStep.text));
					break;
				case "cancelBtn":

					break;
			}

			this.hide();
		}

	}
}
