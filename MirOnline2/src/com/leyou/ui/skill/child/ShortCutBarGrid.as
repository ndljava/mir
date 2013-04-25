package com.leyou.ui.skill.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.manager.LibManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.UIManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ShortCutBarGrid extends Sprite {
		private var bg:Bitmap;
		private var icon:Bitmap;
		private var _id:int;
		private var isEmpty:Boolean;
		private var numLbl:Label;
		private var _gridType:String;
		private var selectImg:Image;

		public function ShortCutBarGrid() {
			super();
			this.init();
		}

		private function init():void {
			this.isEmpty=true;
			
			this.bg=new Bitmap();
			this.bg.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.addChildAt(this.bg,0);
			this.selectImg=new Image();
			this.selectImg.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
			this.addChild(this.selectImg);
			this.selectImg.visible=false;
			
			this.icon=new Bitmap();
			this.icon.x=(40 - 28) >> 1;
			this.icon.y=(40 - 30) >> 1;
			this.addChild(this.icon);

			this.numLbl=new Label("", FontEnum.STYLE_NAME_DIC["White10right"]);
			this.numLbl.x=30;
			this.numLbl.y=23;
			this.addChild(this.numLbl);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function set id(i:int):void {
			this._id=i;
		}

		public function get id():int{
			return this._id;
		}
		private function onClick(evt:MouseEvent):void {
			UIManager.getInstance().skillWnd.setSkillShortCut(this._id);
		}
		
		public function reset():void {
			this.icon.bitmapData=null;
			this.isEmpty=true;
		}
		public function set numberLbl(num:int):void {
			this.numLbl.text=num.toString();
		}
		
		 public function setIcon(bmd:BitmapData):void{
			this.icon.bitmapData=bmd;
			this.isEmpty=false;
		}
		 
		 public function get cionBtd():BitmapData{
			 return this.icon.bitmapData;
		 }
		 
		 public function get gridType():String{
			 return this._gridType;
		 }
		 
		 public function set selectSta(str:Boolean):void{
			 this.selectImg.visible=str;
		 }
	}
}