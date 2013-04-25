package com.leyou.ui.guild.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.ui.guild.child.children.WageRender;

	import flash.events.MouseEvent;

	public class GuildWagePanel extends AutoSprite {
		private var remianGoldIngotLbl:Label; //发放后剩余行会元宝：
		private var goldIngotSumLbl:Label; //行会元宝总额：
		private var getTimeCombox:ComboBox; //领取时间
		private var positionBtn:NormalButton; //帮派职位
		private var membNumBtn:NormalButton; //人数
		private var sumNumBtn:NormalButton; //总发放额
		private var averageBtn:NormalButton; //人均发放
		private var resetBtn:NormalButton; //重置
		private var confirmBtn:NormalButton; //确定
		private var gridList:ScrollPane;

		private var renderArr:Vector.<WageRender>;
		private var selectRenderId:int=-1;
		private var overRenderId:int=-1;

		public function GuildWagePanel() {
			super(LibManager.getInstance().getXML("config/ui/guild/GuildWagePage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.remianGoldIngotLbl=this.getUIbyID("remianGoldIngotLbl") as Label;
			this.goldIngotSumLbl=this.getUIbyID("goldIngotSumLbl") as Label;

			this.getTimeCombox=this.getUIbyID("getTimeCombox") as ComboBox;

			this.positionBtn=this.getUIbyID("positionBtn") as NormalButton;
			this.membNumBtn=this.getUIbyID("membNumBtn") as NormalButton;
			this.sumNumBtn=this.getUIbyID("sumNumBtn") as NormalButton;
			this.averageBtn=this.getUIbyID("averageBtn") as NormalButton;
			this.resetBtn=this.getUIbyID("resetBtn") as NormalButton;
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.gridList=this.getUIbyID("gridList") as ScrollPane;

			this.positionBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.membNumBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.sumNumBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.averageBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.resetBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.gridList.addEventListener(MouseEvent.CLICK, onListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onListOut);
			this.renderArr=new Vector.<WageRender>;
			this.test();
		}

		private function test():void {
			var render:WageRender;
			for (var i:int=0; i < 10; i++) {
				render=new WageRender();
				render.id=i;
				this.gridList.addToPane(render);
				render.y=i * 23;
				this.renderArr.push(render);
			}
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "positionBtn": //帮派职位
					break;
				case "membNumBtn": //人数
					break;
				case "sumNumBtn": //总发放额
					break;
				case "averageBtn": //人均发放
					break;
				case "resetBtn": //重置
					break;
				case "confirmBtn": //确定
					break;
			}
		}

		private function onListClick(evt:MouseEvent):void {
			if (evt.target is WageRender) {
				var id:int=(evt.target as WageRender).id;
				if (id == this.selectRenderId)
					return;
				if (this.selectRenderId != -1) {
					var idx:int=getIdxById(selectRenderId);
					if (idx !== -1)
						return;
					this.renderArr[idx].selectSta=false;
				}

				this.selectRenderId=id;
				this.renderArr[getIdxById(this.selectRenderId)].selectSta=true;
			}
		}

		private function onListOver(evt:MouseEvent):void {
			if (evt.target is WageRender) {
				var id:int=(evt.target as WageRender).id;
				if (id == this.selectRenderId || id == this.overRenderId)
					return;
				if (this.overRenderId != -1 && this.selectRenderId != this.overRenderId) {
					var idx:int=getIdxById(this.overRenderId);
					if (idx == -1)
						return;
					this.renderArr[this.getIdxById(this.overRenderId)].selectSta=false;
				}
				this.overRenderId=id;
				this.renderArr[this.getIdxById(this.overRenderId)].selectSta=true;
			}
		}

		private function onListOut(evt:MouseEvent):void {
			if (this.overRenderId != -1 && this.selectRenderId != this.overRenderId) {
				var idx:int=this.getIdxById(this.overRenderId);
				if (idx == -1)
					return;
				this.renderArr[this.getIdxById(this.overRenderId)].selectSta=false;
			}
			this.overRenderId=-1;
		}

		private function getIdxById(id:int):int {
			var idx:int=-1;
			for (var i:int=0; i < this.renderArr.length; i++) {
				if (this.renderArr[i].id == id) {
					idx=i;
					break;
				}
			}
			return idx;
		}
	}
}