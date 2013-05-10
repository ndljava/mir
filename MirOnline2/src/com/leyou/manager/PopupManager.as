package com.leyou.manager {
	import com.ace.enum.UIEnum;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.ui.window.children.WindInfo;

	public class PopupManager {
		
		private static var i:int=0;
		
		public function PopupManager() {
		}

		public static function showAlert(txt:String, okfunc:Function=null):SimpleWindow {
			i++;
			var w:WindInfo=WindInfo.getAlertInfo(txt, okfunc);
			return PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, w, "wind.alert"+i);
		}
		
		public static function showConfirm(txt:String, okfunc:Function=null,cancelfunc:Function=null):SimpleWindow {
			i++;
			var w:WindInfo=WindInfo.getConfirmInfo(txt, okfunc,cancelfunc);
			return PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, w, "wind.confirm"+i);
		}
		
		public static function showConfirmInput(txt:String, okfunc:Function=null,cancelfunc:Function=null):SimpleWindow {
			i++;
			var w:WindInfo=WindInfo.getInputInfo(txt, okfunc,cancelfunc);
			return PopWindow.showWnd(UIEnum.WND_TYPE_INPUT, w, "wind.confirminput"+i);
		}

	}
}
