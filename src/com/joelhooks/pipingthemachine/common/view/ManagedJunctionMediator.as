package com.joelhooks.pipingthemachine.common.view
{
	import com.ericfeminella.collections.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	/**
	 * Adds properties and methods for managing connections of a JunctionMediator
	 * mostly related to managing memory with dynamically loaded and unloaded
	 * modules.
	 *  
	 * @author joel
	 */
	public class ManagedJunctionMediator extends JunctionMediator
	{
		public function ManagedJunctionMediator(name:String, junction:Junction)
		{
			super(name, junction);
		}
		
		//a pool of connections to this junction
		protected var connectionPool:HashMap = new HashMap();
		
		public function addConnectionToPool(input:IPipeFitting, output:IPipeFitting, contextId:String):void
		{
			this.connectionPool.put(contextId, {input:input,output:output});
		}
		
		public function removeConnectionFromPool(contextId:String):void
		{
			if(junction.hasPipe(contextId))
				junction.removePipe( contextId );
				
			if(connectionPool.containsKey(contextId))
			{
				var input:IPipeFitting = this.connectionPool.getValue(contextId).input;
				var output:IPipeFitting = this.connectionPool.getValue(contextId).output;
				if(output is TeeSplit)
					TeeSplit(output).disconnectFitting(input);
				input.disconnect();
				this.connectionPool.remove(contextId);				
			}
		}	
		
		/**
		 * List Notification Interests.
		 * <P>
		 * Returns the notification interests for this base class.
		 * Override in subclass and call <code>super.listNotificationInterests</code>
		 * to get this list, then add any sublcass interests to 
		 * the array before returning.</P>
		 */
		override public function listNotificationInterests():Array
		{
			return [ JunctionMediator.ACCEPT_INPUT_PIPE, 
			         JunctionMediator.ACCEPT_OUTPUT_PIPE
			       ];	
		}
		
		/**
		 * Handle Notification.
		 * <P>
		 * This provides the handling for common junction activities. It 
		 * accepts input and output pipes in response to <code>IPipeAware</code>
		 * interface calls.</P>
		 * <P>
		 * Override in subclass, and call <code>super.handleNotification</code>
		 * if none of the subclass-specific notification names are matched.</P>
		 */
		override public function handleNotification( note:INotification):void
		{
			switch( note.getName() )
			{
				// accept an input pipe
				// register the pipe and if successful 
				// set this mediator as its listener
				case JunctionMediator.ACCEPT_INPUT_PIPE:
					var inputPipeName:String = note.getType();
					var inputPipe:IPipeFitting = note.getBody() as IPipeFitting;
					if ( junction.registerPipe(inputPipeName, Junction.INPUT, inputPipe) ) 
					{
						junction.addPipeListener( inputPipeName, this, handlePipeMessage );		
					} 
					break;
				
				// accept an output pipe
				case JunctionMediator.ACCEPT_OUTPUT_PIPE:
					var outputPipeName:String = note.getType();
					var outputPipe:IPipeFitting = note.getBody() as IPipeFitting;
					junction.registerPipe( outputPipeName, Junction.OUTPUT, outputPipe );
					break;
					
			}
		}	
	}
}