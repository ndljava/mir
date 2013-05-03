package com.leyou.net {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.tools.print;
	import com.leyou.config.Core;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Forge;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.net.protocol.Cmd_Market;
	import com.leyou.net.protocol.Cmd_Role;
	import com.leyou.net.protocol.Cmd_Skill;
	import com.leyou.net.protocol.Cmd_Stall;
	import com.leyou.net.protocol.Cmd_Task;
	import com.leyou.net.protocol.Cmd_Team;
	import com.leyou.net.protocol.Cmd_Trade;
	import com.leyou.net.protocol.Cmd_backPack;
	import com.leyou.net.protocol.TDefaultMessage;
	import com.leyou.net.protocol.login.Cmd_Login;
	import com.leyou.net.protocol.scene.CmdScene;

	public class ServerFunDic {
		private static var dict:Object=null;
		private static var cacheCmdDic:Object=null;

		public function ServerFunDic() {
		}

		public static function setup():void {
			if (!ServerFunDic.dict) {
				dict={};
				cacheCmdDic={};
				//登录
				dict[MirProtocol.SM_PASSOK_SELECTSERVER]=Cmd_Login.sm_Login;
				dict[MirProtocol.SM_SELECTSERVER_OK]=Cmd_Login.sm_selectServer;
				dict[MirProtocol.SM_QUERYCHR]=Cmd_Login.sm_QueryChr;
				dict[MirProtocol.SM_STARTPLAY]=Cmd_Login.sm_SelChr;
				dict[MirProtocol.SM_SENDNOTICE]=Cmd_Login.sm_RunLogin;
				dict[MirProtocol.SM_NEWMAP]=Cmd_Login.sm_NewMap;
				dict[MirProtocol.SM_LOGON]=Cmd_Login.sm_Logon;
				dict[MirProtocol.SM_NEWCHR_SUCCESS]=Cmd_Login.sm_newChr_success;
				dict[MirProtocol.SM_NEWCHR_FAIL]=Cmd_Login.sm_newChr_fail;

				dict[MirProtocol.SM_CHANGEMAP]=CmdScene.sm_changeMap; //地图传送			
				//移动等协议

				dict[MirProtocol.SM_ALIVE]=CmdScene.sm_alive;
				dict[MirProtocol.SM_FEATURECHANGED]=CmdScene.sm_featurechanged;
				dict[MirProtocol.SM_TURN]=CmdScene.sm_Turn;
				dict[MirProtocol.SM_WALK]=CmdScene.sm_walk;
				dict[MirProtocol.SM_RUN]=CmdScene.sm_run;
				dict[MirProtocol.SM_HORSERUN]=CmdScene.sm_run;
				dict[MirProtocol.SM_USERNAME]=CmdScene.sm_userName;
				dict[MirProtocol.SM_DISAPPEAR]=CmdScene.sm_disappear;

				//战士技能
				dict[MirProtocol.SM_HIT]=CmdScene.sm_hit;
				dict[MirProtocol.SM_HEAVYHIT]=CmdScene.sm_hit;
				dict[MirProtocol.SM_POWERHIT]=CmdScene.sm_powerHit;
				dict[MirProtocol.SM_LONGHIT]=CmdScene.sm_longhit;
				dict[MirProtocol.SM_WIDEHIT]=CmdScene.sm_widehit;
				dict[MirProtocol.SM_FIREHIT]=CmdScene.sm_firHit;

				dict[MirProtocol.SM_RUSH]=CmdScene.sm_rush; //野蛮冲撞
				dict[MirProtocol.SM_BACKSTEP]=CmdScene.sm_backStep;
				dict[MirProtocol.SM_HEALTHSPELLCHANGED]=CmdScene.sm_healthSpellChanged;

				//攻击后其他协议
				dict[MirProtocol.SM_STRUCK]=CmdScene.sm_struck; //受攻击
				dict[MirProtocol.SM_DURACHANGE]=CmdScene.sm_xxxx; //受攻击
				dict[MirProtocol.SM_CHANGENAMECOLOR]=CmdScene.sm_changeNameColor;

				//法师
				dict[MirProtocol.SM_SPELL]=CmdScene.sm_spell;
				dict[MirProtocol.SM_MAGICFIRE]=CmdScene.sm_magicFire;
				dict[MirProtocol.SM_MAGICFIRE_FAIL]=CmdScene.sm_magicFireFail;

				//持续火墙、特效等
				dict[MirProtocol.SM_SHOWEVENT]=CmdScene.sm_showEvent;
				dict[MirProtocol.SM_HIDEEVENT]=CmdScene.sm_hideEvent;
				//魔法盾、隐身等
				dict[MirProtocol.SM_CHARSTATUSCHANGED]=CmdScene.sm_charStatusChanged;
				//瞬间转移
				dict[MirProtocol.SM_SPACEMOVE_HIDE2]=CmdScene.sm_spaceMove_hide2;
				dict[MirProtocol.SM_SPACEMOVE_SHOW2]=CmdScene.sm_spaceMove_show2;
				dict[MirProtocol.SM_CLEAROBJECTS]=CmdScene.sm_clearObjects;

				//心灵启示
				dict[MirProtocol.SM_OPENHEALTH]=CmdScene.sm_openHealth;
				dict[MirProtocol.SM_CLOSEHEALTH]=CmdScene.sm_closeHealth;
				
				//其他
				dict[MirProtocol.SM_SERVERCONFIG]=CmdScene.sm_xxxx;


				//怪物
				dict[MirProtocol.SM_716]=CmdScene.sm_716;
				dict[MirProtocol.SM_DEATH]=CmdScene.sm_death;
				dict[MirProtocol.SM_NOWDEATH]=CmdScene.sm_death;
				dict[MirProtocol.SM_FLYAXE]=CmdScene.sm_flyaxe;
				dict[MirProtocol.SM_DIGUP]=CmdScene.sm_digup; //
				dict[MirProtocol.SM_LIGHTING]=CmdScene.sm_lighting; //僵尸王放电


				if (Core.bugTest)
					return;

				//背包
				dict[MirProtocol.SM_GAMEGOLDNAME]=Cmd_backPack.sm_gameGoldName;
				dict[MirProtocol.SM_BAGITEMS]=Cmd_backPack.sm_bagItems;
				dict[MirProtocol.SM_ADDITEM]=Cmd_backPack.sm_addItem;
				dict[MirProtocol.SM_DELITEM]=Cmd_backPack.sm_delItem;
				dict[MirProtocol.SM_UPDATEITEM]=Cmd_backPack.sm_updateItem;
				dict[MirProtocol.SM_ITEMCHANGECOUNT]=Cmd_backPack.sm_itemChangeCount;
				//				dict[MirProtocol.SM_MERCHANTSAY]=Cmd_backPack.sm_merchantSay;//仓库
				dict[MirProtocol.SM_SAVEITEMLIST]=Cmd_backPack.sm_saveItemList;
				dict[MirProtocol.SM_STORAGE_OK]=Cmd_backPack.sm_storage_ok; //背包转仓库的返回协议
				dict[MirProtocol.SM_STORAGE_FULL]=Cmd_backPack.sm_storage_full;
				dict[MirProtocol.SM_STORAGE_FAIL]=Cmd_backPack.sm_storage_fail;
				dict[MirProtocol.SM_TAKEBACKSTORAGEITEM_OK]=Cmd_backPack.sm_takeBackStorageItem_ok; //仓库取回
				dict[MirProtocol.SM_TAKEBACKSTORAGEITEM_FAIL]=Cmd_backPack.sm_takeBackStorageItem_fail;
				dict[MirProtocol.SM_TAKEBACKSTORAGEITEM_FULLBAG]=Cmd_backPack.sm_takeBackStorageItem_fullBag;
				dict[MirProtocol.SM_DROPITEM_SUCCESS]=Cmd_backPack.sm_dropItem_success;
				dict[MirProtocol.SM_DROPITEM_FAIL]=Cmd_backPack.sm_dropItem_fail;


				//显示道具
				dict[MirProtocol.SM_ITEMSHOW]=Cmd_backPack.sm_itemShow;
				dict[MirProtocol.SM_ITEMHIDE]=Cmd_backPack.sm_itemHide;

				//使用道具
				dict[MirProtocol.SM_TAKEON_OK]=Cmd_backPack.sm_takeOn_ok;
				dict[MirProtocol.SM_TAKEON_FAIL]=Cmd_backPack.sm_takeOn_fail;
				dict[MirProtocol.SM_EAT_OK]=Cmd_backPack.sm_eat_ok;
				dict[MirProtocol.SM_EAT_FAIL]=Cmd_backPack.sm_eat_fail;

				//技能
				dict[MirProtocol.SM_SENDMYMAGIC]=Cmd_Skill.sm_sendMyMagic;
				dict[MirProtocol.SM_ADDMAGIC]=Cmd_Skill.sm_addMagic;
				dict[MirProtocol.SM_MAGIC_LVEXP]=Cmd_Skill.sm_magic_lvExp;

				//聊天
				dict[MirProtocol.SM_HEAR]=Cmd_Chat.sm_hear;
				//				dict[MirProtocol.SM_CRY]=Cmd_Chat.sm_sysMessage;
				dict[MirProtocol.SM_GROUPMESSAGE]=Cmd_Chat.sm_groupMessage;
				dict[MirProtocol.SM_GUILDMESSAGE]=Cmd_Chat.sm_guildMessage;
				dict[MirProtocol.SM_WHISPER]=Cmd_Chat.sm_whisper;
				dict[MirProtocol.SM_MOVEMESSAGE]=Cmd_Chat.sm_moveMessage;
				dict[MirProtocol.SM_SYSMESSAGE]=Cmd_Chat.sm_sysMessage;



				//角色面板
				dict[MirProtocol.SM_ABILITY]=Cmd_Role.sm_ability;
				dict[MirProtocol.SM_SUBABILITY]=Cmd_Role.sm_subAbility;
				dict[MirProtocol.SM_SENDUSEITEMS]=Cmd_Role.sm_sendUseItems;
				dict[MirProtocol.SM_TAKEOFF_FAIL]=Cmd_Role.sm_takeOff_fail;
				dict[MirProtocol.SM_TAKEOFF_OK]=Cmd_Role.sm_takeOff_ok;
				dict[MirProtocol.SM_WEIGHTCHANGED]=Cmd_Role.sm_weightChanged;
				dict[MirProtocol.SM_WINEXP]=Cmd_Role.sm_winExp; //经验改变
				dict[MirProtocol.SM_LEVELUP]=Cmd_Role.sm_levelUp; //升级
				//属性分配
				dict[MirProtocol.SM_ADJUST_BONUS]=Cmd_Role.sm_adjust_bonus;
				//查看其它玩家
				dict[MirProtocol.SM_SENDUSERSTATE]=Cmd_Role.sm_sendUserState;
				

				//交易
				dict[MirProtocol.SM_DEALMENU]=Cmd_Trade.sm_dealMenu;
				dict[MirProtocol.SM_DEALTRY_FAIL]=Cmd_Trade.sm_dealtry_fail;
				dict[MirProtocol.SM_DEALADDITEM_OK]=Cmd_Trade.sm_dealAddItem_ok;
				dict[MirProtocol.SM_DEALADDITEM_FAIL]=Cmd_Trade.sm_dealAddItem_fail;
				dict[MirProtocol.SM_DEALDELITEM_OK]=Cmd_Trade.sm_dealDelItem_ok;
				dict[MirProtocol.SM_DEALDELITEM_FAIL]=Cmd_Trade.sm_dealDelItem_fail;
				dict[MirProtocol.SM_DEALCANCEL]=Cmd_Trade.sm_dealCancel;
				dict[MirProtocol.SM_DEALREMOTEADDITEM]=Cmd_Trade.sm_dealRemoteAddItem;
				dict[MirProtocol.SM_DEALREMOTEDELITEM]=Cmd_Trade.sm_dealRemoteDelItem;
				dict[MirProtocol.SM_DEALCHGGOLD_OK]=Cmd_Trade.sm_dealChgGold_ok;
				dict[MirProtocol.SM_DEALCHGGOLD_FAIL]=Cmd_Trade.sm_dealChgGold_fail;
				dict[MirProtocol.SM_DEALREMOTECHGGOLD]=Cmd_Trade.sm_dealRemoteChgGold;
				dict[MirProtocol.SM_DEALSUCCESS]=Cmd_Trade.sm_dealSuccess;
				dict[MirProtocol.SM_MENU_OK]=Cmd_Trade.sm_menu_ok;

				//任务+商店
				dict[MirProtocol.SM_MERCHANTSAY]=Cmd_Task.sm_merchantSay;
				dict[MirProtocol.SM_SENDGOODSLIST]=Cmd_Task.sm_sendGoodsList;
				dict[MirProtocol.SM_BUYITEM_SUCCESS]=Cmd_Task.sm_buyItem_success;
				dict[MirProtocol.SM_BUYITEM_FAIL]=Cmd_Task.sm_buyItem_fail;
				dict[MirProtocol.SM_GOLDCHANGED]=Cmd_Task.sm_goldChanged;
				dict[MirProtocol.SM_USERSELLITEM_OK]=Cmd_Task.sm_userSellItem_ok;
				dict[MirProtocol.SM_USERSELLITEM_FAIL]=Cmd_Task.sm_userSellItem_fail;
				dict[MirProtocol.SM_MERCHANTDLGCLOSE]=Cmd_Task.sm_merchantdlgclose;
				dict[MirProtocol.SM_CloseBigDialogBox]=Cmd_Task.sm_closeBigDialogBox;

				//组队
				dict[MirProtocol.SM_CREATEGROUP_FAIL]=Cmd_Team.sm_createGroup_fail;
				dict[MirProtocol.SM_CREATEGROUP_OK]=Cmd_Team.sm_createGroup_ok;
				dict[MirProtocol.SM_GROUPADDMEM_FAIL]=Cmd_Team.sm_groupAddMem_fail;
				dict[MirProtocol.SM_GROUPADDMEM_OK]=Cmd_Team.sm_groupAddMem_ok;
				dict[MirProtocol.SM_GROUPCANCEL]=Cmd_Team.sm_groupCancel;
				dict[MirProtocol.SM_GROUPDELMEM_FAIL]=Cmd_Team.sm_groupDelMem_fail;
				dict[MirProtocol.SM_GROUPDELMEM_OK]=Cmd_Team.sm_groupDelMem_ok;
				dict[MirProtocol.SM_GROUPMEMBERS]=Cmd_Team.sm_groupMembers;
				dict[MirProtocol.SM_GROUPMODECHANGED]=Cmd_Team.sm_groupModeChanged;
				//dict[MirProtocol.SM_GROUPMESSAGE]=Cmd_Team.sm_group;

				//market
				dict[MirProtocol.SM_SENGSHOPITEMS]=Cmd_Market.sm_sengShopItems;
				dict[MirProtocol.SM_SENGSHOPSPECIALLYITEMS]=Cmd_Market.sm_sengShopSpeciallyItems;
				dict[MirProtocol.SM_BUYSHOPITEM_SUCCESS]=Cmd_Market.sm_buyShopItem_success;
				dict[MirProtocol.SM_BUYSHOPITEM_FAIL]=Cmd_Market.sm_buyShopItem_fail

				//摆摊
				dict[MirProtocol.SM_BTITEM_SUCCESS]=Cmd_Stall.sm_btItem_success;
				dict[MirProtocol.SM_BTITEM_FAIL]=Cmd_Stall.sm_btItem_fail;
				dict[MirProtocol.SM_BTITEM]=Cmd_Stall.sm_btitem;
				dict[MirProtocol.SM_BAITANITEM_FAIL]=Cmd_Stall.sm_btItem_fail;

				//行会
				dict[MirProtocol.SM_OPENGUILDDLG]=Cmd_Guild.sm_openGuildDlg;
				dict[MirProtocol.SM_ADDGUILDITEM_FAIL]=Cmd_Guild.sm_addGuildItem_fail;
				dict[MirProtocol.SM_ADDGUILDITEM_SUCC]=Cmd_Guild.sm_addGuildItem_succ;
				dict[MirProtocol.SM_CHANGEGUILDNAME]=Cmd_Guild.sm_changeGuildName;
				dict[MirProtocol.SM_CONTRIBUTE]=Cmd_Guild.sm_contribute;
				dict[MirProtocol.SM_GUILDADDMEMBER_FAIL]=Cmd_Guild.sm_guildAddMember_fail;
				dict[MirProtocol.SM_GUILDADDMEMBER_OK]=Cmd_Guild.sm_guildAddMember_ok;
				dict[MirProtocol.SM_GUILDDELMEMBER_FAIL]=Cmd_Guild.sm_guildDelMember_fail;
				dict[MirProtocol.SM_GUILDRANKUPDATE_FAIL]=Cmd_Guild.sm_guildRankUpdate_fail;
				dict[MirProtocol.SM_GUILDDELMEMBER_OK]=Cmd_Guild.sm_guildDelMember_ok;
				dict[MirProtocol.SM_GUILDMAKEALLY_FAIL]=Cmd_Guild.sm_guildMakeAlly_fail;
				dict[MirProtocol.SM_GUILDMAKEALLY_OK]=Cmd_Guild.sm_guildMakeAlly_ok;
				dict[MirProtocol.SM_GUILDSTROAGE]=Cmd_Guild.sm_guildStroage;
				dict[MirProtocol.SM_GUILDSTROAGETYPE_SUCC]=Cmd_Guild.sm_guildStroageType_succ;
				dict[MirProtocol.SM_MASTERTAKEGUILDITEM]=Cmd_Guild.sm_masterTakeGuildItem;
				dict[MirProtocol.SM_MASTERTAKEGUILDITEMFAIL]=Cmd_Guild.sm_masterTakeGuildItemFail;
				dict[MirProtocol.SM_OPENGUILDDLG_FAIL]=Cmd_Guild.sm_openGuildDlg_fail;
				dict[MirProtocol.SM_SENDGUILDMEMBERLIST]=Cmd_Guild.sm_sendGuildMemberList;
				
				
				//合成
				dict[MirProtocol.SM_OPENMITEMWIN]=Cmd_Forge.sm_openmItemWin;
				dict[MirProtocol.SM_FIFITEM_SUCC]=Cmd_Forge.sm_fifItem_succ;
				dict[MirProtocol.SM_FIFITEM_FAIL]=Cmd_Forge.sm_fifItem_fail;
				

			}
		}


		static private var spSmCmdArr:Array=[ //
			MirProtocol.SM_TURN, MirProtocol.SM_SPELL, MirProtocol.SM_MAGICFIRE, MirProtocol.SM_DEATH, MirProtocol.SM_BACKSTEP, //场景 
			MirProtocol.SM_BAGITEMS, MirProtocol.SM_SAVEITEMLIST, MirProtocol.SM_ADDITEM, MirProtocol.SM_DELITEM, MirProtocol.SM_UPDATEITEM, //背包
			MirProtocol.SM_SENDMYMAGIC, //技能
			MirProtocol.SM_ABILITY, MirProtocol.SM_SENDUSEITEMS, MirProtocol.SM_ADJUST_BONUS,MirProtocol.SM_SENDUSERSTATE,//角色
			MirProtocol.SM_DEALREMOTEADDITEM, MirProtocol.SM_DEALREMOTEDELITEM, //交易
			MirProtocol.SM_SENGSHOPITEMS, MirProtocol.SM_SENGSHOPSPECIALLYITEMS, //market
			MirProtocol.SM_BTITEM, //摆摊
			MirProtocol.SM_GUILDSTROAGE //行会
			];


		static private var skipCmdArr:Array=[14, 10, 41];

		public static function executeCmd(td:TDefaultMessage, body:String):void {
			var fun:Function;
			if (spSmCmdArr.indexOf(td.Ident) == -1) {
				body=NetEncode.getInstance().DecodeString(body);
			}
			fun=ServerFunDic.dict[td.Ident];
			if (fun == null) {
				trace("☆☆☆☆☆☆☆ 【警告！暂时还没有该类[" + td.Ident + "]" + body + "】 ☆☆☆☆☆☆☆");
				return;
			}

			if (skipCmdArr.indexOf(td.Ident) == -1)
				trace("收到协议❀❀❀❀❀❀❀❀❀❀❀❀❀【[" + td.Ident + "]" + body + "】");


			if ( /*td.Recog != MyInfoManager.getInstance().id &&*/cacheCmdArr.indexOf(td.Ident) != -1 && CmdScene.playerIsBusy(td)) {
				cacheCmd(td, body);
			} else {
				fun(td, body); //正常处理
			}
		}

		//
		static private var cacheCmdArr:Array=[MirProtocol.SM_WALK, MirProtocol.SM_RUN, MirProtocol.SM_RUSH, //
			MirProtocol.SM_BACKSTEP, MirProtocol.SM_STRUCK];

		//缓存
		static public function cacheCmd(td:TDefaultMessage, body:String):void {
			if (cacheCmdDic[td.Recog]) {
				if (td.Ident == MirProtocol.SM_STRUCK) {
					addCmd(td.Recog, td.Ident, [td, body]);
				} else {
					(cacheCmdDic[td.Recog] as Array).push([td, body]); //缓冲处理
				}
			} else {
				cacheCmdDic[td.Recog]=[[td, body]];
			}
		}

		static public function addCmd(playerId:uint, ident:uint, info:Array):void {
			var arr:Array=cacheCmdDic[playerId];
			for (var i:int=0; i < arr.length; i++) {
				if (ident == (arr[i][0] as TDefaultMessage).Ident) {
					arr.splice(i, 1);
					i--;
				}
			}
			arr.push(info);
		}

		//读取
		static public function getCmd(playerId:int):Boolean {
			var arr:Array;
			if (cacheCmdDic[playerId] && (cacheCmdDic[playerId] as Array).length > 0) {
				arr=(cacheCmdDic[playerId] as Array).shift();
				executeCmd_local(arr[0], arr[1]);
				return true;
			}
			return false;
		}

		static public function nextCacheCmd(playerId:int):uint {
			var arr:Array;
			if (cacheCmdDic[playerId] && (cacheCmdDic[playerId] as Array).length > 0) {
				arr=(cacheCmdDic[playerId] as Array)[0];
				return (arr[0] as TDefaultMessage).Ident;
			}
			return 999999;
		}

		//执行
		static public function executeCmd_local(td:TDefaultMessage, body:String):void {
			var fun:Function;
			fun=ServerFunDic.dict[td.Ident];
			fun(td, body);
		}
	}
}