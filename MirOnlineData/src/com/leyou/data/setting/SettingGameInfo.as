package com.leyou.data.setting {

	public class SettingGameInfo {
		public var drug:int;//显示药品格
		public var npc:int;//显示NPC名称
		public var monster:int;//显示怪物名称
		public var snow:int;//启用飘血设置
		public var onlyDrug:int;//只能显示药品格
		public var simpleName:int;//显示简单人名
		public var complexName:int;//显示完整人名
		public var autoPickup:int;//自动拾取物品
		public var groupChat:int;//允许组队聊天
		public var natureHuman:int;//允许天人合一
		public var guildAnd:int;//允许行会合一
		public var coupleTransfer:int;//允许夫妻传送
		public var teacherPuilTransfer:int;//允许师徒传送
		public var trade:int;//允许交易
		public var gruop:int;//允许组队
		public var joinGuild:int;//允许加入行会
		public var privateChat:int;//允许私人聊天
		public var guildChat:int;//允许行会聊天
		public var shiftAttack:int;//免Shift攻击
		public var warehouseLock:int;//启用仓库锁
		public var loginLock:int;//启用登录锁
		public function SettingGameInfo() {
		}
	}
}