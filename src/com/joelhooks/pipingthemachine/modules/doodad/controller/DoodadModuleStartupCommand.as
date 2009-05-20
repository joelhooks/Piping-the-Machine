package com.joelhooks.pipingthemachine.modules.doodad.controller
{
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.modules.doodad.view.DoodadJunctionMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class DoodadModuleStartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			trace("DoodadModuleStartup");
			var module:DoodadModule = notification.getBody() as DoodadModule;
			facade.registerMediator( new DoodadJunctionMediator(module) );
		}
	}
}