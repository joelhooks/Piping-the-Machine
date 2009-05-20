package com.joelhooks.pipingthemachine.common.view.components
{
	import com.ericfeminella.collections.HashMap;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	public class ManagedJunction extends Junction
	{
		private var connectionPool:HashMap = new HashMap();
		
		public function ManagedJunction()
		{
			super();
		}

		public function addConnectionToPool(input:IPipeFitting, output:IPipeFitting, connectionId:String):void
		{
			this.connectionPool.put(connectionId, {input:input,output:output});
		}
		
		public function removeConnectionFromPool(connectionId:String):void
		{
			if(this.hasPipe(connectionId))
				this.removePipe( connectionId );
				
			if(connectionPool.containsKey(connectionId))
			{
				var input:IPipeFitting = this.connectionPool.getValue(connectionId).input;
				var output:IPipeFitting = this.connectionPool.getValue(connectionId).output;
				if(output is TeeSplit)
					TeeSplit(output).disconnectFitting(input);
				input.disconnect();
				this.connectionPool.remove(connectionId);				
			}
		}			
	}
}