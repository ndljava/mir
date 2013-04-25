package com.leyou.ui.guild.child
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.ui.guild.child.children.StorageComponent;
	
	import flash.events.MouseEvent;

	public class GuildStoragePanel extends AutoSprite
	{
		private var btnArr:Vector.<NormalButton>;
		private var compoent:StorageComponent;

		
		
		public function GuildStoragePanel()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/GuildStoragePage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void
		{
			this.btnArr=new Vector.<NormalButton>;
//			this.btnArr.push(this.getUIbyID("storageBtn0") as NormalButton);
//			this.btnArr.push(this.getUIbyID("storageBtn1") as NormalButton);
//			this.btnArr.push(this.getUIbyID("storageBtn2") as NormalButton);
//			this.btnArr.push(this.getUIbyID("storageBtn3") as NormalButton);
//			this.btnArr.push(this.getUIbyID("storageBtn4") as NormalButton);
//			this.btnArr.push(this.getUIbyID("storageBtn5") as NormalButton);
//			this.btnArr.push(this.getUIbyID("openBtn0") as NormalButton);
//			this.btnArr.push(this.getUIbyID("openBtn1") as NormalButton);
//			this.btnArr.push(this.getUIbyID("openBtn2") as NormalButton);
//			this.btnArr.push(this.getUIbyID("openBtn3") as NormalButton);

			for (var i:int=0; i < this.btnArr.length; i++)
			{
				this.btnArr[i].addEventListener(MouseEvent.CLICK, onBtnClick);
				this.btnArr[i].visible=false;
			}

			this.compoent=new StorageComponent();
			//this.compoent.x=123.5;
			//this.compoent.y=7;
			this.addChild(this.compoent);
		}
		
		public function updateData():void
		{
			this.compoent.updateGrid();
		}

		private function onBtnClick(evt:MouseEvent):void
		{
			switch (evt.target.name)
			{
				case "storageBtn0": //公会仓库栏1
					break;
				case "storageBtn1": //公会仓库栏2
					break;
				case "storageBtn2": //公会仓库栏3
					break;
				case "storageBtn3": //公会仓库栏4
					break;
				case "storageBtn4": //公会仓库栏5
					break;
				case "storageBtn5": //公会仓库栏6
					break;
				case "openBtn0": //点击开启
					break;
				case "openBtn1": //点击开启
					break;
				case "openBtn2": //点击开启
					break;
				case "openBtn3": //点击开启
					break;
			}
		}
		
		public function get currentPage():int
		{
			return this.compoent.currentPage;
		}
		
	}
}
