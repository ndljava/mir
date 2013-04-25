package com.leyou.ui.loadingWnd {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.progressBar.children.ProgressBar;

	public class LoadingWnd extends AutoSprite {
		private var progressBar:ProgressBar;

		public function LoadingWnd() {
			super(LibManager.getInstance().getXML("config/ui/LoadingWnd.xml"));
			this.init();
		}

		private function init():void {
			this.progressBar=this.getUIbyID("progressBar") as ProgressBar;
		}

		/**
		 *进度更新
		 * @param now
		 * @param sum
		 *
		 */
		public function setProgress(now:int, sum:int):void {
			this.progressBar.updateProgressByVal(now, sum);
		}
	}
}