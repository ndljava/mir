package com.leyou.data.net.lostAndFind {
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.backPack.TSClientItem;

	import flash.utils.ByteArray;

	public class TUserItem {
		public var MakeIndex:int;
		public var wIndex:int;
		public var Dura:int;
		public var DuraMax:int;
		public var btValue:Array;
		public var AddValue:Array;

		private var tc:TClientItem;

		public function TUserItem(br:ByteArray) {
			this.MakeIndex=br.readInt();
			this.wIndex=br.readUnsignedShort();
			this.Dura=br.readUnsignedShort();
			this.DuraMax=br.readUnsignedShort();

			this.btValue=[];
			for (var i:int=0; i < 21; i++) {
				this.btValue.push(br.readByte());
			}

			this.AddValue=[];
			for (var j:int=0; j < 4; j++) {
				this.AddValue.push(br.readInt());
			}

			if (tc == null)
				tc=new TClientItem();
		}

		public function toTClientItem():TClientItem {

			tc.Addvalue=this.AddValue;
			tc.MakeIndex=this.MakeIndex;
			tc.Dura=this.Dura;
			tc.DuraMax=this.DuraMax;
			//			tc.btType=

			tc.s=TableManager.getInstance().getItemInfo(this.wIndex - 1);
			
			return tc;
		}

	}
}


/*
 *

MakeIndex: Integer;
wIndex: Word; //物品id
Dura: Word; //当前持久值
DuraMax: Word; //最大持久值
btValue: array[0..20] of Byte;		//附加属性:9-(升级次数)装备等级 12-发光(1为发光,0不发光,2聚灵珠不能聚集),13-自定义名称,14-禁止扔,15-禁止交易,16-禁止存,17-禁止修,18-禁止出售,19-禁止爆出 20-吸伤(聚灵珠,1-开始聚经验,2-聚结束)
															//11-未使用 8-神秘物品 10-武器升级设置(1-破碎 10-12增加DC, 20-22增加MC，30-32增加SC)
AddValue: array[0..3] of integer; 	//LowWord[0]-叠加物品数 HiWord[0]-装备星星数量
									//HiWord[1]- 技能威力
									//loWord[2] - 孔数量  HiWord[2]=1,装备刻名
									//loword[3] - 为计时物品



*/
