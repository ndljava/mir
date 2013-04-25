package com.leyou.ui.chat.child {
	import com.ace.ui.img.child.Image;
	import com.leyou.enum.ChatEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class RichTextFiled extends Sprite {
		private var w:Number;
		private var h:Number;

		private var textFiled:TextField;
		private var spContain:Sprite;
		private var PLACEHOLDER:String="-";
		private var spriteMap:Array;
		private var imgFlg:Boolean; //是否需要图文混排
		private var overObj:Object;

		public var onTextClick:Function;


		public function RichTextFiled(w:Number, h:Number, flag:Boolean=true) {
			this.w=w;
			this.h=h;
			this.imgFlg=flag;

			this.textFiled=new TextField();
			this.textFiled.width=w - 10;
			this.textFiled.x=3;
			this.textFiled.useRichTextClipboard=true;
			this.textFiled.multiline=true;
			this.textFiled.wordWrap=true;
			this.textFiled.selectable=false;
			this.textFiled.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(this.textFiled);
			if (this.imgFlg) {
				this.spContain=new Sprite();
				this.addChild(this.spContain);
				this.spContain.mouseChildren=false;
				this.spContain.mouseEnabled=false;
				this.textFiled.addEventListener(TextEvent.LINK, this.linkHandler);
				this.textFiled.addEventListener(MouseEvent.MOUSE_DOWN, this.linkHandler);
				this.textFiled.addEventListener(MouseEvent.MOUSE_OVER, this.onTextOver);
				this.textFiled.addEventListener(MouseEvent.MOUSE_OUT, this.onTextOut);
			}
			this.spriteMap=new Array();
		}

		public function clearContain():void {
			this.clear();
		}

		public function appendHtmlText(str:String):void {
			this.appendRichText(str);
		}

		private function appendRichText(str:String):void {
			this.textFiled.htmlText+=str;
			this.textFiled.height=this.height;
			if (this.imgFlg) {
				this.convert();
			}
		}

		private function clear():void {
			if (imgFlg) {
				while (this.spContain.numChildren) {
					this.spContain.removeChildAt(0);
				}
			}
			this.textFiled.htmlText="";
			this.overObj=null;
		}

		private function convert():void {
			var _replaceStr:String=PLACEHOLDER;
			var _strLen:int;
			var _id:int;
			var _index:int;
			var _iconStr:String;
			var _iconInfo:Object;
			while (_index != -1) {
				_iconInfo=getIconInfo(this.textFiled.text);
				_index=_iconInfo.index;
				if (_index != -1) {
					_strLen=_iconInfo.iconStr.length;
					this.textFiled.replaceText(_iconInfo.index, _iconInfo.index + _strLen, _replaceStr);
					this.refreshArr(_index, _replaceStr.length - 3);
					this.addIcon(_iconInfo);
				}
			}
		}

		//refresh
		private function refreshArr(index:int, num:int, isSetSelection:Boolean=true):void {
			var _arr:Array=this.spriteMap;
			var _len:int=_arr.length;
			var _info:Object;
			for (var i:int=0; i < _len; i++) {
				_info=_arr[i];
				if (_info) {
					if (_info.index >= index) {
						_info.index+=num;
					}
				}
			}
			if (num != 0) {
				if (isSetSelection)
					this.textFiled.setSelection(this.textFiled.caretIndex + num, this.textFiled.caretIndex + num);
			}
		}

		private function refresh():void {
			var _arr:Array=this.spriteMap;
			var _len:int=_arr.length;

			var _info:Object;
//			var _item:Sprite;
			var _item:Image;
			var _rect:Rectangle;

			var _txtLineMetrics:TextLineMetrics;
			var _lineHeight:int;
			while (_len--) {
				_info=_arr[_len];
				if (_info) {
					_item=_info.item;
					if (_item) {
						_rect=this.textFiled.getCharBoundaries(_info.index);
						if (_rect) {
							_txtLineMetrics=this.textFiled.getLineMetrics(this.textFiled.getLineIndexOfChar(_info.index));
							_lineHeight=_rect.height * 0.5 > 25 ? _txtLineMetrics.ascent - 25 : (_rect.height - 25) * 0.5; // _txtLineMetrics.ascent ;// + _txtLineMetrics.descent * 0.5;
							_item.visible=true;
							_item.x=_rect.x;
							_item.y=_rect.y + _lineHeight + 5;

						} else {
							_item.visible=false;
						}
					}
				}
			}
			this.setContainerPos();
		}

		private function setContainerPos():void {
			var _txtPos:Object=this.getTextFieldPos();
			this.spContain.x=this.textFiled.x + _txtPos.x;
			this.spContain.y=this.textFiled.y + _txtPos.y;
		}

		private function getTextFieldPos():Object {
			var _xpos:Number=this.textFiled.scrollH;
			var _n:int=this.textFiled.scrollV - 1;
			var _ypos:Number=0;
			while (_n--) {
				_ypos+=this.textFiled.getLineMetrics(_n).height;
			}
			return {x: -_xpos, y: -_ypos};
		}

		private function getIconInfo(str:String):Object {
			var _index:int=-1;
			var _id:int=-1;
			var _info:Object={index: -1, iconStr: ""};
			for (var i:int=0; i < ChatEnum.imgKeyArr.length; i++) {
				_index=str.indexOf("\\" + ChatEnum.imgKeyArr[i]);
				if (_index != -1) {
					_id=_index;
					_info.index=_index;
					_info.iconStr="\\" + ChatEnum.imgKeyArr[i];
//					_info.iconUrl="\\" + img[i];
//					_info.iconType="\\" + img[i];
					break;
				}
			}
			return _info;
		}

		private function addIcon(iconInfo:Object):void {
			var _id:int;
			var str:String=iconInfo.iconStr;
			str=str.replace("\\", "");
//			this.spriteMap.push({item: item, iconStr: iconInfo.iconStr, iconType: iconInfo.iconType, iconUrl: iconInfo.iconUrl, index: iconInfo.index, textFormat: null, status: STATUS_INIT});
//			var item:Sprite=new Sprite();
			var img:Image=new Image();
			img.updateBmp("ui/chat/face/" + int(str) + ".png");
//			item.addChild(img);
			this.spriteMap.push({item: img, iconStr: iconInfo.iconStr, index: iconInfo.index});
			_id=this.spriteMap.length - 1;
			this.spContain.addChild(img);
			this.setFormat(_id);
			this.refresh();

		}

		private function setFormat(id:int):void {
			var _format:TextFormat;
//			var _item:Sprite;
			var _item:Image;
			var _rec:Rectangle;
//			var _info:Object=this.spriteMap[id];

			_item=this.spriteMap[id].item;
			_format=new TextFormat();
			_format.size=_item.height + 2;
			_format.letterSpacing=15;
			_format.color=0x272220;
			this.textFiled.setTextFormat(_format, this.spriteMap[id].index);
		}


		private function linkHandler(evt:Event):void {
			if (evt is MouseEvent) {
				var target:TextField=evt.currentTarget as TextField;
				if (!target)
					return;
				var ishit:Boolean=this.stage.hitTestObject(target);
				var n:int=target.getCharIndexAtPoint(target.mouseX, target.mouseY);
				if (n > 0 && n < target.text.length && target.getTextFormat(n, n + 1).url != null)
					ishit=false;
				if (ishit) {
					evt.stopPropagation();
				}

			} else if (evt is TextEvent) {
				if (this.onTextClick != null) {
					this.onTextClick((evt as TextEvent).text);

				}
			}
		}

		private function onTextOver(evt:MouseEvent):void {
			if (!this.textFiled.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.textFiled.addEventListener(MouseEvent.MOUSE_MOVE, onTextMove);
		}

		private function onTextMove(evt:MouseEvent):void {
			if (this.overObj && this.overObj.format) {
				this.textFiled.setTextFormat(this.overObj.format, this.overObj.start, this.overObj.end);
				this.overObj=null;
			}
			var target:TextField=evt.currentTarget as TextField;
			if (!target)
				return;
			var ishit:Boolean=this.stage.hitTestObject(target);
			var n:int=target.getCharIndexAtPoint(target.mouseX, target.mouseY);
			if (n > 0) {
				var url:String=target.getTextFormat(n, n + 1).url;
				if (url != null && url!= "") {
					url=url.substring(6);
					n=target.getLineIndexAtPoint(target.mouseX, target.mouseY);
					var lineLong:int=target.getLineLength(n); //行的字符长度
					var lineStartIdx:int=target.getLineOffset(n); //第一个字符的索引
					var str:String=target.getLineText(n); //行的字符
					var startIdx:int=lineStartIdx + str.indexOf(url);
					var endIdx:int=startIdx + url.length;
					var textFormat:TextFormat=target.getTextFormat(startIdx, endIdx);
					this.overObj=new Object();
					this.overObj={start: startIdx, end: endIdx, format: textFormat};
					var f:TextFormat=new TextFormat();
					f.color=0xffff00;
					f.underline=true;
					target.setTextFormat(f, startIdx, endIdx);
				}
			}
		}

		private function onTextOut(evt:MouseEvent):void {
			if (this.overObj && this.overObj.format) {
				this.textFiled.setTextFormat(this.overObj.format, this.overObj.start, this.overObj.end);
				this.overObj=null;
			}
			if (this.textFiled.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.textFiled.removeEventListener(MouseEvent.MOUSE_MOVE, onTextMove);
		}

	}
}