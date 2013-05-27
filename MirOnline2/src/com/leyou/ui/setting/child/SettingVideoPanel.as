package com.leyou.ui.setting.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.ace.gameData.setting.SettingVideoInfo;
	import com.leyou.manager.UIManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SettingVideoPanel extends AutoSprite {
		private var resolutionComboBox:ComboBox;
		private var windowModeChBox:CheckBox;
		private var bgMusicHSlider:HSlider;
		private var skillSoundhSlider:HSlider;
		private var interfaceSoundHSlider:HSlider;
		private var turnOffMusicChBox:CheckBox;
		private var sceneMusicRepeatChBox:CheckBox;
		private var _settingVideoInfo:SettingVideoInfo;

		public function SettingVideoPanel() {
			super(LibManager.getInstance().getXML("config/ui/setting/SettingVideo.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.resolutionComboBox=this.getUIbyID("resolutionComboBox") as ComboBox;

			this.windowModeChBox=this.getUIbyID("windowModeChBox") as CheckBox;
			this.turnOffMusicChBox=this.getUIbyID("turnOffMusicChBox") as CheckBox;
			this.sceneMusicRepeatChBox=this.getUIbyID("sceneMusicRepeatChBox") as CheckBox;

			this.bgMusicHSlider=this.getUIbyID("bgMusicHSlider") as HSlider;
			this.skillSoundhSlider=this.getUIbyID("skillSoundhSlider") as HSlider;
			this.interfaceSoundHSlider=this.getUIbyID("interfaceSoundHSlider") as HSlider;

			this.windowModeChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.turnOffMusicChBox.addEventListener(MouseEvent.CLICK, onClick);
			this.sceneMusicRepeatChBox.addEventListener(MouseEvent.CLICK, onClick);

			this.bgMusicHSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
			this.skillSoundhSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
			this.interfaceSoundHSlider.addEventListener(ScrollBarEvent.Progress_Update, onChange);
		}

		public function updataInfo(infor:SettingVideoInfo):void {
			this._settingVideoInfo=infor;
			if (infor.windowMode == 1)
				this.windowModeChBox.turnOn(false)
			else
				this.windowModeChBox.turnOff(false);
			if (infor.turnOffMusic == 1)
				this.turnOffMusicChBox.turnOn(false);
			else
				this.turnOffMusicChBox.turnOff(false);
			if (infor.sceneMusicRepeat == 1)
				this.sceneMusicRepeatChBox.turnOn(false);
			else
				this.sceneMusicRepeatChBox.turnOff(false);
			this.bgMusicHSlider.progress=infor.bgMusic;
			this.skillSoundhSlider.progress=infor.skillSound;
			this.interfaceSoundHSlider.progress=infor.interfaceSound;
		}

		private function onClick(evt:Event):void {
			switch (evt.target.name) {
				case "windowModeChBox":
					if (this.windowModeChBox.isOn)
						this._settingVideoInfo.windowMode=1;
					else
						this._settingVideoInfo.windowMode=0;
					break;
				case "turnOffMusicChBox":
					if (this.turnOffMusicChBox.isOn)
						this._settingVideoInfo.turnOffMusic=1;
					else
						this._settingVideoInfo.turnOffMusic=0;
					break;
				case "sceneMusicRepeatChBox":
					if (this.sceneMusicRepeatChBox.isOn)
						this._settingVideoInfo.sceneMusicRepeat=1;
					else
						this._settingVideoInfo.sceneMusicRepeat=0;
					break;
			}
			UIManager.getInstance().settingWnd.saveClientData();
		}

		private function onChange(evt:Event):void {
			switch (evt.target.name) {
				case "bgMusicHSlider":
					this._settingVideoInfo.bgMusic=this.bgMusicHSlider.progress;
					break;
				case "skillSoundhSlider":
					this._settingVideoInfo.skillSound=this.skillSoundhSlider.progress;
					break;
				case "interfaceSoundHSlider":
					this._settingVideoInfo.interfaceSound=this.interfaceSoundHSlider.progress;
					break;
			}
			UIManager.getInstance().settingWnd.saveClientData();
		}

		public function get settingVideoInfo():SettingVideoInfo {
			return _settingVideoInfo;
		}
	}
}