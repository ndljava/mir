package com.leyou.data.net.shop {
	import flash.utils.ByteArray;

	public class TStdItem {
		public var Name:String; //物品名称
		public var StdMode:uint; //物品分类 0/1/2/3：药， 5/6:武器，10/11：盔甲，15：头盔，22/23：戒指，24/26：手镯，19/20/21：项链
		public var Shape:uint; //装配外观
		public var Weight:uint; //重量
		public var AniCount:uint;
		public var Source:int; //源动力
		public var Reserved:uint; //保留
		public var NeedIdentify:uint; //需要记录日志
		public var Looks:uint; //外观，即Items.WIL中的图片索引
		public var DuraMax:uint; //最大持久
		public var Reserved1:uint; //发光属性
		public var AC:int; //0x1A
		public var MAC:int; //0x1C
		public var DC:int; //0x1E
		public var MC:int; //0x20
		public var SC:int; //0x22
		public var Need:int; //0x24
		public var NeedLevel:int; //0x25
		public var Price:int; //价格
		public var Stock:int; //库存 20080610    金牛装备 内力恢复速度 点数
		public var isStack:uint; //是否叠加物品  //20101102
		public var LimitCheck:uint;
		public var power:uint;
		public var zl:uint, ll:uint, tz:uint, tp:uint, ds:uint;
		public var HP:int, MP:int;
		public var Exp:int;
		public var color:uint;
		public var HeroZM:uint, HeroGjsh:uint, HeroWlsh:uint, Heromfsh:uint, HeroShft:uint, HeroHsfy:uint, HeroExp:uint;
		public var HeroTz:uint;
		public var AddAC:int, ADDMAC:int, ADDDC:int, ADDMC:int, ADDSC:int;
		public var Appraisal:uint;

		public function TStdItem(br:ByteArray) {
			this.Name=br.readMultiByte(br.readByte(), "gb2312");
			br.position=31;
			this.StdMode=br.readByte();
			this.Shape=br.readByte();
			this.Weight=br.readByte();
			this.AniCount=br.readByte();

			this.Source=br.readInt();
			this.Reserved=br.readByte();
			this.NeedIdentify=br.readByte();
			this.Looks=br.readUnsignedShort();
			this.DuraMax=br.readUnsignedShort();
			this.Reserved1=br.readUnsignedShort();
			this.AC=br.readInt();
			this.MAC=br.readInt();
			this.DC=br.readInt();
			this.MC=br.readInt();
			this.SC=br.readInt();
			this.Need=br.readInt();
			this.NeedLevel=br.readInt();
			this.Price=br.readInt();
			this.Stock=br.readInt();
			this.isStack=br.readUnsignedShort();
			this.LimitCheck=br.readByte();
			this.power=br.readByte();
			this.zl=br.readByte();
			this.ll=br.readByte();
			this.tz=br.readByte();
			this.tp=br.readByte();
			this.ds=br.readByte();
			this.HP=br.readInt();
			this.MP=br.readInt();
			this.Exp=br.readInt();
			this.color=br.readByte();
			this.HeroZM=br.readByte();
			this.HeroGjsh=br.readByte();
			this.HeroWlsh=br.readByte();
			this.Heromfsh=br.readByte();
			this.HeroShft=br.readByte();
			this.HeroHsfy, HeroExp=br.readByte();
			this.HeroTz=br.readUnsignedShort();
			this.AddAC=br.readInt();
			this.ADDMAC=br.readInt();
			this.ADDDC=br.readInt();
			this.ADDMC=br.readInt();
			this.ADDSC=br.readInt();
			this.Appraisal=br.readByte();
		}
	}
}