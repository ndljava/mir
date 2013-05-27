package com.leyou.config {
	import com.ace.enum.UIEnum;
	import com.ace.utils.LoadUtil;
	
	//修改配置的
	public class GameConfig {
		static public function setup():void {
			UIEnum.READ_CACH=false;
			UIEnum.FRAME=32;
			UIEnum.WIDTH=1024;
			UIEnum.HEIGHT=768;
			UIEnum.ISPRINT=false;
			UIEnum.IS_PLAY_SOUND=false;
			UIEnum.VERSIONSM="3.12"; //资源版本号
			UIEnum.DATAROOT="http://192.168.10.16/webData/mirRes/";
			
			
			//做成分布加载ui和ui配置信息
			
			//测试用的
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/testUI.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.libCachSOL("lib/gameUI.lib"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("lib/modelUI/test.uif"));
			
			
			//表格配置
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/actTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/bulletTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/pnfTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/skillTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/livingTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/monSpeciesTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/itemTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/mapTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/transTable.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/table/itemAvatarTable.xml"));
			
			
			//默认avatar
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/baitan.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/suit/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/hair/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/weapon/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/effect/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/mount/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/mount_hair/999.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("player/mount_suit/999.pnf"));
			
			//地图
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/0/map.xx"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/3/map.xx"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/5/map.xx"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/6/map.xx"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/11/map.xx"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/0122/map.xx"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/0/map.jpg"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/3/map.jpg"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/6/map.jpg"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/11/map.jpg"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("scene/0122/map.jpg"));
			
			
			
			/*	//怪物
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/70200.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/70600.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/70701.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/70703.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/71800.pnf"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("monster/71801.pnf"));
			
			var i:int=0;
			for (i=100; i < 130; i++) {
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("magic/" + i + ".pnf"));
			}
			
			for (i=200; i < 210; i++) {
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("magic/" + i + ".pnf"));
			}
			
			for (i=300; i < 310; i++) {
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("magic/" + i + ".pnf"));
			}
			*/
			//登陆+选择角色
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/LoginWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/SelectUserWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/child/SelectUserBtn.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/login/login_background.jpg"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/selectPlayer/selectPlayer_button_3.png"));
			
			
			//小地图
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/SmallMapWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_map_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/other.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/self.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/npc.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/monster.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/self_bg.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/map/team.png"));
			
			//大地图
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/MapWnd.xml"));
			
			
			//面板配图
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/controlbarbackground.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/textarea.png"));
			if (Core.bugTest)
				return;
			
			//============================================ui资源【xml+png】======================================================
			
			
			//创建角色
			//			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/CreatUserWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/CreatUserWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/creatUser/UserBtn.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/creatUser/creatPlayer_dice_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/creatUser/playName_femalename.txt"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/creatUser/playName_malename.txt"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/creatUser/playName_surname.txt"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/roleHead_01.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/roleHead_02.png"));
			
			//聊天面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/ChatWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/chat/chat_button_small_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/chat/chat_button_enter_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/chat/chat_button_emosion_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/chat/ChatSecret.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/button_font.png"));
			var i:int;
			for (i=0; i < 40; i++) {
				var url:String="ui/chat/face/" + i + ".png";
				LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach(url));
			}
			
			//工具条
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/ToolsWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_skill_bar.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_character_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_skill_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_friend_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_party_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_team_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_horse_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_trade_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_bag_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_system_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_vip_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_button_IBshop_3.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_exp_bar_hp.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/main_exp_bar_emp.png"));
			
			//背包+仓库面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/BackpackWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/StorageWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/bg.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/select.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/bgcd.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/lock.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/moneyIco.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/backpack/yuanbaoIco.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/backPack/MessageWnd02.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/backPack/MessageWnd03.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/backPack/MessageWnd04.xml"));
			
			//技能面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/SkillWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/skill/SkillListRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/mainUI/icon_skill.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/skill/skillShortCutBar.xml"));
			
			//好友面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/FriendWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/friend/FriendDateBar.xml"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_zs_m.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_zs_f.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_fs_m.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_fs_f.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_ds_m.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/small_ds_f.png"));
			
			
			//角色面板
			//			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/RoleWnd.xml"));
			//			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/PropertyWnd.xml"));
			//			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/property/PropertyNum.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/character/character_bg.png"));
			//			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/PropertyPointWnd.xml"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/RoleWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/role/PropertyNum.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/ui_plus.png"));
			
			//设置面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/SettingWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/setting/SettingGame.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/setting/SettingVideo.xml"));
			
			//组队面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/TeamWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/team/TeamDateBar.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/TeamAddWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/team/TeamHeadWnd.xml"));
			
			//商店面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/ShopWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/shop/BShopRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/textinput_focus.png"));
			
			//商城面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/MarketWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/market/MarketRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/fittingRoomRender.xml"));
			
			//交易面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/tradeWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/trade/tradeRender.xml"));
			
			//行会面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/GuildWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildMainPage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildMemberPage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildPurviewPage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildStoragePage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildShopPage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/GuildWagePage.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/MessageWnd07.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/MessageWnd06.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/child/PurviewRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/child/StorageRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/child/ShopRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/child/WageRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/child/MemberRender.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/guild/AddContributPage.xml"));
			
			//任务面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/TaskWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/ForgeWnd.xml"));
			
			//摆摊面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/StallWnd.xml"));
			
			//人物头像
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/RoleHeadWnd.xml"));
			
			//tips
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/tips/TipsItemWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/tips/TipsEquipWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/tips/TipsSkillWnd.xml"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/tips_equip.png"));
			
			//加载面板 进度条
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/LoadingWnd.xml"));
			
			//系统提示
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/warn.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/prompt.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/other/wrong.png"));
			
			//其他玩家属性面板
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("config/ui/OtherRoleWnd.xml"));
			
			//冒泡的数字图片
			for(i=0;i<10;i++){
				LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/R"+i+".png"));
				LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/G"+i+".png"));
				LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/B"+i+".png"));
			}
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/B-.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/G-.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/R-.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/B+.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/G+.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/R+.png"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/D.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/E.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/G.png"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/HP.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/MP.png"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/LowHP.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/LowMP.png"));
			
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/Miss_G.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/Miss_O.png"));
			LoadUtil.preLoadFiles.push(LoadUtil.lib2Cach("ui/num/P.png"));
			
		}
	}
}
