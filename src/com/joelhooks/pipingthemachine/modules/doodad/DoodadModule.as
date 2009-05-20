package com.joelhooks.pipingthemachine.modules.doodad
{
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	
	import mx.utils.UIDUtil;

	public class DoodadModule extends PipeAwareModule
	{
		public static const NAME:String = "DoodadModule/";
		
		public static const DOODAD_UI:String = "GetDoodadUI";
		public static const DESTROY_DOODAD:String = "DestroyDoodad";
		
		public function DoodadModule()
		{
			this._GUID = UIDUtil.createUID();
			super(DoodadModuleFacade.getInstance( NAME+this._GUID ));
			DoodadModuleFacade(this.facade).startup(this);
		}
		
		/**
		 * Get the unique id of module instance.
		 */
		public function getID():String
		{
			return moduleID;
		}
		
		public function getSequenceNumber():int
		{
			return int(this.getID().split("/")[1]);
		}
		
		/**
		 * Get the next unique id.
		 * <P>
		 * This module can be instantiated multiple times, 
		 * so each instance needs to have it's own unique
		 * id for use as a multiton key.
		 */
		private static function getNextID():String
		{
			return NAME + serial++;
		}
			
		private static var serial:Number = 0;
		private var moduleID:String = DoodadModule.getNextID();		
	}
}