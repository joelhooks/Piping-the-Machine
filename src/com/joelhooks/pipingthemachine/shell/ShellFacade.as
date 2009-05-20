/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.shell
{
	import com.joelhooks.pipingthemachine.shell.controller.AddNewDoodadCommand;
	import com.joelhooks.pipingthemachine.shell.controller.StartupCommand;
	import com.joelhooks.pipingthemachine.shell.controller.state.AssembleCommand;
	import com.joelhooks.pipingthemachine.shell.controller.state.FailCommand;
	import com.joelhooks.pipingthemachine.shell.controller.state.PlumbCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class ShellFacade extends Facade
	{
		//---------------------------------------------------------------------------
	    // State Machine related constants ( In order of runtime sequence /FSM )
		//---------------------------------------------------------------------------
		public static const STARTING:String   	  		  = "state/starting/puremvc";
        public static const STARTUP:String  		  	  = "note/startup";
		public static const STARTED:String   	  		  = "acion/completed/startup";
		public static const STARTUP_FAILED:String  		  = "action/startup/failed";

		public static const PLUMBING:String  		  	  = "state/plumbing";
		public static const PLUMB:String  				  = "note/plumb";
		public static const PLUMBED:String  		  	  = "action/plumbing";
		public static const PLUMB_FAILED:String  		  = "action/plumbing/failed";

		public static const ASSEMBLING:String  	  	  	  = "state/assembling";
		public static const ASSEMBLE:String  			  = "note/assemble";
		public static const ASSEMBLED:String  		  	  = "action/assembled";
		public static const ASSEMBLY_FAILED:String  	  = "action/assembly/failed";

		public static const NAVIGATING:String  	  		  = "state/navigating";
		public static const NAVIGATE:String  			  = "note/navigate";
		
		public static const FAILING:String  	  		  = "state/failing";
		public static const FAIL:String  	  		  	  = "note/fail";
		
		//---------------------------------------------------------------------------
	    // Shell notification constants
		//---------------------------------------------------------------------------
		
		public static const GET_LOGGER_WINDOW:String			= "note/get/logger/window";
		public static const ADD_LOGGER_WINDOW:String			= "note/add/logger/window";
		public static const SEND_MESSAGE_TO_LOGGER:String		= "note/send/message/to/logger";
		public static const CONNECT_MODULE_TO_LOGGER:String		= "note/connect/module/to/logger";
		
		public static const ADD_NEW_DOODAD:String				= "note/add/new/doodad";
		public static const GET_DOODAD_UI:String				= "note/get/doodad/ui";
		public static const ADD_DOODAD_UI:String				= "note/add/doodad/ui";
		public static const REMOVE_DOODAD:String				= "note/remove/doodad";
				
		public function ShellFacade(key:String)
		{
			super(key);
		}
		
        /**
         * ShellFacade Factory Method
         */
        public static function getInstance( key:String ) : ShellFacade 
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new ShellFacade( key );
            return instanceMap[ key ] as ShellFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();            
            registerCommand( STARTUP, 	StartupCommand );
            
            //Register the state commands. The StateMachince is configured to 
            //use these commands for the process of changing states.
            registerCommand( PLUMB, 	PlumbCommand );
            registerCommand( ASSEMBLE,  AssembleCommand );
            registerCommand( FAIL, 		FailCommand );
            
            //module commands
            registerCommand(ADD_NEW_DOODAD, AddNewDoodadCommand);
            
        }
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup( app:PipingTheMachine):void
        {
            sendNotification( STARTUP, app );
        }
	}
}