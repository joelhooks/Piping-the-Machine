package com.joelhooks.pipingthemachine.modules.logger.view
{
	import com.joelhooks.pipingthemachine.common.model.message.LogMessage;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModuleFacade;
	import com.joelhooks.pipingthemachine.modules.logger.view.components.LoggerWindow;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class LoggerWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LoggerWindowMediator";
		
		public function LoggerWindowMediator(viewComponent:LoggerWindow)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [LoggerModuleFacade.ADD_LOG_MESSAGE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LoggerModuleFacade.ADD_LOG_MESSAGE:
					var logMessage:LogMessage= notification.getBody() as LogMessage;
					this.updateLogText(logMessage.message);
					break;
			}
		}
		
		private function updateLogText(message:String):void
		{
			view.textArea.htmlText += "[" + new Date().toTimeString().substr(0,8) + " ] <b>" + message + "</b>\n";
			view.textArea.validateNow();
			view.textArea.verticalScrollPosition = view.textArea.maxVerticalScrollPosition;			
		}
		
		public function get view():LoggerWindow
		{
			return this.viewComponent as LoggerWindow;
		}
		
	}
}