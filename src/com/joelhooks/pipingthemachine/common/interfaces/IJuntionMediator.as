package com.joelhooks.pipingthemachine.common.interfaces
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	/**
	 * Interface for a JunctionMediator created mainly for the convenience of autogenerating
	 * common methods found on a class that extends JunctionMediator.
	 *  
	 * @author joel
	 */	
	public interface IJuntionMediator
	{
		function listNotificationInterests():Array;
		function handleNotification( note:INotification ):void;
		function handlePipeMessage( message:IPipeMessage ):void
	}
}