package com.ace.gameData.table {

	/*
	idx	NAME	Stdmode(道具类型)	Shape这个属性(显示衣服穿上得样子)	Weight	Anicount	Source	Reserved
	Looks	DuraMax物件持久	AC	AC2	Mac	Mac2	DC	DC2	MC	MC2	SC	SC2	Need	NeedLevel	Price
	Stock	LimitCheck	Note	Throw堆叠数
	*/
	public class TItemInfo {
		public var id:int;
		public var name:String;
		public var type:int;
		public var shape:int;
		public var weight:int;
		public var triggerId:int;
		public var source:int;
		public var reserved:int;
		public var appr:int;
		public var durableMax:int;
		public var ac:int; //物理防御
		public var ac2:int;
		public var mac:int;
		public var mac2:int;
		public var dc:int; //攻击下限
		public var dc2:int;
		public var mc:int; //魔法
		public var mc2:int;
		public var sc:int; //道术
		public var sc2:int;
		public var limitType:int; /*表示限制种类：		0 为等级限制、1 为攻击限制、2 为魔法限制、3 为道术限制*/
		public var limitLevle:int;
		public var price:int;
		public var stock:int;
		public var limitCheck:int; //转为2 进制，依次为：禁止爆出、禁止脱下、静止出售、禁止修理、禁止存仓、禁止交易、禁止仍地、禁止日志
		public var note:String;
		public var stackNum:int; //堆叠

		public function TItemInfo(info:XML) {
			if (info == null)
				return;
			this.id=info.@id;
			this.name=info.@name;
			this.type=info.@type;
			this.shape=info.@shape;
			this.weight=info.@weight;
			this.triggerId=info.@triggerId;
			this.source=info.@source;
			this.reserved=info.@reserved;
			this.appr=info.@appr;
			this.durableMax=info.@durableMax;
			this.ac=info.@ac;
			this.ac2=info.@ac2;
			this.mac=info.@mac;
			this.mac2=info.@mac2;
			this.dc=info.@dc;
			this.dc2=info.@dc2;
			this.mc=info.@mc;
			this.mc2=info.@mc2;
			this.sc=info.@sc;
			this.sc2=info.@sc2;
			this.limitType=info.@limitType;
			this.limitLevle=info.@limitLevle;
			this.price=info.@price;
			this.stock=info.@stock;
			this.limitCheck=info.@limitCheck;
			this.note=info.@note;
			this.stackNum=info.@stackNum;
		}

		public function cloneSelf():TItemInfo {
			var info:TItemInfo=new TItemInfo(null);
			info.ac=this.ac;
			info.ac2=this.ac2;
			info.appr=this.appr;
			info.dc=this.dc;
			info.dc2=this.dc2;
			info.durableMax=this.durableMax;
			info.id=this.id;
			info.limitCheck=this.limitCheck;
			info.limitLevle=this.limitLevle;
			info.limitType=this.limitType;
			info.mac=this.mac;
			info.mac2=this.mac2;
			info.mc=this.mc;
			info.mc2=this.mc2;
			info.name=this.name;
			info.note=this.note;
			info.price=this.price;
			info.reserved=this.reserved;
			info.sc=this.sc;
			info.sc2=this.sc2;
			info.shape=this.shape;
			info.source=this.source;
			info.stackNum=this.stackNum;
			info.stock=this.stock;
			info.triggerId=this.triggerId;
			info.type=this.type;
			info.weight=this.weight;
			return info;
		}
	}
}
