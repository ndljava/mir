package com.ace.ui.menu.data {

	public class MenuInfo {
		public var menuName:String;
		public var menuIndex:int=-1;

		public function MenuInfo(menuName:String, menuIndex:int) {
			this.menuName=menuName;
			this.menuIndex=menuIndex;
		}
	}
}
