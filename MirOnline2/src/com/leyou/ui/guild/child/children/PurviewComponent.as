package com.leyou.ui.guild.child.children
{
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.utils.GuildUtils;

	import flash.display.Shape;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class PurviewComponent extends AutoSprite
	{
		private var positionInput:TextInput; //职位
		private var confirmBtn:NormalButton; //确认按钮
		private var resetBtn:NormalButton; //重置按钮

		private var selectItemType:String;

		/**
		 * ui容器
		 */
		private var memberContiner:ScrollPane;

		/**
		 *当前的
		 */
		private var memberArr:Vector.<CheckBox>;
		/**
		 * 其他的
		 */
		private var memberOtherArr:Vector.<CheckBox>;

		/**
		 * 白线
		 */
		private var whiteLine:Shape;

		public function PurviewComponent()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/child/PurviewRender.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void
		{
			this.positionInput=this.getUIbyID("positionInput") as TextInput;
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.resetBtn=this.getUIbyID("resetBtn") as NormalButton;

			this.positionInput.addEventListener(FocusEvent.FOCUS_OUT, onTextInputChange);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.resetBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.memberArr=new Vector.<CheckBox>;
			this.memberOtherArr=new Vector.<CheckBox>;

			this.memberContiner=new ScrollPane(this.width, this.height - 100);
			this.addChild(this.memberContiner);

			//白线
			this.whiteLine=new Shape;
			this.whiteLine.graphics.lineStyle(0, 0xffffff);
			this.whiteLine.graphics.lineTo(this.width, 0);

			this.memberContiner.addToPane(this.whiteLine);

			this.whiteLine.visible=false;

			this.positionInput.text="";
		}

		private function onTextInputChange(evt:FocusEvent):void
		{

		}

		public function updateData(type:String):void
		{
			selectItemType=type;

			var arr:Array;
			var cb:CheckBox;
			var cbArr:Array=[];
			for each (cb in this.memberArr)
			{
				this.memberContiner.delFromPane(cb);
			}

			for each (cb in this.memberOtherArr)
			{
				this.memberContiner.delFromPane(cb);
			}

			this.whiteLine.visible=true;

			this.memberArr.length=0;
			this.memberOtherArr.length=0;

			if (type == "defined")
			{
				arr=["", UIManager.getInstance().guildWnd.memberArr];
				this.positionInput.text="";
			}
			else
			{
				arr=GuildUtils.getMemberByType(UIManager.getInstance().guildWnd.memberArr, type);
				this.positionInput.text="" + String(GuildUtils.MemeberType[type][1]).replace(/\**/g, "");
			}

			for (var i:int=0; i < arr.length; i++)
			{
				for each (cbArr in arr[i])
				{
					for (var j:int=2; j < cbArr.length; j++)
					{
						cb=new CheckBox();
						cb.text=cbArr[j] + "";

						this.memberContiner.addToPane(cb);

						if (i == 0)
						{
							cb.x=20 + this.memberArr.length % 4 * (cb.width + 10);
							cb.y=20 + Math.floor(this.memberArr.length / 4) * (cb.height + 10);
							cb.turnOn(true);

							this.whiteLine.y=cb.y + 30;
							this.memberArr.push(cb);
						}
						else
						{
							cb.x=20 + this.memberOtherArr.length % 4 * (cb.width + 10);
							cb.y=this.whiteLine.y + Math.floor(this.memberOtherArr.length / 4) * (cb.height + 10);

							this.memberOtherArr.push(cb);
						}
					}
				}
			}
		}


		private function onBtnClick(evt:MouseEvent):void
		{
			switch (evt.target.name)
			{
				case "confirmBtn": //确认按钮
					confirmFunc();
					break;
				case "resetBtn": //重置按钮
					updateData(selectItemType);
					break;
			}
		}

		/**
		 * 确认功能
		 *
		 */
		private function confirmFunc():void
		{
			var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
			if (arr == null || arr[0]!="1")
				return;

			if (this.positionInput.text == "")
			{
				return;
			}

			arr=UIManager.getInstance().guildWnd.memberArr;

			var arrArr:Array=[];
			arrArr.push((selectItemType == "defined" ? (GuildUtils.getTopRankToMemberType() + 1) : selectItemType));
			arrArr.push(this.positionInput.text);

			var cb:CheckBox;
			for each (cb in this.memberArr)
			{
				if (cb.isOn)
				{
					arrArr.push(cb.text);
				}
				else
				{
					arr=GuildUtils.changeMemberToCommon(arr, cb.text);
				}
			}

			for each (cb in this.memberOtherArr)
			{
				if (cb.isOn)
				{
					//删除会员
					GuildUtils.delMemberByName(arr, cb.text);
					arrArr.push(cb.text);
				}
			}

			if (arrArr.length == 2)
			{
				trace("没有选择会员!!!")
				return;
			}

			if (selectItemType == "1" && arrArr.length > 4)
			{
				trace("只能有两个老大")
				return
			}

			GuildUtils.removeAllByType(arr, selectItemType);

			arr.push(arrArr);
			arr.sortOn("0", Array.CASEINSENSITIVE);

			//转字符串
			var rank:String=GuildUtils.getMemberArrToServerString(arr);

			Cmd_Guild.cm_guildUpdateRankinfo(rank);
		}



	}
}
