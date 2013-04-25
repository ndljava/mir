package com.leyou.ui.chat.child {
	import com.ace.ui.button.children.ImgLabelButton;
	
	import flash.text.TextFormat;

	public class MenuButton extends ImgLabelButton {
		public function MenuButton(bmd:*, text:String, $width:int=0, $height:int=0, textFormat:TextFormat=null, isEmbed:Boolean=false) {
			super(bmd, text, $width, $height, textFormat, isEmbed);
		}
		public function get labTextColor():uint{
			return this.lable.defaultTextFormat.color as uint;
		}
	}
}