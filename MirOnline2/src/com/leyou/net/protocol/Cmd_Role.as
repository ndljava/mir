package com.leyou.net.protocol {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.FeatureInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.utils.HexUtil;
	import com.leyou.config.Core;
	import com.leyou.data.net.role.TAbility;
	import com.leyou.data.net.role.TNakedAbility;
	import com.leyou.data.net.scene.TFeature;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.NetGate;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.role.RoleWnd;

	public class Cmd_Role {
		//基本属性
		static public function sm_ability(td:TDefaultMessage, body:String):void {
//			DecodeBuffer (body, @g_MySelf.m_Abil, sizeof(TAbility));  


			MyInfoManager.getInstance().baseInfo.gameCoin=td.Recog; //金币
			MyInfoManager.getInstance().race=HexUtil.LoByte(td.Param);
			MyInfoManager.getInstance().baseInfo.gameGold=td.Tag; //元宝
			MyInfoManager.getInstance().baseInfo.pkValue=HexUtil.LoWord(td.Series);
			MyInfoManager.getInstance().baseInfo.creditValue=HexUtil.HiWord(td.Series);

			var info:TAbility=new TAbility(NetEncode.getInstance().DecodeBuffer(body));
			info.copyTo(MyInfoManager.getInstance().baseInfo);

			var info2:PlayerInfo=MyInfoManager.getInstance();

			UIManager.getInstance().backPackWnd.updataMoney();
			UIManager.getInstance().propertyWnd.updateBaseInfo(MyInfoManager.getInstance().baseInfo);
			UIManager.getInstance().propertyPointWnd.updateKeyInfo();
		}

		//附加属性
		static public function sm_subAbility(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().exInfo.hitPoint=HexUtil.LoByte(td.Param);
			MyInfoManager.getInstance().exInfo.speedPoint=HexUtil.HiByte(td.Param);
			MyInfoManager.getInstance().exInfo.antiPoison=HexUtil.LoByte(td.Tag);
			MyInfoManager.getInstance().exInfo.poisonRecover=HexUtil.HiByte(td.Tag);
			MyInfoManager.getInstance().exInfo.healthRecover=HexUtil.LoByte(td.Series);
			MyInfoManager.getInstance().exInfo.spellRecover=HexUtil.HiByte(td.Series);
			MyInfoManager.getInstance().exInfo.antiMagic=HexUtil.LoByte(HexUtil.LoWord(td.Recog));
			UIManager.getInstance().propertyWnd.updateAddInfo(MyInfoManager.getInstance().exInfo);
			UIManager.getInstance().propertyPointWnd.updateKeyInfo();
			UIManager.getInstance().backPackWnd.setBagWeight(MyInfoManager.getInstance().baseInfo.Weight + "/" + MyInfoManager.getInstance().baseInfo.MaxWeight);
			var info2:PlayerInfo=MyInfoManager.getInstance();
		}

		//装备信息
		static public function sm_sendUseItems(td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");
			var cu:TClientItem;
			var itemIndex:int;
			var itemStr:String;
			var len:int=arr.length / 2;
			for (var i:int=0; i < len; i++) {
				itemIndex=arr[i * 2];
				itemStr=arr[i * 2 + 1];
				if (itemStr.length < 100) {
					continue;
				}
				cu=Cmd_backPack.analysisItem(itemStr);
				MyInfoManager.getInstance().equips[itemIndex]=cu;
			}

			var info2:PlayerInfo=MyInfoManager.getInstance();
			UIManager.getInstance().roleWnd.updata(MyInfoManager.getInstance().equips);
		}

		//脱下装备
		static public function cm_takeOffItem(makeIndex:int, where:int, itemName:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_TAKEOFFITEM, makeIndex, where, 0, 0, itemName);
		}

		//脱下装备-ok
		static public function sm_takeOff_ok(td:TDefaultMessage, body:String):void {
			var info:FeatureInfo=new FeatureInfo();
			var f:TFeature=new TFeature();
			f.feature=td.Recog;
			f.copyTo(info);
			Core.me.changeAvatars(info);
			UIManager.getInstance().roleWnd.takeOffResult(true);
		}

		//脱下装备-fail
		static public function sm_takeOff_fail(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().roleWnd.takeOffResult(false);
		}

		//更新人物血蓝
		static public function updataHealth(hp:int, mp:int, maxHp:int):void {
			MyInfoManager.getInstance().hp=hp;
			MyInfoManager.getInstance().mp=mp;
			MyInfoManager.getInstance().baseInfo.MaxHP=maxHp;
			UIManager.getInstance().roleHeadWnd.updateHealth();
			UIManager.getInstance().propertyWnd.updateBaseInfo(MyInfoManager.getInstance().baseInfo);
		}

		//重量修改
		static public function sm_weightChanged(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().baseInfo.Weight=td.Recog;
			MyInfoManager.getInstance().baseInfo.WearWeight=td.Param;
			MyInfoManager.getInstance().baseInfo.HandWeight=td.Tag;

			UIManager.getInstance().backPackWnd.setBagWeight(MyInfoManager.getInstance().baseInfo.Weight + "/" + MyInfoManager.getInstance().baseInfo.MaxWeight);
		}

		//经验改变
		static public function sm_winExp(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().baseInfo.Exp=td.Recog;
			var addValue:int=HexUtil.MakeLong(td.Param, td.Tag);
			UIManager.getInstance().toolsWnd.updateExp();
		}

		//经验改变
		static public function sm_levelUp(td:TDefaultMessage, body:String):void {
			td.Param; //人物等级
			MyInfoManager.getInstance().level=td.Param;
			UIManager.getInstance().roleHeadWnd.updateLevel();
			UIManager.getInstance().roleWnd.updateLevel();
		}


		//经验改变
		static public function sm_adjust_bonus(td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");
			var infoArr:Array=[];
			var info:TNakedAbility;
			for (var i:int=0; i < arr.length; i++) {
				info=new TNakedAbility();
				info.readBr(NetEncode.getInstance().DecodeBuffer(arr[i]));
				infoArr.push(info);
			}
			UIManager.getInstance().propertyPointWnd.updatePointInfo(td.Recog,infoArr);
//			td.Recog+infoArr//需要的数据
		}

		//确认加点，remain:剩余的点数；info为"该次"所增加的点数
		static public function cm_adjust_bonus(remain:int, info:TNakedAbility):void {
			var t_msg:TDefaultMessage=new TDefaultMessage();
			t_msg.MakeDefaultMsg(MirProtocol.CM_ADJUST_BONUS, remain, 0, 0, 0, NetGate.getInstance().certification);
			CmdScene.SendSocketStr((NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeBuffer(info.writeBr(), info.length)), 1);
		}

	}
}