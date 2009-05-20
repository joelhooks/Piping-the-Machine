package com.joelhooks.pipingthemachine.modules.doodad.view
{
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModuleFacade;
	import com.joelhooks.pipingthemachine.modules.doodad.view.components.Doodad;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class DoodadMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DoodadMediator";
		
		public function DoodadMediator(viewComponent:Doodad)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			view.addEventListener(Doodad.REMOVE_DOODAD, handleRemove);
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function handleNotification(notification:INotification):void
		{
		}
		
		public function get view():Doodad
		{
			return this.viewComponent as Doodad;
		}
		
		private function handleRemove(event:Event):void
		{
			view.removeEventListener(Doodad.REMOVE_DOODAD, handleRemove);
			sendNotification(DoodadModuleFacade.DESTROY_MODULE, this.view);
			facade.removeMediator(this.getMediatorName());
			view.parent.removeChild(view);
			this.viewComponent = null;
			
		}
		
	}
}