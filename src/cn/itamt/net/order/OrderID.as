package cn.itamt.net.order 
{
	/**
	 * 指令ID常量
	 * 详细文档见:svn://63.251.251.89/flash/doc/《我是大魔王》.Net服务端协议.doc
	 * @author tamt
	 */
	public class OrderID 
	{
		//S要求客户端登录
		public static const S_REQUEST_LOGIN:uint = 0x01;
		//C登录指令
		public static const C_LOGIN:uint = 0x02;
		//S登录结果
		public static const S_LOGIN:uint = 0x03;
		//C心跳指令(检测用户是否在线)
		public static const C_HEART:uint = 0x1E;
		//S心跳指令结果
		public static const C_HEART:uint = 0x1E;
		//C发送聊天
		public static const C_CHAT:uint = 0x3A;
		//S发送聊天
		public static const S_CHAT:uint = 0x3B;
		//C发送游戏信息
		public static const C_GAME_DATA:uint = 0x2A;
		//S转发游戏信息
		public static const S_GAME_DATA:uint = 0x2B;
		
		public function OrderID() 
		{
			
		}
		
	}

}