package com.joelhooks.pipingthemachine.shell.view
{
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModule;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;

	public class LoggerModuleMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LoggerModuleMediator";
		
		public function LoggerModuleMediator(module:LoggerModule)
		{
			super(NAME, module);
		}
		
		/**
		 * LoggerModule related Notification list.
		 */
		override public function listNotificationInterests():Array
		{
			return [ ShellFacade.CONNECT_MODULE_TO_LOGGER];	
		}
		
		/**
		 * Handle LoggerModule related Notifications.
		 * <P>
		 * Connecting modules and the Shell to the LoggerModule.
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				// Connect any Module's STDLOG to the logger's STDIN
				case  ShellFacade.CONNECT_MODULE_TO_LOGGER:
					var module:IPipeAware = note.getBody() as IPipeAware;
					var pipe:Pipe = new Pipe();
					module.acceptOutputPipe(PipeAwareModule.STDLOG,pipe);
					logger.acceptInputPipe(PipeAwareModule.STDIN,pipe);
					break;

			}
		}
		
		public function get logger():LoggerModule
		{
			return this.viewComponent as LoggerModule;
		}
		
	}
}