package com.leyou.config {
	import com.leyou.game.scene.player.MyPlayer;
	import com.leyou.ui.selectUser.info.SelectUserInfo;

	public class Core {
		public static var stg:MirOnline;
		public static var me:MyPlayer;
		public static const selectInfo:SelectUserInfo=new SelectUserInfo();

		public static const serverIp:String="192.168.10.16";
//		public static const serverIp:String="211.101.131.125";
		public static const loginPort:int=9003;

		//新3
//		public static const serverIp:String="218.9.85.66";
//		public static const loginPort:int=9013;

//		外网
//		public static const serverIp:String="218.9.85.66";
//		public static const loginPort:int=9003;
//		外网
//		public static const serverIp:String="218.9.85.58";
//		public static const loginPort:int=9003;
		//外网测试
//		public static const serverIp:String="121.52.215.223";
//		public static const loginPort:int=9013;
		public static const gameVersion:String="2.28";

		public static const bugTest:Boolean=false;
		//是否主动触发仓库npc
		public static const auto_client_StoreNpc:Boolean=false;



	}
}