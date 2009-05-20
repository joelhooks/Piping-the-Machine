package com.joelhooks.pipingthemachine.modules.logger.controller
{
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModuleFacade;
	import com.joelhooks.pipingthemachine.modules.logger.view.LoggerWindowMediator;
	import com.joelhooks.pipingthemachine.modules.logger.view.components.LoggerWindow;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CreateLogWindowCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var logWindow:LoggerWindow = new LoggerWindow();
			var logWindowMediator:LoggerWindowMediator = new LoggerWindowMediator(logWindow);
			facade.registerMediator(logWindowMediator);
			
			sendNotification(LoggerModuleFacade.EXPORT_LOG_WINDOW, logWindow);
		}
	}
}