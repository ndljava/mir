package com.leyou.utils {

	public class TimeUtil {
		public function TimeUtil() {
		}

		public static function getStringToDate(s:String):Date {
			if (s == null)
				return null;

			var d:Array=s.split(" ");
			var ymd:Array=d[0].split("-");
			var hms:Array=d[1].split(":");
			var dt:Date=new Date(ymd[0], ymd[1], ymd[2], hms[0], hms[1], hms[2]);
			return dt;
		}

		/**
		 * 获取24小时后的
		 * @param d
		 * @return
		 *
		 */
		public static function getDateTo24hour(d:Date):Date {
			return new Date(d.fullYear, d.month, d.date + 1, d.hours, d.minutes, d.seconds);
		}

		/**
		 * 获取2个月之后的
		 * @param d
		 * @return
		 *
		 */
		public static function getDateTo2month(d:Date):Date {
			return new Date(d.fullYear, d.month + 2, d.date, d.hours, d.minutes, d.seconds);
		}

		/**
		 *
		 * @param d
		 * @return
		 *
		 */
		public static function getDateToString(d:Date):String {

			var ss:String="";
			var mm:String="";
			var hh:String="";

			if (d.seconds < 10) {
				ss="0" + d.seconds;
			} else {
				ss="" + d.seconds;
			}

			if (d.minutes < 10) {
				mm="0" + d.minutes;
			} else {
				mm="" + d.minutes;
			}

			if (d.hours < 10) {
				hh="0" + d.hours;
			} else {
				hh="" + d.hours;
			}

			return d.fullYear + "-" + d.month + "-" + d.date + " " + hh + ":" + mm + ":" + ss;
		}

		public static function getIntToTime(_i:int):String {
			if (_i <= 0)
				return "";

			var s:int=_i % 60;
			var m:int=_i / 60 % 60;
			var h:int=_i / 60 / 60 % 24;

			var ss:String="";
			var mm:String="";
			var hh:String="";

			if (s < 10) {
				ss="0" + s;
			} else {
				ss="" + s;
			}

			if (m < 10) {
				mm="0" + m;
			} else {
				mm="" + m;
			}

			if (h < 10) {
				hh="0" + h;
			} else {
				hh="" + h;
			}

			return hh + ":" + mm + ":" + ss;
		}

	}
}
