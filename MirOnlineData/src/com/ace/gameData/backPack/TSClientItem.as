package com.ace.gameData.backPack {

	import com.ace.utils.ByteArrayUtil;

	import flash.utils.ByteArray;

	//背包道具-服务端协议用
	public class TSClientItem {
		public var MakeIndex:int;
		public var wIndex:int;
		public var Dura:int;
		public var DuraMax:int;
		public var btValue:Array;
		public var Addvalue:Array;
		public var btType:int;
		public var nPrice:int;
		public var Name:String;
		public var boBind:int;

		public function TSClientItem(br:ByteArray) {
			this.MakeIndex=br.readInt();
			this.wIndex=br.readUnsignedShort();
			this.Dura=br.readUnsignedShort();
			this.DuraMax=br.readUnsignedShort();

			this.btValue=[];
			for (var i:int=0; i < 21; i++) {
				this.btValue.push(br.readByte());
			}
			ByteArrayUtil.amendmentPS(br, 4);
			this.Addvalue=[];
			for (var j:int=0; j < 4; j++) {
				this.Addvalue.push(br.readInt());
			}
			this.btType=br.readUnsignedByte();

			ByteArrayUtil.amendmentPS(br, 4);
			this.nPrice=br.readInt();

			var len:uint=br.readUnsignedByte();
			this.Name=br.readMultiByte(30, "gb2312");
//			br.position+=30 - len;

			this.boBind=br.readUnsignedByte();
		}
	}
}
/*
MakeIndex: Integer;
wIndex: Word;
Dura: Word;
DuraMax: Word;
btValue: array[0..20] of shortint;
Addvalue: array[0..3] of integer;
btType: Byte;
nPrice: integer;
//Holes: array[0..3] of THoleItem;
Name: string[30];
boBind: byte;
*/










