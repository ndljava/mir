package com.leyou.enum {

	public class ChatEnum {
		public static const CHANNEL_COMPOSITE:int=0;
		public static const CHANNEL_AREA:int=1;
		public static const CHANNEL_TEAM:int=2;
		public static const CHANNEL_GUILD:int=3;
		public static const CHANNEL_UNION:int=4;
		public static const CHANNEL_PRIVATE:int=5;
//		public static const CHANNEL_SYSTEM_MONVE:int=6;
		public static const CHANNEL_SYSTEM:int=7;
		public static const CHANNEL_SYSTEM_ALL:int=8; //在所有的频道都显示

		//说话【!区域 、	!!组队、 	!~行会 、 /私聊】
		public static const FLAG_AREA:String="!";
		public static const FLAG_TEAM:String="!!";
		public static const FLAG_GUILD:String="!~";
		public static const FLAG_PRIVATE:String="/";
		public static const FLAG_UNION:String="!@";
		public static const FLAG_COMPOSITE:String="~";

		public static const MESSAGE_MAX_NUM:int=50;
		public static const MESSAGE_LONG:int=35;
		public static const MESSAGE_HORN_LONG:int=50;

		//说话的颜色
		public static const COLOR_USER:String="#cc9957";
		public static const COLOR_AREA:String="#8bdb3c";
		public static const COLOR_TEAM:String="#87ceeb";
		public static const COLOR_GUILD:String="#00c957";
		public static const COLOR_PRIVATE:String="#da70d6";
		public static const COLOR_SYSYTEM:String="#ee2211";
		public static const COLOR_COMPOSITE:String="#ffffff";
		public static const COLOR_UNION:String="#fa9611";
		public static const COLOR_HORN:String="#FFD700";

		public static const COLOR_AREA_UINT:uint=0x8bdb3c;
		public static const COLOR_TEAM_UINT:uint=0x87ceeb;
		public static const COLOR_GUILD_UINT:uint=0x00c957;
		public static const COLOR_PRIVATE_UINT:uint=0xda70d6;
		public static const COLOR_COMPOSITE_UINT:uint=0xffffff;
		public static const COLOR_UNION_UINT:uint=0xfa9611;

		//说话的cd时间 秒为毫秒
		public static const TIME_COMPOSITE:int=3000;
		public static const TIME_TEAM:int=3000;
		public static const TIME_GUILD:int=3000;
		public static const TIME_UINT:int=3000;
		public static const TIME_PRIVATE:int=3000;
		public static const TIME_AREA:int=3000;

		public static const imgKeyArr:Array=["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39"];

		public static const COMBOX_CHAT_CHANNEL:String="chat_channle";
		public static const CHAT_MEMORY_LONG:int=5;
		public function ChatEnum() {
		}
	}
}