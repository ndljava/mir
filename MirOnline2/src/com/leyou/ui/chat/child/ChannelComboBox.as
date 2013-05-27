package com.leyou.ui.chat.child {

	import com.ace.enum.FontEnum;
	import com.ace.enum.KeysEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.SkinsManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.input.children.HideInput;
	import com.leyou.enum.ChatEnum;
	import com.leyou.manager.UIManager;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	public class ChannelComboBox extends Sprite {
		public var onClickItemFun:Function;

		private var itemArr:Vector.<MenuButton>;
		private var upBtn:ImgButton;
		private var comboxW:Number;
		private var comboxH:Number;
		private var bgSBM:ScaleBitmap;
		private var selectLabIdx:int;
		private var sta:Boolean;
		private var itemContain:Sprite;
		private var btnInput:HideInput;
		private var maxChar:int;
		private var type:String;

		private var chatLongNum:int;
		private var chatFlag:Boolean;

		public function ChannelComboBox(w:Number, h:Number, type:String="") {
			this.comboxW=w;
			this.comboxH=h;
			this.type=type;
			this.init();
		}

		private function init():void {

//			var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/other/combobox_arrowup.png");
//				bmp.scale9Grid=new Rectangle(2,2,10,10);
//				bmp.setSize(this.comboxW, bmp.height);

			var bmp:ScaleBitmap=new ScaleBitmap(SkinsManager.instance.getUIBmd("ComboBox_skin"));
			bmp.scale9Grid=SkinsManager.instance.getUIRect("ComboBox_skin");
			bmp.setSize(this.comboxW, bmp.height);
			this.upBtn=new ImgButton(bmp.bitmapData);
			this.upBtn.mouseChildren=true;
			this.addChild(upBtn);
			this.upBtn.addEventFn(MouseEvent.CLICK, onUpBtnClick);

			this.itemArr=new Vector.<MenuButton>
			this.itemContain=new Sprite();
			this.itemContain.addEventListener(MouseEvent.CLICK, onClickItem);
			this.addChild(this.itemContain);
			this.itemContain.visible=false;

			this.bgSBM=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.STYLE_NAME_DIC["PanelBgOut"]));
			this.bgSBM.scale9Grid=FontEnum.RECTANGLE_DIC["PanelBgOut"];
			this.itemContain.addChild(this.bgSBM);
			this.btnInput=new HideInput();
			//屏蔽事件
			this.btnInput.width=this.comboxW - 15;
			this.btnInput.stopKeyDownEvt();
//			this.btnInput.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.upBtn.addChild(this.btnInput);

			this.setBtnInputSta(false);
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			if (evt.keyCode != KeysEnum.ENTER && this.stage.focus == this.btnInput)
				this.chatLongNum=this.btnInput.text.length;
			if (evt.keyCode == KeysEnum.ENTER && this.stage.focus == this.btnInput) {
				if (this.chatLongNum < this.btnInput.text.length) {
					this.chatLongNum=this.btnInput.text.length;
					this.chatFlag=true;
				}
			}
			if (evt.keyCode == KeysEnum.ENTER) {
				if (!this.chatFlag && this.stage.focus == this.btnInput) {
					UIManager.getInstance().chatWnd.onStageEnter(false);
					this.chatFlag=false;
				} else
					this.chatFlag=false;
			}


			evt.stopImmediatePropagation();
			if (this.btnInput.text.indexOf("[") > -1)
				this.btnInput.text=this.btnInput.text.replace("[", "");
			if (this.btnInput.text.indexOf("]") > -1)
				this.btnInput.text=this.btnInput.text.replace("]", "");
			var btArr:ByteArray=new ByteArray();
			btArr.writeMultiByte(btnInput.text, "gb2312");
			if (btArr.length > maxChar * 2) {
				btArr.length=maxChar * 2;
				btArr.position=0;
				this.btnInput.text=btArr.readMultiByte(maxChar * 2, "gb2312");
				if (this.btnInput.text.indexOf("?") == this.btnInput.text.length - 1)
					this.btnInput.text=this.btnInput.text.replace("?", "");
			}
		}

		private function onKeyDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
		}

		private function onUpBtnClick(evt:MouseEvent=null):void {
			this.btnInput.htmlText=this.btnInput.htmlText;
			if (this.itemArr.length == 0) {
				sta=false;
				this.itemContain.visible=false;
				return;
			} else if (sta) {
				this.itemContain.visible=false;
				sta=false;
			} else {
				this.itemContain.visible=true;
				sta=true;
			}
		}

		private function onClickItem(evt:MouseEvent):void {
			if (this.itemArr.length == 0) {
				this.itemContain.visible=false;
				return;
			}
			this.onUpBtnClick();
			if (evt.target is MenuButton) {
				var name:int=int((evt.target as MenuButton).name);
				this.selectLabIdx=name;
				if (this.type == ChatEnum.COMBOX_CHAT_CHANNEL) {
					this.btnInput.text=this.itemArr[this.selectLabIdx].text.substring(this.itemArr[this.selectLabIdx].text.length - 2);
				} else
					this.btnInput.text=this.itemArr[this.selectLabIdx].text;
				this.btnInput.textColor=this.itemArr[this.selectLabIdx].labTextColor;
				this.btnInput.htmlText=getBtnLabText(this.btnInput.htmlText);
				if (onClickItemFun != null)
					onClickItemFun(name, this.itemArr[this.selectLabIdx].text);
			}
		}

		private function getBtnLabText(str:String):String {
			if (str.length == 1 && str.indexOf("/") != -1)
				return str;
			if (str.indexOf("/") != -1)
				return str.substring(0, str.indexOf("/")) + str.slice(str.indexOf("/") + 2);
			else
				return str;
		}

		/**
		 *添加内容
		 * @param str 内容
		 * @param lblColor 字体颜色
		 *
		 */
		public function setItem(str:Array, lblColor:Array):void {
			if (str == null)
				return;
			if (this.type == ChatEnum.COMBOX_CHAT_CHANNEL) {
				this.btnInput.text=(str[0] as String).substring((str[0] as String).length - 2);
				this.btnInput.htmlText=getBtnLabText(this.btnInput.text);
			} else
				this.btnInput.htmlText=getBtnLabText(str[0]);
			var format:TextFormat=new TextFormat();
			format.align=TextFormatAlign.LEFT;
			for (var i:int=str.length - 1; i >= 0; i--) {
				var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/other/button_font.png"));
				bmp.scale9Grid=new Rectangle(5, 5, 42, 15);
				bmp.setSize(this.comboxW, bmp.height);
				format.color=lblColor[i];
				var itemLbl:MenuButton=new MenuButton(bmp.bitmapData, str[i], this.comboxW, this.comboxH, format);
				itemLbl.name=i.toString();
				itemLbl.y=i * this.comboxH;
				this.itemContain.addChild(itemLbl);
				this.itemArr.unshift(itemLbl);
			}
			this.itemContain.y=this.upBtn.y - str.length * this.comboxH;
			this.bgSBM.setSize(this.comboxW, str.length * this.comboxH);
			this.selectLabIdx=0;
		}

		/**
		 *设置按钮的text
		 * @param idx
		 *
		 */
		public function setSelectTextByIdx(idx:int):void {
			this.selectLabIdx=idx;
			if (this.type == ChatEnum.COMBOX_CHAT_CHANNEL) 
				this.btnInput.text=this.itemArr[idx].text.substring(this.itemArr[idx].text.length - 2);
			else
				this.btnInput.text=this.itemArr[idx].text;
			this.btnInput.text=getBtnLabText(this.btnInput.text);
			this.setBtnInputColor(this.itemArr[idx].labTextColor);
		}

		/**
		 *返回当前选项的idx
		 * @return
		 *
		 */
		public function get selectIdx():int {
			return this.selectLabIdx;
		}

		/**
		 *返回按钮当前的text
		 * @return
		 *
		 */
		public function get btnText():String {
			return this.btnInput.text;
		}

		/**
		 *清除combox中的所有item
		 *
		 */
		public function clearItem():void {
			this.itemContain.visible=false;
			this.itemArr.length=0;
			this.btnInput.htmlText="";
		}

		/**
		 *按钮的输入框是否可输入
		 * @param sta true 可输入  false 不可输入
		 *
		 */
		public function setBtnInputSta(sta:Boolean):void {
			this.btnInput.mouseEnabled=sta;
			if (sta == true) {
				this.btnInput.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				this.btnInput.addEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
				this.btnInput.type=TextFieldType.INPUT;
			} else 
				this.btnInput.type=TextFieldType.DYNAMIC;

		}

		/**
		 *设置按钮上的字符的颜色
		 * @param c
		 *
		 */
		public function setBtnInputColor(c:uint):void {
			this.btnInput.textColor=c;
		}

		/**
		 *隐藏 显示item 项
		 * @param sta
		 *
		 */
		public function setItemSta(sta:Boolean):void {
			this.itemContain.visible=sta;
			this.sta=sta;
		}

		public function setInputMaxChar(num:int):void {
//			this.btnInput.maxChars=num;
			this.maxChar=num;
		}

		public function setFocs():void {
			this.stage.focus=this.btnInput;
		}
	}
}