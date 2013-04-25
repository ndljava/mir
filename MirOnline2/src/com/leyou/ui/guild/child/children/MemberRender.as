package com.leyou.ui.guild.child.children
{
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;

	public class MemberRender extends AutoSprite
	{
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var positionLbl:Label;
		private var contributionLbl:Label;
		private var nodeLbl:Label;
		private var highLight:ScaleBitmap;

		private var _id:int;


		public function MemberRender()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/child/MemberRender.xml"));
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void
		{
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.positionLbl=this.getUIbyID("positionLbl") as Label;
			this.contributionLbl=this.getUIbyID("contributionLbl") as Label;
			this.nodeLbl=this.getUIbyID("nodeLbl") as Label;
			this.highLight=this.getUIbyID("highLight") as ScaleBitmap;

			this.selectSta=false;
		}

		public function update(memName:String, position:String):void
		{
			this.nameLbl.text=memName.replace(/\**/g, "") + "";
			this.lvLbl.text="";
			this.raceLbl.text="";
			this.positionLbl.text=position.replace(/\**/g, "") + "";
			this.contributionLbl.text="";
			this.nodeLbl.text="";
		}

		public function get id():int
		{
			return this._id;
		}

		public function set id(i:int):void
		{
			this._id=i;
		}

		public function get memberName():String
		{
			return this.nameLbl.text;
		}

		public function get memberLv():int
		{
			return int(this.lvLbl.text);
		}

		public function set selectSta(sta:Boolean):void
		{
			this.highLight.visible=sta;
		}
	}
}
