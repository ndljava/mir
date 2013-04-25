package com.leyou.net.protocol {
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.gameData.playerSkill.TClientMagic;
	import com.leyou.manager.UIManager;
	import com.leyou.net.NetEncode;
	
	import flash.utils.ByteArray;

	public class Cmd_Skill {

		//SM_SENDMYMAGIC
		static public function sm_sendMyMagic(td:TDefaultMessage, body:String):void {
			var arr:Array=body.split("/");

			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] == "")
					continue;
				updataSkill(arr[i]);
			}
			UIManager.getInstance().skillWnd.updata(MyInfoManager.getInstance().skills, true);
			UIManager.getInstance().ser_initUI();
		}

		static public function sm_addMagic(td:TDefaultMessage, body:String):void {
			updataSkill(body);
			UIManager.getInstance().skillWnd.updata(MyInfoManager.getInstance().skills);
		}

		static private function updataSkill(str:String):void {
			var cm:TClientMagic;
			var br:ByteArray;

			br=NetEncode.getInstance().DecodeBuffer(str);
			cm=new TClientMagic(br);
			cm=MyInfoManager.getInstance().getSkillInfo(cm.def.wMagicId);
			br.position=0;
			cm && cm.read(br);
		}
	}
}