package com.leyou.ui.task {
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.WindInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.ui.tips.TipsEquipsEmpty;
	import com.leyou.utils.TaskUtils;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TaskWnd extends AutoWindow {
		private var cloceBtn:NormalButton;
		private var returnBtn:NormalButton;

		private var contentTxt:TextField;

		public var npcId:int=0;

		private var tips:TipsEquipsEmpty;

		public function TaskWnd() {
			super(LibManager.getInstance().getXML("config/ui/TaskWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.cloceBtn=this.getUIbyID("cloceBtn") as NormalButton;
			this.returnBtn=this.getUIbyID("returnBtn") as NormalButton;

			this.contentTxt=new TextField();
			this.contentTxt.width=420;
			this.contentTxt.height=170;

			this.contentTxt.x=30;
			this.contentTxt.y=50;

			this.contentTxt.addEventListener(TextEvent.LINK, onClickLink);
			this.contentTxt.addEventListener(MouseEvent.MOUSE_MOVE, onshowTips)
			this.contentTxt.mouseEnabled=true;

			var css:StyleSheet=new StyleSheet();
			css.setStyle(".c", {textDecoration: 'underline'});
			css.setStyle(".b", {textDecoration: 'none'});
			css.setStyle(".z", {leading: '0'});
			this.contentTxt.styleSheet=css;
			this.contentTxt.selectable=false;
			this.addToPane(this.contentTxt);

			this.tips=new TipsEquipsEmpty();
			this.addChild(this.tips)
			this.tips.visible=false;

			this.cloceBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.returnBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "cloceBtn":
					this.hide()
					break;
				case "returnBtn":
					break;
			}
		}

		private function onClickLink(e:TextEvent):void {
			var arr:Array=e.text.split("-");

			if (e.text.indexOf("@") == -1)
				return;

			var eve:String=arr[1];

			if (eve.indexOf("@@@") > -1) {
				PopupManager.showConfirm(arr[2], function():void {
					Cmd_Task.cm_merchantDlgSelect(npcId, eve.substr(2));
				});
			} else if (eve.indexOf("@@") > -1) {
				PopupManager.showConfirmInput(arr[2], function(i:String):void {
					if (i == null || i == "" || i == "0" || i == " ")
						return;
					Cmd_Task.cm_merchantDlgSelect(npcId, eve+"\r"+ i);
				});
			} else
				Cmd_Task.cm_merchantDlgSelect(npcId, eve);
		}

		override public function hide():void {
			super.hide();
			Cmd_Task.cm_closeNpcWin()
		}

		private function onshowTips(e:MouseEvent):void {
			var lb:TextField=TextField(e.target);
			if (lb.getCharIndexAtPoint(e.localX, e.localY) == -1) {
				this.tips.visible=false;
				return;
			}

			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xml:XML=XML(lb.getXMLText(i, i + 1));

			var tips:String=xml.textformat.@url;
			var tip:String=tips.split("-")[0];
			tip=tip.replace("event:", "");

			if (tip != null && tip != "") {
				while (tip.indexOf("^") > -1)
					tip=tip.replace("^", "\n");

				this.tips.showTaskTips(tip);

				this.tips.x=this.mouseX + 10;
				this.tips.y=this.mouseY + 20;
				this.tips.visible=true;
			} else
				this.tips.visible=false;
		}

		public function resize():void {
			this.y=(UIEnum.HEIGHT-this.height)/2;
		}
		
		public function updateInfo(content:String):void {
			content=TaskUtils.getTaskContent(content);
			var arr:Array=content.split("|");

			if(arr[0]=="QFunction")
				arr[0]="会员";
			
			this.titleLbl.text=arr[0];
			this.contentTxt.htmlText=arr[1];
		}

		/**
		 * 显示对话框
		 * @param npcid npcid
		 * @param str 内容
		 *
		 */
		public function serv_showTalk(npcid:int, str:String):void {
			this.show();
			updateInfo(str);
			this.npcId=npcid;
		}

		/**
		 * 关闭面板
		 *
		 */
		public function serv_CLoseWind():void {
			super.hide();
		}
	}
}
