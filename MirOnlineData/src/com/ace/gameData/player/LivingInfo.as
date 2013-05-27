package com.ace.gameData.player {
	import com.ace.astarII.child.INode;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.tools.print;

	import flash.geom.Point;


	public class LivingInfo extends LivingBaseInfo {

		public var id:int;
		public var livingType:int;
		public var type:int; //种族 人、怪、npc
		private var _name:String;
		public var sex:int=1; //
		public var race:int; //职业
		public var level:int;


		public var featureInfo:FeatureInfo; //avatar信息
		public var baseInfo:PlayerBasicInfo; //基本信息
		public var exInfo:PlayerExtendInfo; //附加信息
		public var equips:Vector.<TClientItem>; //装备信息


		public var stallName:String; //摆摊名称
		public var status:uint; //盾牌

		public var isOnMount:Boolean; //是否在马上
		public var isStall:Boolean; //是否摆摊

		public var nameArr:Array;


		public function LivingInfo($info:LivingInfo=null) {
			this.init();
			$info && this.copyInfo($info);
		}

		public function get name():String {
			return _name;
		}

		//[face101\认证商人\钻石会员\★★★★★★★★★★\行会名字七个字≮掌门人≯\face882的老婆\face91的师父/241]
		public function set name(value:String):void {
			value=value.split("/")[0]; //把\255去掉
			if (value == null)
				return;
			if (value.indexOf("\\") != -1) {
				this.nameArr=value.split("\\");
			} else {
				this.nameArr=value.split("|");
			}

			this._name=this.nameArr[0];
		}

		/**
		 * 会员
		 * @return
		 *
		 */
		public function get member():String {
			return this.nameArr[2] || "";
		}

		public function get isMember():Boolean {
			if (this.member == "" || this.member == null)
				return false;
			else
				return true;
		}

		private function copyInfo($info:LivingInfo):void {
			this.id=$info.id;
			this.name=$info.name;
			this.nameArr=$info.nameArr;
			if (this.name == null)
				this.name="";
			this.currentDir=$info.currentDir;
			this.nextTile.x=$info.nextTile.x;
			this.nextTile.y=$info.nextTile.y;
			this.race=$info.race;

			this.sex=$info.sex;
			this.type=$info.type; //种族
			this.livingType=$info.livingType;

			this.featureInfo=$info.featureInfo;
		}

		protected function init():void {
			this.baseInfo=new PlayerBasicInfo();
			this.exInfo=new PlayerExtendInfo();
			this.initEquips();

			this.featureInfo=new FeatureInfo();
			this.moveLocked=false;
			this.pathArr=new Vector.<INode>;
			this.nextPt=new Point();
			this.nextTile=new Point();
			this.speed=PlayerEnum.SPEED_WALK;
			this.currentAct=""; //添加默认动作  设置为空，因为城门上来的时候方向动作相同
		}

		private function initEquips():void {
			this.equips=new Vector.<TClientItem>;
			for (var i:int=0; i < 15; i++) {
				this.equips.push(new TClientItem(true));
			}
		}

		public function get currentDir():int {
			return _currentDir;
		}

		public function set currentDir(value:int):void {
			if (value == -1) {
				throw new Error("方向错误");
			}
			_currentDir=value;
		}

		public function get hp():int {
			return this.baseInfo.HP;
		}

		public function set hp(value:int):void {
			this.baseInfo.HP=value;
		}

		public function get mp():int {
			return this.baseInfo.MP;
		}

		public function set mp(value:int):void {
			this.baseInfo.MP=value;
		}

		public function get isDead():Boolean {
			return this.hp == 0;
		}

		public function set isDead(value:Boolean):void {
			if (value)
				this.hp=0;
		}


		public var preMount:int=0;

		public function updataAvatar(info:FeatureInfo):void {
			this.featureInfo=info;
			if (this.preMount != 0) {
				this.featureInfo.mount=this.preMount;
				this.preMount=0;
			}
			//			this.isOnMount=(this.featureInfo.mount == 0) ? false : true;
			this.isStall=false;
			if (this.featureInfo.mount == 0) {
				this.isOnMount=false;
			} else {
				if (this.featureInfo.mount == 100) {
					this.isStall=true;
					this.moveLocked=true;
				} else {
					this.isOnMount=true;
				}
			}
			this.moveLocked=this.isStall;
		}

		public function get avtArr():Array {
			return [this.featureInfo.suit * 2 + this.sex, this.featureInfo.weapon * 2 + this.sex, this.featureInfo.hair, this.getEffectId(), //
				this.featureInfo.hair, this.getMount_suit(), this.featureInfo.mount - 1];
		}




		//==================================龙信的=====================
		//==================================龙信的=====================
		private function getEffectId():int {
//			trace("玩家名称：" + this.name + "---" + this.featureInfo.effect);
			if (this.featureInfo.effect == 0)
				return 999;


//			return 0;
			switch (this.featureInfo.effect) {
				case 8:
					if (this.sex == PlayerEnum.SEX_BOY) {
						return 14;
					} else if (this.sex == PlayerEnum.SEX_GIRL) {
						return 15;
					}
					break;
				case 3:
					if (this.sex == PlayerEnum.SEX_BOY) {
						return 4;
					} else if (this.sex == PlayerEnum.SEX_GIRL) {
						return 5;
					}
					break;
				case 1:
					if (this.sex == PlayerEnum.SEX_BOY) {
						return 0;
					} else if (this.sex == PlayerEnum.SEX_GIRL) {
						return 1;
					}
					break;
			}

			return 999;
		}

		private function getMount_suit():int {
			if (this.featureInfo.suit == 0) {
				return this.sex;
			} else {
				return this.sex + 2;
			}
			return 999;
		}


		public function coloring():Boolean {
			if ((this.status & 0x80000000) != 0) {
				return true;
			} else if ((this.status & 0x40000000) != 0) {
				return true;
			} else if ((this.status & 0x20000000) != 0) {
				return true;
			}
			return false;
		}

		public function reset():void {
			this.moveLocked=false;
			this.isHurting=false;
		}
	}
}