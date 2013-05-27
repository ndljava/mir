package com.leyou.ui.role {
	import com.ace.enum.ItemEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.data.net.role.TNakedAbility;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.utils.TipsUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextExtent;
	import flash.text.TextField;

	public class PointDistributionWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var splitHSlider:HSlider;
		private var numStep:TextInput;
		private var img:Image;

		private var lblI:Label;
		private var lblII:Label;
		private var pointedTexf:TextField;
		private var point:int;
		private var afterPoint:int;
		private var preKey:int;
		private var addInfo:TNakedAbility;

		public function PointDistributionWnd() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd02.xml"));
			this.init();
		}

		private function init():void {
			this.allowDrag=false;
			this.titleLbl.text="属性分配";
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.splitHSlider=this.getUIbyID("splitHSlider") as HSlider;
			this.numStep=this.getUIbyID("numStep") as TextInput;
			this.numStep.closeEvent();
			this.numStep.restrict="0-9";
			this.numStep.input.maxChars=10;
			this.numStep.input.addEventListener(Event.CHANGE, onKeyUp);

			this.img=this.getUIbyID("img") as Image;
			this.img.visible=false;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.splitHSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);

			this.lblI=new Label();
			this.lblI.x=23;
			this.lblI.y=51;
			this.addChild(this.lblI);

			this.lblII=new Label();
			this.lblII.text="此项已分配属性点";
			this.lblII.x=23;
			this.lblII.y=72;
			this.addChild(this.lblII);

			this.pointedTexf=new TextField();
			this.pointedTexf.x=134;
			this.pointedTexf.y=72;
			this.pointedTexf.height=20;
			this.addChild(this.pointedTexf);
			this.pointedTexf.text="40";
			this.pointedTexf.width=60;
			this.pointedTexf.textColor=0xffffff;
			this.pointedTexf.addEventListener(MouseEvent.MOUSE_OVER, onTextFiledOver);
			this.pointedTexf.addEventListener(MouseEvent.MOUSE_OUT, onTextFiledOut);

			this.addInfo=new TNakedAbility();
		}

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "confirmBtn": //确定按钮
//					UIManager.getInstance().roleWnd.addInfo(int(this.numStep.text), this.afterPoint);
					if (this.numStep.text != "")
						UIManager.getInstance().roleWnd.addInfoSure();
					this.hide();
					break;
				case "cancelBtn":
					this.numStep.text="0";
					this.afterPoint=this.point;
					UIManager.getInstance().roleWnd.addInfo(int(this.numStep.text), this.afterPoint);
					this.hide();
					break;
			}
//			UIManager.getInstance().roleWndI.addInfo(int(this.numStep.text),this.afterPoint);
			UIManager.getInstance().roleWnd.setCurrentPoint();
		}

		public function updateInfo(perP:int, porperN:String, pointed:int):void {
			this.lblI.htmlText=TipsUtil.getColorStr("每", TipsEnum.COLOR_GOLD) + TipsUtil.getColorStr(perP + "点", TipsEnum.COLOR_GREEN) + TipsUtil.getColorStr("属性点可转化", TipsEnum.COLOR_GOLD) + TipsUtil.getColorStr("1点" + porperN, TipsEnum.COLOR_RED);
			this.pointedTexf.text=pointed.toString();
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			this.numStep.text="";
			this.point=UIManager.getInstance().roleWnd.pointKey;
		}

		override public function hide():void {
			super.hide();
			this.numStep.text="0";
			this.afterPoint=this.point;
			UIManager.getInstance().roleWnd.addInfo(int(this.numStep.text), this.afterPoint);
			UIManager.getInstance().roleWnd.setCurrentPoint();
			this.x=0;
			this.y=0;

		}

		public function clear():void{
			this.numStep.text="0";
			this.afterPoint=this.point;
			UIManager.getInstance().roleWnd.addInfo(int(this.numStep.text), this.afterPoint);
			UIManager.getInstance().roleWnd.setCurrentPoint();
		}
		public function updatePoint(p:Point):void{
			this.x=p.x;
			this.y=p.y;
		}
		
		private function onChange(evt:Event):void {
//			this.splitHSlider.progress
		}

		private function onTextFiledOver(evt:MouseEvent):void {
			ItemTip.getInstance().showString(TipsUtil.getColorStr("已用点数不可重新分配\n在分配时要谨慎选择。", TipsEnum.COLOR_YELLOW));
			var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
			ItemTip.getInstance().updataPs(p.x, p.y);
		}

		private function onTextFiledOut(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
		}

		private function onKeyUp(evt:Event):void {
			evt.stopImmediatePropagation();
			if (int(this.numStep.text) > this.point)
				this.numStep.text=this.point.toString();
			this.afterPoint=this.point - int(numStep.text);
			UIManager.getInstance().roleWnd.addInfo(int(numStep.text), this.afterPoint);

		}
		
		
		
		
		
	}
}