package com.leyou.utils {
	import com.ace.gameData.backPack.TClientItem;

	import flash.sampler.getMasterString;
	import flash.utils.Dictionary;

	public class GuildUtils {

		public static var MemeberType:Array=[];

		public static var memeberArr:Array=[];

		public function GuildUtils() {

		}

		/**
		 * 主页
		 * @param str
		 * @return
		 * [呵呵呵呵, ,1,<Notice>ddddddddddddddddddddddddd,<KillGuilds>,<AllyGuilds>,<GuildItem>太阳水         可获得贡献度:1];
		 */
		public static function getHomeContent(str:String):Array {
			if (str == null)
				return null;

			var arr:Array=str.match(/(<.*?>)?(\r?([^<]*?))?\r/g);
			if (arr == null)
				return null;

			/**
			 * <Notice>
				set好的身体好的人和第二大软件突然放大多提意见若犯同样惊人3463456用$%^$#%^&$%17
				<KillGuilds>
				<AllyGuilds>
					<GuildItem>
			*
			*/

			for (var stc:String in arr) {
				arr[stc]=String(arr[stc].replace(/\r*/g, "")).replace("<Notice>", "").replace("<KillGuilds>", "")..replace("<AllyGuilds>", "").replace("<GuildItem>", "");
			}

			return arr;
		}

		/**
		 * 会员
		 * @param str
		 * @return
		 *
		 * allArr=[
		 * 		[#1,*掌门人,face71]
		 *      [#99,*行会成员,face101]
		 * ]
		 */
		public static function getMemberContent(str:String):Array {
			if (str == null)
				return null;

			//清空类别
			MemeberType=[]

			var arr:Array=str.substr(1).split("#");

			var allArr:Array=[];
			var tmpStr:String;
			var tmpTypeIndex:int=-1;

			for (var j:int=0; j < arr.length; j++) {
				tmpStr=arr[j];
				arr[j]=[];

				tmpStr=tmpStr.replace(/\**/g, "");
				if (tmpStr.lastIndexOf("/") == tmpStr.length - 1)
					tmpStr=tmpStr.substr(0, tmpStr.length - 1)

				arr[j]=tmpStr.split("/");

				//类别
				if (MemeberType[arr[j][0]] == null)
					MemeberType[arr[j][0]]=arr[j].slice(0, 2);

			}

			return arr;
		}

		/**
		 * 返回最近的权限
		 * @return
		 *
		 */
		public static function getTopRankToMemberType():int {
			var typeArr:Array=GuildUtils.MemeberType;
			typeArr.sortOn("0", Array.CASEINSENSITIVE);

			var i:int=0;
			var arr:Array;
			for each (arr in typeArr) {
				if (arr != null && arr[0] != "99") {
					i=arr[0];
				}
			}

			return i;
		}

		/**
		 * 获取会员个数
		 * @param memArr
		 * @return
		 *
		 */
		public static function getMemberCount(memArr:Array):int {
			if (memArr == null || memArr.length == 0)
				return 0;

			var count:int=0;
			var arr:Array;
			for each (arr in memArr) {
				if (arr.length > 0)
					count+=arr.length - 2;
			}

			return count;
		}


		/**
		 * 删除某一类别下会员
		 * @param oldMemberArr
		 * @param type
		 * @return
		 *
		 */
		public static function removeAllByType(oldMemberArr:Array, type:String):void {
			var arr:Array=oldMemberArr;

			for (var i:int=0; i < arr.length; i++) {
				if (arr[i][0] == type)
					arr.splice(i, 1);
			}

		}

		/**
		 * 会员的数组转换
		 * @param arr
		 * @return
		 *
		 */
		public static function getArrayToString(arr:Array):String {
			var k:Array=arr.map(callback1);

			function callback1(item:Array, i:int, arr:Array):String {
				if (item != null) {
					return item.join("/");
				}

				return "";
			}

			return "#" + k.join("/");
		}

		/**
		 * 获取到服务器端的
		 * @param mArr
		 * @return
		 *
		 */
		public static function getMemberArrToServerString(mArr:Array):String {
			if (mArr == null || mArr.length == 0)
				return "";

			var str:String="";
			for (var i:int=0; i < mArr.length; i++) {
				str+="#" + mArr[i][0] + " <" + mArr[i][1] + ">\r\n";

				for (var j:int=2; j < mArr[i].length; j++) {
					str+=mArr[i][j] + "\r\n";
				}
			}

			return str;
		}

		/**
		 * 根据职业获取会员
		 * @param arr
		 * @param type
		 * @return
		 *
		 */
		public static function getMemberByType(arr:Array, type:String):Array {
			if (arr == null || arr.length == 0)
				return null;

			//本类别
			var typeArr:Array=[];
			var tmpArr:Array;
			//其他类别
			var typ1Arr:Array=[];

			for each (tmpArr in arr) {
				if (tmpArr[0] == type)
					typeArr.push(tmpArr);
				else
					typ1Arr.push(tmpArr);
			}


			return [typeArr, typ1Arr];
		}

		/**
		 * 删除会员
		 * @param memArr
		 * @param mName
		 *
		 */
		public static function delMemberByName(memArr:Array, mName:String):void {

			if (mName == null || mName == "")
				return;

			var swapArr:Array=[];
			var arr:Array;
			for each (arr in memArr) {
				if (arr.indexOf(mName) > -1)
					arr.splice(arr.indexOf(mName), 1);
			}
		}

		/**
		 * 会员类别归普通类别
		 * @param memArr
		 * @param mName
		 *
		 */
		public static function changeMemberToCommon(memArr:Array, mName:String, mType:String="99"):Array {
			if (mName == null || mName == "")
				return null;

			var swapArr:Array=[];
			var arr:Array;
			for each (arr in memArr) {
				if (arr.indexOf(mName) > -1)
					swapArr.push(arr.splice(arr.indexOf(mName), 1)[0]);
			}

			var hhArr:Array=getMemberByType(memArr, mType);
			hhArr[0][0]=hhArr[0][0].concat(swapArr);

			return hhArr[1].concat(hhArr[0]);
		}

		/**
		 * 获取会员的上下权限值
		 * @param arr
		 * @param type
		 * @return [0,1] 0是上线 1是下线
		 *
		 */
		public static function getMemberTopAndLowerByName(arr:Array, mName:String):Array {
			if (arr == null || arr.length == 0)
				return null;

			var typeArr:Array=getMemberByName(arr, mName);
			if (typeArr == null)
				return null;

			var lower:int=getTopRankToMemberType();
			if (typeArr[0] == "99") {
				return [lower, 99];
			} else {
				if (typeArr[0] == "1")
					return [1, int(typeArr[0]) + 1];
				else if (int(typeArr[0]) == lower)
					return [lower - 1, 99];
				else
					return [int(typeArr[0]) - 1, int(typeArr[0]) + 1];
			}

		}

		/**
		 * 通过名字获取会员
		 * @param arr
		 * @param mName
		 * @return
		 *
		 */
		public static function getMemberByName(arr:Array, mName:String):Array {
			if (arr == null || arr.length == 0)
				return null;

			var typeArr:Array=[];
			var tmpArr:Array;
			for each (tmpArr in arr) {
				if (tmpArr.indexOf(mName) > -1)
					return tmpArr;
			}

			return null;
		}

		/**
		 * 根据物品返回商店物品的类别
		 * @param item
		 * @return
		 *
		 */
		public static function getStoreTypeByItem(arr:Vector.<Vector.<Vector.<TClientItem>>>, item:TClientItem):int {
			for (var x1:int=0; x1 < arr.length; x1++) {
				if (x1 == 5 || x1 == 0)
					continue;

				for (var x2:int=0; x2 < arr[x1].length; x2++) {
					for (var x3:int=0; x3 < arr[x1][x2].length; x3++) {
						if (arr[x1][x2][x3] == item)
							return x1;
					}
				}
			}

			return 0;
		}


	}
}
