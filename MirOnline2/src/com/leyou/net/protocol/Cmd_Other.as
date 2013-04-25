package com.leyou.net.protocol {
	import com.ace.gameData.player.MyInfoManager;
	import com.leyou.config.Core;
	import com.leyou.manager.UIManager;

	public class Cmd_Other {


		public static function readCmd(str:String):void {
			str=str.split("/")[0];
			str=str.split("+")[1];
//			trace("其它附加协议:" + str);
			switch (str) {
				case "GOOD":
//					trace("ok");
					Core.me.clearPrePt();
					break;
				case "FAIL":
					trace("失败了");
					Core.me.comeback(); 
					UIManager.getInstance().mirScene.setMapPs(Core.me.x, Core.me.y);
					break;
				case "PWR!": //打开攻杀
					MyInfoManager.getInstance().openPwR();
					break;
				/*case "UPWR!": //打开攻杀-close
					MyInfoManager.getInstance().closePwR();
					break;*/
				case "LNG!": //打开刺杀 默认开
					MyInfoManager.getInstance().openLng();
					break;
				case "ULNG!": //打开刺杀 默认开-close
					MyInfoManager.getInstance().closeLng();
					break;
				case "WID!": //打开半月
					MyInfoManager.getInstance().openWid();
					break;
				case "UWID!": //打开半月-close
					MyInfoManager.getInstance().closeWid();
					break;
				case "FIR!": //逐日剑法
					MyInfoManager.getInstance().openFire();
					break;
				case "UFIR!": //逐日剑法-close
					MyInfoManager.getInstance().closeFire();
					break;
				default:
					trace("其它附加协议:" + str);
					break;
			}
		}


	}
}




/*
关闭“免shift攻击”
	默认单击后，走到人物面前，按键shift单击后，走到人物面前攻击
开启“免shift攻击”
	单击后，走到人物面前攻击

战士
	主动技能
		半月、刺杀(关技能)
	被动技能
		攻杀

1:


















*/