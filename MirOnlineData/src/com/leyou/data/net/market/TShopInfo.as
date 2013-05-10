package com.leyou.data.net.market {
	import com.ace.utils.HexUtil;
	import com.leyou.data.net.shop.TStdItem;
	
	import flash.utils.ByteArray;

	public class TShopInfo {
		public var stdInfo:TStdItem;
		public var sIntroduce:String;//类似tip
		public var idx:String;
		public var imgBegin:String;
		public var imgEnd:String;
		public var Introduce1:String;

		public function TShopInfo(br:ByteArray) {
//			HexUtil.toHexDump("商城里的道具：", br, 0, br.bytesAvailable);
			this.stdInfo=new TStdItem(br);
			br.position++;//135开始
			
			
			this.sIntroduce=br.readMultiByte(201, "gb2312");
//			br.position++;
			this.idx=br.readMultiByte(2, "gb2312");
			this.imgBegin=br.readMultiByte(6, "gb2312");
			this.imgEnd=br.readMultiByte(6, "gb2312");
			this.Introduce1=br.readMultiByte(21, "gb2312");
		}
	}
}



/*
TShopInfo = record//商铺物品
StdItem: TStdItem;
sIntroduce:array [0..200] of Char;
Idx: string[1];
ImgBegin: string[5];
Imgend: string[5];
Introduce1:string[20];
end;
*/