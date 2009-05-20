/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.shell.view
{
	import com.ericfeminella.collections.HashMap;
	import com.joelhooks.pipingthemachine.common.interfaces.IJuntionMediator;
	import com.joelhooks.pipingthemachine.common.model.message.LogMessage;
	import com.joelhooks.pipingthemachine.common.model.message.UIQueryMessage;
	import com.joelhooks.pipingthemachine.common.view.ManagedJunctionMediator;
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.modules.doodad.view.components.Doodad;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModule;
	import com.joelhooks.pipingthemachine.modules.logger.view.components.LoggerWindow;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	public class ShellJunctionMediator extends ManagedJunctionMediator implements IJuntionMediator
	{
		public static const NAME:String = "ShellJunctionMediator";
		
		public function ShellJunctionMediator(junction:Junction)
		{
			super(NAME, junction);
		}
		
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ShellFacade.GET_LOGGER_WINDOW);
			interests.push(ShellFacade.SEND_MESSAGE_TO_LOGGER);
			interests.push(ShellFacade.GET_DOODAD_UI);
			interests.push(ShellFacade.REMOVE_DOODAD);
			return interests;
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{	
				case ShellFacade.REMOVE_DOODAD:
					var doodad:Doodad = note.getBody() as Doodad;
					//this.removeConnectionFromPool(doodad.doodadModuleId);
					break;
				case ShellFacade.SEND_MESSAGE_TO_LOGGER:
					var logMessage:LogMessage = new LogMessage(1, this.getMediatorName(), note.getBody() as String)
					junction.sendMessage( PipeAwareModule.STDOUT, logMessage);					
					break;			
				case ShellFacade.GET_LOGGER_WINDOW:
					var getLoggerWindowRequest:UIQueryMessage = 
						new UIQueryMessage( UIQueryMessage.GET, LoggerModule.LOG_WINDOW_UI )
					junction.sendMessage( LoggerModule.NAME, getLoggerWindowRequest);
					break;
				case ShellFacade.GET_DOODAD_UI:
					var getDoodadUIRequest:UIQueryMessage = 
						new UIQueryMessage( UIQueryMessage.GET, DoodadModule.DOODAD_UI );
					junction.sendMessage( note.getBody() as String, getDoodadUIRequest);
				// Let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)
				default:
					super.handleNotification(note);
			}
		}
		
		override public function handlePipeMessage(message:IPipeMessage):void
		{
			if(message is UIQueryMessage)
			{
				var uiQuery:UIQueryMessage = message as UIQueryMessage;
				switch(uiQuery.name)
				{
					case LoggerModule.LOG_WINDOW_UI:
						var loggerWindow:LoggerWindow = uiQuery.component as LoggerWindow;
						sendNotification(ShellFacade.ADD_LOGGER_WINDOW, loggerWindow);
						break;
					case  DoodadModule.DOODAD_UI:
						sendNotification(ShellFacade.ADD_DOODAD_UI, uiQuery.component);
						break;
					case DoodadModule.DESTROY_DOODAD:
						sendNotification(ShellFacade.REMOVE_DOODAD, uiQuery.component);
						break;
				}
			}
		}
		
	}
}