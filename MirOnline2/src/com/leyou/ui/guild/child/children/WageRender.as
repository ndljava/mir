package com.leyou.ui.guild.child.children {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;

	public class WageRender extends AutoSprite {
		private var positionLbl:Label; //职位
		private var memNumLbl:Label; //人数
		private var sumNumInput:TextInput; //总发放额
		private var averageLbl:Label; //人均发放额
		private var highLight:ScaleBitmap; //选中的亮框

		private var _id:int;

		public function WageRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/child/WageRender.xml"));
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void {
			this.positionLbl=this.getUIbyID("positionLbl") as Label;
			this.memNumLbl=this.getUIbyID("memNumLbl") as Label;
			this.sumNumInput=this.getUIbyID("sumNumInput") as TextInput;
			this.averageLbl=this.getUIbyID("averageLbl") as Label;
			this.highLight=this.getUIbyID("highLight") as ScaleBitmap;

			this.selectSta=false;
			this.sumNumInputSta=true;

			this.test();
		}

		private function test():void {
			this.positionLbl.text="1";
			this.memNumLbl.text="2";
			this.sumNumInput.text="2";
			this.averageLbl.text="4";
		}

		public function set selectSta(sta:Boolean):void {
			this.highLight.visible=sta;
		}

		public function set sumNumInputSta(sta:Boolean):void {
//			this.sumNumInput.mouseEnabled=sta;
			this.mouseChildren=sta;
		}

		public function set id(i:int):void {
			this._id=i;
		}

		public function get id():int {
			return this._id;
		}
	}
}