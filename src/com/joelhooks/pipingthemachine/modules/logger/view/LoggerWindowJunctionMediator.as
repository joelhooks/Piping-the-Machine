package com.joelhooks.pipingthemachine.modules.logger.view
{
	import com.joelhooks.pipingthemachine.common.interfaces.IJuntionMediator;
	import com.joelhooks.pipingthemachine.common.model.message.LogMessage;
	import com.joelhooks.pipingthemachine.common.model.message.UIQueryMessage;
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModule;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModuleFacade;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;

	public class LoggerWindowJunctionMediator extends JunctionMediator implements IJuntionMediator
	{
		public static const NAME:String = "LoggerWindowJunctionMediator";
		
		public function LoggerWindowJunctionMediator()
		{
			super(NAME, new Junction());
			
		}
		
		override public function onRegister():void
		{
			this.junction.addPipeListener( PipeAwareModule.STDIN, this, this.handlePipeMessage);
		}
		
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(LoggerModuleFacade.EXPORT_LOG_WINDOW);
			return interests;
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case LoggerModuleFacade.EXPORT_LOG_WINDOW:
					var logWindowMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.SET, LoggerModule.LOG_WINDOW_UI, UIComponent(note.getBody()) );
					junction.sendMessage( PipeAwareModule.STDOUT, logWindowMessage );
					break;	
				// Let the JunctionMediator superclass handle the rest 
				// (i.e. ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE )								
				default:
					super.handleNotification( note );			
			}

		}
		
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			if ( message is LogMessage ) 
			{
				sendNotification( LoggerModuleFacade.ADD_LOG_MESSAGE, message );
			} 
			else if ( message is UIQueryMessage )
			{
				switch ( UIQueryMessage(message).name )
				{
					case LoggerModule.LOG_WINDOW_UI:
						sendNotification(LoggerModuleFacade.CREATE_LOG_WINDOW )
						break;
				}
			}
		}
		
	}
}