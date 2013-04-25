package com.leyou.ui.guild {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ManageMessageWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var nameLbl:Label;
		private var raceLbl:Label;
		private var contributionLbl:Label;
		private var positionComBox:ComboBox;
		private var noteInput:TextInput;

		public function ManageMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/guild/MessageWnd07.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.contributionLbl=this.getUIbyID("contributionLbl") as Label;
			this.positionComBox=this.getUIbyID("positionComBox") as ComboBox;
			this.noteInput=this.getUIbyID("noteInput") as TextInput;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.positionComBox.addEventListener(DropMenuEvent.Item_Selected, onComBoxItemClick);
			//this.test();
		}

		private function test():void {
			this.nameLbl.text="1";
			this.raceLbl.text="2";
			this.contributionLbl.text="3";
			this.noteInput.text="4";
			this.positionComBox.setDataByArr([{str: "会员", val: 0}, {str: "掌门", val: 1}]); //  arr.push({str: childData[i], val: i});
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "cancelBtn": //取消
					this.open();
					break;
				case "confirmBtn": //确定

					break;
			}
		}

		private function onComBoxItemClick(evt:Event):void {
			var idx:int=evt.target.value.val;
		}
	}
}