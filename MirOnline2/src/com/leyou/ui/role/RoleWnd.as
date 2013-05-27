package com.leyou.ui.role {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.SystemNoticeEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.ui.role.child.Avator;
	import com.leyou.ui.role.child.EquipGrid;
	import com.leyou.ui.role.child.PropertyNum;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PlayerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	public class RoleWnd extends AutoWindow {
		private var lvLbl:Label;
		private var raceLbl:Label;
		private var nameLbl:Label;
		private var reLifeLbl:Label;
		private var guildLbl:Label;
		private var theTitleLbl:Label;

		private var propertyNum:PropertyNum;
		private var avator:Avator;
		private var gridArr:Object;
		private var _takeOffEquipId:int=-1;
		private var _dragWrisPos:int=-1; //记录拖动穿手镯的位置
		private var _dragRingPos:int=-1; //记录拖动穿戒指的位置
		private var wrisPos:int;
		private var ringPos:int;
		private var _waitPutPos:int; //发指令要放的位置
		private var p:Point;
		private var titleSp:Sprite;

		public function RoleWnd() {
			super(LibManager.getInstance().getXML("config/ui/RoleWnd.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}

		private function init():void {
			this.propertyNum=new PropertyNum();
			this.propertyNum.x=318;
			this.propertyNum.y=86;
			this.addToPane(this.propertyNum);

			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.reLifeLbl=this.getUIbyID("reLifeLbl") as Label;
			this.guildLbl=this.getUIbyID("guildLbl") as Label;
			this.theTitleLbl=this.getUIbyID("titleLbl") as Label;

			this.titleSp=new Sprite();
			this.titleSp.x=this.theTitleLbl.x;
			this.titleSp.y=this.theTitleLbl.y;
			this.addChild(this.titleSp);
			this.theTitleLbl.x=0;
			this.theTitleLbl.y=0;
			this.titleSp.addChild(this.theTitleLbl);
			this.titleSp.addEventListener(MouseEvent.MOUSE_OVER, onTitleOverFun);
			this.titleSp.addEventListener(MouseEvent.MOUSE_OUT, onOutTitleFun);

			this.avator=new Avator();
			this.avator.x=78;
			this.avator.y=250;
			this.addChild(this.avator);

			this.gridArr=new Object();
			var equipGrid:EquipGrid;
			var i:int;
			for (i=0; i < 10; i++) {
				equipGrid=new EquipGrid();
				equipGrid.y=177 + (i % 5) * 56;
				equipGrid.x=37 + (i % 2) * 218;
				equipGrid.dataId=ItemUtil.getTypeByPos(i);
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
			for (i=0; i < 3; i++) {
				equipGrid=new EquipGrid();
				equipGrid.x=89 + i * (60);
				equipGrid.y=444;
				equipGrid.dataId=ItemUtil.getTypeByPos(i + 10);
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.gridArr[equipGrid.dataId]=equipGrid;
				this.addToPane(equipGrid);
			}
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

		public function updata(arr:Vector.<TClientItem>):void {
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i].s != null) {
					this.updateGridInfo(i, arr[i]);
				}
			}
		}

		private function updateGridInfo(i:int, Info:TClientItem):void {
			this.mouseUp();
			if (i == ItemEnum.U_HORSE) {
				(this.gridArr[2] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_ZHULI) {
				(this.gridArr[4] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_ITEM) {
				(this.gridArr[0] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_ARMRINGL || i == ItemEnum.U_ARMRINGR) {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			} else if (i == ItemEnum.U_RINGL || i == ItemEnum.U_RINGR) {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			} else {
				(this.gridArr[i] as EquipGrid).updataInfo(Info);
			}
			this.updateAvator(i, Info);
		}

		public override function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			this.initInfo();
			super.show(false, false);
			this.updateBody();
			this.resize();
		}

		public function resize():void {
			if (this.p != null)
				this.p=new Point(this.x, this.y);
			if (this.p == null || this.p.x > 0) {
				this.p=new Point();
				p.x=100;
				p.y=(this.stage.stageHeight - this.height) / 2;
				this.x=p.x;
				this.y=p.y;
			} else if (this.p.x == 0) {
				p.x=0;
				p.y=(this.stage.stageHeight - this.height) / 2;
				this.x=p.x;
				this.y=p.y;
			}
		}

		override public function hide():void {
			this.p=new Point(this.x, this.y);
			super.hide();
			UIManager.getInstance().pointDistributionWnd.hide();
		}

		private function initInfo():void {
			this.nameLbl.text=MyInfoManager.getInstance().name;
			this.lvLbl.text=MyInfoManager.getInstance().level + "级";
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(MyInfoManager.getInstance().race);
			var str:Array=MyInfoManager.getInstance().nameArr;
			if (str[3] != null)
				this.reLifeLbl.text=(str[3] as String).length + "级"; //转生等级
			else
				this.reLifeLbl.text="0级";
			if (str[4] != null)
				this.guildLbl.text=str[4];
			else
				this.guildLbl.text="";
			if (this.guildLbl.text.indexOf("≮") > -1) {
				this.theTitleLbl.text=this.guildLbl.text.substring(this.guildLbl.text.indexOf("≮") + 1, this.guildLbl.text.length - 1);
				if (this.theTitleLbl.text.length > 7)
					this.theTitleLbl.text=this.theTitleLbl.text.substr(0, 7) + "...";
				this.guildLbl.text=this.guildLbl.text.substring(0, this.guildLbl.text.indexOf("≮"));
			} else
				this.theTitleLbl.text="";
		}

		public function set takeOffEquipId(id:int):void {
			this._takeOffEquipId=id;
		}

		public function takeOffResult(f:Boolean):void {
			if (this._takeOffEquipId == -1)
				return;
			var i:int;
			if (f) { //成功
				MyInfoManager.getInstance().equips[this._takeOffEquipId].s=null;
				this.updateAvator(this._takeOffEquipId, MyInfoManager.getInstance().equips[this._takeOffEquipId]);
				if (this._takeOffEquipId == ItemEnum.U_HORSE)
					i=ItemEnum.U_RIGHTHAND;
				else if (this._takeOffEquipId == ItemEnum.U_ZHULI)
					i=ItemEnum.U_HELMET;
				else if (this._takeOffEquipId == ItemEnum.U_ITEM)
					i=ItemEnum.U_DRESS;
				else
					i=this._takeOffEquipId;
				(this.gridArr[i] as EquipGrid).clearMe();
			} else { //失败
				UIManager.getInstance().noticeMidDownUproll.setNoticeStr(MyInfoManager.getInstance().equips[this._takeOffEquipId].s.name + " 脱装备失败", SystemNoticeEnum.IMG_WARN);
			}
			this._takeOffEquipId=-1;
		}

		/**
		 *拖动穿装备
		 * @param id
		 *
		 */
		public function takeOnEquip(id:int):void {
			var info:TClientItem=MyInfoManager.getInstance().backpackItems[id];
			var i:int=ItemEnum.equipPos[info.s.type];

			if (i == ItemEnum.U_ARMRINGL || i == ItemEnum.U_ARMRINGR || i == ItemEnum.U_RINGL || i == ItemEnum.U_RINGR) {
				i=this._waitPutPos;
			}
			this.updateGridInfo(i, info);
			MyInfoManager.getInstance().equips[i]=info;
			this._dragRingPos=-1;
			this._dragWrisPos=-1
		}

		public function set dragRingPos(pos:int):void {
			this._dragRingPos=pos;
		}

		public function set dragWrisPos(pos:int):void {
			this._dragWrisPos=pos;
		}

		public function set waitPutPos(pos:int):void {
			this._waitPutPos=pos;
		}

		public function get dragRingPos():int {
			return this._dragRingPos;
		}

		public function get dragWrisPos():int {
			return this._dragWrisPos;
		}

		/**
		 *计算穿戴手镯 戒指的位置的方法 两个位置都有东西的时候先左后右 （不受拖拽和空位的影响）
		 * @param flag
		 * @return
		 *
		 */
		public function checkWrisRingPos(flag:int):int {
			var pos:int;
			if (flag == ItemEnum.U_ARMRINGL || flag == ItemEnum.U_ARMRINGR) {
				if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty && this.gridArr[ItemEnum.U_ARMRINGR].isEmpty) {
					wrisPos=ItemEnum.U_ARMRINGL;
					pos=ItemEnum.U_ARMRINGL;
				} else if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty == false && this.gridArr[ItemEnum.U_ARMRINGR].isEmpty == false) {
					if (this.wrisPos == 0 || this.wrisPos == ItemEnum.U_ARMRINGR)
						this.wrisPos=ItemEnum.U_ARMRINGL;
					else if (this.wrisPos == ItemEnum.U_ARMRINGL)
						this.wrisPos=ItemEnum.U_ARMRINGR;
					pos=this.wrisPos;
				} else {
					if (this.gridArr[ItemEnum.U_ARMRINGL].isEmpty)
						pos=ItemEnum.U_ARMRINGL;
					else if (this.gridArr[ItemEnum.U_ARMRINGR].isEmpty)
						pos=ItemEnum.U_ARMRINGR;
				}
			} else if (flag == ItemEnum.U_RINGL || flag == ItemEnum.U_RINGR) {
				if (this.gridArr[ItemEnum.U_RINGL].isEmpty && this.gridArr[ItemEnum.U_RINGR].isEmpty)
					pos=ItemEnum.U_RINGR;
				else if (this.gridArr[ItemEnum.U_RINGL].isEmpty == false && this.gridArr[ItemEnum.U_RINGR].isEmpty == false) {
					if (this.ringPos == 0 || this.ringPos == ItemEnum.U_RINGR)
						this.ringPos=ItemEnum.U_RINGL;
					else if (this.ringPos == ItemEnum.U_RINGL)
						this.ringPos=ItemEnum.U_RINGR;
					pos=this.ringPos;
				} else {
					if (this.gridArr[ItemEnum.U_RINGR].isEmpty)
						pos=ItemEnum.U_RINGR;
					else if (this.gridArr[ItemEnum.U_RINGL].isEmpty)
						pos=ItemEnum.U_RINGL;
				}
			}
			return pos;
		}

		public function resetDragPos():void {
			this._dragRingPos=-1;
			this._dragWrisPos=-1;
		}

		public function updateLevel():void {
			this.lvLbl.text=MyInfoManager.getInstance().level.toString();
		}

		public function updateGamePoint(num:int):void {
			this.propertyNum.updateGamePoint(num);
		}

		/**
		 *删除某个道具
		 * @param info
		 *
		 */
		public function serv_removeItem(info:TClientItem):void {
			if (info == null || info.s == null)
				return;
			var e:Vector.<TClientItem>=MyInfoManager.getInstance().equips;
			for (var i:int=0; i < e.length; i++) {
				if (info.MakeIndex == e[i].MakeIndex && e[i].s != null) {
					MyInfoManager.getInstance().equips[i].s=null;
					this.updateAvator(i, MyInfoManager.getInstance().equips[i]);
					if (this.gridArr[i] != null) {
						(this.gridArr[i] as EquipGrid).clearMe();
					}
				}
			}
		}

		//更新人物形象
		private function updateAvator(i:int, info:TClientItem):void {
			if (i == ItemEnum.U_DRESS) { //衣服
				if (info.s !== null)
					this.avator.updateCloth(info.s.appr);
				else
					this.avator.updateCloth(0);
			}
			if (i == ItemEnum.U_HELMET || i == ItemEnum.U_ZHULI) { //头盔 斗笠
				if (info.s != null)
					this.avator.updateHat(info.s.appr);
				else
					this.avator.updateHat(0);
			}
			if (i == ItemEnum.U_WEAPON) { //武器
				if (info.s != null)
					this.avator.updateWeapon(info.s.appr);
				else
					this.avator.updateWeapon(0);
			}
		}

		private function updateBody():void {
			var sex:int=MyInfoManager.getInstance().sex;
			this.avator.updateBody(sex);
		}

		public function updateInfo():void {
			this.propertyNum.updateInfo();
		}

		public function updatePointInfo(point:int, arr:Array):void {
			this.propertyNum.updatePointInfo(point, arr);
		}

		public function setCurrentPoint(str:String=""):void {
			this.propertyNum.currentPoint=str;
		}

		public function get pointKey():int {
			return this.propertyNum.point;
		}

		public function set pointKey(k:int):void {
			this.propertyNum.point=k;
		}

		public function addInfo(key:int, point:int):void {
			this.propertyNum.addInfo(key, point);
		}

		public function addInfoSure():void {
			this.propertyNum.addSure();
		}

		public function mouseUp(evt:MouseEvent=null):void {
			for each (var key:EquipGrid in this.gridArr) {
				if (key.enable == false)
					key.enable=true;
			}
		}

		private function onTitleOverFun(evt:MouseEvent):void {
			var str:Array=MyInfoManager.getInstance().nameArr;
			if (str[3] != null) {
				if (this.theTitleLbl.text.length < str[3]) {
					ItemTip.getInstance().showString(str[3]);
					var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
					ItemTip.getInstance().updataPs(p.x, p.y);
				}
			}
		}

		private function onOutTitleFun(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
		}

		public function dropEquip(arr:Array):void {
			var i:int=0;
			var name:Array=new Array();
			var idx:Array=new Array();
			for (i=0; i < arr.length; i++) {
				if (i % 2 > 0)
					idx.push(arr[i]);
				else
					name.push();
			}
			var equip:Vector.<TClientItem>=MyInfoManager.getInstance().equips;
			for (var j:int=0; j < idx.length; j++) {
				for (i=0; i < equip.length; i++) {
					if (equip[i].s != null && idx[j] == equip[i].MakeIndex) {
						this.serv_removeItem(equip[i]);
					}
				}
			}
		}

		public function checkPosition():void {
			if (this.stage.stageWidth - this.x < this.width)
				this.x=this.stage.stageWidth - this.width;
		}

		/**
		 *检查玩家身上是否有同类型的装备 tips显示对比 
		 * @param type
		 * @return 
		 * 
		 */		
		public function checkDress(type:int):Vector.<TClientItem> {
			var i:int=ItemEnum.equipPos[type];
			var arr:Vector.<TClientItem>=new Vector.<TClientItem>;
			var equip:Vector.<TClientItem>=MyInfoManager.getInstance().equips;
			if(i == ItemEnum.U_ARMRINGL||i == ItemEnum.U_ARMRINGR){
				if(equip[ItemEnum.U_ARMRINGL].s!=null)
					arr.push(equip[ItemEnum.U_ARMRINGL]);
				if(equip[ItemEnum.U_ARMRINGR].s!=null)
					arr.push(equip[ItemEnum.U_ARMRINGR]);
			}
			else if(i == ItemEnum.U_RINGL || i == ItemEnum.U_RINGR){
				if(equip[ItemEnum.U_RINGL].s!=null)
					arr.push(equip[ItemEnum.U_RINGL]);
				if(equip[ItemEnum.U_RINGR].s!=null)
					arr.push(equip[ItemEnum.U_RINGR]);
			}
			else if(equip[i].s!=null)
				arr.push(equip[i]);
			return arr;
		}
	}
}