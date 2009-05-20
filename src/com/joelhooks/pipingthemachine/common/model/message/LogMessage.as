package com.joelhooks.pipingthemachine.common.model.message
{
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;

	public class LogMessage extends Message
	{
		public static const DEBUG:int	= 5;
		public static const INFO:int	= 4;
		public static const WARN:int	= 3;
		public static const ERROR:int	= 2;
		public static const FATAL:int	= 1; 
		public static const NONE:int	= 0; 
		
		public static const CHANGE:int	= -1; 

		public static const LEVELS:Array = [ 'NONE', 'FATAL', 'ERROR', 'WARN', 'INFO', 'DEBUG' ];
		 
		public static const SEND_TO_LOG:String = Message.BASE+'LoggerModule/sendToLog';

		public static const STDLOG:String = 'standardLog';
		
		public function LogMessage( logLevel:int, sender:String, message:String  )
		{
			var time:String = new Date().toTimeString();
			var headers:Object = {logLevel:logLevel, sender:sender, time:time};
			super( Message.NORMAL, headers, message );
		}
		
		public function set logLevel(logLevel:int):void
		{
			header.logLevel = logLevel;
		}

		public function get logLevel():int
		{
			return header.logLevel as int;
		}
		
		public function get sender():String
		{
			return header.sender as String;
		}
		
		public function get time():String
		{
			return header.time as String;			
		}
		
		public function get message():String 
		{
			return body as String;			
		}
		
	}
}