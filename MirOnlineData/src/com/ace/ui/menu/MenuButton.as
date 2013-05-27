package com.ace.ui.menu {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.menu.data.MenuInfo;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class MenuButton extends ImgLabelButton {
		public var index:int=-1;

		public function MenuButton(text:String, $index:int, $width:int=0, $height:int=0, textFormat:TextFormat=null, isEmbed:Boolean=false) {
			var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/other/button_font.png"));
			bmp.scale9Grid=new Rectangle(5, 5, 42, 15);
			if (text.length == 4)
				bmp.setSize(60, bmp.height);
			super(bmp.bitmapData, text, $width, $height, textFormat, isEmbed);
			this.index=$index;
		}
//		public function MenuButton(text:String,$index:int)
//		{
//			super(text);
//			this.index=$index;
//		}



	}
}