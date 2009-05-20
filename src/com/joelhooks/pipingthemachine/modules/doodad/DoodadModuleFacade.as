package com.joelhooks.pipingthemachine.modules.doodad
{
	import com.joelhooks.pipingthemachine.modules.doodad.controller.CreateDoodadCommand;
	import com.joelhooks.pipingthemachine.modules.doodad.controller.DoodadModuleStartupCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class DoodadModuleFacade extends Facade
	{
		public static const STARTUP:String  	 			= DoodadModule.NAME + "/note/startup";
		public static const SEND_MESSAGE_TO_LOGGER:String	= DoodadModule.NAME + "/note/send/message/to/logger";
		
		public static const CREATE_DOODAD:String			= DoodadModule.NAME + "/note/create/doodad";
		public static const EXPORT_DOODAD:String			= DoodadModule.NAME + "/note/export/doodad";
		
		public static const DESTROY_MODULE:String			= DoodadModule.NAME + "/note/destroy/module";
		
		public function DoodadModuleFacade(key:String)
		{
			super(key);
		}
		
        /**
         * DoodadModuleFacade Factory Method
         */
        public static function getInstance( key:String ) : DoodadModuleFacade
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new DoodadModuleFacade( key );
            return instanceMap[ key ] as DoodadModuleFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();            
            registerCommand( STARTUP, DoodadModuleStartupCommand );
            registerCommand( CREATE_DOODAD, CreateDoodadCommand );
        }
        
        /**
         * Module startup
         * 
         * @param app a reference to the module
         */  
        public function startup( module:DoodadModule ):void
        {
            sendNotification( STARTUP, module );
        }	
        
	}
}