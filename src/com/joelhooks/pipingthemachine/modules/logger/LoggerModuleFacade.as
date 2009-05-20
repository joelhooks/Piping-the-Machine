package com.joelhooks.pipingthemachine.modules.logger
{
	import com.joelhooks.pipingthemachine.modules.logger.controller.CreateLogWindowCommand;
	import com.joelhooks.pipingthemachine.modules.logger.controller.LoggerModuleStartupCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class LoggerModuleFacade extends Facade
	{
		public static const STARTUP:String = LoggerModule.NAME + "/note/startup";
		public static const ADD_LOG_MESSAGE:String = LoggerModule.NAME + "/note/add/log/message";
		
		public static const EXPORT_LOG_WINDOW:String = LoggerModule.NAME + "/note/export/log/window";
		public static const CREATE_LOG_WINDOW:String = LoggerModule.NAME + "/note/create/log/window";
		
		public function LoggerModuleFacade(key:String)
		{
			super(key);
		}
		
        /**
         * LoggerModuleFacade Factory Method
         */
        public static function getInstance( key:String ) : LoggerModuleFacade
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new LoggerModuleFacade( key );
            return instanceMap[ key ] as LoggerModuleFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();            
            registerCommand( STARTUP, LoggerModuleStartupCommand );
            registerCommand( CREATE_LOG_WINDOW, CreateLogWindowCommand); 
        }
        
        /**
         * Module startup
         * 
         * @param app a reference to the module
         */  
        public function startup( module:LoggerModule ):void
        {
            sendNotification( STARTUP, module );
        }
		
	}
}