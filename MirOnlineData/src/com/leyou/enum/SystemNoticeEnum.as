package com.leyou.enum {

	public class SystemNoticeEnum {
		//		[SystemMassage]
		public static const Message1Count:int = 70 			//信息栏1最多语序输入70个字符
		public static const Message1Colour:uint=0x00ff00;   //信息栏1字体颜色
		public static const Message1Font:String= "simsun";	//信息栏1使用字体为宋体
		public static const Message1Size:int = 20;  //信息栏1使用字号为20号
		public static const Message1TIME:int=2000;  // 毫秒  信息栏1消息显示时间 
		
		public static const Message2Count:int= 70;			//信息栏2最多语序输入70个字符
		public static const Message2Colour:uint =0x00ff00;  //信息栏2字体颜色
		public static const Message2Font:String= "simsun";   //信息栏2使用字体为宋体
		public static const Message2TIME:int=6000;  // 毫秒  信息栏2消息显示时间 
		public static const Message2Size:int = 20;  //信息栏2使用字号为20号
		
		public static const Message3Size:int = 20;     //信息栏3使用字号为10号
		public static const Message3Colour:uint =0x00ff00;    //信息栏3字体颜色
		public static const Message3Count:int = 70;//			信息栏3最多语序输入70个字符
		public static const Message3TIME:int=4000;  // 毫秒  信息栏3消息显示时间 
		public static const Message3Font:String= "simsun";   //信息栏3使用字体为宋体
		
		public static const Message4Count:int = 70;	 //信息栏4最多语序输入70个字符
		public static const Message4Colour:uint =0x00ff00;   //信息栏4字体颜色
		public static const Message4Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const Message4Size:int = 20;//				信息栏4使用字号为10号
		public static const Message4TIME:int =3000;//				信息栏4消息显示时间
		
		public static const PostCount:int = 140;// 				公告栏最多语序输入70个字符
		public static const PostColour:uint =0x00ff00;//			公告栏字体颜色
		public static const PostFont:String= "simsun";//				公告栏使用字体为宋体
		public static const PostSize:int = 20;//					公告栏使用字号为10号
		public static const PostTime:int= 5000;//	公告栏消息显示时间
		public static const PostSpeed:int=2;//移动速度  单位像素
		public static const ImMessageCount:int = 70	;//重要信息栏最多语序输入70个字符
		public static const ImMassageColour:uint =0x00ff00;  //重要信息栏字体颜色
		public static const ImMessageFont:String="simsun"; 	//重要信息栏使用字体为宋体
		public static const ImMessageSize:int = 10;	//重要信息栏使用字号为10号
		public static const ImMessageAcount:int = 10;//重要信息栏最多可以存储10个重要信息（交易那种可叠加显示信息算一条
		
		public static const IMG_WRONG:int=0;//红色叉
		public static const IMG_WARN:int=1;//蓝色叹号
		public static const IMG_PROMPT:int=2;//黄色叹号
		
		public static const IMG_WRONG_Count:int = 70;	 //信息栏4最多语序输入70个字符
		public static const IMG_WRONG_Colour:uint =0xFF0000;   //信息栏4字体颜色
		public static const IMG_WRONG_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_WRONG_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_WRONG_TIME:int =4000;//				信息栏4消息显示时间
		
		public static const IMG_WARN_Count:int = 70;	 //信息栏4最多语序输入70个字符
		public static const IMG_WARN_Colour:uint =0xFFFF00;   //信息栏4字体颜色
		public static const IMG_WARN_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_WARN_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_WARN_TIME:int =4000;//	
		
		public static const IMG_PROMPT_Count:int = 70;	 //信息栏4最多语序输入70个字符
		public static const IMG_PROMPT_Colour:uint =0xffffff;   //信息栏4字体颜色
		public static const IMG_PROMPT_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_PROMPT_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_PROMPT_TIME:int =4000;//	
		public function SystemNoticeEnum() {
		}
	}
}