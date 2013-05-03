package com.leyou.net.protocol.login {
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.npc.NpcUI;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.ui.window.children.AlertWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.ace.utils.HexUtil;
	import com.leyou.config.Core;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.NetEncode;
	import com.leyou.net.NetEnum;
	import com.leyou.net.NetGate;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.TDefaultMessage;
	import com.leyou.net.protocol.scene.CmdScene;
	import com.leyou.ui.selectUser.info.SelectUserInfo;
	
	import flash.geom.Point;

	public class Cmd_Login {

		//登录
		static public function cm_Login(userName:String, pwd:String):void {
			var t_DefaultMsg:TDefaultMessage=new TDefaultMessage;
			t_DefaultMsg.MakeDefaultMsg(MirProtocol.CM_IDPASSWORD, 0, 0, 0, 0, NetGate.getInstance().certification);

			var t_strpid:String=userName + '/' + pwd + '/' + Core.gameVersion;
			var t_str:String=NetEncode.getInstance().EncodeMessage(t_DefaultMsg);
			var t_strx:String=NetEncode.getInstance().EncodeString(t_strpid);
			t_str+=t_strx;
			t_strx=NetEncode.getInstance().GetSendText(2, t_str);

			NetGate.getInstance().SendString(t_strx);
		}

		static public var serBody:String;

		//登录成功
		static public function sm_Login(td:TDefaultMessage, body:String):void {
			serBody=body;
			cm_SelectServer(body.split("/")[0]);
		}

		//选服务器
		static public function cm_SelectServer(serverName:String):void {
			var t_Msg:TDefaultMessage=new TDefaultMessage;
			t_Msg.MakeDefaultMsg(MirProtocol.CM_SELECTSERVER, 0, 0, 0, 0, NetGate.getInstance().certification);

			var t_str:String=NetEncode.getInstance().EncodeMessage(t_Msg);
			serverName=NetEncode.getInstance().EncodeString(serverName);
			serverName=NetEncode.getInstance().GetSendText(2, t_str + serverName);
			NetGate.getInstance().SendString(serverName);
		}

		//选服务器成功
		static public function sm_selectServer(td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");
			NetGate.getInstance().certification=uint(arr[2]);
			NetGate.getInstance().changeConnect(arr[0], arr[1], onConnectSelectUserSer);
		}

		//连接角色服务器成功5
		static public function onConnectSelectUserSer():void {
			cm_QueryChr(serBody.split("/")[1]);
		}

		static public function cm_QueryChr(nCode:uint):void {
			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_QUERYCHR, 0, 0, 0, nCode, NetGate.getInstance().certification);

			var t_str:String=serBody.split("/")[2];
			t_str=t_str.split("|")[1];
			t_str+='/' + NetGate.getInstance().certification;
			t_str=NetEncode.getInstance().EncodeString(t_str);
			t_str=NetEncode.getInstance().GetSendText(2, NetEncode.getInstance().EncodeMessage(t_msg) + t_str);
			NetGate.getInstance().SendString(t_str);

		}

		static public function sm_QueryChr(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().addSelectUserWnd();
			UIManager.getInstance().loginWnd.die();
			UIManager.getInstance().selectUserWnd.ser_updataUser(body);
		}

		//创建角色【账号 + '/' + 角色名称 + '/' + 头发 + '/' + 职业 + '/' + 性别】
		static public function cm_newChr(str:String):void {
			var t_msg:TDefaultMessage=new TDefaultMessage();
			t_msg.MakeDefaultMsg(MirProtocol.CM_NEWCHR, 0, 0, 0, 0, NetGate.getInstance().certification);
			CmdScene.SendSocketStr((NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeString(str)), 2);
		}

		//创建角色-ok
		static public function sm_newChr_success(td:TDefaultMessage, body:String):void {
			cm_QueryChr(0);
			UIManager.getInstance().creatUserWnd.die();
			
		}

		//创建角色-fail
		static public function sm_newChr_fail(td:TDefaultMessage, body:String):void {
			if(td.Recog==0)
				PopupManager.showAlert("输入的名称包含非法字符！");
			else if(td.Recog==2)
				PopupManager.showAlert("创建的名称服务器已有！");
			else if(td.Recog==3)
				PopupManager.showAlert("服务器只能创建两个游戏人物！");
			else if(td.Recog==4)
				PopupManager.showAlert("创建游戏人物时出现错误！");
			else
				PopupManager.showAlert("创建游戏人物时出现未知错误！");
				
		/*case td.Recog of
		0: ('[错误] 输入的名称包含非法字符！', [mbOk]);
		2:  ('[错误] 创建的名称服务器已有', [mbOk]);
		3: ('[错误] 服务器只能创建两个游戏人物', [mbOk]);
		4: ('[错误] 创建游戏人物时出现错误。', [mbOk]);
		else ('[错误] 创建游戏人物时出现未知错误', [mbOk]);
		end;*/
		}

		private static var charName:String;

		static public function cm_SelChr($charName:String):void {
			charName=$charName;
			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_SELCHR, 0, 0, 0, 0, NetGate.getInstance().certification);
			var t_str:String=serBody.split("/")[2];
			t_str=t_str.split("|")[1];
			t_str+='/' + charName;
			t_str=NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeString(t_str);
			t_str=NetEncode.getInstance().GetSendText(2, t_str);
			NetGate.getInstance().SendString(t_str);
		}

		static public function sm_SelChr(td:TDefaultMessage, body:String):void {
//			192.168.10.16/9007
			NetGate.getInstance().changeConnect(body.split("/")[0], body.split("/")[1], onConnetctGameSer);
		}

		static public function onConnetctGameSer():void {
			cm_RunLogin();
		}

		//登录游戏服务器
		static private function cm_RunLogin():void {
			var playerName:String=serBody.split("/")[2];
			playerName=playerName.split("|")[1];
			var t_str:String="**";
			t_str+=playerName + '/' + charName + '/' + NetGate.getInstance().certification + '/' + MirProtocol.CLIENT_VERSION_NUMBER + '/' + '0';
			t_str=NetEncode.getInstance().EncodeString(t_str);
			t_str=NetEncode.getInstance().GetSendText(1, t_str);
			NetGate.getInstance().SendString(t_str);
		}

		static public function sm_RunLogin(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().selectUserWnd.die();
			UIManager.getInstance().addSceneWnd()
			cm_SendSelfInfo();

		}

		//发送机器信息
		static private function cm_SendSelfInfo():void {
			var t_strMac:String='DC-85-DE-14-5A-5A';
			var t_strIDE:String='S1E0WD0D';
			var t_strMd5:String='aacc2fd4b01daba23e3f7c403a04d9d5/2.26';

			var t_msg:TDefaultMessage=new TDefaultMessage;
			t_msg.MakeDefaultMsg(MirProtocol.CM_LOGINNOTICEOK, 0, 0, 0, MirProtocol.CLIENTTYPE, NetGate.getInstance().certification);

			// str := sIDE+'/'+sMac+'/'+g_Md5String+'/'+inttostr(g_ShowMode);
			var t_str:String=t_strIDE + '/' + t_strMac + '/' + t_strMd5 + '/' + '0';
			t_str=NetEncode.getInstance().EncodeMessage(t_msg) + NetEncode.getInstance().EncodeString(t_str);
			t_str=NetEncode.getInstance().GetSendText(1, t_str);
			NetGate.getInstance().SendString(t_str);
		}


		static public function sm_NewMap(td:TDefaultMessage, body:String):void {
//			m_nX = td.Param;
//			m_nY = td.Tag;
//			trace("hero pos,x:" + m_nX + "y:" + m_nY);

			UIManager.getInstance().mirScene.gotoMap(body, new Point(td.Param, td.Tag));
		}

		static public function sm_Logon(td:TDefaultMessage, body:String):void {
			NetGate.getInstance().startHeart();

			var a:SelectUserInfo=Core.selectInfo;

			//			var info:PlayerInfo=new PlayerInfo();
			var info:PlayerInfo=MyInfoManager.getInstance();
			info.level=Core.selectInfo.level;
			info.name=Core.selectInfo.name;
			info.race=Core.selectInfo.race;
			info.sex=Core.selectInfo.sex;
			info.livingType=PlayerEnum.RACE_HUMAN;
			info.id=td.Recog;
			info.currentDir=HexUtil.LoByte(td.Series);
			info.initSkills();
			UIManager.getInstance().mirScene.addMe(info);
			onLogon();

			return;
			if (!Core.me) {
				DelayCallManager.getInstance().add(UIManager.getInstance().mirScene, UIManager.getInstance().mirScene.addMe, "addme", 48, td);
				return;
			}
			UIManager.getInstance().mirScene.addMe(td);
		}

		//登录时发送的
		static public function onLogon():void {
			Cmd_backPack.cm_queryBagItems(); //获取背包
			Cmd_backPack.cm_addStarItem();
		}

	}
}