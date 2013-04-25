package com.leyou.utils {
	import com.ace.enum.PlayerEnum;
	import com.ace.ui.img.child.Image;

	public class PlayerUtil {
		public function PlayerUtil() {
		}

		/**
		 *根据玩家的 职业 性别 返回头像的路径
		 * @param race
		 * @param sex
		 * @return
		 *
		 */
		public static function getPlayerHeadImg(race:int, sex:int):String {
			var url:String;
			if (race == PlayerEnum.PRO_SOLDIER) {
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_zhans.png";
				else
					url="ui/login/icon_f_zhans.png";
			} else if (race == PlayerEnum.PRO_MASTER) {
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_fas.png";
				else
					url="ui/login/icon_f_fas.png";
			} else if (race == PlayerEnum.PRO_TAOIST) {
				if (sex == PlayerEnum.SEX_BOY)
					url="ui/login/icon_m_daos.png";
				else
					url="ui/login/icon_f_daos.png";
			}
			return url;
		}

		/**
		 *通过职业编号 返回职业名字
		 * @param raceIdx
		 * @param flag 0：职业全称 1：职业简称
		 * @return
		 *
		 */
		public static function getPlayerRaceByIdx(raceIdx:int, flag:int=0):String {
			if (raceIdx == PlayerEnum.PRO_SOLDIER && flag == 0)
				return "战士";
			else if (raceIdx == PlayerEnum.PRO_MASTER && flag == 0)
				return "法师";
			else if (raceIdx == PlayerEnum.PRO_TAOIST && flag == 0)
				return "道士";
			else if (raceIdx == PlayerEnum.PRO_SOLDIER && flag == 1)
				return "战";
			else if (raceIdx == PlayerEnum.PRO_MASTER && flag == 1)
				return "法";
			else if (raceIdx == PlayerEnum.PRO_TAOIST && flag == 1)
				return "道";
			else
				return "";

		}

		/**
		 *MemberType=5,Huiyuan="钻石"},
			MemberType=4,Huiyuan="钻石"},
			MemberType=3,Huiyuan="白金"},
			MemberType=2,Huiyuan="黄金"},
			MemberType=1,Huiyuan="过期会员"
			MemberType=0,Huiyuan="非会员"}
		 * @param id
		 *
		 */
		public static function getPlayerMemberByid(id:int):String {
			var str:String;
			switch (id) {
				case 0:
					str="普通玩家";
					break;
				case 1:
					str="普通玩家";
					break;
				case 2:
					str="黄金会员";
					break;
				case 3:
					str="白金会员";
					break;
				case 4:
					str="钻石会员";
					break;
				case 5:
					str="钻石会员";
					break;
			}

			return str;
		}
	}
}
