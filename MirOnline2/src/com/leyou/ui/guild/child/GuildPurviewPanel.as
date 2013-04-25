package com.leyou.ui.guild.child
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.manager.UIManager;
	import com.leyou.ui.guild.child.children.PurviewComponent;
	import com.leyou.utils.GuildUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class GuildPurviewPanel extends AutoSprite
	{
		private var btnArr:Vector.<NormalButton>;
		private var component:PurviewComponent;

		private var selectType:String;

		public function GuildPurviewPanel()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/GuildPurviewPage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void
		{
			this.btnArr=new Vector.<NormalButton>;

			this.component=new PurviewComponent();
			this.component.x=125.3;
			this.component.y=6;
			this.addChild(this.component);
		}

		public function updateData():void
		{
			var btn:NormalButton;
			for each (btn in this.btnArr)
			{
				this.removeChild(btn);
			}

			this.btnArr.length=0;

			var mType:Array=GuildUtils.MemeberType;
			
			for (var k:int=0;k<mType.length;k++)
			{
				if (mType[k] != null)
				{
					btn=new NormalButton("" + String(mType[k][1]).replace(/(\s|\r|\t|\*)*/g, ""), 116, 25);
					btn.name="" + k;
					btn.addEventListener(MouseEvent.CLICK, onBtnClick);
					
					this.addChild(btn);

					btn.x=10;
					btn.y=7 + this.btnArr.length * btn.height;

					this.btnArr.push(btn);
				}
			}

			//添加类别按钮
			btn=new NormalButton("自定义权限", 116, 25);
			btn.name="defined";

			this.addChild(btn);

			btn.x=10;
			btn.y=7 + this.btnArr.length * btn.height;

			btn.addEventListener(MouseEvent.CLICK, onBtnClick);

			if (selectType != null)
				this.component.updateData(selectType);
		}

		private function onBtnClick(evt:MouseEvent):void
		{
			selectType=evt.target.name as String;
			this.component.updateData(selectType);
		}
	}
}
