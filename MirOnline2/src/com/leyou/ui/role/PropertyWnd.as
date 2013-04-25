package com.leyou.ui.role {
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.gameData.player.PlayerExtendInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.role.child.PropertyList;
	
	import flash.events.MouseEvent;

	public class PropertyWnd extends AutoWindow {
		private var gridList:ScrollPane;
		private var propertyNum:PropertyList;
		private var pointBtn:NormalButton;

		public function PropertyWnd() {
			super(LibManager.getInstance().getXML("config/ui/PropertyWnd.xml"));
			this.init();
		}

		private function init():void {
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.pointBtn=this.getUIbyID("pointBtn") as NormalButton;
			this.propertyNum=new PropertyList();
			this.gridList.addToPane(propertyNum);
			
			this.pointBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
		}

		public function updateBaseInfo(info:*):void {
			this.propertyNum.updateBaseInfo(info);
		}

		public function updateAddInfo(info:*):void {
			this.propertyNum.updateAddInfo(info);
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, false);
			this.x=UIManager.getInstance().roleWnd.x + UIManager.getInstance().roleWnd.width;
			this.y=UIManager.getInstance().roleWnd.y;
		}
		
		private function onBtnClick(evt:MouseEvent):void{
			UIManager.getInstance().propertyPointWnd.open();
		}
		
		
	}
}