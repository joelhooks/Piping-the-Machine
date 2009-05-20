package com.joelhooks.pipingthemachine.shell.view
{
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class DoodadModuleMediator extends Mediator implements IMediator
	{
		public function DoodadModuleMediator(viewComponent:DoodadModule)
		{
			super(viewComponent.GUID, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			
			return [ShellFacade.REMOVE_DOODAD];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ShellFacade.REMOVE_DOODAD:
					if(notification.getBody().doodadModuleId == this.getMediatorName())
					{
						facade.removeMediator(this.getMediatorName());
						sendNotification(ShellFacade.SEND_MESSAGE_TO_LOGGER, "Removed DoodadModule #" + this.module.getSequenceNumber());
						this.setViewComponent( null );
					}
						
					break;
			}
		}
		
		public function get module():DoodadModule
		{
			return this.viewComponent as DoodadModule;
		}
		
	}
}