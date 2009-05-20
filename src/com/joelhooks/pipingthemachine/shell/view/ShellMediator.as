package com.joelhooks.pipingthemachine.shell.view
{
	import com.joelhooks.pipingthemachine.modules.doodad.view.components.Doodad;
	import com.joelhooks.pipingthemachine.modules.logger.view.components.LoggerWindow;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class ShellMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ShellMediator";
		
		public function ShellMediator(viewComponent:PipingTheMachine)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			shell.doodadBtn.addEventListener( MouseEvent.CLICK, handleMakeDoodadClick, false, 0, true );
		}
		
		override public function listNotificationInterests():Array
		{
			return [ShellFacade.ADD_LOGGER_WINDOW,
					ShellFacade.ADD_DOODAD_UI];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ShellFacade.ADD_LOGGER_WINDOW:
					var loggerWindow:LoggerWindow = notification.getBody() as LoggerWindow;
					shell.loggerContainer.addChild(loggerWindow);
					sendNotification(ShellFacade.SEND_MESSAGE_TO_LOGGER, "Logger Added to Stage");
					break;
				case ShellFacade.ADD_DOODAD_UI:
					var doodad:Doodad = notification.getBody() as Doodad;
					shell.tileContainer.addChild(doodad);
					shell.tileContainer.validateNow();
					shell.tileContainer.verticalScrollPosition = shell.tileContainer.maxVerticalScrollPosition;
					sendNotification(ShellFacade.SEND_MESSAGE_TO_LOGGER, "Added a doodad " + doodad.labelText);
					break;
			}
		}
		
		public function get shell():PipingTheMachine
		{
			return this.viewComponent as PipingTheMachine;
		}
		
		private function handleMakeDoodadClick(event:Event):void
		{
			sendNotification( ShellFacade.ADD_NEW_DOODAD );
		}
	}
}