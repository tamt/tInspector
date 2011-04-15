package cn.itamt.net.order 
{
	import cn.itamt.net.order.model.OrderDataMap;
	import cn.itamt.net.order.model.client.ChatData;
	import cn.itamt.net.order.model.client.HeartData;
	import cn.itamt.net.order.model.client.LoginData;
	import cn.itamt.net.order.model.client.TransferData;
	import cn.itamt.net.order.model.server.LoginResultData;
	import cn.itamt.net.order.model.server.ServerChatData;
	import cn.itamt.net.order.model.server.ServerChatResultData;
	import cn.itamt.net.order.model.server.ServerHeartData;
	import cn.itamt.net.order.model.server.ServerPlayerLeaveData;
	import cn.itamt.net.order.model.server.ServerTransferData;
	import cn.itamt.net.order.model.server.ServerTransferResultData;
	/**
	 * 指令ID常量
	 * @author tamt
	 */
	public class OrderID 
	{
		//S要求客户端登录
		public static const S_REQUEST_LOGIN:uint = 0x01;
		//C登录指令
		public static const C_LOGIN:uint = 0x02;
		//S登录结果
		public static const S_LOGIN_RESULT:uint = 0x03;
		//C心跳指令(检测用户是否在线)
		public static const C_HEART:uint = 0x1E;
		//S心跳指令结果
		public static const S_HEART:uint = 0x1E;
		//C发送聊天
		public static const C_CHAT:uint = 0x3A;
		//S返回聊天信息是否发送成功
		public static const S_CHAT_RESULT:uint = 0x3A;
		//S发送聊天
		public static const S_CHAT:uint = 0x3B;
		//C发送游戏信息
		public static const C_GAME_DATA:uint = 0x2A;
		public static const S_GAME_DATA_RESULT:uint = 0x2A;
		//S转发游戏信息
		public static const S_GAME_DATA:uint = 0x2B;
		//S发送玩家掉线
		public static const S_PLAYER_LEAVE:uint = 0x04;
	}

	OrderDataMap.mapEncoder(OrderID.C_LOGIN, LoginData);
	OrderDataMap.mapEncoder(OrderID.C_CHAT, ChatData);
	OrderDataMap.mapEncoder(OrderID.C_GAME_DATA, TransferData);
	OrderDataMap.mapEncoder(OrderID.C_HEART, HeartData);
	
	OrderDataMap.mapDecoder(OrderID.S_LOGIN_RESULT, LoginResultData);	
	OrderDataMap.mapDecoder(OrderID.S_CHAT, ServerChatData);	
	OrderDataMap.mapDecoder(OrderID.S_CHAT_RESULT, ServerChatResultData);	
	OrderDataMap.mapDecoder(OrderID.S_GAME_DATA, ServerTransferData);
	OrderDataMap.mapDecoder(OrderID.S_GAME_DATA_RESULT, ServerTransferResultData);
	OrderDataMap.mapDecoder(OrderID.S_HEART, ServerHeartData);
	OrderDataMap.mapDecoder(OrderID.S_PLAYER_LEAVE, ServerPlayerLeaveData);
	
}
