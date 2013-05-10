package com.ace.gameData.backPack {
	import com.ace.gameData.table.TItemInfo;
	import com.ace.utils.HexUtil;

	//背包道具信息
	public class TClientItem {
		public var s:TItemInfo
		public var MakeIndex:int;
		public var Dura:int;
		public var DuraMax:int;
		public var Addvalue:Array;
		public var btType:int;
		public var nPrice:int;
		public var Holes:Array;
		public var Name:String;
		public var boBind:int;
		public var sTime:String;
		public var isJustFill:Boolean;

		public function TClientItem(fill:Boolean=false) {
			this.isJustFill=fill;
			this.Addvalue=[];

			this.Holes=[];
			for (var i:int=0; i < 4; i++) {
				this.Holes.push(0);
			}
		}

		public function copyScu(info:TSClientItem, isStall:Boolean=false):void {

			this.MakeIndex=info.MakeIndex;
			this.Dura=info.Dura;
			this.DuraMax=info.DuraMax;
			this.boBind=info.boBind;
			this.Name=info.Name;
			this.nPrice=info.nPrice;

			for (var i:int=0; i < info.Addvalue.length; i++) {
				this.Addvalue[i]=info.Addvalue[i];
			}

			//如果是行会仓库里的
			if (isStall) {
				this.btType=info.btValue[14] + 99;
				if (info.btValue[14] == 5) {
					this.btType=106;
				}
				if ((info.btValue[14] == 1) || (info.btValue[14] == 3)) {
					this.nPrice=HexUtil.MakeLong(info.btValue[15], info.btValue[16]);
				}
			}
		}
	}
}

/*
s: TStdItem;
MakeIndex: Integer;
Dura: Word;
DuraMax: Word;
Addvalue: array[0..3] of integer;
btType: Byte;         //100=行会贡献类物品
nPrice: integer;
Holes: array[0..3] of THoleItem;
Name: string[30];
boBind: Byte;
sTime: string;

*/