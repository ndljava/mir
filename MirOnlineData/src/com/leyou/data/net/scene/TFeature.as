package com.leyou.data.net.scene {
	import com.ace.gameData.player.FeatureInfo;
	import com.ace.utils.HexUtil;


	public class TFeature {
		public var suit:int;
		public var weapon:int;
		public var hair:int;
		public var effect:int;
		public var mount_hair:int;
		public var mount_suit:int;
		public var mount:int;
		public var appr:int;
		public var avtArr:Array;

		public var sex:int;
		public var type:int;

		private var _feature:int;
		private var _featureEx:int;

		public function TFeature() {
		}

		public function set featureEx(value:int):void {
			_featureEx=value;
			this.mount=HexUtil.LoByte(HexUtil.LoWord(value));
			this.effect=HexUtil.HiByte(HexUtil.LoWord(value));
		}


		public function set feature(value:int):void {
			_feature=value;

			var hair:int=value >> 16 & 0xFF;
			var body:int=(value >> 16) >> 8;
			var weapon:int=(value >> 8) & 0xFF;


			/*
			m_btRace     := RACEfeature(cfeature);         //种族
			m_btHair     := HAIRfeature(cfeature);         //头发
			m_btDress    := DRESSfeature(cfeature);        //服装
			m_btWeapon   := WEAPONfeature(cfeature);       //武器
			m_wAppearance:= APPRfeature(cfeature);         //外貌
			*/

			this.type=HexUtil.LoByte(this._feature);
			this.hair=HexUtil.LoByte(HexUtil.HiWord(value));
			this.suit=HexUtil.HiByte(HexUtil.HiWord(value));
			this.weapon=HexUtil.LoByte(HexUtil.HiByte(value));
			this.appr=HexUtil.HiWord(value);


			this.mount=HexUtil.LoByte(HexUtil.LoWord(value));
			this.effect=HexUtil.HiByte(HexUtil.LoWord(value));


			this.specialCase();
		}

		//特例
		private function specialCase():void {
			switch (this.type) {
				case 0:
				case 1:
				case 150:
					this.sex=0;
					break;
				case 100:
				case 101:
				case 250:
					this.sex=1;
					this.type-=100;
					break;
				default:
					this.sex=0;
					break;
			}
		}

		public function copyTo(info:FeatureInfo):void {
			info.suit=this.suit;
			info.weapon=this.weapon;
			info.hair=this.hair;
			info.effect=this.effect;
			info.mount_hair=this.mount_hair;
			info.mount_suit=this.mount_suit;
			info.mount=this.mount;
			info.appr=this.appr;
		}

	}
}


