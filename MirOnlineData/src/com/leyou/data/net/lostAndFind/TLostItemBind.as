package com.leyou.data.net.lostAndFind {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.utils.ByteArrayUtil;
	import com.ace.utils.HexUtil;
	
	import flash.utils.ByteArray;

	public class TLostItemBind {
		public var UserItem:TUserItem;
		public var sBindName:String;
		public var sSendUserItem:String;
		public var sTime:String;

		public function TLostItemBind(br:ByteArray) {
			this.UserItem=new TUserItem(br);
			ByteArrayUtil.amendmentPS(br, 4);
			br.readByte();
			this.sBindName=br.readMultiByte(20, "gb2312");
			br.readByte();
			this.sSendUserItem=br.readMultiByte(20, "gb2312");
			br.readByte();
			this.sTime=br.readMultiByte(19, "gb2312");
		}

	}
}


/*
 *
UserItem: TUserItem;
sBindName: string[20];//玩家名称
sSendUserItem: string[20];
sTime: String[19];
*/
