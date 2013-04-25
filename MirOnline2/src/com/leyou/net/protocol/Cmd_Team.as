package com.leyou.net.protocol {
	import com.ace.ui.window.children.AlertWindow;
	import com.leyou.manager.UIManager;
	import com.leyou.net.MirProtocol;
	import com.leyou.net.protocol.scene.CmdScene;

	public class Cmd_Team {
		//新建组队[第一次创建队伍发生2次，第2次带参数；如果有队伍，只发送一次即可，不需要参数]
		static public function cm_createGroup(name:String, isWithWho:Boolean=false):void {
			if (isWithWho) {
				CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_CREATEGROUP, 0, 0, 0, 0, name);
			} else {
				CmdScene.cm_sendDefaultMsg(MirProtocol.CM_CREATEGROUP, 0, 0, 0, 0);
			}

		}

		//新建组队-成功
		static public function sm_createGroup_ok(td:TDefaultMessage, body:String):void {
			//无返回值
			trace("新建组队-成功");
		}

		//新建组队-失败
		static public function sm_createGroup_fail(td:TDefaultMessage, body:String):void {
			switch (td.Recog) {
				case -1:
					//提示：编组还未成立。
					trace("编组还未成立。")
					break;
				case -2:
					//提示：输入的人物名称不正确。
					trace("输入的人物名称不正确")
					break;
				case -3:
					//提示：您想邀请加入编组的人已经加入了其它组。
					trace("您想邀请加入编组的人已经加入了其它组")
					break;
				case -4:
					//提示：对方不允许编组。
					trace("对方不允许编组。")
					break;
			}
		}

		//队员列表【'face141/2/1/face131/0/0/face71/0/0/'】
		static public function sm_groupMembers(td:TDefaultMessage, body:String):void {
			//trace("ddd");
			UIManager.getInstance().teamWnd.serv_AddTeam(body);
		}


		//组内添人
		static public function cm_addGroupMember(name:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_ADDGROUPMEMBER, 0, 0, 0, 0, name);
		}

		//组内添人-ok
		static public function sm_groupAddMem_ok(td:TDefaultMessage, body:String):void {
			//无返回值
			trace("组内添人-ok");
		}

		//组内添人-fail
		static public function sm_groupAddMem_fail(td:TDefaultMessage, body:String):void {
			
			trace("组内添人-fail",body,td.Recog);
			
			switch (td.Recog) {
				case -1:
					//提示：非队长不能操作。
					trace("非队长不能操作");
					break;
				case -2:
					//提示：输入的人物名称不正确。
					trace("输入的人物名称不正确");
					break;
				case -3:
					//提示：已经加入编组。
					trace("已经加入编组");
					break;
				case -4:
					//提示：对方不允许编组。
					trace("对方不允许编组。");
					break;
				case -5:
					//提示：您想邀请加入编组的人已经加入了其它组！
					trace("您想邀请加入编组的人已经加入了其它组");
					break;
			}
		}

		//组内删人
		static public function cm_delGroupMember(name:String):void {
			CmdScene.cm_sendDefaultMsgII(MirProtocol.CM_DELGROUPMEMBER, 0, 0, 0, 0, name);
		}

		//组内删人-ok
		static public function sm_groupDelMem_ok(td:TDefaultMessage, body:String):void {
			//无返回值
			trace("组内删人-ok");
			UIManager.getInstance().teamWnd.serv_RemoveTeam(body);
		}

		//组内删人-fail
		static public function sm_groupDelMem_fail(td:TDefaultMessage, body:String):void {
			switch (td.Recog) {
				case -1:
					//提示：编组还未成立.
					trace("编组还未成立");
					break;
				case -2:
					//提示：输入的人物名称不正确.
					trace("输入的人物名称不正确");
					break;
				case -3:
					//提示：此人不在本组中.
					trace("此人不在本组中");
					break;
			}
		}


		//退出队伍--关组还是开组[0为关，1为开]
		static public function cm_groupMode(value:int):void {
			CmdScene.cm_sendDefaultMsg(MirProtocol.CM_GROUPMODE, 0, value, 0, 0);
		}

		//退出队伍--如果有队伍，返回：队伍改变
		static public function sm_groupModeChanged(td:TDefaultMessage, body:String):void {
			if (td.Param > 0) {
				//允许组队
			} else {
				//不允许组队
				UIManager.getInstance().teamWnd.serv_RemoveAllTeam();
			}
		}

		//退出队伍--如果有队伍，返回：队伍取消
		static public function sm_groupCancel(td:TDefaultMessage, body:String):void {
			//无返回值-- 清除队伍列表
			//trace("无返回值-- 清除队伍列表",body);
			UIManager.getInstance().teamWnd.serv_RemoveAllTeam();
		}
	}
}