package com.leyou.net {

	//==============暂时没有===========释放技能时触发
	public class MirProtocol {
		public static const VERMS:uint=0; //版本类型 1=对外发布
		public static const GAMEPLAN:uint=1; //0-SD界面 1-乐都界面
		public static const HEROVERSION:uint=1; //1是英雄版
		public static const MAXPATHLEN:uint=255;
		public static const DIRPATHLEN:uint=80;
		public static const MAPNAMELEN:uint=16;
		public static const ACTORNAMELEN:uint=14;
		public static const DEFBLOCKSIZE:uint=32; //20081221
		public static const BUFFERSIZE:uint=10000; //缓冲定义
		public static const DATA_BUFSIZE2:uint=16348; //8192;
		public static const DATA_BUFSIZE:uint=8192; //8192;
		public static const GROUPMAX:uint=11;
		public static const BAGGOLD:uint=5000000;
		public static const BODYLUCKUNIT:uint=10;
		public static const MAX_STATUS_ATTRIBUTE:uint=12; //20080626 修改

//public static const //传奇中人物只有8个方向,但是打符,锲蛾飞行,神鹰都有16方向
		public static const DR_UP:uint=0; //北
		public static const DR_UPRIGHT:uint=1; //东北向
		public static const DR_RIGHT:uint=2; //东
		public static const DR_DOWNRIGHT:uint=3; //东南向
		public static const DR_DOWN:uint=4; //南
		public static const DR_DOWNLEFT:uint=5; //西南向
		public static const DR_LEFT:uint=6; //西
		public static const DR_UPLEFT:uint=7; //西北向



		public static const X_RepairFir:uint=20; //修补火龙之心

		public static const POISON_DECHEALTH:uint=0; //中毒类型：绿毒
		public static const POISON_DAMAGEARMOR:uint=1; //中毒类型：红毒
		public static const POISON_LOCKSPELL:uint=2; //不能攻击

		public static const POISON_DONTMOVE:uint=4; //不能移动
		public static const POISON_STONE:uint=5; //中毒类型:麻痹

		public static const STATE_STONE_MODE:uint=1; //被石化
		public static const STATE_LOCKRUN:uint=3; //不能跑动(中蛛网) 20080811
		public static const STATE_ProtectionDEFENCE:uint=7; //护体神盾 20080107
		public static const STATE_TRANSPARENT:uint=8; //隐身
		public static const STATE_DEFENCEUP:uint=9; //神圣战甲术  防御力
		public static const STATE_MAGDEFENCEUP:uint=10; //幽灵盾  魔御力
		public static const STATE_BUBBLEDEFENCEUP:uint=11; //魔法盾


		public static const USERMODE_PLAYGAME:uint=1;
		public static const USERMODE_LOGIN:uint=2;
		public static const USERMODE_LOGOFF:uint=3;
		public static const USERMODE_NOTICE:uint=4;

		public static const RUNGATEMAX:uint=20;

		public static const RUNGATECODE:uint=0xAA55AA55;

		public static const OS_MOVINGOBJECT:uint=1;
		public static const OS_ITEMOBJECT:uint=2;
		public static const OS_EVENTOBJECT:uint=3;
		public static const OS_GATEOBJECT:uint=4;
		public static const OS_SWITCHOBJECT:uint=5;
		public static const OS_MAPEVENT:uint=6;
		public static const OS_DOOR:uint=7;
		public static const OS_ROON:uint=8;

		public static const RC_PLAYOBJECT:uint=0; //人物
		public static const RC_PLAYMOSTER:uint=150; //人形怪物
		public static const RC_HEROOBJECT:uint=66; //英雄
		public static const RC_GUARD:uint=12; //大刀守卫 20080311
		public static const RC_PEACENPC:uint=15;
		public static const RC_ANIMAL:uint=50;
		public static const RC_MONSTER:uint=80;
		public static const RC_NPC:uint=10; //NPC
		public static const RC_ARCHERGUARD:uint=112; //NPC 弓箭手


		public static const RCC_USERHUMAN:uint=RC_PLAYOBJECT;
		public static const RCC_GUARD:uint=RC_GUARD;
		public static const RCC_MERCHANT:uint=RC_ANIMAL;

		public static const ISM_WHISPER:uint=1234;

		public static const CM_QUERYCHR:uint=100; //登录成功,客户端显出左右角色的那一瞬
		public static const CM_NEWCHR:uint=101; //创建角色
		public static const CM_DELCHR:uint=102; //删除角色
		public static const CM_SELCHR:uint=103; //选择角色
		public static const CM_SELECTSERVER:uint=104; //服务器,注意不是选区,盛大一区往往有(至多8个??group.dat中是这么写的)不止一个的服务器
		public static const CM_QUERYDELCHR:uint=105; //查询删除过的角色信息 20080706
		public static const CM_RESDELCHR:uint=106; //恢复删除的角色 20080706

		public static const SM_RUSH:uint=6; //跑动中改变方向
		public static const SM_RUSHKUNG:uint=7; //野蛮冲撞
		public static const SM_FIREHIT:uint=8; //烈火
		public static const SM_4FIREHIT:uint=58; //4级烈火 20080112
		public static const SM_BACKSTEP:uint=9; //后退,野蛮效果? //半兽统领公箭手攻击玩家的后退??axemon.pas中procedure   TDualAxeOma.Run
		public static const SM_TURN:uint=10; //转向
		public static const SM_WALK:uint=11; //走
		public static const SM_SITDOWN:uint=12;
		public static const SM_RUN:uint=13; //跑
		public static const SM_HIT:uint=14; //砍
		public static const SM_HEAVYHIT:uint=15; //
		public static const SM_BIGHIT:uint=16; //
		public static const SM_SPELL:uint=17; //使用魔法
		public static const SM_POWERHIT:uint=18; //攻杀
		public static const SM_LONGHIT:uint=19; //刺杀
		public static const SM_DIGUP:uint=20; //挖是一"起"一"坐",这里是挖动作的"起"
		public static const SM_DIGDOWN:uint=21; //挖动作的"坐"
		public static const SM_FLYAXE:uint=22; //飞斧,半兽统领的攻击方式?
		public static const SM_LIGHTING:uint=23; //免蜡开关
		public static const SM_WIDEHIT:uint=24; //半月
		public static const SM_CRSHIT:uint=25; //抱月刀
		public static const SM_TWINHIT:uint=26; //开天斩重击
		public static const SM_QTWINHIT:uint=59; //开天斩轻击
		public static const SM_CIDHIT:uint=57; //龙影剑法

		public static const SM_SANJUEHIT:uint=60; //三绝杀
		public static const SM_ZHUIXINHIT:uint=61; //追心刺
		public static const SM_DUANYUEHIT:uint=62; //断岳斩
		public static const SM_HENGSAOHIT:uint=63; //横扫千军
		public static const SM_YTPDHIT:uint=64; //倚天劈地
		public static const SM_XPYJHIT:uint=65; //血魄一击

		public static const SM_4LONGHIT:uint=66; //四级刺杀
		public static const SM_YUANYUEHIT:uint=67; //圆月弯刀
		public static const SM_MAG101:uint=68; //风剑术
		public static const SM_MAG111:uint=71; //猛毒剑气

		public static const SM_ALIVE:uint=27; //复活??复活戒指
		public static const SM_MOVEFAIL:uint=28; //移动失败,走动或跑动
		public static const SM_HIDE:uint=29; //隐身?
		public static const SM_DISAPPEAR:uint=30; //地上物品消失
		public static const SM_STRUCK:uint=31; //受攻击
		public static const SM_DEATH:uint=32; //正常死亡
		public static const SM_SKELETON:uint=33; //尸体
		public static const SM_NOWDEATH:uint=34; //秒杀?

		public static const SM_ACTION_MIN:uint=SM_RUSH;
		public static const SM_ACTION_MAX:uint=SM_WIDEHIT;
		public static const SM_ACTION2_MIN:uint=65072;
		public static const SM_ACTION2_MAX:uint=65073;

		public static const SM_HEAR:uint=40; //有人回你的话
		public static const SM_FEATURECHANGED:uint=41;
		public static const SM_USERNAME:uint=42;
		public static const SM_WINEXP:uint=44; //获得经验
		public static const SM_LEVELUP:uint=45; //升级,左上角出现墨绿的升级字样
		public static const SM_DAYCHANGING:uint=46; //传奇界面右下角的太阳星星月亮

		public static const SM_LOGON:uint=50; //logon
		public static const SM_NEWMAP:uint=51; //新地图??
		public static const SM_ABILITY:uint=52; //打开属性对话框,F11
		public static const SM_HEALTHSPELLCHANGED:uint=53; //治愈术使你的体力增加
		public static const SM_MAPDESCRIPTION:uint=54; //地图描述,行会战地图?攻城区域?安全区域?
		public static const SM_SPELL2:uint=117;

//public static const //对话消息
		public static const SM_MOVEMESSAGE:uint=99;
		public static const SM_SYSMESSAGE:uint=100; //系统消息,盛大一般红字,私服蓝字
		public static const SM_GROUPMESSAGE:uint=101; //组内聊天!!
		public static const SM_CRY:uint=102; //喊话
		public static const SM_WHISPER:uint=103; //私聊
		public static const SM_GUILDMESSAGE:uint=104; //行会聊天!~

		//背包操作
		public static const SM_ADDITEM:uint=200; //添加物品
		public static const SM_BAGITEMS:uint=201; //获取背包内所有物品
		public static const SM_DELITEM:uint=202; //删除物品
		public static const SM_UPDATEITEM:uint=203; //更新物品

		//技能
		public static const SM_ADDMAGIC:uint=210; //添加技能
		public static const SM_SENDMYMAGIC:uint=211; //发送我的技能
		public static const SM_DELMAGIC:uint=212; //删除技能
		public static const SM_GUILDSTROAGE:uint=213;
		public static const SM_BACKSTEPEX:uint=250;

//public static const //服务器端发送的命令 SM:server msg,服务端向客户端发送的消息

//public static const //登录、新帐号、新角色、查询角色等
		public static const SM_CERTIFICATION_FAIL:uint=501;
		public static const SM_ID_NOTFOUND:uint=502;
		public static const SM_PASSWD_FAIL:uint=503; //验证失败,"服务器验证失败,需要重新登录"??
		public static const SM_NEWID_SUCCESS:uint=504; //创建新账号成功
		public static const SM_NEWID_FAIL:uint=505; //创建新账号失败
		public static const SM_CHGPASSWD_SUCCESS:uint=506; //修改密码成功
		public static const SM_CHGPASSWD_FAIL:uint=507; //修改密码失败
		public static const SM_GETBACKPASSWD_SUCCESS:uint=508; //密码找回成功
		public static const SM_GETBACKPASSWD_FAIL:uint=509; //密码找回失败

		public static const SM_QUERYCHR:uint=520; //返回角色信息到客户端
		public static const SM_NEWCHR_SUCCESS:uint=521; //新建角色成功
		public static const SM_NEWCHR_FAIL:uint=522; //新建角色失败
		public static const SM_DELCHR_SUCCESS:uint=523; //删除角色成功
		public static const SM_DELCHR_FAIL:uint=524; //删除角色失败
		public static const SM_STARTPLAY:uint=525; //开始进入游戏世界(点了健康游戏忠告后进入游戏画面)
		public static const SM_STARTFAIL:uint=526; ////开始失败,玩传奇深有体会,有时选择角色,点健康游戏忠告后黑屏

		public static const SM_QUERYCHR_FAIL:uint=527; //返回角色信息到客户端失败
		public static const SM_OUTOFCONNECTION:uint=528; //超过最大连接数,强迫用户下线
		public static const SM_PASSOK_SELECTSERVER:uint=529; //密码验证完成且密码正确,开始选服
		public static const SM_SELECTSERVER_OK:uint=530; //选服成功
		public static const SM_NEEDUPDATE_ACCOUNT:uint=531; //需要更新,注册后的ID会发生什么变化?私服中的普通ID经过充值??或者由普通ID变为会员ID,GM?
		public static const SM_UPDATEID_SUCCESS:uint=532; //更新成功
		public static const SM_UPDATEID_FAIL:uint=533; //更新失败

		public static const SM_QUERYDELCHR:uint=534; //返回删除过的角色 20080706
		public static const SM_QUERYDELCHR_FAIL:uint=535; //返回删除过的角色失败 20080706
		public static const SM_RESDELCHR_SUCCESS:uint=536; //恢复删除角色成功 20080706
		public static const SM_RESDELCHR_FAIL:uint=537; //恢复删除角色失败 20080706
		public static const SM_NOCANRESDELCHR:uint=538; //禁止恢复删除角色,即不可查看 200800706

		public static const SM_DROPITEM_SUCCESS:uint=600; //丢弃道具成功
		public static const SM_DROPITEM_FAIL:uint=601; //丢弃道具失败

		public static const SM_ITEMSHOW:uint=610; //显示地面上的物品
		public static const SM_ITEMHIDE:uint=611; //隐藏道具
//public static const //  SM_DOOROPEN           :uint= 612;
		public static const SM_OPENDOOR_OK:uint=612; //通过过门点成功
		public static const SM_OPENDOOR_LOCK:uint=613; //发现过门口是封锁的,以前盛大秘密通道去赤月的门要5分钟开一次
		public static const SM_CLOSEDOOR:uint=614; //用户过门,门自行关闭
		public static const SM_TAKEON_OK:uint=615; //穿衣成功
		public static const SM_TAKEON_FAIL:uint=616; //穿衣服失败
		public static const SM_TAKEOFF_OK:uint=619; //脱衣服成功
		public static const SM_TAKEOFF_FAIL:uint=620; //脱衣服失败
		public static const SM_SENDUSEITEMS:uint=621;
		public static const SM_WEIGHTCHANGED:uint=622; //重量改变
		public static const SM_CLEAROBJECTS:uint=633;
		public static const SM_CHANGEMAP:uint=634; //地图改变,进入新地图
		public static const SM_EAT_OK:uint=635; //吃药成功
		public static const SM_EAT_FAIL:uint=636; //吃药失败
		public static const SM_BUTCH:uint=637; //野蛮?
		public static const SM_MAGICFIRE:uint=638; //地狱火,火墙??
		public static const SM_MAGICFIRE_FAIL:uint=639;
		public static const SM_MAGIC_LVEXP:uint=640;//技能的熟练度值 改变 暂无
		public static const SM_DURACHANGE:uint=642;
		public static const SM_MERCHANTSAY:uint=643; //商人说话
		public static const SM_MERCHANTDLGCLOSE:uint=644;
		public static const SM_SENDGOODSLIST:uint=645;
		public static const SM_SENDUSERSELL:uint=646;
		public static const SM_SENDBUYPRICE:uint=647;
		public static const SM_USERSELLITEM_OK:uint=648;
		public static const SM_USERSELLITEM_FAIL:uint=649;
		public static const SM_BUYITEM_SUCCESS:uint=650; //?
		public static const SM_BUYITEM_FAIL:uint=651; //?
		public static const SM_SENDDETAILGOODSLIST:uint=652;
		public static const SM_GOLDCHANGED:uint=653;
		public static const SM_CHANGELIGHT:uint=654; //负重改变
		public static const SM_LAMPCHANGEDURA:uint=655; //蜡烛持久改变
		public static const SM_CHANGENAMECOLOR:uint=656; //名字颜色改变,白名,灰名,红名,黄名
		public static const SM_CHARSTATUSCHANGED:uint=657; //脱衣服后外观改变
		public static const SM_SENDNOTICE:uint=658; //发送健康游戏忠告(公告)
		public static const SM_GROUPMODECHANGED:uint=659; //组队模式改变
		public static const SM_CREATEGROUP_OK:uint=660;
		public static const SM_CREATEGROUP_FAIL:uint=661;
		public static const SM_GROUPADDMEM_OK:uint=662;
		public static const SM_GROUPDELMEM_OK:uint=663;
		public static const SM_GROUPADDMEM_FAIL:uint=664;
		public static const SM_GROUPDELMEM_FAIL:uint=665;
		public static const SM_GROUPCANCEL:uint=666;
		public static const SM_GROUPMEMBERS:uint=667;
		public static const SM_SENDUSERREPAIR:uint=668;
		public static const SM_USERREPAIRITEM_OK:uint=669;
		public static const SM_USERREPAIRITEM_FAIL:uint=670;
		public static const SM_SENDREPAIRCOST:uint=671;
		public static const SM_DEALMENU:uint=673;
		public static const SM_DEALTRY_FAIL:uint=674;
		public static const SM_DEALADDITEM_OK:uint=675;
		public static const SM_DEALADDITEM_FAIL:uint=676;
		public static const SM_DEALDELITEM_OK:uint=677;
		public static const SM_DEALDELITEM_FAIL:uint=678;
		public static const SM_DEALCANCEL:uint=681;
		public static const SM_DEALREMOTEADDITEM:uint=682;
		public static const SM_DEALREMOTEDELITEM:uint=683;
		public static const SM_DEALCHGGOLD_OK:uint=684;
		public static const SM_DEALCHGGOLD_FAIL:uint=685;
		public static const SM_DEALREMOTECHGGOLD:uint=686;
		public static const SM_DEALSUCCESS:uint=687;
		public static const SM_SENDLOSTITEMLIST:uint=688;
		public static const SM_SENDUSERSTORAGEITEM:uint=700;
		public static const SM_STORAGE_OK:uint=701; //存成功
		public static const SM_STORAGE_FULL:uint=702; //存满
		public static const SM_STORAGE_FAIL:uint=703; //存失败
		public static const SM_SAVEITEMLIST:uint=704; //仓库item列表
		public static const SM_TAKEBACKSTORAGEITEM_OK:uint=705;
		public static const SM_TAKEBACKSTORAGEITEM_FAIL:uint=706;
		public static const SM_TAKEBACKSTORAGEITEM_FULLBAG:uint=707;

		public static const SM_AREASTATE:uint=708; //周围状态
		public static const SM_MYSTATUS:uint=766; //我的状态,最近一次下线状态,如是否被毒,挂了就强制回城

		public static const SM_DELITEMS:uint=709;
		public static const SM_READMINIMAP_OK:uint=710;
		public static const SM_READMINIMAP_FAIL:uint=711;
		public static const SM_SENDUSERMAKEDRUGITEMLIST:uint=712;
		public static const SM_MAKEDRUG_SUCCESS:uint=713;
		public static const SM_USERLOSTITEM_FAIL:uint=714;

		public static const SM_SELFID:uint=715;
//public static const //  714
//public static const //  716
		public static const SM_MAKEDRUG_FAIL:uint=65036;

		public static const SM_CHANGEGUILDNAME:uint=750; //修改协会名称
		public static const SM_SENDUSERSTATE:uint=751; //
		public static const SM_SUBABILITY:uint=752; //打开输助属性对话框
		public static const SM_OPENGUILDDLG:uint=753; //
		public static const SM_OPENGUILDDLG_FAIL:uint=754; //
		public static const SM_SENDGUILDMEMBERLIST:uint=756; //
		public static const SM_GUILDADDMEMBER_OK:uint=757; //
		public static const SM_GUILDADDMEMBER_FAIL:uint=758;
		public static const SM_GUILDDELMEMBER_OK:uint=759;
		public static const SM_GUILDDELMEMBER_FAIL:uint=760;
		public static const SM_GUILDRANKUPDATE_FAIL:uint=761;
		public static const SM_BUILDGUILD_OK:uint=762;
		public static const SM_BUILDGUILD_FAIL:uint=763;
		public static const SM_DONATE_OK:uint=764;
		public static const SM_DONATE_FAIL:uint=765;

		public static const SM_MENU_OK:uint=767; //?
		public static const SM_GUILDMAKEALLY_OK:uint=768;
		public static const SM_GUILDMAKEALLY_FAIL:uint=769;
		public static const SM_GUILDBREAKALLY_OK:uint=770; //?
		public static const SM_GUILDBREAKALLY_FAIL:uint=771; //?
		public static const SM_DLGMSG:uint=772; //Jacky
		public static const SM_SPACEMOVE_HIDE:uint=800; //道士走一下隐身
		public static const SM_SPACEMOVE_SHOW:uint=801; //道士走一下由隐身变为现身
		public static const SM_RECONNECT:uint=802; //与服务器重连
		public static const SM_GHOST:uint=803; //尸体清除,虹魔教主死的效果?
		public static const SM_SHOWEVENT:uint=804; //显示事件
		public static const SM_HIDEEVENT:uint=805; //隐藏事件
		public static const SM_SPACEMOVE_HIDE2:uint=806;
		public static const SM_SPACEMOVE_SHOW2:uint=807;
		public static const SM_TIMECHECK_MSG:uint=810; //时钟检测,以免客户端作弊
		public static const SM_ADJUST_BONUS:uint=811; //?调整奖金
		public static const SM_SERVERINFO:uint=812;
		public static const SM_AUTOSKILL:uint=813;
		public static const SM_CONEDELTYPE:uint=814;


//public static const //----SM_消息 从6000开始添加----//
		public static const SM_OPENPULSE_OK:uint=6000;
		public static const SM_OPENPULSE_FAIL:uint=6001;
		public static const SM_RUSHPULSE_OK:uint=6002;
		public static const SM_RUSHPULSE_FAIL:uint=6003;
		public static const SM_PULSECHANGED:uint=6004;
		public static const SM_BATTERORDER:uint=6005;
		public static const SM_CANUSEBATTER:uint=6006;
		public static const SM_BATTERUSEFINALLY:uint=6007;
		public static const SM_BATTERSTART:uint=6008;
		public static const SM_OPENPULS:uint=6009; //打开经络
		public static const SM_HEROBATTERORDER:uint=6010;
		public static const SM_HEROPULSECHANGED:uint=6011;
		public static const SM_BATTERBACKSTEP:uint=6012;
		public static const SM_STORMSRATE:uint=6013;
		public static const SM_STORMSRATECHANGED:uint=6014;
		public static const SM_HEROSTORMSRATECHANGED:uint=6015;
		public static const SM_OPENPULSENEEDLEV:uint=6016;
		public static const SM_HEROATTECTMODE:uint=6017;
		public static const SM_GETASSESSHEROINFO:uint=6018;
		public static const SM_QUERYASSESSHERO:uint=6019;
		public static const SM_SHOWASSESSDLG:uint=6020;
		public static const SM_ISDEHERO:uint=6021;
		public static const SM_OPENTRAININGDLG:uint=6022;

//public static const //怪物AI部分
		public static const SM_MONSPELL:uint=6023;
		public static const SM_MONSPELLEFF:uint=6024;
		public static const SM_SHOWEFF:uint=6025;
		public static const SM_BUFF:uint=6026; //==============暂时没有===========释放技能时触发
		public static const SM_MAGICEFF:uint=6027;
		public static const SM_SHOWBMP:uint=6028;

		public static const SM_SHOWHUMEFF:uint=6029;
		public static const SM_FLASHMISSIONBUTTON:uint=6030;
		public static const SM_ITEMCHANGECOUNT:uint=6031; //道具数量改变
		public static const SM_HEROITEMCHANGECOUNT:uint=6032;
		public static const SM_STARTSTONE:uint=6033;
		public static const SM_STONEFAIL:uint=6034;
		public static const SM_SHOWADDSTAR:uint=6035;
		public static const SM_DENYADDSTAR:uint=6036;
		public static const SM_ADDSTARSUCCESS:uint=6037;
		public static const SM_ADDSTARFAIL:uint=6038;
		public static const SM_CLEARITEMSTAR:uint=6039;
		public static const SM_SHOWWIN:uint=6040;
		public static const SM_SETSUCCESSRATE:uint=6041;
		public static const SM_SETBUTTON:uint=6042;
		public static const SM_PUTDOWNFAIL:uint=6043;
		public static const SM_PUTDOWNDIAMONDFAIL:uint=6044;
		public static const SM_TRYDEAL:uint=6045;
		public static const SM_CHALLENGE:uint=6046;
		public static const SM_SHOWREALIVE:uint=6047;
		public static const SM_CloseBigDialogBox:uint=6048;
		public static const SM_PLAYMUSIC:uint=6049;
		public static const SM_SHOWAPPLE:uint=6050;
		public static const SM_APPLEEND:uint=6051;
		public static const SM_QIANZSUCC:uint=6052;
		public static const SM_XIAZHUSUCC:uint=6053;
		public static const SM_XIAZHUFAIL:uint=6054;
		public static const SM_ZHUANJIAOFFLINE:uint=6055;
		public static const SM_CHATTOPMESSAGE:uint=6056;
		public static const SM_DECTIME:uint=6057;
		public static const SM_CHATITEM:uint=6058;
		public static const SM_OpenGameShop:uint=6059;
		public static const SM_MAG104TIEM:uint=6060;
		public static const SM_MAG109LRT:uint=6061;
		public static const SM_PLAYEFFECT:uint=6062;
		public static const SM_PLAYEFFECT1:uint=6063;
		public static const SM_ITEMLIGHT:uint=6064;
		public static const SM_STARTSTONE1:uint=6065;
		public static const SM_OpenWebSite:uint=6066;
		public static const SM_SM:uint=6067;
		public static const SM_HL:uint=6068;
		public static const SM_PKPOINT:uint=6069;
		public static const SM_CREDITPOINT:uint=6070;
		public static const SM_REFUSE:uint=6071;
		public static const SM_CLOSECLIENT:uint=6072;
		public static const SM_GETTHREAD:uint=6073;
		public static const SM_USERTHREAD:uint=6074;
		public static const SM_OPENMITEMWIN:uint=6075;//打开合成
		public static const SM_FIFITEM_FAIL:uint=6076;
		public static const SM_FIFITEM_SUCC:uint=6077;
		public static const SM_QUERYLOSTITEM:uint=6078;
		public static const SM_GUILDSTROAGETYPE_SUCC:uint=6079;
		public static const SM_CONTRIBUTE:uint=6080; //贡献
		public static const SM_ADDGUILDITEM_FAIL:uint=6081;
		public static const SM_ADDGUILDITEM_SUCC:uint=6082;
		public static const SM_MASTERTAKEGUILDITEM:uint=6083;
		public static const SM_MASTERTAKEGUILDITEMFAIL:uint=6084;

		public static const SM_OPENHEALTH:uint=1100;
		public static const SM_CLOSEHEALTH:uint=1101;

		public static const SM_BREAKWEAPON:uint=1102; //武器破碎
		public static const SM_INSTANCEHEALGUAGE:uint=1103; //实时治愈
		public static const SM_CHANGEFACE:uint=1104; //变脸,发型改变?
		public static const SM_VERSION_FAIL:uint=1106; //客户端版本验证失败

		public static const SM_ITEMUPDATE:uint=1500;
		public static const SM_MONSTERSAY:uint=1501;

		public static const SM_EXCHGTAKEON_OK:uint=65023;
		public static const SM_EXCHGTAKEON_FAIL:uint=65024;

		public static const SM_TEST:uint=65037;
		public static const SM_TESTHERO:uint=65038;
		public static const SM_THROW:uint=65069;

		public static const RM_DELITEMS:uint=9000; //Jacky
		public static const RM_TURN:uint=10001;
		public static const RM_WALK:uint=10002;
		public static const RM_RUN:uint=10003;
		public static const RM_HIT:uint=10004;
		public static const RM_SPELL:uint=10007;
		public static const RM_SPELL2:uint=10008;
		public static const RM_POWERHIT:uint=10009;
		public static const RM_LONGHIT:uint=10011;
		public static const RM_WIDEHIT:uint=10012;
		public static const RM_PUSH:uint=10013;
		public static const RM_FIREHIT:uint=10014; //烈火
		public static const RM_4FIREHIT:uint=10016; //4级烈火 20080112
		public static const RM_RUSH:uint=10015;
		public static const RM_STRUCK:uint=10020; //受物理打击
		public static const RM_DEATH:uint=10021;
		public static const RM_DISAPPEAR:uint=10022;
		public static const RM_MAGSTRUCK:uint=10025;
		public static const RM_MAGHEALING:uint=10026;
		public static const RM_STRUCK_MAG:uint=10027; //受魔法打击
		public static const RM_MAGSTRUCK_MINE:uint=10028;
		public static const RM_INSTANCEHEALGUAGE:uint=10029; //jacky
		public static const RM_HEAR:uint=10030; //公聊
		public static const RM_WHISPER:uint=10031;
		public static const RM_CRY:uint=10032;
		public static const RM_RIDE:uint=10033;
		public static const RM_WINEXP:uint=10044;
		public static const RM_USERNAME:uint=10043;
		public static const RM_LEVELUP:uint=10045;
		public static const RM_CHANGENAMECOLOR:uint=10046;
		public static const RM_PUSHEX:uint=10047;

		public static const RM_LOGON:uint=10050;
		public static const RM_ABILITY:uint=10051;
		public static const RM_HEALTHSPELLCHANGED:uint=10052;
		public static const RM_DAYCHANGING:uint=10053;

//public static const //:uint=========小水增加================
		public static const RM_MONSPELL:uint=10054;
		public static const RM_MONSPELLEFF:uint=10055;
		public static const RM_DELAYMAGICEFF:uint=10056;
		public static const RM_SHOWEFF:uint=10057;
		public static const RM_MAGICEFF:uint=10058;
		public static const RM_SHOWHUMEFF:uint=10059;
		public static const RM_QIANZSUCC:uint=10070;
		public static const RM_XIAZHUSUCC:uint=10071;
		public static const RM_ZHUANJIAOFFLINE:uint=10072;
		public static const RM_CONEDELTYPE:uint=10073;

		public static const RM_CHATTOPMESSAGE:uint=10098; //聊天框固顶广告
		public static const RM_MOVEMESSAGE:uint=10099; //滚动公告   清清 2007.11.13
		public static const RM_SYSMESSAGE:uint=10100;
		public static const RM_GROUPMESSAGE:uint=10102;
		public static const RM_SYSMESSAGE2:uint=10103;
		public static const RM_GUILDMESSAGE:uint=10104;
		public static const RM_SYSMESSAGE3:uint=10105; //Jacky
		public static const RM_ITEMSHOW:uint=10110;
		public static const RM_ITEMHIDE:uint=10111;
		public static const RM_DOOROPEN:uint=10112;
		public static const RM_DOORCLOSE:uint=10113;
		public static const RM_SENDUSEITEMS:uint=10114; //发送使用的物品
		public static const RM_WEIGHTCHANGED:uint=10115;

		public static const RM_FEATURECHANGED:uint=10116;
		public static const RM_CLEAROBJECTS:uint=10117;
		public static const RM_CHANGEMAP:uint=10118;
		public static const RM_BUTCH:uint=10119; //挖
		public static const RM_MAGICFIRE:uint=10120;
		public static const RM_SENDMYMAGIC:uint=10122; //发送使用的魔法
		public static const RM_MAGIC_LVEXP:uint=10123;
		public static const RM_SKELETON:uint=10024;
		public static const RM_DURACHANGE:uint=10125; //持久改变
		public static const RM_MERCHANTSAY:uint=10126;
		public static const RM_GOLDCHANGED:uint=10136;
		public static const RM_CHANGELIGHT:uint=10137;
		public static const RM_CHARSTATUSCHANGED:uint=10139;
		public static const RM_DELAYMAGIC:uint=10154;
		public static const RM_CHATITEM:uint=10156;
		public static const RM_MAG109LRT:uint=10157;

		public static const RM_DIGUP:uint=10200;
		public static const RM_DIGDOWN:uint=10201;
		public static const RM_FLYAXE:uint=10202;
		public static const RM_LIGHTING:uint=10204;
		public static const RM_SUBABILITY:uint=10302;
		public static const RM_TRANSPARENT:uint=10308;

		public static const RM_SPACEMOVE_SHOW:uint=10331;
		public static const RM_RECONNECTION:uint=11332;
		public static const RM_SPACEMOVE_SHOW2:uint=10332; //?
		public static const RM_HIDEEVENT:uint=10333; //隐藏烟花
		public static const RM_SHOWEVENT:uint=10334; //显示烟花
		public static const RM_ZEN_BEE:uint=10337;

		public static const RM_OPENHEALTH:uint=10410;
		public static const RM_CLOSEHEALTH:uint=10411;
		public static const RM_DOOPENHEALTH:uint=10412;
		public static const RM_CHANGEFACE:uint=10415;

		public static const RM_ITEMUPDATE:uint=11000;
		public static const RM_MONSTERSAY:uint=11001;
		public static const RM_MAKESLAVE:uint=11002;

		public static const RM_MONMOVE:uint=21004;
		public static const SS_200:uint=200;
		public static const SS_201:uint=201;
		public static const SS_202:uint=202;
		public static const SS_WHISPER:uint=203;
		public static const SS_204:uint=204;
		public static const SS_205:uint=205;
		public static const SS_206:uint=206;
		public static const SS_207:uint=207;
		public static const SS_208:uint=208;
		public static const SS_209:uint=219;
		public static const SS_210:uint=210;
		public static const SS_211:uint=211;
		public static const SS_212:uint=212;
		public static const SS_213:uint=213;
		public static const SS_214:uint=214;


		public static const RM_10205:uint=10205;
		public static const RM_10101:uint=10101;
		public static const RM_ALIVE:uint=10153; //复活
		public static const RM_CHANGEGUILDNAME:uint=10301;
		public static const RM_10414:uint=10414;
		public static const RM_POISON:uint=10300;
		public static const LA_UNDEAD:uint=1; //不死系

		public static const RM_DELAYPUSHED:uint=10555;

		public static const CM_GETBACKPASSWORD:uint=2010; //密码找回
		public static const CM_SPELL:uint=3017; //施魔法
		public static const CM_QUERYUSERNAME:uint=80; //进入游戏,服务器返回角色名到客户端

		public static const CM_DROPITEM:uint=1000; //从包裹里扔出物品到地图,此时人物如果在安全区可能会提示安全区不允许扔东西
		public static const CM_PICKUP:uint=1001; //捡东西
		public static const CM_TAKEONITEM:uint=1003; //装配装备到身上的装备位置
		public static const CM_TAKEOFFITEM:uint=1004; //从身上某个装备位置取下某个装备
		public static const CM_EAT:uint=1006; //吃药
		public static const CM_BUTCH:uint=1007; //挖
		public static const CM_MAGICKEYCHANGE:uint=1008; //魔法快捷键改变
		public static const CM_HEROMAGICKEYCHANGE:uint=1046; //英雄魔法开关设置 20080606
		public static const CM_1005:uint=1005;

//public static const //与商店NPC交易相关
		public static const CM_CLICKNPC:uint=1010; //用户点击了某个NPC进行交互
		public static const CM_MERCHANTDLGSELECT:uint=1011; //商品选择,大类
		public static const CM_MERCHANTQUERYSELLPRICE:uint=1012; //返回价格,标准价格,我们知道商店用户卖入的有些东西掉持久或有特殊
		public static const CM_USERSELLITEM:uint=1013; //用户卖东西
		public static const CM_USERBUYITEM:uint=1014; //用户买入东西
		public static const CM_USERGETDETAILITEM:uint=1015; //取得商品清单,比如点击"蛇眼戒指"大类,会出现一列蛇眼戒指供你选择
		public static const CM_DROPGOLD:uint=1016; //用户放下金钱到地上
		public static const CM_LOGINNOTICEOK:uint=1018; //健康游戏忠告点了确实,进入游戏
		public static const CM_GROUPMODE:uint=1019; //关组还是开组
		public static const CM_CREATEGROUP:uint=1020; //新建组队
		public static const CM_ADDGROUPMEMBER:uint=1021; //组内添人
		public static const CM_DELGROUPMEMBER:uint=1022; //组内删人
		public static const CM_USERREPAIRITEM:uint=1023; //用户修理东西
		public static const CM_MERCHANTQUERYREPAIRCOST:uint=1024; //客户端向NPC取得修理费用
		public static const CM_DEALTRY:uint=1025; //开始交易,交易开始
		public static const CM_DEALADDITEM:uint=1026; //加东东到交易物品栏上
		public static const CM_DEALDELITEM:uint=1027; //从交易物品栏上撤回东东???好像不允许哦
		public static const CM_DEALCANCEL:uint=1028; //取消交易
		public static const CM_DEALCHGGOLD:uint=1029; //本来交易栏上金钱为0,,如有金钱交易,交易双方都会有这个消息
		public static const CM_DEALEND:uint=1030; //交易成功,完成交易
		public static const CM_USERSTORAGEITEM:uint=1031; //用户寄存东西
		public static const CM_USERTAKEBACKSTORAGEITEM:uint=1032; //用户向保管员取回东西
		public static const CM_WANTMINIMAP:uint=1033; //用户点击了"小地图"按钮
		public static const CM_USERMAKEDRUGITEM:uint=1034; //用户制造毒药(其它物品)
		public static const CM_OPENGUILDDLG:uint=1035; //用户点击了"行会"按钮
		public static const CM_GUILDHOME:uint=1036; //点击"行会主页"
		public static const CM_GUILDMEMBERLIST:uint=1037; //点击"成员列表"
		public static const CM_GUILDADDMEMBER:uint=1038; //增加成员
		public static const CM_GUILDDELMEMBER:uint=1039; //踢人出行会
		public static const CM_GUILDUPDATENOTICE:uint=1040; //修改行会公告
		public static const CM_GUILDUPDATERANKINFO:uint=1041; //更新联盟信息(取消或建立联盟)
		public static const CM_1042:uint=1042;
		public static const CM_ADJUST_BONUS:uint=1043; //用户得到奖励??私服中比较明显,小号升级时会得出金钱声望等,不是很确定,//求经过测试的高手的验证
		public static const CM_SPEEDHACKUSER:uint=10430; //用户加速作弊检测
		public static const CM_GUILDALLY:uint=1044;
		public static const CM_GUILDBREAKALLY:uint=1045;


		public static const CM_CLICKMISSNPC:uint=1047;
		public static const CM_STONEFINISH:uint=1048; //偷砖结束
		public static const CM_CLICKHUMAN:uint=1049;
		public static const CM_CHOICEITEM:uint=1050;
		public static const CM_PUTDOWNCL:uint=1051;
		public static const CM_ITEMDAKON:uint=1052;
		public static const CM_ITEMXIANQIAN:uint=1053;
		public static const CM_PUTDOWNDIAMOND:uint=1054;
		public static const CM_BOTHITEM:uint=1055; //物品叠加
		public static const CM_FENITEM:uint=1056; //拆分物品
		public static const CM_SUREDEAL:uint=1057;
		public static const CM_QUERYFEATURE:uint=1058;
		public static const CM_SURECHALLENGE:uint=1059;
		public static const CM_REALIVE:uint=1060;
		public static const CM_USEFU:uint=1061;
		public static const CM_CHECKGUA:uint=1062;
		public static const CM_CHATITEM:uint=1063;
		public static const CM_SETGUAGEBAR:uint=1064;
		public static const CM_THREAD:uint=1065;
		public static const CM_FINDGUA:uint=1066;
		public static const CM_USERLOSTITEM:uint=1067;
		public static const CM_USERGETBACKLOSTITEM:uint=1068;
		public static const CM_USERGETDETAILLOSTITEM:uint=1069;

		public static const CM_GUILDSTROAGE:uint=1070;
		public static const CM_GUILDSTROAGETYPE:uint=1071;
		public static const CM_TAKEGUILDITEM:uint=1072;
		public static const CM_ADDGUILDITEM:uint=1073;
		public static const CM_ADDGUILDGOLD:uint=1074;
		public static const CM_GUILDCONTRIBUTE:uint=1075;
		public static const CM_STOPPLAY:uint=1076;

		public static const CM_PASSWORD:uint=1105;
		public static const CM_CHGPASSWORD:uint=1221; //?
		public static const CM_SETPASSWORD:uint=1222; //?



		public static const CM_HORSERUN:uint=3009;

		public static const CM_THROW:uint=3005; //抛符

//public static const //动作命令1
		public static const CM_TURN:uint=3010; //转身(方向改变)
		public static const CM_WALK:uint=3011; //走
		public static const CM_SITDOWN:uint=3012; //挖(蹲下)
		public static const CM_RUN:uint=3013; //跑
		public static const CM_HIT:uint=3014; //普通物理近身攻击
		public static const CM_HEAVYHIT:uint=3015; //跳起来打的动作
		public static const CM_BIGHIT:uint=3016;

		public static const CM_POWERHIT:uint=3018; //攻杀 被动技能
		public static const CM_LONGHIT:uint=3019; //刺杀


		public static const CM_WIDEHIT:uint=3024; //半月
		public static const CM_FIREHIT:uint=3025; //烈火攻击
		public static const CM_4FIREHIT:uint=3031; //4级烈火攻击
		public static const CM_CRSHIT:uint=3036; //抱月刀
		public static const CM_TWNHIT:uint=3037; //开天斩重击
		public static const CM_QTWINHIT:uint=3041; //开天斩轻击
		public static const CM_CIDHIT:uint=3040; //龙影剑法
		public static const CM_TWINHIT:uint=CM_TWNHIT;
		public static const CM_PHHIT:uint=3038; //破魂斩
		public static const CM_DAILY:uint=3042; //逐日剑法 20080511

		public static const CM_SANJUEHIT:uint=3060; //三绝杀
		public static const CM_ZHUIXINHIT:uint=3061; //追心刺
		public static const CM_DUANYUEHIT:uint=3062; //断岳斩
		public static const CM_HENGSAOHIT:uint=3063; //横扫千军
		public static const CM_YTPDHIT:uint=3064; //倚天劈地
		public static const CM_XPYJHIT:uint=3065; //血魄一击
		public static const CM_4LONGHIT:uint=3066; //4级刺杀
		public static const CM_YUANYUEHIT:uint=3067; //圆月弯刀
		public static const CM_KMAG101:uint=3068; //风剑术
		public static const CM_KMAG101D:uint=3069;
		public static const CM_MAGICMSG:uint=3070;
		public static const CM_KMAG111:uint=3071;

		public static const RM_SANJUEHIT:uint=10060; //三绝杀
		public static const RM_ZHUIXINHIT:uint=10061; //追心刺  人刚刚开始的动作
		public static const RM_DUANYUEHIT:uint=10062; //断岳斩
		public static const RM_HENGSAOHIT:uint=10063; //横扫千军
		public static const RM_ZHUIXIN_OK:uint=10064; //追心刺  冲撞过去的动作
		public static const RM_YTPDHIT:uint=10065; //倚天劈地
		public static const RM_XPYJHIT:uint=10066; //血魄一击
		public static const RM_MAG101:uint=10067;
		public static const RM_MAGICTYPE:uint=10068;
		public static const RM_MAG111:uint=10069;


//public static const //--RM_消息 添加处 36000起步--//
		public static const RM_OPENPULSE_OK:uint=36000;
		public static const RM_OPENPULSE_FAIL:uint=36001;
		public static const RM_RUSHPULSE_OK:uint=36002;
		public static const RM_RUSHPULSE_FAIL:uint=36003;
		public static const RM_PULSECHANGED:uint=36004;
		public static const RM_BATTERORDER:uint=36005;
		public static const RM_BATTERUSEFINALLY:uint=36006;
		public static const RM_HEROBATTERORDER:uint=36007;
		public static const RM_HEROPULSECHANGED:uint=36008;
		public static const RM_STORMSRATE:uint=36009;
		public static const RM_STORMSRATECHANGED:uint=36010;
		public static const RM_HEROSTORMSRATECHANGED:uint=36011;
		public static const RM_OPENPULSENEEDLEV:uint=36012;
//public static const //双英雄 相关
//public static const //  RM_GETDOUBLEHEROINFO     :uint= 36013;
		public static const RM_HEROATTECTMODE:uint=36014;
		public static const RM_GETASSESSHEROINFO:uint=36015;
		public static const RM_QUERYASSESSHERO:uint=36016;
		public static const RM_SHOWASSESSDLG:uint=36017;
		public static const RM_ISDEHERO:uint=36018;
		public static const RM_OPENTRAININGDLG:uint=36019;

//public static const //新技能和四级技能相关
		public static const RM_4LONGHIT:uint=36020;
		public static const RM_YUANYUEHIT:uint=36021;

		public static const CM_SAY:uint=3030; //角色发言
		public static const CM_40HIT:uint=3026;
		public static const CM_41HIT:uint=3027;
		public static const CM_42HIT:uint=3029;
		public static const CM_43HIT:uint=3028;
		public static const CM_USEBATTER:uint=3080; //使用连击
		public static const RM_10401:uint=10401;

		public static const RM_MENU_OK:uint=10309; //菜单
		public static const RM_MERCHANTDLGCLOSE:uint=10127;
		public static const RM_SENDDELITEMLIST:uint=10148; //发送删除项目的名单
		public static const RM_SENDUSERSREPAIR:uint=10141; //发送用户修理
		public static const RM_SENDGOODSLIST:uint=10128; //发送商品名单
		public static const RM_SENDUSERSELL:uint=10129; //发送用户出售
		public static const RM_SENDUSERREPAIR:uint=11139; //发送用户修理
		public static const RM_USERMAKEDRUGITEMLIST:uint=10149; //用户做药品项目的名单
		public static const RM_USERSTORAGEITEM:uint=10146; //用户仓库项目
		public static const RM_USERGETBACKITEM:uint=10147; //用户获得回的仓库项目

		public static const RM_SPACEMOVE_FIRE2:uint=11330; //空间移动
		public static const RM_SPACEMOVE_FIRE:uint=11331; //空间移动

		public static const RM_BUYITEM_SUCCESS:uint=10133; //购买项目成功
		public static const RM_BUYITEM_FAIL:uint=10134; //购买项目失败
		public static const RM_SENDDETAILGOODSLIST:uint=10135; //发送详细的商品名单
		public static const RM_SENDBUYPRICE:uint=10130; //发送购买价格
		public static const RM_USERSELLITEM_OK:uint=10131; //用户出售成功
		public static const RM_USERSELLITEM_FAIL:uint=10132; //用户出售失败
		public static const RM_MAKEDRUG_SUCCESS:uint=10150; //做药成功
		public static const RM_MAKEDRUG_FAIL:uint=10151; //做药失败
		public static const RM_SENDREPAIRCOST:uint=10142; //发送修理成本
		public static const RM_USERREPAIRITEM_OK:uint=10143; //用户修理项目成功
		public static const RM_USERREPAIRITEM_FAIL:uint=10144; //用户修理项目失败

		public static const MAXBAGITEM:uint=46; //人物背包最大数量
		public static const MAXHEROBAGITEM:uint=40; //英雄包裹最大数量
		public static const RM_10155:uint=10155;
		public static const RM_PLAYDICE:uint=10500;
		public static const RM_ADJUST_BONUS:uint=10400;

		public static const RM_BUILDGUILD_OK:uint=10303;
		public static const RM_BUILDGUILD_FAIL:uint=10304;
		public static const RM_DONATE_OK:uint=10305;

		public static const RM_GAMEGOLDCHANGED:uint=10666;

		public static const STATE_OPENHEATH:uint=1;
		public static const POISON_68:uint=68;

		public static const RM_MYSTATUS:uint=10777;

		public static const CM_QUERYUSERSTATE:uint=82; //查询用户状态(用户登录进去,实际上是客户端向服务器索取查询最近一次,退出服务器前的状态的过程,
//public static const //服务器自动把用户最近一次下线以让游戏继续的一些信息返回到客户端)

		public static const CM_QUERYBAGITEMS:uint=81; //查询包裹物品 背包

		public static const CM_QUERYUSERSET:uint=49999;

		public static const CM_OPENDOOR:uint=1002; //开门,人物走到地图的某个过门点时
		public static const CM_SOFTCLOSE:uint=1009; //退出传奇(游戏程序,可能是游戏中大退,也可能时选人时退出)
		public static const CM_1017:uint=1017;


		public static const RM_HORSERUN:uint=11000;
		public static const RM_HEAVYHIT:uint=10005;
		public static const RM_BIGHIT:uint=10006;
		public static const RM_MOVEFAIL:uint=10010;
		public static const RM_CRSHIT:uint=11014;
		public static const RM_RUSHKUNG:uint=11015;

		public static const RM_41:uint=41;
		public static const RM_42:uint=42;
		public static const RM_43:uint=43;
		public static const RM_44:uint=56;

		public static const RM_MAGICFIREFAIL:uint=10121;
		public static const RM_LAMPCHANGEDURA:uint=10138;
		public static const RM_GROUPCANCEL:uint=10140;

		public static const RM_DONATE_FAIL:uint=10306;

		public static const RM_BREAKWEAPON:uint=10413;

		public static const RM_PASSWORD:uint=10416;

		public static const RM_PASSWORDSTATUS:uint=10601;

		public static const SM_40:uint=35;
		public static const SM_41:uint=36;
		public static const SM_42:uint=37;
		public static const SM_43:uint=38;
		public static const SM_44:uint=39; //龙影剑法

		public static const SM_HORSERUN:uint=5;
		public static const SM_716:uint=716;

		public static const SM_PASSWORD:uint=3030;
		public static const SM_PLAYDICE:uint=1200;

		public static const SM_PASSWORDSTATUS:uint=20001;

		public static const SM_GAMEGOLDNAME:uint=55; //向客户端发送游戏币,游戏点,金刚石,灵符数量

		public static const SM_SERVERCONFIG:uint=20002;
		public static const SM_GETREGINFO:uint=20003;
		public static const SM_GUALIST:uint=20004;


		public static const ET_DIGOUTZOMBI:uint=1;
		public static const ET_PILESTONES:uint=3;
		public static const ET_HOLYCURTAIN:uint=4;
		public static const ET_FIRE:uint=5;
		public static const ET_SCULPEICE:uint=6;

		public static const ET_FIREFLOWER_1:uint=7; //一心一意
		public static const ET_FIREFLOWER_2:uint=8; //心心相印
		public static const ET_FIREFLOWER_3:uint=9;
		public static const ET_FIREFLOWER_4:uint=10;
		public static const ET_FIREFLOWER_5:uint=11;
		public static const ET_FIREFLOWER_6:uint=12;
		public static const ET_FIREFLOWER_7:uint=13;
		public static const ET_FIREFLOWER_8:uint=14; //没有图片
		public static const ET_FOUNTAIN:uint=15; //喷泉效果 20080624
		public static const ET_DIEEVENT:uint=16; //人型庄主死亡动画效果 20080918
		public static const ET_FIREDRAGON:uint=17; //守护兽小火圈效果 20090123
		public static const ET_NPCDOOR1:uint=18;
		public static const ET_NPCDOOR2:uint=19;
		public static const ET_NPCDOOR3:uint=20;
		public static const ET_NPCDOOR4:uint=21;
		public static const ET_NPCDOOR5:uint=22;

		public static const ET_WALL2:uint=23;
		public static const ET_WALL3:uint=18;
		public static const ET_WALL4:uint=19;
		public static const ET_WALL5:uint=20;
		public static const ET_WALL6:uint=21;
		public static const ET_WALL7:uint=22;
		public static const ET_FIRER:uint=24;

		public static const ET_MAPMAGIC:uint=25;
		public static const ET_BARRIER:uint=26; //障碍点

//public static const {5种空间门}
		public static const ET_SPACEDOOR_1:uint=26;
		public static const ET_SPACEDOOR_2:uint=27;
		public static const ET_SPACEDOOR_3:uint=28;
		public static const ET_SPACEDOOR_4:uint=29;
		public static const ET_SPACEDOOR_5:uint=30;
		public static const ET_SPACEDOOR_6:uint=31;

		public static const ET_FIRE70:uint=32;

		public static const CM_CHECKID:uint=1999;
		public static const CM_PROTOCOL:uint=2000;
		public static const CM_IDPASSWORD:uint=2001; //客户端向服务器发送ID和密码
		public static const CM_ADDNEWUSER:uint=2002; //新建用户,就是注册新账号,登录时选择了"新用户"并操作成功
		public static const CM_CHANGEPASSWORD:uint=2003; //修改密码
		public static const CM_UPDATEUSER:uint=2004; //更新注册资料??
		public static const CM_RANDOMCODE:uint=2006; //取验证码 20080612
		public static const SM_RANDOMCODE:uint=2007;
		public static const SM_CHECKID_FAIL:uint=1998;
		public static const SM_CHECKID_OK:uint=1997;
		public static const CM_CHANGEPASSWORD1:uint=1992; //客户端修改密码
		public static const CM_CLOSENPCWIN:uint=1991;


		public static const CLIENT_VERSION_NUMBER:uint=920080512; //9+客户端版本号 20080512
		public static const CM_3037:uint=3039; //2007.10.15改了值  以前是  3037

		public static const SM_NEEDPASSWORD:uint=8003;
		public static const CM_POWERBLOCK:uint=0;

//public static const //商铺相关
		public static const CM_OPENSHOP:uint=9000; //打开商铺
		public static const SM_SENGSHOPITEMS:uint=9001; // SERIES 7 每页的数量    wParam 总页数
		public static const CM_BUYSHOPITEM:uint=9002;
		public static const SM_BUYSHOPITEM_SUCCESS:uint=9003;
		public static const SM_BUYSHOPITEM_FAIL:uint=9004;
		public static const SM_SENGSHOPSPECIALLYITEMS:uint=9005; //奇珍类型
		public static const CM_BUYSHOPITEMGIVE:uint=9006; //赠送
		public static const SM_BUYSHOPITEMGIVE_FAIL:uint=9007;
		public static const SM_BUYSHOPITEMGIVE_SUCCESS:uint=9008;

		public static const RM_OPENSHOPSpecially:uint=30000;
		public static const RM_OPENSHOP:uint=30001;
		public static const RM_BUYSHOPITEM_FAIL:uint=30003; //商铺购买物品失败
		public static const RM_BUYSHOPITEMGIVE_FAIL:uint=30004;
		public static const RM_BUYSHOPITEMGIVE_SUCCESS:uint=30005;
//public static const //:uint==============================================================================
		public static const CM_QUERYUSERLEVELSORT:uint=3500; //用户等级排行
		public static const RM_QUERYUSERLEVELSORT:uint=35000;
		public static const SM_QUERYUSERLEVELSORT:uint=2500;
//public static const //:uint==============================新增物品寄售系统(拍卖)==========================
		public static const RM_SENDSELLOFFGOODSLIST:uint=21008; //拍卖
		public static const SM_SENDSELLOFFGOODSLIST:uint=20008; //拍卖
		public static const RM_SENDUSERSELLOFFITEM:uint=21005; //寄售物品
		public static const SM_SENDUSERSELLOFFITEM:uint=20005; //寄售物品
		public static const RM_SENDSELLOFFITEMLIST:uint=22009; //查询得到的寄售物品
		public static const CM_SENDSELLOFFITEMLIST:uint=20009; //查询得到的寄售物品
		public static const RM_SENDBUYSELLOFFITEM_OK:uint=21010; //购买寄售物品成功
		public static const SM_SENDBUYSELLOFFITEM_OK:uint=20010; //购买寄售物品成功
		public static const RM_SENDBUYSELLOFFITEM_FAIL:uint=21011; //购买寄售物品失败
		public static const SM_SENDBUYSELLOFFITEM_FAIL:uint=20011; //购买寄售物品失败
		public static const RM_SENDBUYSELLOFFITEM:uint=41005; //购买选择寄售物品
		public static const CM_SENDBUYSELLOFFITEM:uint=4005; //购买选择寄售物品
		public static const RM_SENDQUERYSELLOFFITEM:uint=41006; //查询选择寄售物品
		public static const CM_SENDQUERYSELLOFFITEM:uint=4006; //查询选择寄售物品
		public static const RM_SENDSELLOFFITEM:uint=41004; //接受寄售物品
		public static const CM_SENDSELLOFFITEM:uint=4004; //接受寄售物品
		public static const RM_SENDUSERSELLOFFITEM_FAIL:uint=2007; //R = -3  寄售物品失败
		public static const RM_SENDUSERSELLOFFITEM_OK:uint=2006; //寄售物品成功
		public static const SM_SENDUSERSELLOFFITEM_FAIL:uint=20007; //R = -3  寄售物品失败
		public static const SM_SENDUSERSELLOFFITEM_OK:uint=20006; //寄售物品成功
//public static const //:uint==============================元宝寄售系统(20080316)==========================
		public static const RM_SENDDEALOFFFORM:uint=23000; //打开出售物品窗口
		public static const SM_SENDDEALOFFFORM:uint=23001; //打开出售物品窗口
		public static const CM_SELLOFFADDITEM:uint=23002; //客户端往出售物品窗口里加物品
		public static const SM_SELLOFFADDITEM_OK:uint=23003; //客户端往出售物品窗口里加物品 成功
		public static const RM_SELLOFFADDITEM_OK:uint=23004;
		public static const SM_SellOffADDITEM_FAIL:uint=23005; //客户端往出售物品窗口里加物品 失败
		public static const RM_SellOffADDITEM_FAIL:uint=23006;
		public static const CM_SELLOFFDELITEM:uint=23007; //客户端删除出售物品窗里的物品
		public static const SM_SELLOFFDELITEM_OK:uint=23008; //客户端删除出售物品窗里的物品 成功
		public static const RM_SELLOFFDELITEM_OK:uint=23009;
		public static const SM_SELLOFFDELITEM_FAIL:uint=23010; //客户端删除出售物品窗里的物品 失败
		public static const RM_SELLOFFDELITEM_FAIL:uint=23011;
		public static const CM_SELLOFFCANCEL:uint=23012; //客户端取消元宝寄售
		public static const RM_SELLOFFCANCEL:uint=23013; // 元宝寄售取消出售
		public static const SM_SellOffCANCEL:uint=23014; //元宝寄售取消出售
		public static const CM_SELLOFFEND:uint=23015; //客户端元宝寄售结束
		public static const SM_SELLOFFEND_OK:uint=23016; //客户端元宝寄售结束 成功
		public static const RM_SELLOFFEND_OK:uint=23017;
		public static const SM_SELLOFFEND_FAIL:uint=23018; //客户端元宝寄售结束 失败
		public static const RM_SELLOFFEND_FAIL:uint=23019;
		public static const RM_QUERYYBSELL:uint=23020; //查询正在出售的物品
		public static const SM_QUERYYBSELL:uint=23021; //查询正在出售的物品
		public static const RM_QUERYYBDEAL:uint=23022; //查询可以的购买物品
		public static const SM_QUERYYBDEAL:uint=23023; //查询可以的购买物品
		public static const CM_CANCELSELLOFFITEMING:uint=23024; //取消正在寄售的物品 20080318(出售人)
//public static const //SM_CANCELSELLOFFITEMING_OK :uint=23018;//取消正在寄售的物品 成功
		public static const CM_SELLOFFBUYCANCEL:uint=23025; //取消寄售 物品购买 20080318(购买人)
		public static const CM_SELLOFFBUY:uint=23026; //确定购买寄售物品 20080318
		public static const SM_SELLOFFBUY_OK:uint=23027; //购买成功
		public static const RM_SELLOFFBUY_OK:uint=23028;
//public static const //SM_SELLOFFBUY_FAIL :uint=23029;//购买失败
//public static const //RM_SELLOFFBUY_FAIL :uint=23030;
//public static const //:uint==============================================================================
//public static const //英雄
//public static const ////////////////////////////////////////////////////////////////////////////////
		public static const CM_RECALLHERO:uint=5000; //召唤英雄
		public static const SM_RECALLHERO:uint=5001;
		public static const CM_HEROLOGOUT:uint=5002; //英雄退出
		public static const SM_HEROLOGOUT:uint=5003;
		public static const SM_CREATEHERO:uint=5004; //创建英雄

		public static const SM_HERODEATH:uint=5005; //创建死亡
		public static const CM_HEROCHGSTATUS:uint=5006; //改变英雄状态
		public static const CM_HEROATTACKTARGET:uint=5007; //英雄锁定目标
		public static const CM_HEROPROTECT:uint=5008; //守护目标
		public static const CM_HEROTAKEONITEM:uint=5009; //打开物品栏
		public static const CM_HEROTAKEOFFITEM:uint=5010; //关闭物品栏
		public static const CM_TAKEOFFITEMHEROBAG:uint=5011; //装备脱下到英雄包裹
		public static const CM_TAKEOFFITEMTOMASTERBAG:uint=5012; //装备脱下到主人包裹
		public static const CM_SENDITEMTOMASTERBAG:uint=5013; //主人包裹到英雄包裹
		public static const CM_SENDITEMTOHEROBAG:uint=5014; //英雄包裹到主人包裹
		public static const SM_HEROTAKEON_OK:uint=5015;
		public static const SM_HEROTAKEON_FAIL:uint=5016;
		public static const SM_HEROTAKEOFF_OK:uint=5017;
		public static const SM_HEROTAKEOFF_FAIL:uint=5018;
		public static const SM_TAKEOFFTOHEROBAG_OK:uint=5019;
		public static const SM_TAKEOFFTOHEROBAG_FAIL:uint=5020;
		public static const SM_TAKEOFFTOMASTERBAG_OK:uint=5021;
		public static const SM_TAKEOFFTOMASTERBAG_FAIL:uint=5022;
		public static const CM_HEROTAKEONITEMFORMMASTERBAG:uint=5023; //从主人包裹穿装备到英雄包裹
		public static const CM_TAKEONITEMFORMHEROBAG:uint=5024; //从英雄包裹穿装备到主人包裹
		public static const SM_SENDITEMTOMASTERBAG_OK:uint=5025; //主人包裹到英雄包裹成功
		public static const SM_SENDITEMTOMASTERBAG_FAIL:uint=5026; //主人包裹到英雄包裹失败
		public static const SM_SENDITEMTOHEROBAG_OK:uint=5027; //英雄包裹到主人包裹
		public static const SM_SENDITEMTOHEROBAG_FAIL:uint=5028; //英雄包裹到主人包裹
		public static const CM_QUERYHEROBAGCOUNT:uint=5029; //查看英雄包裹容量
		public static const SM_QUERYHEROBAGCOUNT:uint=5030; //查看英雄包裹容量
		public static const CM_QUERYHEROBAGITEMS:uint=5031; //查看英雄包裹
		public static const SM_SENDHEROUSEITEMS:uint=5032; //发送英雄身上装备
		public static const SM_HEROBAGITEMS:uint=5033; //接收英雄物品
		public static const SM_HEROADDITEM:uint=5034; //英雄包裹添加物品
		public static const SM_HERODELITEM:uint=5035; //英雄包裹删除物品
		public static const SM_HEROUPDATEITEM:uint=5036; //英雄包裹更新物品
		public static const SM_HEROADDMAGIC:uint=5037; //添加英雄魔法
		public static const SM_HEROSENDMYMAGIC:uint=5038; //发送英雄的魔法
		public static const SM_HERODELMAGIC:uint=5039; //删除英雄魔法
		public static const SM_HEROABILITY:uint=5040; //英雄属性1
		public static const SM_HEROSUBABILITY:uint=5041; //英雄属性2
		public static const SM_HEROWEIGHTCHANGED:uint=5042;
		public static const CM_HEROEAT:uint=5043; //吃东西
		public static const SM_HEROEAT_OK:uint=5044; //吃东西成功
		public static const SM_HEROEAT_FAIL:uint=5045; //吃东西失败
		public static const SM_HEROMAGIC_LVEXP:uint=5046; //魔法等级
		public static const SM_HERODURACHANGE:uint=5047; //英雄持久改变
		public static const SM_HEROWINEXP:uint=5048; //英雄增加经验
		public static const SM_HEROLEVELUP:uint=5049; //英雄升级
		public static const SM_HEROCHANGEITEM:uint=5050; //好象没用上？
		public static const SM_HERODELITEMS:uint=5051; //删除英雄物品
		public static const CM_HERODROPITEM:uint=5052; //英雄往地上扔物品
		public static const SM_HERODROPITEM_SUCCESS:uint=5053; //英雄扔物品成功
		public static const SM_HERODROPITEM_FAIL:uint=5054; //英雄扔物品失败
		public static const CM_HEROGOTETHERUSESPELL:uint=5055; //使用合击
		public static const SM_GOTETHERUSESPELL:uint=5056; //使用合击
		public static const SM_FIRDRAGONPOINT:uint=5057; //英雄怒气值
		public static const CM_REPAIRFIRDRAGON:uint=5058; //修补火龙之心
		public static const SM_REPAIRFIRDRAGON_OK:uint=5059; //修补火龙之心成功
		public static const SM_REPAIRFIRDRAGON_FAIL:uint=5060; //修补火龙之心失败
//public static const //---------------------------------------------------
//public static const //祝福罐.魔令包功能 20080102
		public static const CM_REPAIRDRAGON:uint=5061; //祝福罐.魔令包功能
		public static const SM_REPAIRDRAGON_OK:uint=5062; //修补祝福罐.魔令包成功
		public static const SM_REPAIRDRAGON_FAIL:uint=5063; //修补祝福罐.魔令包失败
//public static const //----------------------------------------------------
		public static const CM_BTITEM:uint=5064; //摆摊物品
		public static const SM_BTITEM_SUCCESS:uint=5065;
		public static const SM_BTITEM_FAIL:uint=5066;
		public static const SM_BTITEM:uint=5067;

		public static const CM_BUYBTITEM:uint=5068;
		public static const CM_CANCLEBTITEM:uint=5069;
		public static const CM_GUANGAO:uint=5070;
		public static const CM_CHANGESZ:uint=5071;

		public static const SM_BAITANITEM_FAIL:uint=5072;
		public static const SM_LOGIP:uint=5073;

		public static const CM_FIFITEM:uint=5073;//背包-到合成
		public static const CM_FIFITEMOK:uint=5074;//确认合成
		public static const CM_DELFIFITEM:uint=5075;//合成取回-背包

		public static const CM_DOWN:uint=60000;
		public static const CM_DOWNMAP:uint=60002;
		public static const CM_DOWNSOUND:uint=60004;

//public static const //----CM_消息 从26000开始添加----//
//public static const //-------连击 经脉----- /
		public static const CM_OPENPULSE:uint=26000;
		public static const CM_RUSHPULSE:uint=26001;
		public static const CM_QUERYOPENPULSE:uint=26002;
		public static const CM_SETBATTERORDER:uint=26003;
		public static const CM_SETHEROBATTERORDER:uint=26004;
		public static const CM_QUERYHEROOPENPULSE:uint=26005;
		public static const CM_RUSHHEROPULSE:uint=26006;
		public static const CM_CHANGEHEROATTECTMODE:uint=26007; //改变副将英雄攻击模式
		public static const CM_QUERYASSESSHERO:uint=26008;
		public static const CM_ASSESSMENTHERO:uint=26009;
		public static const CM_TRAININGHERO:uint=26010;

		public static const CM_REMOTE:uint=20000;

		public static const RM_RECALLHERO:uint=19999; //召唤英雄
		public static const RM_HEROWEIGHTCHANGED:uint=20000;
		public static const RM_SENDHEROUSEITEMS:uint=20001;
		public static const RM_SENDHEROMYMAGIC:uint=20002;
		public static const RM_HEROMAGIC_LVEXP:uint=20003;
		public static const RM_QUERYHEROBAGCOUNT:uint=20004;
		public static const RM_HEROABILITY:uint=20005;
		public static const RM_HERODURACHANGE:uint=20006;
		public static const RM_HERODEATH:uint=20007;
		public static const RM_HEROLEVELUP:uint=20008;
		public static const RM_HEROWINEXP:uint=20009;
//public static const //RM_HEROLOGOUT :uint= 20010;
		public static const RM_CREATEHERO:uint=20011;
		public static const RM_MAKEGHOSTHERO:uint=20012;
		public static const RM_HEROSUBABILITY:uint=20013;


		public static const RM_GOTETHERUSESPELL:uint=20014; //使用合击
		public static const RM_FIRDRAGONPOINT:uint=20015; //发送英雄怒气值
		public static const RM_CHANGETURN:uint=20016;
//public static const //-----------------------------------月灵重击
		public static const RM_FAIRYATTACKRATE:uint=20017;
		public static const SM_FAIRYATTACKRATE:uint=20018;
//public static const //-----------------------------------
		public static const SM_SERVERUNBIND:uint=20019;
		public static const RM_DESTROYHERO:uint=20020; //英雄销毁
		public static const SM_DESTROYHERO:uint=20021; //英雄销毁

		public static const ET_PROTECTION_STRUCK:uint=20022; //护体受攻击  20080108
		public static const ET_PROTECTION_PIP:uint=20023; //护体被破

		public static const SM_MYSHOW:uint=20024; //显示自身动画
		public static const RM_MYSHOW:uint=20025; //

		public static const RM_OPENBOXS:uint=20026; //打开宝箱 20080115
		public static const SM_OPENBOXS:uint=5064; //打开宝箱 20080115
		public static const CM_OPENBOXS:uint=20027; //打开宝箱 20080115 清清加
		public static const CM_MOVEBOXS:uint=20028; //转动宝箱 20080117
		public static const RM_MOVEBOXS:uint=20029; //转动宝箱 20080117
		public static const SM_MOVEBOXS:uint=20030; //转动宝箱 20080117
		public static const CM_GETBOXS:uint=20031; //客户端取得宝箱物品 20080118
		public static const SM_GETBOXS:uint=20032;
		public static const RM_GETBOXS:uint=20033;
		public static const SM_OPENBOOKS:uint=20034; //打开卧龙NPC 20080119
		public static const RM_OPENBOOKS:uint=20035;
		public static const RM_DRAGONPOINT:uint=20036; //发送黄条气值 20080201
		public static const SM_DRAGONPOINT:uint=20037;
		public static const ET_OBJECTLEVELUP:uint=20038; //人物升级动画显示 20080222
		public static const RM_CHANGEATTATCKMODE:uint=20039; //改变攻击模式 20080228
		public static const SM_CHANGEATTATCKMODE:uint=20040; //改变攻击模式 20080228
		public static const CM_EXCHANGEGAMEGIRD:uint=20042; //商铺兑换灵符  20080302
		public static const SM_EXCHANGEGAMEGIRD_FAIL:uint=20043; //商铺购买物品失败
		public static const SM_EXCHANGEGAMEGIRD_SUCCESS:uint=20044;
		public static const RM_EXCHANGEGAMEGIRD_FAIL:uint=20045;
		public static const RM_EXCHANGEGAMEGIRD_SUCCESS:uint=20046;
		public static const RM_OPENDRAGONBOXS:uint=20047; //卧龙开宝箱 20080306
		public static const SM_OPENDRAGONBOXS:uint=20048; //卧龙开宝箱 20080306
//public static const // SM_OPENBOXS_OK :uint= 20047; //打开宝箱成功 20080306
		public static const RM_OPENBOXS_FAIL:uint=20049; //打开宝箱失败 20080306
		public static const SM_OPENBOXS_FAIL:uint=20050; //打开宝箱失败 20080306

		public static const RM_EXPTIMEITEMS:uint=20051; //聚灵珠 发送时间改变消息 20080306
		public static const SM_EXPTIMEITEMS:uint=20052; //聚灵珠 发送时间改变消息 20080306

		public static const ET_OBJECTBUTCHMON:uint=20053; //人物挖尸体得到物品显示 20080325
		public static const ET_DRINKDECDRAGON:uint=20054; //喝酒抵御合击，显示自身效果 20090105

//public static const //SM_CLOSEDRAGONPOINT :uint= 20055;  //关闭龙影黄条 20080329
//public static const //---------------------------粹练系统------------------------------------------
		public static const RM_QUERYREFINEITEM:uint=20056; //打开粹练框口
		public static const SM_QUERYREFINEITEM:uint=20057; //打开粹练框口
		public static const CM_REFINEITEM:uint=20058; //客户端发送粹练物品 20080507

		public static const SM_UPDATERYREFINEITEM:uint=20059; //更新粹练物品 20080507
		public static const CM_REPAIRFINEITEM:uint=20060; //修补火云石 20080507 20080507
		public static const SM_REPAIRFINEITEM_OK:uint=20061; //修补火云石成功  20080507
		public static const SM_REPAIRFINEITEM_FAIL:uint=20062; //修补火云石失败  20080507
//public static const //-----------------------------------------------------------------------------
		public static const RM_DAILY:uint=20063; //逐日剑法 20080511
		public static const SM_DAILY:uint=20064; //逐日剑法 20080511
		public static const RM_GLORY:uint=20065; //发送到客户端 荣誉值 20080511
		public static const SM_GLORY:uint=20066; //发送到客户端 荣誉值 20080511

		public static const RM_GETHEROINFO:uint=20067;
		public static const SM_GETHEROINFO:uint=20068; //获得英雄数据
		public static const CM_SELGETHERO:uint=20069; //取出英雄
		public static const RM_SENDUSERPLAYDRINK:uint=20070; //出现请酒对话框 20080515
		public static const SM_SENDUSERPLAYDRINK:uint=20071; //出现请酒对话框 20080515
		public static const CM_USERPLAYDRINKITEM:uint=20072; //请酒框放上物品发送到M2
		public static const SM_USERPLAYDRINK_OK:uint=20073; //请酒成功  20080515
		public static const SM_USERPLAYDRINK_FAIL:uint=20074; //请酒失败 20080515
		public static const RM_PLAYDRINKSAY:uint=20075; //
		public static const SM_PLAYDRINKSAY:uint=20076;
		public static const CM_PlAYDRINKDLGSELECT:uint=20077; //商品选择,大类
		public static const RM_OPENPLAYDRINK:uint=20078; //打开窗口
		public static const SM_OPENPLAYDRINK:uint=20079; //打开窗口
		public static const CM_PlAYDRINKGAME:uint=20080; //发送猜拳码数 20080517
		public static const RM_PlayDrinkToDrink:uint=20081; //发送到客户端谁赢谁输
		public static const SM_PlayDrinkToDrink:uint=20082; //
		public static const CM_DrinkUpdateValue:uint=20083; //发送喝酒
		public static const RM_DrinkUpdateValue:uint=20084; //返回喝酒
		public static const SM_DrinkUpdateValue:uint=20085; //返回喝酒
		public static const RM_CLOSEDRINK:uint=20086; //关闭斗酒，请酒窗口
		public static const SM_CLOSEDRINK:uint=20087; //关闭斗酒，请酒窗口
		public static const CM_USERPLAYDRINK:uint=20088; //客户端发送请酒物品
		public static const SM_USERPLAYDRINKITEM_OK:uint=20089; //请酒物品成功
		public static const SM_USERPLAYDRINKITEM_FAIL:uint=20090; //请酒物品失败
		public static const RM_Browser:uint=20091; //连接指定网站
		public static const SM_Browser:uint=20092;

		public static const RM_PIXINGHIT:uint=20093; //劈星斩效果 20080611
		public static const SM_PIXINGHIT:uint=20094;

		public static const RM_LEITINGHIT:uint=20095; //雷霆一击效果 20080611
		public static const SM_LEITINGHIT:uint=20096;

		public static const CM_CHECKNUM:uint=20097; //检测验证码 20080612
		public static const SM_CHECKNUM_OK:uint=20098;
		public static const CM_CHANGECHECKNUM:uint=20099;

		public static const RM_AUTOGOTOXY:uint=20100; //自动寻路
		public static const SM_AUTOGOTOXY:uint=20101;
//public static const //-----------------------酿酒系统---------------------------------------------
		public static const RM_OPENMAKEWINE:uint=20102; //打开酿酒窗口
		public static const SM_OPENMAKEWINE:uint=20103; //打开酿酒窗口
		public static const CM_BEGINMAKEWINE:uint=20104; //开始酿酒(即把材料全放上窗口)
		public static const RM_MAKEWINE_OK:uint=20105; //酿酒成功
		public static const SM_MAKEWINE_OK:uint=20106; //酿酒成功
		public static const RM_MAKEWINE_FAIL:uint=20107; //酿酒失败
		public static const SM_MAKEWINE_FAIL:uint=20108; //酿酒失败
		public static const RM_NPCWALK:uint=20109; //酿酒NPC走动
		public static const SM_NPCWALK:uint=20110; //酿酒NPC走动
		public static const RM_MAGIC68SKILLEXP:uint=20111; //酒气护体技能经验
		public static const SM_MAGIC68SKILLEXP:uint=20112; //酒气护体技能经验
//public static const //------------------------挑战系统--------------------------------------------
		public static const SM_CHALLENGE_FAIL:uint=20113; //挑战失败
		public static const SM_CHALLENGEMENU:uint=20114; //打开挑战抵押物品窗口
		public static const CM_CHALLENGETRY:uint=20115; //玩家点挑战

		public static const CM_CHALLENGEADDITEM:uint=20116; //玩家把物品放到挑战框中
		public static const SM_CHALLENGEADDITEM_OK:uint=20117; //玩家增加抵押物品成功
		public static const SM_CHALLENGEADDITEM_FAIL:uint=20118; //玩家增加抵押物品失败
		public static const SM_CHALLENGEREMOTEADDITEM:uint=20119; //发送增加抵押的物品后,给客户端显示

		public static const CM_CHALLENGEDELITEM:uint=20120; //玩家从挑战框中取回物品
		public static const SM_CHALLENGEDELITEM_OK:uint=20121; //玩家删除抵押物品成功
		public static const SM_CHALLENGEDELITEM_FAIL:uint=20122; //玩家删除抵押物品失败
		public static const SM_CHALLENGEREMOTEDELITEM:uint=20123; //发送删除抵押的物品后,给客户端显示

		public static const CM_CHALLENGECANCEL:uint=20124; //玩家取消挑战
		public static const SM_CHALLENGECANCEL:uint=20125; //玩家取消挑战

		public static const CM_CHALLENGECHGGOLD:uint=20126; //客户端把金币放到挑战框中
		public static const SM_CHALLENCHGGOLD_FAIL:uint=20127; //客户端把金币放到挑战框中失败
		public static const SM_CHALLENCHGGOLD_OK:uint=20128; //客户端把金币放到挑战框中成功
		public static const SM_CHALLENREMOTECHGGOLD:uint=20129; //客户端把金币放到挑战框中,给客户端显示

		public static const CM_CHALLENGECHGDIAMOND:uint=20130; //客户端把金刚石放到挑战框中
		public static const SM_CHALLENCHGDIAMOND_FAIL:uint=20131; //客户端把金刚石放到挑战框中失败
		public static const SM_CHALLENCHGDIAMOND_OK:uint=20132; //客户端把金刚石放到挑战框中成功
		public static const SM_CHALLENREMOTECHGDIAMOND:uint=20133; //客户端把金刚石放到挑战框中,给客户端显示

		public static const CM_CHALLENGEEND:uint=20134; //挑战抵押物品结束
		public static const SM_CLOSECHALLENGE:uint=20135; //关闭挑战抵押物品窗口
//public static const //----------------------------------------------------------------------------
		public static const RM_PLAYMAKEWINEABILITY:uint=20136; //酒2相关属性 20080804
		public static const SM_PLAYMAKEWINEABILITY:uint=20137; //酒2相关属性 20080804
		public static const RM_HEROMAKEWINEABILITY:uint=20138; //酒2相关属性 20080804
		public static const SM_HEROMAKEWINEABILITY:uint=20139; //酒2相关属性 20080804

		public static const RM_CANEXPLORATION:uint=20140; //可探索 20080810
		public static const SM_CANEXPLORATION:uint=20141; //可探索 20080810
//public static const //----------------------------------------------------------------------------
		public static const SM_SENDLOGINKEY:uint=20142; //网关给客户端或登陆器发送登陆器封包码 20080901
		public static const SM_GATEPASS_FAIL:uint=20143; //和网关的密码错误

		public static const RM_HEROMAGIC68SKILLEXP:uint=20144; //英雄酒气护体技能经验  20080925
		public static const SM_HEROMAGIC68SKILLEXP:uint=20145; //英雄酒气护体技能经验  20080925

		public static const RM_USERBIGSTORAGEITEM:uint=20146; //用户无限仓库项目
		public static const RM_USERBIGGETBACKITEM:uint=20147; //用户获得回的无限仓库项目
		public static const RM_USERLEVELORDER:uint=20148; //用户等级命令

		public static const RM_HEROAUTOOPENDEFENCE:uint=20149; //英雄内挂自动持续开盾 20080930
		public static const SM_HEROAUTOOPENDEFENCE:uint=20150; //英雄内挂自动持续开盾 20080930
		public static const CM_HEROAUTOOPENDEFENCE:uint=20151; //英雄内挂自动持续开盾 20080930

		public static const RM_MAGIC69SKILLEXP:uint=20152; //内功心法经验
		public static const SM_MAGIC69SKILLEXP:uint=20153; //内功心法经验
		public static const RM_HEROMAGIC69SKILLEXP:uint=20154; //英雄内功心法经验  20080930
		public static const SM_HEROMAGIC69SKILLEXP:uint=20155; //英雄内功心法经验  20080930

		public static const RM_MAGIC69SKILLNH:uint=20156; //内力值(黄条) 20081002
		public static const SM_MAGIC69SKILLNH:uint=20157; //内力值(黄条) 20081002
		public static const RM_WINNHEXP:uint=20158; //取得内功经验 20081007
		public static const SM_WINNHEXP:uint=20159; //取得内功经验 20081007
		public static const RM_HEROWINNHEXP:uint=20160; //英雄取得内功经验 20081007
		public static const SM_HEROWINNHEXP:uint=20161; //英雄取得内功经验 20081007

		public static const SM_SHOWSIGHICON:uint=20162; //显示感叹号图标 20090126
		public static const RM_HIDESIGHICON:uint=20163; //隐藏感叹号图标 20090126
		public static const SM_HIDESIGHICON:uint=20164; //隐藏感叹号图标 20090126
		public static const CM_CLICKSIGHICON:uint=20165; //点击感叹号图标 20090126
		public static const SM_UPDATETIME:uint=20166; //统一与客户端的倒计时 20090129

		public static const RM_OPENEXPCRYSTAL:uint=20167; //显示天地结晶图标 20090201
		public static const SM_OPENEXPCRYSTAL:uint=20168; //显示天地结晶图标 20090201
		public static const SM_SENDCRYSTALNGEXP:uint=20169; //发送天地结晶的内功经验 20090201
		public static const SM_SENDCRYSTALEXP:uint=20170; //发送天地结晶的内功经验 20090201
		public static const SM_SENDCRYSTALLEVEL:uint=20171; //发送天地结晶的等级 20090202
		public static const CM_CLICKCRYSTALEXPTOP:uint=20172; //点击天地结晶获得经验 20090202
		public static const SM_ZHUIXIN_OK:uint=20172; //追心刺
//public static const ////////////////////////////////////////////////////////////////////////////////
		public static const CM_ADDSTARITEM:uint=20174;
		public static const CM_APPLESTART:uint=20175;
		public static const CM_QIANZ:uint=20176;
		public static const CM_XIAZHU:uint=20177;


		public static const UNITX:uint=48;
		public static const UNITY:uint=32;
		public static const HALFX:uint=24;
		public static const HALFY:uint=16;
//public static const //MAXBAGITEM :uint= 46; //用户背包最大数量
//public static const //MAXMAGIC :uint= 30{20}; //原来54; 200081227 注释
		public static const MAXSTORAGEITEM:uint=50;
		public static const LOGICALMAPUNIT:uint=40;

///
		public static const CLIENTTYPE:uint=0; //普通的为0 ,99 为管理客户端    【客户端类型】

		public function MirProtocol() {

		}

	}

}