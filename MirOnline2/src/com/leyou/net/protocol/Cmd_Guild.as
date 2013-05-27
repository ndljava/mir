package com.leyou.net.protocol {
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.utils.HexUtil;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Guild {
		/**
		 * 当前仓库的页数
		 */
		private static var currentStorePage:Array=[0];

		//打开行会
		static public function cm_openGuildDlg():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_OPENGUILDDLG, 0, 0, 0, 0);
		}

		//打开行会-ok
		static public function sm_openGuildDlg(td:TDefaultMessage, body:String):void {
			UIManager.getInstance().guildWnd.guildLv=td.Recog; //行会等级
			UIManager.getInstance().guildWnd.guildMemeberNum=HexUtil.LoWord(td.Param); //行会人数
			UIManager.getInstance().guildWnd.guildMemeberTopNum=HexUtil.HiWord(td.Param); //行会人数上限
			body; //主页内容文字，自己拆分下

			UIManager.getInstance().guildWnd.serv_showGuild(body);
		}

		//打开行会-fail
		static public function sm_openGuildDlg_fail(td:TDefaultMessage, body:String):void {
			//提示：您还没有加入行会.
			UIManager.getInstance().noticeMidDownUproll.setNoticeStr("打开行会失败!!!",0);
		}

		//成员列表
		static public function cm_guildMemberList():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GUILDMEMBERLIST, 0, 0, 0, 0);
		}

		//成员列表-返回
		static public function sm_sendGuildMemberList(td:TDefaultMessage, body:String):void {
			trace(body); //类似=='#1/*掌门人/face71/#2/*行会成员/face141'
			UIManager.getInstance().guildWnd.serv_updateMemberList(body);
		}

		//主页
		static public function cm_guildHome():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GUILDHOME, 0, 0, 0, 0);
		}

		//主页---返回==【//打开行会-ok】

		//行会仓库 【参数：1-6分别为类别】
		static public function cm_guildStroage(type:int, index:int=0):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GUILDSTROAGE, index, type, 0, 0);
			currentStorePage[type]=index;
		}

		//行会仓库-返回
		static public function sm_guildStroage(td:TDefaultMessage, body:String):void {
//			HexUtil.LoWord(td.nSessionID);//判断是否第一次打开？
			var type:int=HexUtil.LoWord(td.Param); //类型
			//if (currentStorePage[type] < totalCount - 1) {
			//				currentStorePage[type]++;
			//				cm_guildStroage(type, currentStorePage[type]);
			//			}
			UIManager.getInstance().guildWnd.serv_updateStore(td, body, currentStorePage[type]);
		}

		//行会仓库到--贡献、称号、备战、个人【参数：类型，道具id，值】
		static public function cm_guildStroageType(type:int, makeIndex:int, value:int=0, str:String=""):void {
			if (str == "") {
				CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GUILDSTROAGETYPE, type, makeIndex, value, 0);
			} else {
				CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_GUILDSTROAGETYPE, type, makeIndex, value, 0, str);
			}
		}

		/**
		 * 拆分贡献值
		 * @param value
		 *
		 */
		static public function cm_guildContribute(value:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GUILDCONTRIBUTE, 0, value, 0, 0);
		}

		//行会仓库到--贡献-ok
		static public function sm_guildStroageType_succ(td:TDefaultMessage, body:String):void {
			//无返回参数
			//trace(body, "行会仓库到--贡献-ok");
		}

		//背包拖到行会仓库【type:1会长拖放，2会员贡献】
		static public function cm_addGuildItem(makeIndex:int, type:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_ADDGUILDITEM, 0, makeIndex, type, 0);
		}

		/**
		金币
		CM_ADDGUILDGOLD, 0, nGold, 0, 0）
		*/
		static public function cm_addGuildGold(gold:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_ADDGUILDGOLD, 0, gold, 0, 0);
		}

		//背包拖到行会仓库-ok
		static public function sm_addGuildItem_succ(td:TDefaultMessage, body:String):void {
			//无返回参数
			trace(body, "背包拖到行会仓库-ok");
		}

		//背包拖到行会仓库-fail
		static public function sm_addGuildItem_fail(td:TDefaultMessage, body:String):void {
			//无返回参数
			trace(body, "背包拖到行会仓库-fail");
		}

		//行会库到背包[type:0会员，1会长]
		static public function cm_takeGuildItem(makeIndex:int, type:int=0):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_TAKEGUILDITEM, 0, makeIndex, type, type);
		}


		//行会库到背包-ok
		static public function sm_masterTakeGuildItem(td:TDefaultMessage, body:String):void {
			//无返回参数

		}

		//行会库到背包-fail
		static public function sm_masterTakeGuildItemFail(td:TDefaultMessage, body:String):void {
			//无返回参数
		}

		//行会库到背包-贡献
		static public function sm_contribute(td:TDefaultMessage, body:String):void {
			MyInfoManager.getInstance().baseInfo.contribution=td.Recog; //行会贡献
		}

		//添加成员
		static public function cm_guildAddMember(who:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_GUILDADDMEMBER, 0, 0, 0, 0, who);
		}

		//添加成员--ok
		static public function sm_guildAddMember_ok(td:TDefaultMessage, body:String):void {
			cm_guildMemberList(); //刷新列表
		}

		//添加成员--fail
		static public function sm_guildAddMember_fail(td:TDefaultMessage, body:String):void {
			switch (td.Recog) {
				case 1:
					//FrmDlg.DMessageDlg ('你没有权利使用这个命令.', [mbOk]);
					trace("你没有权利使用这个命令")
					break;
				case 2:
					//FrmDlg.DMessageDlg ('想加入行会的应该来面对行会掌门人.', [mbOk]);
					trace("想加入行会的应该来面对行会掌门人.")
					break;
				case 3:
					//FrmDlg.DMessageDlg ('对方已经加入行会.', [mbOk]);
					trace("对方已经加入行会")
					break;
				case 4:
					//FrmDlg.DMessageDlg ('对方已经加入其他行会.', [mbOk]);
					trace("对方已经加入其他行会")
					break;
				case 5:
					//FrmDlg.DMessageDlg ('对方不想加入行会.', [mbOk]);
					trace("对方不想加入行会")
					break;
				case 6:
					//FrmDlg.DMessageDlg ('你的行会人数已达上限.', [mbOk]);
					trace("你的行会人数已达上限.")
					break;
			}
		}


		//删除成员
		static public function cm_guildDelMember(who:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_GUILDDELMEMBER, 0, 0, 0, 0, who);
		}

		//删除成员-ok
		static public function sm_guildDelMember_ok(td:TDefaultMessage, body:String):void {
			cm_guildMemberList(); //刷新列表
		}

		//删除成员-fail
		static public function sm_guildDelMember_fail(td:TDefaultMessage, body:String):void {
			switch (td.Recog) {
				case 1:
					//FrmDlg.DMessageDlg('不能使用命令！', [mbOk]);
					trace("不能使用命令");
					break;
				case 2:
					//FrmDlg.DMessageDlg('此人非本行会成员！', [mbOk]);
					trace("此人非本行会成员");
					break;
				case 3:
					//FrmDlg.DMessageDlg('行会掌门人不能开除自己！', [mbOk]);
					trace("行会掌门人不能开除自己");
					break;
				case 4:
					//FrmDlg.DMessageDlg('不能使用命令Z！', [mbOk]);
					trace("不能使用命令");
					break;
			}
		}

		//编辑公告
		static public function cm_guildUpdateNotice(notices:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_GUILDUPDATENOTICE, 0, 0, 0, 0, notices);
		}

		//编辑封号
		static public function cm_guildUpdateRankinfo(rankinfo:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_GUILDUPDATERANKINFO, 0, 0, 0, 0, rankinfo);
		}

		//编辑封号--返回   修改协会名称
		static public function sm_changeGuildName(td:TDefaultMessage, body:String):void {
			//body; //行会名字
			if (body == null || body == "")
				UIManager.getInstance().guildWnd.hide()
		}

		//SM_GUILDRANKUPDATE_FAIL
		static public function sm_guildRankUpdate_fail(td:TDefaultMessage, body:String):void {
			body; //行会名字
			trace(body, "======");

			switch (td.Recog) {
				case -1:
					//FrmDlg.DMessageDlg ('您无此权限！', [mbOk]);
					trace("您无此权限");
					break;
				case -2:
					//FrmDlg.DMessageDlg ('结盟失败！', [mbOk]);
					trace("掌门人位置不能为空。");
					break;
				case -3:
					//FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
					trace("新的行会掌门人已经被传位。");
					break;
				case -4:
					//FrmDlg.DMessageDlg ('对方行会掌门人不允许结盟！', [mbOk]);
					trace("一个行会最多只能有二个掌门人。");
					break;
				case -5:
					//FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
					trace("掌门人位置不能为空。");
					break;
				case -6:
					//FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
					trace("不能添加成员/删除成员。");
					break;
				case -7:
					//FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
					trace("职位重复或者出错。");
					break;
			}

		}

		//联盟==说话协议
		static public function xx22xxxx():void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_SAY, 0, 0, 0, 0);
		}

		//联盟-ok
		static public function sm_guildMakeAlly_ok(td:TDefaultMessage, body:String):void {

		}

		//联盟-fail
		static public function sm_guildMakeAlly_fail(td:TDefaultMessage, body:String):void {

			switch (td.Recog) {
				case -1:
					//FrmDlg.DMessageDlg ('您无此权限！', [mbOk]);
					trace("您无此权限");
					break;
				case -2:
					//FrmDlg.DMessageDlg ('结盟失败！', [mbOk]);
					trace("结盟失败");
					break;
				case -3:
					//FrmDlg.DMessageDlg ('行会结盟必须双方掌门人面对面！', [mbOk]);
					trace("行会结盟必须双方掌门人面对面");
					break;
				case -4:
					//FrmDlg.DMessageDlg ('对方行会掌门人不允许结盟！', [mbOk]);
					trace("对方行会掌门人不允许结盟");
			}
		}
//		创建行会

	}
}
