package com.leyou.data.net.role {
	import com.ace.gameData.backPack.TSClientItem;
	import com.ace.gameData.player.FeatureInfo;
	import com.ace.utils.ByteArrayUtil;
	import com.ace.utils.HexUtil;
	import com.leyou.data.net.scene.TFeature;

	import flash.utils.ByteArray;

	public class TUserStateInfo {
		public var feature:FeatureInfo;
		public var UserName:String;
		public var NAMECOLOR:uint;
		public var GuildName:String;
		public var GuildRankName:String;
		public var UseItems:Vector.<TSClientItem>; //20080417 支持斗笠,0..12改0..13

		public function TUserStateInfo(br:ByteArray) {
			this.feature=new FeatureInfo();
			this.UseItems=new Vector.<TSClientItem>;

			var f:TFeature=new TFeature();
			f.feature=br.readInt();
			f.copyTo(this.feature);
			var len:int;
			len=br.readByte();
			this.UserName=br.readMultiByte(14, "gb2312");
			ByteArrayUtil.amendmentPS(br, 4);
			this.NAMECOLOR=br.readUnsignedInt();
			len=br.readByte();
			this.GuildName=br.readMultiByte(14, "gb2312");
			len=br.readByte();
			this.GuildRankName=br.readMultiByte(16, "gb2312");
//			while (br.position < br.length - 88-30) {
			for (var i:int=0; i < 13; i++) {
				this.UseItems.push(new TSClientItem(br));
			}
		}
	}
}


/*
feature: Integer;
UserName: string[ACTORNAMELEN];
NAMECOLOR: DWord;
GuildName: string[ACTORNAMELEN];
GuildRankName: string[16];
UseItems: array[0..12] of TSClientItem;//20080417 支持斗笠,0..12改0..13
*/