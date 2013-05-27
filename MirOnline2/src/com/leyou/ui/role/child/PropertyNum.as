package com.leyou.ui.role.child {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.gameData.player.PlayerExtendInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.HexUtil;
	import com.leyou.data.net.role.TNakedAbility;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.ui.backpack.child.ItemTip;
	import com.leyou.utils.TipsUtil;

	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PropertyNum extends AutoSprite {
		private var dcLbl:Label; //攻击
		private var mcLbl:Label; //魔攻
		private var scLbl:Label; //道术
		private var acLbl:Label; //防御
		private var macLbl:Label; //魔防
		private var hpLbl:Label; //体力
		private var mpLbl:Label; //魔法
		private var pkLbl:Label; //PK值
		private var gmPointLbl:Label; //游戏点
		private var fameLbl:Label; //声望值
		private var wearWeightLbl:Label; //穿戴重量
		private var wristLbl:Label; //腕力
		private var pointLbl:Label; //属性点
		private var hitLbl:Label; //准确
		private var speedLbl:Label; //敏捷
		private var hpImg:Image;
		private var mpImg:Image;
		private var detailTextFiled:TextField; //详细信息
		private var btnArr:Vector.<ImgButton>;

		private var _addInfo:TNakedAbility;
		private var afterPoint:int;
		private var pointInfpArr:Array;
		private var addKey:int;
		private var addFlag:Boolean;
		private var hpMpW:int;
		private var hpMpH:int;

		public var currentPoint:String;
		public var point:int;

		public function PropertyNum() {
			super(LibManager.getInstance().getXML("config/ui/role/PropertyNum.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.hpMpW=102;
			this.hpMpH=21;
			this.dcLbl=this.getUIbyID("dcLbl") as Label;
			this.mcLbl=this.getUIbyID("mcLbl") as Label;
			this.scLbl=this.getUIbyID("scLbl") as Label;
			this.acLbl=this.getUIbyID("acLbl") as Label;
			this.macLbl=this.getUIbyID("macLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;
			this.pkLbl=this.getUIbyID("pkLbl") as Label;
			this.gmPointLbl=this.getUIbyID("gmPointLbl") as Label;
			this.fameLbl=this.getUIbyID("fameLbl") as Label;
			this.wearWeightLbl=this.getUIbyID("wearWeightLbl") as Label;
			this.wristLbl=this.getUIbyID("wristLbl") as Label;

			this.hitLbl=this.getUIbyID("hitLbl") as Label;
			this.speedLbl=this.getUIbyID("speedLbl") as Label;
			this.pointLbl=this.getUIbyID("pointLbl") as Label;

			this.hpImg=this.getUIbyID("hpImg") as Image;
			this.mpImg=this.getUIbyID("mpImg") as Image;

			this.btnArr=new Vector.<ImgButton>;
			this.btnArr.push(this.getUIbyID("hpBtn"));
			this.btnArr.push(this.getUIbyID("mpBtn"));
			this.btnArr.push(this.getUIbyID("dcBtn"));
			this.btnArr.push(this.getUIbyID("mcBtn"));
			this.btnArr.push(this.getUIbyID("scBtn"));
			this.btnArr.push(this.getUIbyID("acBtn"));
			this.btnArr.push(this.getUIbyID("macBtn"));
			this.btnArr.push(this.getUIbyID("hitBtn"));
			this.btnArr.push(this.getUIbyID("speedBtn"));

			for (var i:int=0; i < this.btnArr.length; i++) {
				this.btnArr[i].addEventListener(MouseEvent.CLICK, onBtnClick);
			}

			this.detailTextFiled=new TextField();
			this.detailTextFiled.textColor=0x008B00;
			var format:TextFormat=new TextFormat();
			format.align=TextFieldAutoSize.LEFT;
			format.underline=true;
			this.detailTextFiled.defaultTextFormat=format;
			this.detailTextFiled.x=0;
			this.detailTextFiled.y=230;
			this.detailTextFiled.height=20;
			this.detailTextFiled.text="【详细属性说明】";
			this.addChild(this.detailTextFiled);
			this.detailTextFiled.selectable=false;
			this.detailTextFiled.addEventListener(MouseEvent.MOUSE_OVER, this.detailInfo);
			this.detailTextFiled.addEventListener(MouseEvent.MOUSE_OUT, this.hideDetailInfo);

			this.pointInfpArr=new Array();
			this.currentPoint=new String();
			this._addInfo=new TNakedAbility();
		}

		public function updateInfo():void {
			//更新信息
			var extendInfo:PlayerExtendInfo=MyInfoManager.getInstance().exInfo;
			if (extendInfo != null) {
				this.hitLbl.text=extendInfo.hitPoint.toString();
				this.speedLbl.text=extendInfo.speedPoint.toString();
			}

			var baseInfo:PlayerBasicInfo=MyInfoManager.getInstance().baseInfo;
			if (baseInfo != null) {
				this.dcLbl.text=HexUtil.LoWord(baseInfo.DC) + " - " + HexUtil.HiWord(baseInfo.DC);
				this.mcLbl.text=HexUtil.LoWord(baseInfo.MC) + " - " + HexUtil.HiWord(baseInfo.MC);
				this.scLbl.text=HexUtil.LoWord(baseInfo.SC) + " - " + HexUtil.HiWord(baseInfo.SC);
				this.acLbl.text=HexUtil.LoWord(baseInfo.AC) + " - " + HexUtil.HiWord(baseInfo.AC);
				this.macLbl.text=HexUtil.LoWord(baseInfo.MAC) + " - " + HexUtil.HiWord(baseInfo.MAC);
				this.hpLbl.text=baseInfo.HP + " / " + baseInfo.MaxHP;
				this.mpLbl.text=baseInfo.MP + " / " + baseInfo.MaxMP;
				//更新 生命值 魔法值
				var hhp:Number=(baseInfo.HP / baseInfo.MaxHP) * this.hpMpW;
				if (hhp > this.hpMpW)
					hhp=this.hpMpW;
				if (hhp <= 0)
					hhp=1;
				this.hpImg.setWH(hhp, this.hpMpH);

				var mmp:Number=(baseInfo.MP / baseInfo.MaxMP) * this.hpMpW;
				if (mmp > this.hpMpW)
					mmp=this.hpMpW;
				if (mmp <= 0)
					mmp=1;
				this.mpImg.setWH(mmp, this.hpMpH);

//				this.hpLbl.text=baseInfo.MaxHP + "";
//				this.mpLbl.text=baseInfo.MaxMP + "";
				this.pkLbl.text=baseInfo.pkValue.toString();
//				this.gmPointLbl.text="暂时未找到" //游戏点
				this.fameLbl.text=baseInfo.creditValue.toString(); //声望值
				this.wearWeightLbl.text=baseInfo.WearWeight + " / " + baseInfo.MaxWearWeight;
				this.wristLbl.text=baseInfo.HandWeight + " / " + baseInfo.MaxHandWeight;
				UIManager.getInstance().roleHeadWnd.updateHealth();
			}

			if (this.addFlag == true) {
				(this.pointInfpArr[1] as TNakedAbility).AC+=this._addInfo.AC;
				(this.pointInfpArr[1] as TNakedAbility).DC+=this._addInfo.DC;
				(this.pointInfpArr[1] as TNakedAbility).Hit+=this._addInfo.Hit;
				(this.pointInfpArr[1] as TNakedAbility).HP+=this._addInfo.HP;
				(this.pointInfpArr[1] as TNakedAbility).MAC+=this._addInfo.MAC;
				(this.pointInfpArr[1] as TNakedAbility).MC+=this._addInfo.MC;
				(this.pointInfpArr[1] as TNakedAbility).MP+=this._addInfo.MP;
				(this.pointInfpArr[1] as TNakedAbility).SC+=this._addInfo.SC;
				(this.pointInfpArr[1] as TNakedAbility).Speed+=this._addInfo.Speed;
				this.point=this.afterPoint;
				this._addInfo.clearMe();
				this.addFlag=false;

			}
		}

		public function updateGamePoint(num:int):void {
			this.gmPointLbl.text=num+""; //游戏点
		}

		private function detailInfo(evt:MouseEvent):void {
			var str:String=new String();
			var extendInfo:PlayerExtendInfo=MyInfoManager.getInstance().exInfo;
			str=TipsUtil.getColorStr("魔法躲避:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(extendInfo.antiMagic * 10 + "%  ", TipsEnum.COLOR_YELLOW) + TipsUtil.getColorStr("增加对于魔法与道术技能的闪避几率。仅\n                    与【", TipsEnum.COLOR_GREEN) + TipsUtil.getColorStr("魔法命中", TipsEnum.COLOR_ORANGE) + TipsUtil.getColorStr("】对抗，不能增加由于【", TipsEnum.COLOR_GREEN) + TipsUtil.getColorStr("敏捷", TipsEnum.COLOR_ORANGE) + TipsUtil.getColorStr("】\n                    不足带来的【", TipsEnum.COLOR_GREEN) + TipsUtil.getColorStr("闪避率", TipsEnum.COLOR_ORANGE) + TipsUtil.getColorStr("】。", TipsEnum.COLOR_GREEN);
			str+=TipsUtil.getColorStr("\n毒物躲避:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(extendInfo.antiPoison * 10 + "% ", TipsEnum.COLOR_YELLOW) + TipsUtil.getColorStr("增加对于中毒效果（道士的红、绿毒，麻痹\n                    毒等）的闪避几率。", TipsEnum.COLOR_GREEN);
			str+=TipsUtil.getColorStr("\n生命恢复:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(extendInfo.healthRecover * 10 + "% ", TipsEnum.COLOR_YELLOW) + TipsUtil.getColorStr("百分比增加生命值的恢复速度。", TipsEnum.COLOR_GREEN);
			str+=TipsUtil.getColorStr("\n魔法恢复:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(extendInfo.spellRecover * 10 + "% ", TipsEnum.COLOR_YELLOW) + TipsUtil.getColorStr("百分比增加魔法值的恢复速度。", TipsEnum.COLOR_GREEN);
			str+=TipsUtil.getColorStr("\n毒物恢复:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(extendInfo.poisonRecover * 10 + "% ", TipsEnum.COLOR_YELLOW) + TipsUtil.getColorStr("百分比减少自身中毒时间。", TipsEnum.COLOR_GREEN);
//			this.antiMagicLbl.text="+" + info.antiMagic * 10 + "%";//魔法防暑
//			this.antiPoisonLbl.text="+" + info.antiPoison * 10 + "%";//中毒防御
//			this.poisonRecoverLbl.text="+" + info.poisonRecover * 10 + "%";//中毒恢复
//			this.healthRecoverLbl.text="+" + info.healthRecover * 10 + "%";//体力恢复
//			this.mgRecoverLbl.text="+" + info.spellRecover * 10 + "%";//魔法恢复

//			var baseInfo:PlayerBasicInfo=MyInfoManager.getInstance().baseInfo;
//			str+=TipsUtil.getColorStr("\n背包重量:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(baseInfo.Weight + " / " + baseInfo.MaxWeight, TipsEnum.COLOR_YELLOW);
//			str+=TipsUtil.getColorStr("\n负重:  ", TipsEnum.COLOR_WHITE) + TipsUtil.getColorStr(baseInfo.MaxWearWeight.toString(), TipsEnum.COLOR_YELLOW);
			ItemTip.getInstance().showString(str);
			var p:Point=this.localToGlobal(new Point(this.mouseX, this.mouseY));
			ItemTip.getInstance().updataPs(p.x + 5, p.y + 5);
//			this.loadLbl.text=baseInfo.MaxWearWeight.toString();//负重
//			this.bgWeightLbl.text=baseInfo.Weight + " / " + baseInfo.MaxWeight;//背包重量

		}

		private function hideDetailInfo(evt:MouseEvent):void {
			ItemTip.getInstance().hide();
		}

		public function updatePointInfo(point:int, arr:Array):void {
			this.point=point;
			this.afterPoint=point;
			this.pointInfpArr=arr;
			this.pointLbl.text=this.point.toString();
//			this.attPointLbl.text=(arr[1] as TNakedAbility).DC + "/" + (arr[0] as TNakedAbility).DC;
//			this.mpAttPointLbl.text=(arr[1] as TNakedAbility).MC + "/" + (arr[0] as TNakedAbility).MC;
//			this.taositPointLbl.text=(arr[1] as TNakedAbility).SC + "/" + (arr[0] as TNakedAbility).SC;
//			this.defPointLbl.text=(arr[1] as TNakedAbility).AC + "/" + (arr[0] as TNakedAbility).AC;
//			this.mpDefPointLbl.text=(arr[1] as TNakedAbility).MAC + "/" + (arr[0] as TNakedAbility).MAC;
//			this.phyPointLbl.text=(arr[1] as TNakedAbility).HP + "/" + (arr[0] as TNakedAbility).HP;
//			this.mpPointLbl.text=(arr[1] as TNakedAbility).MP + "/" + (arr[0] as TNakedAbility).MP;
//			this.exactPointLbl.text=(arr[1] as TNakedAbility).Hit + "/" + (arr[0] as TNakedAbility).Hit;
//			this.nimblePointLbl.text=(arr[1] as TNakedAbility).Speed + "/" + (arr[0] as TNakedAbility).Speed;
		}

		private function onBtnClick(evt:MouseEvent):void {
			var p:Point;
			switch (evt.target.name) {
				case "hpBtn":
					if (this.currentPoint == "hpBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[0].x, this.btnArr[0].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).HP, "体力", (this.pointInfpArr[1] as TNakedAbility).HP);
					this.currentPoint="hpBtn";
					break;
				case "mpBtn":
					if (this.currentPoint == "mpBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[1].x, this.btnArr[1].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).MP, "魔法", (this.pointInfpArr[1] as TNakedAbility).MP);
					this.currentPoint="mpBtn";
					break;
				case "dcBtn":
					if (this.currentPoint == "dcBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[2].x, this.btnArr[2].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).DC, "物攻", (this.pointInfpArr[1] as TNakedAbility).DC);
					this.currentPoint="dcBtn";
					break;
				case "mcBtn":
					if (this.currentPoint == "mcBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[3].x, this.btnArr[3].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).MC, "魔攻", (this.pointInfpArr[1] as TNakedAbility).MC);
					this.currentPoint="mcBtn";
					break;
				case "scBtn":
					if (this.currentPoint == "scBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[4].x, this.btnArr[4].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).SC, "道术", (this.pointInfpArr[1] as TNakedAbility).SC);
					this.currentPoint="scBtn";
					break;
				case "acBtn":
					if (this.currentPoint == "acBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[5].x, this.btnArr[5].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).AC, "防御", (this.pointInfpArr[1] as TNakedAbility).AC);
					this.currentPoint="acBtn";
					break;
				case "macBtn":
					if (this.currentPoint == "macBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[6].x, this.btnArr[6].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).MAC, "魔防", (this.pointInfpArr[1] as TNakedAbility).MAC);
					this.currentPoint="macBtn";
					break;
				case "hitBtn":
					if (this.currentPoint == "hitBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[7].x, this.btnArr[7].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).Hit, "准确", (this.pointInfpArr[1] as TNakedAbility).Hit);
					this.currentPoint="hitBtn";
					break;
				case "speedBtn":
					if (this.currentPoint == "speedBtn")
						return;
					p=this.localToGlobal(new Point(this.btnArr[8].x, this.btnArr[8].y));
					this.showPointWnd(p, (this.pointInfpArr[0] as TNakedAbility).Speed, "敏捷", (this.pointInfpArr[1] as TNakedAbility).Speed);
					this.currentPoint="speedBtn";
					break;
			}
		}

		private function showPointWnd(p:Point, key:int, name:String, key1:int):void {
			if (UIManager.getInstance().pointDistributionWnd.isShow == true)
				UIManager.getInstance().pointDistributionWnd.hide();
			UIManager.getInstance().pointDistributionWnd.show(true, false);
			UIManager.getInstance().pointDistributionWnd.updateInfo(key, name, key1);
			p=this.parent.globalToLocal(p);
			p.x+=35;
			UIManager.getInstance().pointDistributionWnd.updatePoint(p);
			UIManager.getInstance().roleWnd.checkPosition();
		}

		public function addInfo(key:int, afterPoint:int):void {
			if (this.addFlag == true)
				return;
			this.afterPoint=afterPoint;
			this._addInfo.clearMe();
			switch (this.currentPoint) {
				case "hpBtn":
					this._addInfo.HP=key;
					break;
				case "mpBtn":
					this._addInfo.MP=key;
					break;
				case "dcBtn":
					this._addInfo.DC=key;
					break;
				case "mcBtn":
					this._addInfo.MC=key;
					break;
				case "scBtn":
					this._addInfo.SC=key;
					break;
				case "acBtn":
					this._addInfo.AC=key;
					break;
				case "macBtn":
					this._addInfo.MAC=key;
					break;
				case "hitBtn":
					this._addInfo.Hit=key;
					break;
				case "speedBtn":
					this._addInfo.Speed=key;
					break;
			}
			this.addedInfo(afterPoint);
		}

		private function addedInfo(afterPoint:int):void {
			this.afterPoint=afterPoint;
			var add:int;
			switch (this.currentPoint) {
				case "dcBtn":
					if (this._addInfo.DC >= (this.pointInfpArr[0] as TNakedAbility).DC) {
						add=Math.floor(this._addInfo.DC / (this.pointInfpArr[0] as TNakedAbility).DC);
						if (add <= 2 && add > 0) {
							this.dcLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.DC) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC)) + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
						} else if (add > 2)
							this.dcLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.DC) + TipsUtil.getColorStr("+" + Math.ceil((add - 2) / 2), TipsEnum.COLOR_PINK) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC)) + TipsUtil.getColorStr("+" + (2 + Math.floor((add - 2) / 2)), TipsEnum.COLOR_PINK);
					} else {
						this.dcLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.DC) + " - " + HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC);
					}
					break;
				case "acBtn":
					if (this._addInfo.AC >= (this.pointInfpArr[0] as TNakedAbility).AC) {
						add=Math.floor(this._addInfo.AC / (this.pointInfpArr[0] as TNakedAbility).AC);
						if (add <= 2 && add > 0) {
							this.acLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.AC) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.AC)) + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
						} else if (add > 2)
							this.acLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.AC) + TipsUtil.getColorStr("+" + Math.ceil((add - 2) / 2), TipsEnum.COLOR_PINK) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.AC)) + TipsUtil.getColorStr("+" + (2 + Math.floor((add - 2) / 2)), TipsEnum.COLOR_PINK);
					} else {
						this.acLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.AC) + " - " + HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.AC);
					}
					break;
				case "mpBtn":
					if (this._addInfo.MP >= (this.pointInfpArr[0] as TNakedAbility).MP) {
						add=Math.floor(this._addInfo.MP / (this.pointInfpArr[0] as TNakedAbility).MP);
						this.mpLbl.htmlText=MyInfoManager.getInstance().baseInfo.MP + "/" + MyInfoManager.getInstance().baseInfo.MaxMP + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
					} else {
						this.mpLbl.text=MyInfoManager.getInstance().baseInfo.MP + " / " + MyInfoManager.getInstance().baseInfo.MaxMP;
					}
					break;
				case "mcBtn":
					if (this._addInfo.MC >= (this.pointInfpArr[0] as TNakedAbility).MC) {
						add=Math.floor(this._addInfo.MC / (this.pointInfpArr[0] as TNakedAbility).MC);
						if (add <= 2 && add > 0) {
							this.mcLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MC) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MC)) + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
						} else if (add > 2)
							this.mcLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MC) + TipsUtil.getColorStr("+" + Math.ceil((add - 2) / 2), TipsEnum.COLOR_PINK) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MC)) + TipsUtil.getColorStr("+" + (2 + Math.floor((add - 2) / 2)), TipsEnum.COLOR_PINK);
					} else {
						this.mcLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MC) + " - " + HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MC);
					}
					break;
				case "macBtn":
					if (this._addInfo.MAC >= (this.pointInfpArr[0] as TNakedAbility).MAC) {
						add=Math.floor(this._addInfo.MAC / (this.pointInfpArr[0] as TNakedAbility).MAC);
						if (add <= 2 && add > 0) {
							this.macLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MAC) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MAC)) + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
						} else if (add > 2)
							this.macLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MAC) + TipsUtil.getColorStr("+" + Math.ceil((add - 2) / 2), TipsEnum.COLOR_PINK) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MAC)) + TipsUtil.getColorStr("+" + (2 + Math.floor((add - 2) / 2)), TipsEnum.COLOR_PINK);
					} else {
						this.macLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MAC) + " - " + HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MAC);
					}
					break;
				case "hpBtn":
					if (this._addInfo.HP >= (this.pointInfpArr[0] as TNakedAbility).HP) {
						add=Math.floor(this._addInfo.HP / (this.pointInfpArr[0] as TNakedAbility).HP);
						this.hpLbl.htmlText=MyInfoManager.getInstance().baseInfo.HP + " / " + MyInfoManager.getInstance().baseInfo.MaxHP + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
					} else {
						this.hpLbl.text=MyInfoManager.getInstance().baseInfo.HP + " / " + MyInfoManager.getInstance().baseInfo.MaxHP;
					}
					break;
				case "scBtn":
					if (this._addInfo.SC >= (this.pointInfpArr[0] as TNakedAbility).SC) {
						add=Math.floor(this._addInfo.SC / (this.pointInfpArr[0] as TNakedAbility).SC);
						if (add <= 2 && add > 0) {
							this.scLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.SC) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC)) + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_GREEN);
						} else if (add > 2)
							this.scLbl.htmlText=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.SC) + TipsUtil.getColorStr("+" + Math.ceil((add - 2) / 2), TipsEnum.COLOR_PINK) + " - " + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC)) + TipsUtil.getColorStr("+" + (2 + Math.floor((add - 2) / 2)), TipsEnum.COLOR_PINK);
					} else {
						this.scLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.SC) + " - " + HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC);
					}
					break;
				case "hitBtn":
					if (this._addInfo.Hit >= (this.pointInfpArr[0] as TNakedAbility).Hit) {
						add=Math.floor(this._addInfo.Hit / (this.pointInfpArr[0] as TNakedAbility).Hit);
						this.hitLbl.htmlText=MyInfoManager.getInstance().exInfo.hitPoint + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
					} else {
						this.hitLbl.text=MyInfoManager.getInstance().exInfo.hitPoint.toString();
					}
					break;
				case "speedBtn":
					if (this._addInfo.Speed >= (this.pointInfpArr[0] as TNakedAbility).Speed) {
						add=Math.floor(this._addInfo.Speed / (this.pointInfpArr[0] as TNakedAbility).Speed);
						this.speedLbl.htmlText=MyInfoManager.getInstance().exInfo.speedPoint + TipsUtil.getColorStr("+" + add, TipsEnum.COLOR_PINK);
					} else {
						this.speedLbl.text=MyInfoManager.getInstance().exInfo.speedPoint.toString();
					}
					break;
			}
			this.pointLbl.text=afterPoint.toString();
		}

		public function addSure():void {
			this.addFlag=true;
			Cmd_Role.cm_adjust_bonus(this.afterPoint, this._addInfo);
		}
	}
}