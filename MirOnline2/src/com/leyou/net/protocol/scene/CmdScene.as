package com.leyou.net.protocol.scene {
	import com.ace.astarII.Node;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.player.FeatureInfo;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.utils.DebugUtil;
	import com.ace.utils.HexUtil;
	import com.leyou.config.Core;
	import com.leyou.data.net.scene.TCharDesc;
	import com.leyou.data.net.scene.TFeature;
	import com.leyou.data.net.scene.TMessageBodyW;
	import com.leyou.data.net.scene.TMessageBodyWL;
	import com.leyou.enum.ChatEnum;
	import com.leyou.game.scene.player.MyPlayer;
	import com.leyou.game.skill.bullets.BulletManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.NetGate;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.TDefaultMessage;

	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class CmdScene {

		//默认发送协议
		static public function cm_sendDefaultMsg(wIdent:int, nRecog:int, wParam:int, wTag:int, wSeries:int):void {
//			trace("发送协议：" + wIdent);
			var t_msg:TDefaultMessage=new TDefaultMessage();
			t_msg.MakeDefaultMsg(wIdent, nRecog, wParam, wTag, wSeries, NetGate.getInstance().certification);
			SendSocketStr(NetEncode.getInstance().EncodeMessage(t_msg), 1);
		}

		//默认+附加str
		static public function cm_sendDefaultMsgII(wIdent:int, nRecog:int, wParam:int, wTag:int, wSeries:int, str:String):void {
//			trace("发送协议2：" + wIdent);
			var t_msg:TDefaultMessage=new TDefaultMessage();
			t_msg.MakeDefaultMsg(wIdent, nRecog, wParam, wTag, wSeries, NetGate.getInstance().certification);
			SendSocketStr((NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeString(str)), 1);
		}

		static public function SendSocketStr(str:String, _nMode:uint):void {
			str=NetEncode.getInstance().GetSendText(_nMode, str);
			NetGate.getInstance().SendString(str);
		}

		//心跳
		static public function cm_Heartbeat(count:int):void {
			var t_DefaultMsg:TDefaultMessage=new TDefaultMessage;
			t_DefaultMsg.MakeDefaultMsg(MirProtocol.CM_CHECKGUA, count, 0, 0, 0, NetGate.getInstance().certification);
			SendSocketStr(NetEncode.getInstance().EncodeMessage(t_DefaultMsg), 1);
		}

		/*	static public function cm_Say(_str:String):void {
				var t_msg:TDefaultMessage=new TDefaultMessage;
				t_msg.MakeDefaultMsg(MirProtocol.CM_SAY, 0, 0, 0, 0, NetGate.getInstance().certification);
				var t_str:String=NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeString(_str);
				SendSocketStr(t_str, 1);
			}*/

		static public function cm_SendWalk(px:int, py:int, _nDir:int):void {
			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_WALK, HexUtil.MakeLong(px, py), 0, _nDir, 0, NetGate.getInstance().certification);
			var t_str:String=NetEncode.getInstance().GetSendText(1, NetEncode.getInstance().EncodeMessage(t_msg));
			NetGate.getInstance().SendString(t_str);
		}

		static public function cm_SendRun(px:int, py:int, _nDir:int):void {
			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_RUN, HexUtil.MakeLong(px, py), 0, _nDir, 0, NetGate.getInstance().certification);
			var t_str:String=NetEncode.getInstance().GetSendText(1, NetEncode.getInstance().EncodeMessage(t_msg));
			NetGate.getInstance().SendString(t_str);
		}

		static public function cm_SendRide(px:int, py:int, _nDir:int):void {
			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_HORSERUN, HexUtil.MakeLong(px, py), 0, _nDir, 0, NetGate.getInstance().certification);
			var t_str:String=NetEncode.getInstance().GetSendText(1, NetEncode.getInstance().EncodeMessage(t_msg));
			NetGate.getInstance().SendString(t_str);
		}


		//切换地图
		static public function sm_changeMap(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().mirScene.gotoMap(body, new Point(td.Param, td.Tag));
		}

		//外观改变
		static public function sm_featurechanged(td:TDefaultMessage, body:String):void {
			if (!UIManager.getInstance().mirScene) {
				DebugUtil.throwError("摆摊后，再次上线报错,麻烦再次登录");
				return;
			}
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				var info:FeatureInfo=new FeatureInfo();
				var t:TFeature=new TFeature();
				t.feature=HexUtil.MakeLong(td.Param, td.Tag);
				t.featureEx=HexUtil.MakeLong(td.Series, 0);
				t.copyTo(info);
				player.changeAvatars(info);

				if (body != "" && body.indexOf("#") != -1) {
					body=body.substring(0, body.indexOf("#"));
				}
				if (body != "" && body.indexOf("|") != -1) {
					player.infoB.stallName=body.substring(1);
				}
			} else {
				trace("没找到人");
			}
		}

		//其他玩家、npc、怪进入视野
		static public function sm_Turn(td:TDefaultMessage, body:String):void {
			var featureStr:String;
			var nameStr:String;

			featureStr=body.substr(0, 27);
			if (body.length > 27) {
				nameStr=body.substring(27);
				nameStr=NetEncode.getInstance().DecodeString(nameStr);
			}
			var t:TCharDesc=new TCharDesc(NetEncode.getInstance().DecodeBuffer(featureStr));
			var f:TFeature=new TFeature();
			f.feature=t.feature;

			//根据不同类型的种族，创建玩家、npc、怪
			var info:LivingInfo=new LivingInfo();
			info.id=td.Recog;
			info.name=nameStr ? nameStr : "";
			info.currentDir=HexUtil.LoByte(td.Series);
			info.nextTile.x=td.Param;
			info.nextTile.y=td.Tag;
			info.race=HexUtil.HiByte(td.Series); //职业

			info.sex=f.sex;
			info.type=f.type; //种族
			info.status=t.status;

			f.copyTo(info.featureInfo);

			UIManager.getInstance().mirScene.addOtherLiving(info, nameStr);

		}

		//走
		static public function sm_walk(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				player.infoB.speed=PlayerEnum.SPEED_WALK;
				player.serMoveTo(new Node(td.Param, td.Tag), PlayerEnum.ACT_WALK);
			} else {
				trace("没找到人");
			}
		}

		//跑
		static public function sm_run(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				player.infoB.speed=PlayerEnum.SPEED_WALK;
				player.serMoveTo(new Node(td.Param, td.Tag), PlayerEnum.ACT_RUN);
			} else {
				trace("没找到人");
			}
		}

		//设置用户名
		static public function sm_userName(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.setName(body);
		}

		//改变玩家名称的颜色
		static public function sm_changeNameColor(td:TDefaultMessage, body:String):void {
			td.Param;
		}

		//玩家消失
		static public function sm_disappear(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player && player != Core.me) {
				UIManager.getInstance().mirScene.delPlayer(td.Recog);
			}
		}

		//普通攻击 ：自己的坐标点x、y，方向
		static public function cm_Attack(skillId:int, x:int, y:int, dir:int):void {
			//普通攻击的id：比如3014
			cm_sendDefaultMsg(skillId, HexUtil.MakeLong(x, y), NetEncode.getInstance().LowWord(y), dir, NetEncode.getInstance().HiWord(y));
		}

		//使用技能
		static public function cm_spell(tx:int, ty:int, skillId:int, target:int):void {
			cm_sendDefaultMsg(MirProtocol.CM_SPELL, HexUtil.MakeLong(tx, ty), NetEncode.getInstance().LowWord(target), skillId, NetEncode.getInstance().HiWord(target));
		}

		//普通攻击
		static public function sm_hit(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
//			if (td.Series > -1 && td.Series <= 7)为什么加方向判断？服务器好像有时候发过来的方向不在该范围内
			player && player.autoAttack(new Point(td.Param, td.Tag), td.Series, 0); //普通
		}

		static public function sm_powerHit(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.autoAttack(new Point(td.Param, td.Tag), td.Series, PlayerEnum.SKILL_POWERHIT); ///攻杀
//			player && print("触发攻杀: " + player.infoB.name)
		}

		static public function sm_longhit(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.autoAttack(new Point(td.Param, td.Tag), td.Series, PlayerEnum.SKILL_LONGHIT); ///刺杀
		}

		//半月
		static public function sm_widehit(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.autoAttack(new Point(td.Param, td.Tag), td.Series, PlayerEnum.SKILL_WIDEHIT); ///半月
		}

		static public function sm_firHit(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.autoAttack(new Point(td.Param, td.Tag), td.Series, PlayerEnum.SKILL_FIRHIT); ///烈火
		}

		/*	//参数说明：方向，未知（0），技能id,未知(0)
			static public function cm_rush(dir:int, x:int, skillId:int, y:int):void {

				var t_msg:TDefaultMessage=new TDefaultMessage;

				t_msg.MakeDefaultMsg(MirProtocol.CM_SPELL, HexUtil.MakeLong(dir, x), NetEncode.getInstance().LowWord(y), skillId, NetEncode.getInstance().HiWord(y), NetGate.getInstance().certification);
				SendSocketStr(NetEncode.getInstance().EncodeMessage(t_msg), 1);
			}*/

		//野蛮冲撞
		static public function sm_rush(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				player.infoB.speed=PlayerEnum.SPEED_WALK / 2;
				player.serMoveTo(new Node(td.Param, td.Tag), PlayerEnum.ACT_RUN);
			} else {
				trace("没找到人");
			}
		}

		//退步
		static public function sm_backStep(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				player.infoB.speed=PlayerEnum.SPEED_WALK / 2;
				player.infoB.dirLocked=true;
				player.changeDir(NetEncode.getInstance().LowByte(td.Series));
				player.serMoveTo(new Node(td.Param, td.Tag), PlayerEnum.ACT_WALK);
			} else {
				trace("没找到人");
			}
		}

		//受伤
		static public function sm_struck(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.actHit(td.Param, td.Tag);
			if (player && player is MyPlayer) {
				Cmd_Role.updataHealth(td.Param, MyInfoManager.getInstance().mp, td.Tag);
			}
		}


		//血蓝值改变
		static public function sm_healthSpellChanged(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (!player)
				return;
			if (player is MyPlayer)
				Cmd_Role.updataHealth(td.Param, td.Tag, td.Series);
		}

		//心灵启示--打开血值
		static public function sm_openHealth(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (!player)
				return;
			player.updataHealth(td.Param, td.Tag);
		}

		//心灵启示--关闭血值
		static public function sm_closeHealth(td:TDefaultMessage, body:String):void {
		}

		//法师技能
		static public function sm_spell(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.actSpell(int(body), SceneUtil.dirOfPtDel(new Point(td.Param, td.Tag), player.nowTilePt()));
		}

		//技能--子弹
		static public function sm_magicFire(td:TDefaultMessage, body:String):void {
			var br:ByteArray=NetEncode.getInstance().DecodeBuffer(body);
			var targetId:int=br.readInt();
			trace("子弹释放者：" + td.Recog + " 目标：" + targetId + " 位置：[" + td.Param + "-" + td.Tag + "]" + " type:" + HexUtil.LoByte(td.Series) + " effNum:" + HexUtil.HiByte(td.Series))
			BulletManager.getInstance().addBullet(td.Recog, targetId, td.Param, td.Tag, HexUtil.LoByte(td.Series), HexUtil.HiByte(td.Series));
		}

		//技能使用失败
		static public function sm_magicFireFail(td:TDefaultMessage, body:String):void {
//			trace("使用技能失败");
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, "使用技能失败");
		}

		//状态改变，buff等效果
		static public function sm_charStatusChanged(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.statusChanged(HexUtil.MakeLong(td.Param, td.Tag));
		}

		//火墙-show
		static public function sm_showEvent(td:TDefaultMessage, body:String):void {
			BulletManager.getInstance().addBuff(td.Recog, td.Param, HexUtil.LoWord(td.Tag), td.Series);
		}

		//火墙-hide
		static public function sm_hideEvent(td:TDefaultMessage, body:String):void {
			BulletManager.getInstance().delBuff(td.Recog);
		}

		//瞬间转移
		static public function sm_spaceMove_hide2(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player && player != Core.me) {
				UIManager.getInstance().mirScene.delPlayer(td.Recog);
			}
		}

		static public function sm_spaceMove_show2(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player && player == Core.me) {
				player.flyTo(td.Param, td.Tag, false);
				UIManager.getInstance().mirScene.setMapPs(player.x, player.y);
			}
		}

		//瞬间转移，清除场景
		static public function sm_clearObjects(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().mirScene.clearLiving();
		}

		static public function sm_xxxx(td:TDefaultMessage, body:String):void {

		}

		//地刺
		static public function sm_716(td:TDefaultMessage, body:String):void {
//			BulletManager.getInstance().addxxx(td.Series, td.Param, td.Tag);
//			BulletManager.getInstance().addBullet(td.Recog, -1, td.Param, td.Tag, 0, 18);
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			var tPlayer:LivingModel=UIManager.getInstance().mirScene.findPlayer(new Point(td.Param, td.Tag));
			player && player.actBulletAttack(td.Series, tPlayer.id);
		}

		//正常死亡
		static public function sm_death(td:TDefaultMessage, body:String):void {
			var desc:TCharDesc=new TCharDesc(NetEncode.getInstance().DecodeBuffer(body));
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				player.actHit(0, 0);
			} else {
				return;
				var f:TFeature=new TFeature();
				f.feature=desc.feature;

				//根据不同类型的种族，创建玩家、npc、怪
				var info:LivingInfo=new LivingInfo();
				info.id=td.Recog;
//				info.name=nameStr;
				info.currentDir=HexUtil.LoByte(td.Series);
				info.nextTile.x=td.Param;
				info.nextTile.y=td.Tag;
				info.race=HexUtil.HiByte(td.Series); //职业

				info.sex=f.sex;
				info.type=f.type; //种族

				f.copyTo(info.featureInfo);

				player=UIManager.getInstance().mirScene.addOtherLiving(info);
				DelayCallManager.getInstance().delByOwner(player);
				player.infoB.actLocked=false;
				player.actHit(0, 0);
			}
		}

		//复活
		static public function sm_alive(td:TDefaultMessage, body:String):void {
//			PlayScene.SendMsg (SM_ALIVE, msg.Recog, msg.param{HP}, msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, '');
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
//			print("玩家复活" + player.infoB.name);
			if (!player)
				return;
			player.revive(td.Param);


			var t:TCharDesc=new TCharDesc(NetEncode.getInstance().DecodeBuffer(body));
			var info:FeatureInfo=new FeatureInfo();
			var f:TFeature=new TFeature();
			f.feature=t.feature;
			f.copyTo(info);
			player.changeAvatars(info);
		}

		//投掷斧头等镖
		static public function sm_flyaxe(td:TDefaultMessage, body:String):void {
			var t:TMessageBodyW=new TMessageBodyW(NetEncode.getInstance().DecodeBuffer(body));
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			var tPlayer:LivingModel=UIManager.getInstance().mirScene.getPlayer(HexUtil.MakeLong(t.Tag1, t.Tag2));
			if (!tPlayer || !player)
				return;
//			print("玩家名称：", player.infoB.name, "目标living：" + tPlayer.infoB.name);
			player.actBulletAttack(td.Series, tPlayer.id);
//			player.autoAttack(null, td.Series );
//			BulletManager.getInstance().addBullet(td.Recog, MakeLong(t.Tag1, t.Tag2), tPlayer.nowTilePt().x, tPlayer.nowTilePt().y, 0, player.attackBullet);
		}

		//僵尸王
		static public function sm_lighting(td:TDefaultMessage, body:String):void {
			var t:TMessageBodyWL=new TMessageBodyWL(NetEncode.getInstance().DecodeBuffer(body));
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			var tPlayer:LivingModel=UIManager.getInstance().mirScene.getPlayer(t.Tag1);
			if (!tPlayer)
				return;
			//			print("玩家名称：", player.infoB.name, "目标living：" + tPlayer.infoB.name);
			player.actBulletAttack(td.Series, tPlayer.id);
		}

		//城门伤害
		static public function sm_digup(td:TDefaultMessage, body:String):void {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			player && player.changeDir(td.Series);
		}

		//玩家是否忙绿状态
		static public function playerIsBusy(td:TDefaultMessage):Boolean {
			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(td.Recog);
			if (player) {
				return player.isBusy();
			}
			return false; //
			UIManager.getInstance().toolsWnd.updateExp();
		}
	}
}