package com.leyou.enum {

	public class FriendEnum {
		public static const FRIENDLIST_RENDER_HEIGHT:int=36;
		public static const FIREND_MENULIST_CONTAIN:Array=["私聊", "查看", "组队", "屏蔽", "删除"];
		public static const PRIVATE_CHAT:int=0;
		public static const CHECK:int=1;
		public static const GROUP:int=2;
		public static const SHIELD:int=3;
		public static const DELETE:int=4;

		public static const FRIEND_MAX_NUM:int=10;

		public static const REQUEST_FRIENDLIST:String="@WEB_viewFriendsList";
		public static const DELETE_FRIEND:String="@WEB_delFriend";
		public static const ADD_FRIEND:String="@WEB_addFriend";

		public static const RECEIVE_FRIENDLIST:String="####viewFriendsList=";

		public function FriendEnum() {
		}
	}
}