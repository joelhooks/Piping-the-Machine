package com.joelhooks.pipingthemachine.modules.logger.controller
{
	import com.joelhooks.pipingthemachine.modules.logger.view.LoggerWindowJunctionMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class LoggerModuleStartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			trace("Logger Startup");
			facade.registerMediator( new LoggerWindowJunctionMediator() );
		}
	}
}