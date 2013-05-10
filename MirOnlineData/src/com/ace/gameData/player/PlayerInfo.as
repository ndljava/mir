package com.ace.gameData.player {
	import com.ace.enum.ItemEnum;
	import com.ace.game.manager.TableManager;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.utils.Tools;

	import flash.geom.Point;

	public class PlayerInfo extends LivingInfo {

		public var preTile:Point; //上一个位置
		public var walkFail:Boolean; //行走失败
		public var targetTile:Point; //寻路的目标点
		public var attackPt:Point;

		public var autoWalk:Boolean;
		public var autoWalkNum:int=0;
		public var mouseDownTile:Point; //鼠标按下的点

		public var hasTeam:Boolean;
		public var hasGuild:Boolean;
		//技能
		public var canPowerHit:Boolean; //攻杀--被动-服务器控制
		public var canLongHit:Boolean; //刺杀--默认开
		public var canWideHit:Boolean; //半月
		public var canFireHit:Boolean; //烈火
		public var lastSkillTime:int;

		public var backpackItems:Vector.<TClientItem>; //背包数据
		public var skills:Vector.<TClientMagic>; //技能数据


		public var talkNpcId:int; //对话的npcid
		public var waitItemFromId:int=-1; //道具操作时等待的fromId
		public var waitItemToId:int=-1; //道具操作时等待的toId
		public var waitItemUse:int=-1; //等待使用的

		//		public var storageItems:Vector.<TClientItem>; //仓库数据


		public function PlayerInfo($info:LivingInfo=null) {
			super($info);
		}

		override protected function init():void {
			super.init();

			this.dirLocked=false;
			this.preTile=new Point(-1, -1);
			this.targetTile=new Point(-1, -1);
			this.skills=new Vector.<TClientMagic>;

			this.initBackItem();
			this.resetWaitItem();
		}

		private function initBackItem():void {
			this.backpackItems=new Vector.<TClientItem>;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_TOTAL; i++) {
				//如果在开启范围内
				//				if (i < ItemEnum.BACKPACK_GRID_OPEN || (i > ItemEnum.BACKPACK_GRID_TOTAL && i < (ItemEnum.STORAGE_GRIDE_OPEN + ItemEnum.BACKPACK_GRID_TOTAL)))
				this.backpackItems.push(new TClientItem(true));
			}
		}

		public function initSkills():void {
			var arr:Vector.<TSkillInfo>=TableManager.getInstance().getSkillInfos(this.race);
			arr.sort(this.sorOnSkill);
			for (var i:int=0; i < arr.length; i++) {
				this.skills.push(new TClientMagic(null, arr[i].id));
			}
		}

		private function sorOnSkill(info1:TSkillInfo, info2:TSkillInfo):Number {
			return (info1.needLv1 - info2.needLv1);
		}

		//根据技能id
		public function getSkillInfo(id:int):TClientMagic {
			for (var i:int=0; i < this.skills.length; i++) {
				if (id == this.skills[i].skillId) {
					return this.skills[i];
				}
			}
			//			Tools.throwError("不应该找不到技能");
			return null;
		}

		public function changeTargetPt(pt:Point):void {
			this.targetTile.x=pt.x;
			this.targetTile.y=pt.y;
		}

		public function hasTargetPt():Boolean {
			return (this.targetTile.x != -1 && this.targetTile.y != -1);
		}

		public function openPwR():void {
			this.canPowerHit=true;
		}

		public function closePwR():void {
			this.canPowerHit=false;
		}

		public function openLng():void {
			this.canLongHit=true;
		}

		public function closeLng():void {
			this.canLongHit=false;
		}

		public function openWid():void {
			this.canWideHit=true;
		}

		public function closeWid():void {
			this.canWideHit=false;
		}

		public function openFire():void {
			this.canFireHit=true;
		}

		public function closeFire():void {
			this.canFireHit=false;
		}

		public function itemIsJustFill(id:int):Boolean {
			if (id == -1)
				return false;
			return this.backpackItems[id].isJustFill;
		}

		//
		public function switchItems(fromId:int, toId:int):void {
			var info:TClientItem=this.backpackItems[fromId];
			this.backpackItems[fromId]=this.backpackItems[toId];
			this.backpackItems[toId]=info;
		}

		public function addItem($type:String, info:TClientItem, ps:int=-1):int {
			if (ps == -1) {
				//判断重复 ndl
				var tmp:TClientItem=this.getItemByMakeIndex(info.MakeIndex,$type);
				if (tmp != null && tmp.Addvalue[0] <= tmp.s.stackNum)
					ps=this.backpackItems.indexOf(tmp);
				else
					ps=this.findEmptyPs($type);
			}
			this.backpackItems[ps]=info;
			return ps;
		}

		/**
		 *通过id返回装备的索引
		 * @param id
		 * @return
		 *
		 */
		public function getEquipIdxById(id:int):int {
			var idx:int=-1;
			for (var i:int=0; i < this.equips.length; i++) {
				if (this.equips[i].s != null && id == this.equips[i].s.id) {
					idx=i;
					break;
				}
			}
			return idx;
		}

		public function resetItem(id:int):void {
			this.backpackItems[id]=new TClientItem(true);
		}


		public function resetBack(type:String):void {

			var startIndex:int;
			var endIndex:int;
			if (type == ItemEnum.TYPE_GRID_BACKPACK) {
				startIndex=0;
				endIndex=ItemEnum.BACKPACK_GRID_OPEN;
			} else {
				startIndex=ItemEnum.BACKPACK_GRID_TOTAL;
				endIndex=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_OPEN;
			}

			for (var i:int=startIndex; i < endIndex; i++) {
				//如果在开启范围内
				//				if (i < ItemEnum.BACKPACK_GRID_OPEN || (i > ItemEnum.BACKPACK_GRID_TOTAL && i < (ItemEnum.STORAGE_GRIDE_OPEN + ItemEnum.BACKPACK_GRID_TOTAL)))
				this.backpackItems[i]=new TClientItem(true);
			}
		}

		/**
		 *
		 * @param $type
		 * @return -1 格子已满
		 *
		 */
		public function findEmptyPs($type:String):int {
			var startIndex:int;
			var endIndex:int;
			if ($type == ItemEnum.TYPE_GRID_BACKPACK) {
				startIndex=0;
				endIndex=ItemEnum.BACKPACK_GRID_OPEN;
			} else {
				startIndex=ItemEnum.BACKPACK_GRID_TOTAL;
				endIndex=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_OPEN;
			}
			for (var i:int=startIndex; i < endIndex; i++) {
				if (this.backpackItems[i].isJustFill) {
					return i;
				}
			}
			//throw new Error("格子已满");
			trace("格子已满")
			return -1;
		}

		/**
		 * 根据makeindex 获取 背包
		 * @param mkindex
		 * @return
		 *
		 */
		public function getItemByMakeIndex(mkindex:int, $type:String="backpackGrid"):TClientItem {

			var startIndex:int;
			var endIndex:int;
			if ($type == ItemEnum.TYPE_GRID_BACKPACK) {
				startIndex=0;
				endIndex=ItemEnum.BACKPACK_GRID_OPEN;
			} else {
				startIndex=ItemEnum.BACKPACK_GRID_TOTAL;
				endIndex=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_OPEN;
			}

			for (var i:int=startIndex; i < endIndex; i++) {
				if (this.backpackItems[i].MakeIndex == mkindex)
					return this.backpackItems[i];
			}

			return null;
		}


		//根据 s.id 返回数据信息
		public function getItemByItemId(id:int):TClientItem {
			var tc:TClientItem;
			for each (tc in backpackItems) {
				if (tc.s && tc.s.id == id)
					return tc;
			}
			return null;
		}

		/**
		 *根据道具的名字得到道具的信息
		 * @param name
		 * @return
		 *
		 */
		public function getItemByItemName(name:String):TClientItem {
			var tc:TClientItem;
			for each (tc in backpackItems) {
				if (tc.s && tc.s.name == name)
					return tc;
			}
			return null;
		}

		//根据类型，返回背包内其总数
		public function itemTotalNum(itemId:int, justGride:Boolean=true):int {
			var total:int=0;
			var info:TClientItem;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_OPEN; i++) {
				info=MyInfoManager.getInstance().backpackItems[i];
				if (info.s && info.s.id == itemId) {
					if (justGride) {
						total++;
					} else {
						total+=info.Addvalue[0];
					}
				}
			}
			return total;
		}


		/**
		 * 根据类型返回数量
		 * @param type
		 *
		 */
		public function getBagNum(type:String="backpackGrid"):int {
			var startIndex:int;
			var endIndex:int;
			if (type == ItemEnum.TYPE_GRID_BACKPACK) {
				startIndex=0;
				endIndex=ItemEnum.BACKPACK_GRID_OPEN;
			} else {
				startIndex=ItemEnum.BACKPACK_GRID_TOTAL;
				endIndex=ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_OPEN;
			}

			var c:int=0;
			var tc:TClientItem;
			for (var i:int=startIndex; i < endIndex; i++) {
				tc=this.backpackItems[i];
				if (tc && tc.s != null)
					c++;
			}

			return c;
		}

		public function resetWaitItem():void {
			this.waitItemFromId=this.waitItemToId=-1;
		}

		public function resetWaitUse():void {
			this.waitItemUse=-1;
		}

		public function startAutoWalk(pt:Point):void {
			this.autoWalk=true;
			this.autoWalkNum++;
			this.mouseDownTile=pt;
		}

		public function updataAutoWalk(pt:Point):void {
			this.mouseDownTile=pt;
		}

		public function stopAutoWalk():void {
			this.autoWalk=false;
			this.autoWalkNum=0;
			this.mouseDownTile=null;
		}

		public function cancelFindPath():Boolean {
			return this.autoWalkNum > 1;
		}
	/*public function copyItems(fromId:int, toId:int):void {
	var info:TClientItem=this.backpackItems[fromId];
	this.backpackItems[fromId]=this.backpackItems[toId];
	this.backpackItems[toId]=info;
	}*/

	}
}
