package com.leyou.utils {
	import com.ace.ui.lable.Label;
	import com.leyou.enum.TaskEnum;

	public class TaskUtils {


		public function TaskUtils() {
		}

		public static function getTaskContent(str:String):String {
			if (str == null)
				return null;

			var npcName:String=str.substring(0, str.indexOf("/"));
			var contentArr:Array=str.substring(str.indexOf("/") + 1).split("\\");

			var item:String;
			npcName+="|<font color='#ffffff' face='微软雅黑' size='12'>";
			//npcName+="|";
			for (var i:int=0; i < contentArr.length; i++) {
				if (contentArr[i] != null && contentArr[i] != "") {

					if (contentArr[i] == " ") {
						npcName+="\n";
						continue;
					}

					item=contentArr[i] as String;
					item=item.replace(/(<.*?>)/g, parseGroup)//.replace(/ /g,"  ");

					if (item.charAt(0) == "\n")
						item=item.replace("\n", "");

					if (item.charAt(0) == "\t")
						item=item.replace("\t", "");

					if (item.charAt(0) == "\t")
						item=item.replace("\t", "");

					npcName+=item + "\n";
				}
			}

			return npcName + "</font>";
		}

		private static function parseGroup(... param):String {
			if (param == null)
				return "";

			var p:String=param[1] as String;

			if (p.indexOf("color") > -1)
				if (p.indexOf("┄") == -1 && p.indexOf("┆") == -1)
					p=p.replace(/<color=([a-zA-Z0-9]{2,6})\s(.*?)(\|(.*?))?\s*>/g, '<font color="#$1"><a class="b" href="event:$4-">$2</a></font>');
				else
					p=p.replace(/<color=([a-zA-Z0-9]{2,6})\s(.*?)(\|(.*?))?\s*>/g, '<font color="#$1" face="宋体"><a href="event:$4-">$2</a></font>');
			else if (p.indexOf("Img") > -1)
				//标志位  <Img:22:0:3:0:0|一键押满/@@@ToMax,1|您确定直接10亿坐庄？>
				p=p.replace(/<(.*?)(\|(.*?))?(\/(@+.*?))(\|(.*?))?>/g, "<font color='#ffffff'><a href='event:$3-$5-$7' class='c'>+</a></font>");
			else if (p.indexOf("/@") > -1)
				p=p.replace(/<(.*?)(\|(.*?))?(\/(@+.*?))(\|(.*?))?>/g, "<font color='#ffea00'><a href='event:$3-$5-$7' class='c'>$1</a></font>");
			else
				p=p.replace(/<(.*?)\s?>/g, "<font color='#ff0000' class='z'>$1</font>");

			
			
			
			return p;
		}

	}
}
