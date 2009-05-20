package com.joelhooks.pipingthemachine.modules.doodad.view
{
	import com.joelhooks.pipingthemachine.common.interfaces.IJuntionMediator;
	import com.joelhooks.pipingthemachine.common.model.message.UIQueryMessage;
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModuleFacade;
	import com.joelhooks.pipingthemachine.modules.doodad.view.components.Doodad;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;

	public class DoodadJunctionMediator extends JunctionMediator implements IJuntionMediator
	{
		public static const NAME:String = "DoodadJunctionMediator/";
		private var module:DoodadModule;
		
		public function DoodadJunctionMediator(module:DoodadModule)
		{
			this.module = module;
			super(this.getMediatorName(), new Junction());
		}
		
		override public function getMediatorName():String
		{
			return NAME + this.module.getSequenceNumber();
		}
		
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(DoodadModuleFacade.EXPORT_DOODAD);
			interests.push(DoodadModuleFacade.DESTROY_MODULE);
			return interests;
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case DoodadModuleFacade.EXPORT_DOODAD:
					var doodadMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.SET, DoodadModule.DOODAD_UI, UIComponent(note.getBody()) );
					junction.sendMessage( PipeAwareModule.STDOUT, doodadMessage );					
					break;
				case DoodadModuleFacade.DESTROY_MODULE:
					this.destroy(note.getBody() as Doodad);
					break;
				// Let the JunctionMediator superclass handle the rest 
				// (i.e. ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE )								
				default:
					super.handleNotification( note );				
			}
		}
		
		override public function handlePipeMessage(message:IPipeMessage):void
		{
			
			if ( message is UIQueryMessage )
			{
				switch ( UIQueryMessage(message).name )
				{
					
					case DoodadModule.DOODAD_UI:
						trace(this.getMediatorName());
						sendNotification( DoodadModuleFacade.CREATE_DOODAD, this.module )
						break;
				}
			}
		}
		
		private function destroy(doodad:Doodad):void
		{
			var doodadMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.DESTROY, DoodadModule.DESTROY_DOODAD, UIComponent(doodad) );
			junction.sendMessage( PipeAwareModule.STDOUT, doodadMessage );					
			this.removeConnections();
			facade.removeMediator(this.getMediatorName());
			facade.removeCore(this.multitonKey);
			this.module = null;
			this.setViewComponent( null );
		}
		
		private function removeConnections():void
		{
			var stdin:IPipeFitting = junction.retrievePipe(PipeAwareModule.STDIN);
			var stdout:IPipeFitting = junction.retrievePipe(PipeAwareModule.STDOUT);
			
			stdin.disconnect();
			stdout.disconnect();
			
			junction.removePipe(PipeAwareModule.STDIN);
			junction.removePipe(PipeAwareModule.STDOUT);			
		}
	}
}