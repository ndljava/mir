package com.leyou.net.protocol {
	import com.leyou.config.Core;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.FriendEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Chat {

		static public function upAndDownHorse():void {
			if(Core.me.info.isStall||Core.me.info.isDead)
				return;
			if (Core.me.info.isOnMount)
				Cmd_Chat.cm_say("@下马");
			else
				Cmd_Chat.cm_say("@骑马");
		}

		//说话【!区域 、	!!组队、 	!~行会 、 /私聊】
		static public function cm_say(text:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_SAY, 0, 0, 0, 0, text);
		}

		//普通+区域【[40]face12:普通说话】【[40](!)face12: 区域说话】
		static public function sm_hear(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_COMPOSITE, body);
		}

		//系统移动消息【[99]诅咒的封印被释放，大量恶魔出现在猪洞七层！】
		static public function sm_moveMessage(td:TDefaultMessage, body:String):void {
			
			if(body.indexOf(FriendEnum.RECEIVE_FRIENDLIST)>-1){
				UIManager.getInstance().friendWnd.friendList(body);
				return;
			}
			if (body.indexOf("####get") > -1) {
				//trace(body)
				UIManager.getInstance().teamWnd.setTeamInfo(body);
				return;
			}

			if (body.indexOf("####") > -1) {
				UIManager.getInstance().guildWnd.updateData(String(body.split("=")[1]).split(","));
				return;
			}
			
//			trace("td.Ident" +td.Ident+
//				",td.nExValue "+td.nExValue+
//				",td.nSessionID "+td.nSessionID+
//				",td.nExValue "+td.nExValue+
//				",td.Param "+td.Param+
//				",td.Recog "+td.Recog+
//				",td.Series "+td.Series+"  "+body);


			if (td.Series == 0) { //0 滚动  中央向上1  3 个人系统4
				if (body.indexOf("千里传音") != -1) { //千里传音 显示在喇叭区
					UIManager.getInstance().chatWnd.addHorn(body); //喇叭显示
				} else
					UIManager.getInstance().noticeLeftroll.setNoticeStr(body);
				return;
			}
			if (body.indexOf("通过抽奖") != -1) { //中间向上

				UIManager.getInstance().noticeUproll.setNoticeStr(body);
				return;
			}
			if (td.Series == 1) { //中央向上1
				UIManager.getInstance().noticeUproll.setNoticeStr(body);
			}
			else if (td.Series == 4) { //
				UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, body);
			}
			else if (td.Series == 2) { //倒计时
				UIManager.getInstance().noticeCountDown.ser_CountDown(td, body); //tag 秒
			}
			else UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM,body);
		}

		//系统消息--【[100]〖组队〗face12: 组队说话】组队
		static public function sm_sysMessage(td:TDefaultMessage, body:String):void {
//			trace("td.Ident " +td.Ident+
//				",td.nExValue "+td.nExValue+
//				",td.nSessionID "+td.nSessionID+
//				",td.nExValue "+td.nExValue+
//				",td.Param "+td.Param+
//				",td.Recog "+td.Recog+
//				",td.Series "+td.Series+"  "+body);

			//个人聊天 1
			if (body.indexOf("对方已经确认交易了") > -1) {

				UIManager.getInstance().tradeWnd.setLock(true, false);
				return;
			}
			//[提示]与face32加为好友！】
			if(body.indexOf("加为好友")>-1||body.indexOf("[提示]已删除好友")>-1||body.indexOf("已与您断绝好友关系")>-1){
				UIManager.getInstance().friendWnd.requestFriendList();
			}
			UIManager.getInstance().settingWnd.checkServReturn(body);
			if (body.indexOf("〖组队〗") != -1 && body.indexOf(":") != -1)
				UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_TEAM, body);
			else {
				if (body.indexOf("没有在线！") != -1)
					UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_PRIVATE, body);
				else {
					if (td.Series == 1) { //活动公告
						UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM_ALL, body);
					} else
						UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_SYSTEM, body);
				}
			}
		}

		//组内聊天!!【[100]〖组队〗face12: 组队说话】系统
		static public function sm_groupMessage(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_TEAM, body);
		}

		//私聊【[103]face12[70级]=>私聊】
		static public function sm_whisper(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_PRIVATE, body);
		}

		////行会聊天!~【[104]face12: 行会说话】
		static public function sm_guildMessage(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().chatWnd.servOnChat(ChatEnum.CHANNEL_GUILD, body);
		}

	}
}
