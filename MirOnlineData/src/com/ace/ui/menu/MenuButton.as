package com.ace.ui.menu
{
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.menu.data.MenuInfo;
	
	import flash.text.TextFormat;
	
	public class MenuButton extends NormalButton
	{
		public var index:int=-1;
		public function MenuButton(text:String,$index:int)
		{
			super(text);
			this.index=$index;
		}
		
		
		
	}
}