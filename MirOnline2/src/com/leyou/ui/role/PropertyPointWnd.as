package com.leyou.ui.role {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.gameData.player.PlayerExtendInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.HexUtil;
	import com.leyou.data.net.role.TNakedAbility;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Role;

	import flash.events.MouseEvent;

	public class PropertyPointWnd extends AutoWindow {
		private var attKeyLbl:Label; //攻击
		private var attPointLbl:Label;
		private var addAttBtn:NormalButton;
		private var cutAttBtn:NormalButton;

		private var mpAttLbl:Label; //法攻
		private var mpAttPointLbl:Label;
		private var addMpAttBtn:NormalButton;
		private var cutMpAttBtn:NormalButton;

		private var taoistKeyLbl:Label; //道术
		private var taositPointLbl:Label;
		private var addTaoistBtn:NormalButton;
		private var cutTaoistBtn:NormalButton;

		private var defKeylbl:Label; //防御
		private var defPointLbl:Label;
		private var addDefBtn:NormalButton;
		private var cutDefBtn:NormalButton;

		private var mpDefKeyLbl:Label; //法防
		private var mpDefPointLbl:Label;
		private var addMpDefBtn:NormalButton;
		private var cutMpDefBtn:NormalButton;

		private var phyKeylbl:Label; //体力
		private var phyPointLbl:Label;
		private var addPhyBtn:NormalButton;
		private var cutPhyBtn:NormalButton;

		private var mpKeyLbl:Label; //魔法
		private var mpPointLbl:Label;
		private var addMpBtn:NormalButton;
		private var cutMpBtn:NormalButton;

		private var exactKeyLbl:Label; //准确
		private var exactPointLbl:Label;
		private var addExactBtn:NormalButton;
		private var cutExactBtn:NormalButton;

		private var nimbleKeyLbl:Label; //敏捷
		private var nimblePointLbl:Label;
		private var addNimbleBtn:NormalButton;
		private var cutNimbleBtn:NormalButton;

		private var pointLbl:Label;
		private var sureBtn:NormalButton;
		private var point:int;
		private var pointInfpArr:Array;
		private var addInfo:TNakedAbility;
		private var afterPoint:int;
		private var addFlag:TNakedAbility;
		private var cmFlag:Boolean;

		public function PropertyPointWnd() {
			super(LibManager.getInstance().getXML("config/ui/PropertyPointWnd.xml"));
			this.init();
		}

		private function init():void {
			this.addInfo=new TNakedAbility();
			this.addFlag=new TNakedAbility();
			this.attKeyLbl=this.getUIbyID("attKeyLbl") as Label;
			this.attPointLbl=this.getUIbyID("attPointLbl") as Label;
			this.addAttBtn=this.getUIbyID("addAttBtn") as NormalButton;
			this.cutAttBtn=this.getUIbyID("cutAttBtn") as NormalButton;

			this.mpAttLbl=this.getUIbyID("mpAttLbl") as Label;
			this.mpAttPointLbl=this.getUIbyID("mpAttPointLbl") as Label;
			this.addMpAttBtn=this.getUIbyID("addMpAttBtn") as NormalButton;
			this.cutMpAttBtn=this.getUIbyID("cutMpAttBtn") as NormalButton;

			this.taoistKeyLbl=this.getUIbyID("taoistKeyLbl") as Label;
			this.taositPointLbl=this.getUIbyID("taositPointLbl") as Label;
			this.addTaoistBtn=this.getUIbyID("addTaoistBtn") as NormalButton;
			this.cutTaoistBtn=this.getUIbyID("cutTaoistBtn") as NormalButton;

			this.defKeylbl=this.getUIbyID("defKeylbl") as Label;
			this.defPointLbl=this.getUIbyID("defPointLbl") as Label;
			this.addDefBtn=this.getUIbyID("addDefBtn") as NormalButton;
			this.cutDefBtn=this.getUIbyID("cutDefBtn") as NormalButton;

			this.mpDefKeyLbl=this.getUIbyID("mpDefKeyLbl") as Label;
			this.mpDefPointLbl=this.getUIbyID("mpDefPointLbl") as Label;
			this.addMpDefBtn=this.getUIbyID("addMpDefBtn") as NormalButton;
			this.cutMpDefBtn=this.getUIbyID("cutMpDefBtn") as NormalButton;

			this.phyKeylbl=this.getUIbyID("phyKeylbl") as Label;
			this.phyPointLbl=this.getUIbyID("phyPointLbl") as Label;
			this.addPhyBtn=this.getUIbyID("addPhyBtn") as NormalButton;
			this.cutPhyBtn=this.getUIbyID("cutPhyBtn") as NormalButton;

			this.mpKeyLbl=this.getUIbyID("mpKeyLbl") as Label;
			this.mpPointLbl=this.getUIbyID("mpPointLbl") as Label;
			this.addMpBtn=this.getUIbyID("addMpBtn") as NormalButton;
			this.cutMpBtn=this.getUIbyID("cutMpBtn") as NormalButton;

			this.exactKeyLbl=this.getUIbyID("exactKeyLbl") as Label;
			this.exactPointLbl=this.getUIbyID("exactPointLbl") as Label;
			this.addExactBtn=this.getUIbyID("addExactBtn") as NormalButton;
			this.cutExactBtn=this.getUIbyID("cutExactBtn") as NormalButton;

			this.nimbleKeyLbl=this.getUIbyID("nimbleKeyLbl") as Label;
			this.nimblePointLbl=this.getUIbyID("nimblePointLbl") as Label;
			this.addNimbleBtn=this.getUIbyID("addNimbleBtn") as NormalButton;
			this.cutNimbleBtn=this.getUIbyID("cutNimbleBtn") as NormalButton;

			this.pointLbl=this.getUIbyID("pointLbl") as Label;
			this.sureBtn=this.getUIbyID("sureBtn") as NormalButton;

			this.addAttBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutAttBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addDefBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutDefBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addExactBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutExactBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addMpAttBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutMpAttBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addMpBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutMpBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addMpDefBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutMpDefBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addNimbleBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutNimbleBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addPhyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutPhyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.addTaoistBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cutTaoistBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.sureBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function onBtnClick(evt:MouseEvent):void {
			var add:int;
			switch (evt.target.name) {
				case "addAttBtn":
					if (this.afterPoint > 0) {
						this.addInfo.DC++;
						this.afterPoint--;
						this.changeInfo("addAtt");
					}
					break;
				case "cutAttBtn":
					if (this.addInfo.DC > 0) {
						this.addInfo.DC--;
						this.afterPoint++;
						this.changeInfo("addAtt");
					}
					break;
				case "addDefBtn":
					if (this.afterPoint > 0) {
						this.addInfo.AC++;
						this.afterPoint--;
						this.changeInfo("addDef");
					}
					break;
				case "cutDefBtn":
					if (this.addInfo.AC > 0) {
						this.addInfo.AC--;
						this.afterPoint++;
						this.changeInfo("addDef");
					}
					break;
				case "addExactBtn":
					if (this.afterPoint > 0) {
						this.addInfo.Hit++;
						this.afterPoint--;
						this.changeInfo("addExact");
					}
					break;
				case "cutExactBtn":
					if (this.addInfo.Hit > 0) {
						this.addInfo.Hit--;
						this.afterPoint++;
						this.changeInfo("addExact");
					}
					break;
				case "addMpAttBtn":
					if (this.afterPoint > 0) {
						this.addInfo.MC++;
						this.afterPoint--;
						this.changeInfo("addMpAtt");
					}
					break;
				case "cutMpAttBtn":
					if (this.addInfo.MC > 0) {
						this.addInfo.MC--;
						this.afterPoint++;
						this.changeInfo("addMpAtt");
					}
					break;
				case "addMpBtn":
					if (this.afterPoint > 0) {
						this.addInfo.MP++;
						this.afterPoint--;
						this.changeInfo("addMp");
					}
					break;
				case "cutMpBtn":
					if (this.addInfo.MP > 0) {
						this.addInfo.MP--;
						this.afterPoint++;
						this.changeInfo("addMp");
					}
					break;
				case "addMpDefBtn":
					if (this.afterPoint > 0) {
						this.addInfo.MAC++;
						this.afterPoint--;
						this.changeInfo("addMpDef");
					}
					break;
				case "cutMpDefBtn":
					if (this.addInfo.MAC > 0) {
						this.addInfo.MAC--;
						this.afterPoint++;
						this.changeInfo("addMpDef");
					}
					break;
				case "addNimbleBtn":
					if (this.afterPoint > 0) {
						this.addInfo.Speed++;
						this.afterPoint--;
						this.changeInfo("addNimble");
					}
					break;
				case "cutNimbleBtn":
					if (this.addInfo.Speed > 0) {
						this.addInfo.Speed--;
						this.afterPoint++;
						this.changeInfo("addNimble");
					}
					break;
				case "addPhyBtn":
					if (this.afterPoint > 0) {
						this.addInfo.HP++;
						this.afterPoint--;
						this.changeInfo("addPhy");
					}
					break;
				case "cutPhyBtn":
					if (this.addInfo.HP > 0) {
						this.addInfo.HP--;
						this.afterPoint++;
						this.changeInfo("addPhy");
					}
					break;
				case "addTaoistBtn":
					if (this.afterPoint > 0) {
						this.addInfo.SC++;
						this.afterPoint--;
						this.changeInfo("addTaoist");
					}
					break;
				case "cutTaoistBtn":
					if (this.addInfo.SC > 0) {
						this.addInfo.SC--;
						this.afterPoint++;
						this.changeInfo("addTaoist");
					}
					break;
				case "sureBtn":
					if (this.afterPoint >= this.point)
						return;
					this.cmFlag=true;
					Cmd_Role.cm_adjust_bonus(this.afterPoint, this.addInfo);
					break;
			}
		}

		public function updateKeyInfo():void {
			var baseInfo:PlayerBasicInfo=MyInfoManager.getInstance().baseInfo;
			this.attKeyLbl.text=HexUtil.LoWord(baseInfo.DC) + "-" + HexUtil.HiWord(baseInfo.DC);
			this.mpAttLbl.text=HexUtil.LoWord(baseInfo.MC) + "-" + HexUtil.HiWord(baseInfo.MC);
			this.taoistKeyLbl.text=HexUtil.LoWord(baseInfo.SC) + "-" + HexUtil.HiWord(baseInfo.SC);
			this.defKeylbl.text=HexUtil.LoWord(baseInfo.AC) + "-" + HexUtil.HiWord(baseInfo.AC);
			this.mpDefKeyLbl.text=HexUtil.LoWord(baseInfo.MAC) + "-" + HexUtil.HiWord(baseInfo.MAC);
			this.phyKeylbl.text=baseInfo.HP.toString();
			this.mpKeyLbl.text=baseInfo.MP.toString();
			var extendInfo:PlayerExtendInfo=MyInfoManager.getInstance().exInfo;
			this.exactKeyLbl.text=extendInfo.hitPoint.toString();
			this.nimbleKeyLbl.text=extendInfo.speedPoint.toString();
			if (this.cmFlag) {
				this.addedInfo();
				this.updatePointInfo(this.point, this.pointInfpArr);
			}
		}

		public function updatePointInfo(point:int, arr:Array):void {
			this.point=point;
			this.afterPoint=point;
			this.pointInfpArr=arr;
			this.pointLbl.text=this.point.toString();
			this.attPointLbl.text=(arr[1] as TNakedAbility).DC + "/" + (arr[0] as TNakedAbility).DC;
			this.mpAttPointLbl.text=(arr[1] as TNakedAbility).MC + "/" + (arr[0] as TNakedAbility).MC;
			this.taositPointLbl.text=(arr[1] as TNakedAbility).SC + "/" + (arr[0] as TNakedAbility).SC;
			this.defPointLbl.text=(arr[1] as TNakedAbility).AC + "/" + (arr[0] as TNakedAbility).AC;
			this.mpDefPointLbl.text=(arr[1] as TNakedAbility).MAC + "/" + (arr[0] as TNakedAbility).MAC;
			this.phyPointLbl.text=(arr[1] as TNakedAbility).HP + "/" + (arr[0] as TNakedAbility).HP;
			this.mpPointLbl.text=(arr[1] as TNakedAbility).MP + "/" + (arr[0] as TNakedAbility).MP;
			this.exactPointLbl.text=(arr[1] as TNakedAbility).Hit + "/" + (arr[0] as TNakedAbility).Hit;
			this.nimblePointLbl.text=(arr[1] as TNakedAbility).Speed + "/" + (arr[0] as TNakedAbility).Speed;
		}

		override public function show(toTop:Boolean=true, toCenter:Boolean=true):void {
			super.show(toTop, toCenter);
			this.updateKeyInfo();
			if (this.pointInfpArr.length > 0)
				this.updatePointInfo(this.point, this.pointInfpArr);
			this.clearMe();
		}

		private function changeInfo(flag:String):void {
			var add:int;
			switch (flag) {
				case "addAtt":
					if (this.addInfo.DC >= (this.pointInfpArr[0] as TNakedAbility).DC) {
						add=Math.floor(this.addInfo.DC / (this.pointInfpArr[0] as TNakedAbility).DC);
						if (add <= 2 && add > 0) {
							this.attKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.DC) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC) + add);
						} else if (add > 2)
							this.attKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.DC) + Math.ceil((add - 2) / 2) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.DC) + 2 + Math.floor((add - 2) / 2));
					}
					this.attPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).DC + this.addInfo.DC + "/" + (this.pointInfpArr[0] as TNakedAbility).DC;
					break;
				case "addDef":
					if (this.addInfo.AC >= (this.pointInfpArr[0] as TNakedAbility).AC) {
						add=Math.floor(this.addInfo.AC / (this.pointInfpArr[0] as TNakedAbility).AC);
						if (add <= 2 && add > 0) {
							this.defKeylbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.AC) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.AC) + add);
						} else if (add > 2)
							this.defKeylbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.AC) + Math.ceil((add - 2) / 2) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.AC) + 2 + Math.floor((add - 2) / 2));
					}
					this.defPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).AC + this.addInfo.AC + "/" + (this.pointInfpArr[0] as TNakedAbility).AC;
					break;
				case "addMp":
					if (this.addInfo.MP >= (this.pointInfpArr[0] as TNakedAbility).MP) {
						add=Math.floor(this.addInfo.MP / (this.pointInfpArr[0] as TNakedAbility).MP);
						this.mpKeyLbl.text=String(HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MP) + add);
					}
					this.mpPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).MP + this.addInfo.MP + "/" + (this.pointInfpArr[0] as TNakedAbility).MP;
					break;
				case "addMpAtt":
					if (this.addInfo.MC >= (this.pointInfpArr[0] as TNakedAbility).MC) {
						add=Math.floor(this.addInfo.MC / (this.pointInfpArr[0] as TNakedAbility).MC);
						if (add <= 2 && add > 0) {
							this.mpAttLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MC) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MC) + add);
						} else if (add > 2)
							this.mpAttLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MC) + Math.ceil((add - 2) / 2) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MC) + 2 + Math.floor((add - 2) / 2));
					}
					this.mpAttPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).MC + this.addInfo.MC + "/" + (this.pointInfpArr[0] as TNakedAbility).MC;
					break;
				case "addMpDef":
					if (this.addInfo.MAC >= (this.pointInfpArr[0] as TNakedAbility).MAC) {
						add=Math.floor(this.addInfo.MAC / (this.pointInfpArr[0] as TNakedAbility).MAC);
						if (add <= 2 && add > 0) {
							this.mpDefKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MAC) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MAC) + add);
						} else if (add > 2)
							this.mpDefKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.MAC) + Math.ceil((add - 2) / 2) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.MAC) + 2 + Math.floor((add - 2) / 2));
					}
					this.mpDefPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).MAC + this.addInfo.MAC + "/" + (this.pointInfpArr[0] as TNakedAbility).MAC;
					break;
				case "addPhy":
					if (this.addInfo.HP >= (this.pointInfpArr[0] as TNakedAbility).HP) {
						add=Math.floor(this.addInfo.HP / (this.pointInfpArr[0] as TNakedAbility).HP);
						this.phyKeylbl.text=String(HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.HP) + add);
					}
					this.phyPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).HP + this.addInfo.HP + "/" + (this.pointInfpArr[0] as TNakedAbility).HP;
					break;
				case "addTaoist":
					if (this.addInfo.SC >= (this.pointInfpArr[0] as TNakedAbility).SC) {
						add=Math.floor(this.addInfo.SC / (this.pointInfpArr[0] as TNakedAbility).SC);
						if (add <= 2 && add > 0) {
							this.taoistKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.SC) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC) + add);
						} else if (add > 2)
							this.taoistKeyLbl.text=HexUtil.LoWord(MyInfoManager.getInstance().baseInfo.SC) + Math.ceil((add - 2) / 2) + "-" + (HexUtil.HiWord(MyInfoManager.getInstance().baseInfo.SC) + 2 + Math.floor((add - 2) / 2));
					}
					this.taositPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).SC + this.addInfo.SC + "/" + (this.pointInfpArr[0] as TNakedAbility).SC;
					break;
				case "addExact":
					if (this.addInfo.Hit >= (this.pointInfpArr[0] as TNakedAbility).Hit) {
						add=Math.floor(this.addInfo.Hit / (this.pointInfpArr[0] as TNakedAbility).Hit);
						this.exactKeyLbl.text=String(MyInfoManager.getInstance().exInfo.hitPoint + add);
					}
					this.exactPointLbl.text=(this.pointInfpArr[1] as TNakedAbility).Hit + this.addInfo.Hit + "/" + (this.pointInfpArr[0] as TNakedAbility).Hit;
					break;
				case "addNimble":
					if (this.addInfo.Speed >= (this.pointInfpArr[0] as TNakedAbility).Speed) {
						add=Math.floor(this.addInfo.Speed / (this.pointInfpArr[0] as TNakedAbility).Speed);
						this.nimbleKeyLbl.text=String(MyInfoManager.getInstance().exInfo.speedPoint + add);
					}
					this.nimblePointLbl.text=(this.pointInfpArr[1] as TNakedAbility).Speed + this.addInfo.Speed + "/" + (this.pointInfpArr[0] as TNakedAbility).Speed;
					break;
			}
			this.pointLbl.text=this.afterPoint.toString();
		}

		private function addedInfo():void {
			(this.pointInfpArr[1] as TNakedAbility).AC+=this.addInfo.AC;
			(this.pointInfpArr[1] as TNakedAbility).DC+=this.addInfo.DC;
			(this.pointInfpArr[1] as TNakedAbility).Hit+=this.addInfo.Hit;
			(this.pointInfpArr[1] as TNakedAbility).HP+=this.addInfo.HP;
			(this.pointInfpArr[1] as TNakedAbility).MAC+=this.addInfo.MAC;
			(this.pointInfpArr[1] as TNakedAbility).MC+=this.addInfo.MC;
			(this.pointInfpArr[1] as TNakedAbility).MP+=this.addInfo.MP;
			(this.pointInfpArr[1] as TNakedAbility).SC+=this.addInfo.SC;
			(this.pointInfpArr[1] as TNakedAbility).Speed+=this.addInfo.Speed;
			this.point=this.afterPoint;
			this.clearMe();
		}

		private function clearMe():void {
			this.addInfo.clearMe();
			this.afterPoint=this.point;
			this.addFlag.clearMe();
		}

	}
}