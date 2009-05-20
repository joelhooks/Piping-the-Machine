package com.joelhooks.pipingthemachine.modules.doodad.controller
{
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModuleFacade;
	import com.joelhooks.pipingthemachine.modules.doodad.view.DoodadMediator;
	import com.joelhooks.pipingthemachine.modules.doodad.view.components.Doodad;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CreateDoodadCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var doodad:Doodad = new Doodad();
			var doodadMediator:DoodadMediator = new DoodadMediator(doodad);
			var doodadModule:DoodadModule = notification.getBody() as DoodadModule;
			doodad.labelText = "Doodad" + doodadModule.getSequenceNumber();
			doodad.doodadModuleId = doodadModule.GUID
			facade.registerMediator(doodadMediator);
			sendNotification( DoodadModuleFacade.EXPORT_DOODAD, doodad);
		}
	}
}