package com.leyou.ui.guild.child
{
	import com.ace.ICommon.IMenu;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.window.children.ConfirmInputWindow;
	import com.leyou.manager.MenuManager;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Guild;
	import com.leyou.ui.chat.child.MenuButton;
	import com.leyou.ui.guild.child.children.MemberRender;
	import com.leyou.utils.GuildUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	public class GuildMemberPanel extends AutoSprite implements IMenu
	{
		private var btnArr:Vector.<NormalButton>;
		private var gridList:ScrollPane;
		private var offLineCheckBox:CheckBox;
		private var renderArr:Array;

		private var selectRenderId:int=-1;
		private var overRenderId:int=-1;

		public function GuildMemberPanel()
		{
			super(LibManager.getInstance().getXML("config/ui/guild/GuildMemberPage.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void
		{
			this.btnArr=new Vector.<NormalButton>;
			//this.btnArr.push(this.getUIbyID("nameBtn") as NormalButton);
			//this.btnArr.push(this.getUIbyID("lvBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("raceBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("positionBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("contributionBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("noteBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("addMembBtn") as NormalButton);
			this.btnArr.push(this.getUIbyID("quitBtn") as NormalButton);
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.offLineCheckBox=this.getUIbyID("offLineCheckBox") as CheckBox;

			for (var i:int=0; i < this.btnArr.length; i++)
			{
				this.btnArr[i].addEventListener(MouseEvent.CLICK, onBtnClick);
			}

			(this.getUIbyID("nameBtn") as NormalButton).addEventListener(MouseEvent.CLICK, onSortNameClick);
			//(this.getUIbyID("lvBtn") as NormalButton).addEventListener(MouseEvent.CLICK, onSorLvtClick);

			this.gridList.addEventListener(MouseEvent.CLICK, onGridListClick);
			this.gridList.addEventListener(MouseEvent.MOUSE_OVER, onGridListOver);
			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onGridListOut);
			this.offLineCheckBox.addEventListener(MouseEvent.CLICK, onOffLineClick);

			this.renderArr=[];
 
		}
 

		public function updateList():void
		{

			while (this.renderArr.length)
			{
				this.gridList.delFromPane(this.renderArr[0]);
				this.renderArr.splice(0, 1);
			}

			var vec:Array=UIManager.getInstance().guildWnd.memberArr;
			var render:MemberRender;

			var arr:Array;
			for each (arr in vec)
			{
				for (var j:int=2; j < arr.length; j++)
				{
					render=new MemberRender();
					render.id=this.renderArr.length;
					render.y=this.renderArr.length * 23;
					render.x=2.5;

					this.gridList.addToPane(render);
					this.renderArr.push(render);

					render.update(arr[j], arr[1]);
				}
			}

		}

		/**
		 * 排序
		 *
		 */
		private function sortMemeber(sortType:String, sortOptions:int=2):void
		{
			this.renderArr.sortOn(sortType, sortOptions);

			var render:MemberRender;
			for (var i:int=0; i < this.renderArr.length; i++)
			{
				render=this.renderArr[i];
				render.id=i;
				render.y=i * 23;
				render.x=2.5;
			}
		}

		/**
		 * 名字排序
		 * @param e
		 *
		 */
		private function onSortNameClick(e:MouseEvent):void
		{
			if (String(e.target.name).split("_")[1] == 1)
			{
				sortMemeber("memberName", Array.CASEINSENSITIVE)
				e.target.name="n_0";
			}
			else
			{
				sortMemeber("memberName", Array.DESCENDING);
				e.target.name="n_1";
			}
		}

		/**
		 * 等级排序
		 * @param e
		 *
		 */
		private function onSorLvtClick(e:MouseEvent):void
		{
			if (String(e.target.name).split("_")[1] == 1)
			{
				sortMemeber("memberLv", Array.CASEINSENSITIVE)
				e.target.name="l_0";
			}
			else
			{
				sortMemeber("memberLv", Array.DESCENDING)
				e.target.name="l_1";
			}
		}

		private function onBtnClick(evt:MouseEvent):void
		{
			switch (evt.target.name)
			{
				case "nameBtn": //名字

					break;
				case "lvBtn": //等级
					break;
				case "raceBtn": //职业
					break;
				case "positionBtn": //职务
					break;
				case "contributionBtn": //贡献
					break;
				case "noteBtn": //备注
					break;
				case "addMembBtn": //添加成员
					addMemberFunc();
					break;
				case "quitBtn": //退出行会
					var mName:String=MyInfoManager.getInstance().name;
					if (mName == UIManager.getInstance().guildWnd.memberArr[0][2])
						Cmd_Guild.cm_guildDelMember(mName);
					else
						Cmd_Chat.cm_say("@退出行会 " + UIManager.getInstance().guildWnd.guildContent[0]);
					break;
			}
		}

		/**
		 * 添加好友
		 *
		 */
		private function addMemberFunc():void
		{
			var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);
			if (arr == null || arr[0] != "1")
				return;
			
			ConfirmInputWindow.showWin("请输入好友名字:", inputOk);

			function inputOk(s:String):void
			{
				if (s != null && s != "")
				{
					Cmd_Guild.cm_guildAddMember(s);
				}
			}
		}
 

		/**
		 * ["提升职务", "降低职务", "开除公会 "];
		 * 单击右键菜单项
		 * @param e
		 *
		 */
		public function onMenuClick(index:int):void
		{

			switch (index)
			{
				case 1: //提升职务
					changeMemeberFunc();
					break;
				case 2: //降低职务
					changeMemeberFunc(1);
					break;
				case 3: //开除公会 
					Cmd_Guild.cm_guildDelMember(this.renderArr[this.selectRenderId].memberName);
					break;
			}
		}

		public function changeMemeberFunc(i:int=0):void
		{
			var mN:String=this.renderArr[this.selectRenderId].memberName;

			var arr:Array=UIManager.getInstance().guildWnd.memberArr;
			//获取上下线
			var topLow:Array=GuildUtils.getMemberTopAndLowerByName(arr, mN);

			arr=GuildUtils.changeMemberToCommon(arr, mN, topLow[i]);

			arr.sortOn("0", Array.CASEINSENSITIVE);
			var rank:String=GuildUtils.getMemberArrToServerString(arr);

			Cmd_Guild.cm_guildUpdateRankinfo(rank);
		}

		/**
		 * 单击格子
		 * @param evt
		 *
		 */
		private function onGridListClick(evt:MouseEvent):void
		{
			var arr:Array=GuildUtils.getMemberByName(UIManager.getInstance().guildWnd.memberArr, MyInfoManager.getInstance().name);

			if (arr[0] == "1")
			{
				var menuarr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
				menuarr.push(new MenuInfo("提升职务",1));
				menuarr.push(new MenuInfo("降低职务",2));
				menuarr.push(new MenuInfo("开除公会",3));
				
				MenuManager.getInstance().show(menuarr,this,new Point(evt.stageX,evt.stageY));
			}

			if (evt.target is MemberRender)
			{
				var id:int=(evt.target as MemberRender).id;
				if (id == this.selectRenderId)
					return;

				if (this.selectRenderId != -1)
					this.renderArr[this.getIdxById(this.selectRenderId)].selectSta=false;

				this.selectRenderId=id;
				this.renderArr[this.getIdxById(this.selectRenderId)].selectSta=true;
			}
		}

		private function onGridListOver(evt:MouseEvent):void
		{
			if (evt.target is MemberRender)
			{
				var id:int=(evt.target as MemberRender).id;
				if (id == this.selectRenderId || id == this.overRenderId)
					return;
				if (this.overRenderId != -1 && this.selectRenderId != this.overRenderId)
					this.renderArr[this.getIdxById(this.overRenderId)].selectSta=false;
				this.overRenderId=id;
				this.renderArr[this.getIdxById(this.overRenderId)].selectSta=true;
			}
		}

		private function onGridListOut(evt:MouseEvent):void
		{
			if (this.overRenderId != -1 && this.selectRenderId != this.overRenderId)
				this.renderArr[this.getIdxById(this.overRenderId)].selectSta=false;
			this.overRenderId=-1;
		}

		private function onOffLineClick(evt:Event):void
		{
			if (this.offLineCheckBox.isOn)
			{

			}
			else
			{

			}
		}

		private function getIdxById(id:int):int
		{
			var idx:int;
			for (var i:int=0; i < this.renderArr.length; i++)
			{
				if (this.renderArr[i].id == id)
				{
					idx=i;
					break;
				}
			}
			return idx;
		}
	}
}
