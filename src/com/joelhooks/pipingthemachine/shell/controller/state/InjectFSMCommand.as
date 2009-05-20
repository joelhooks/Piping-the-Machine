/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.shell.controller.state
{	
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.statemachine.FSMInjector;

	/**
	 * Create and inject the StateMachine.
	 */
	public class InjectFSMCommand extends SimpleCommand
	{
		/**
		 * Configure and inject the Finite State Machine.
		 */
		override public function execute ( note:INotification ) : void
		{
			// Create the FSM definition
			var fsm:XML = 
			<fsm initial={ShellFacade.STARTING}>
			
				<!-- STARTUP THE SHELL -->
				<state name={ShellFacade.STARTING}>

			       <transition action={ShellFacade.STARTED} 
			       			   target={ShellFacade.PLUMBING}/>

			       <transition action={ShellFacade.STARTUP_FAILED} 
			       			   target={ShellFacade.FAILING}/>
				</state>
				
				<!-- PLUMB THE CORES -->								
				<state name={ShellFacade.PLUMBING} changed={ShellFacade.PLUMB}>

			       <transition action={ShellFacade.PLUMBED} 
			       			   target={ShellFacade.ASSEMBLING}/>
			       
			       <transition action={ShellFacade.PLUMB_FAILED} 
			       			   target={ShellFacade.FAILING}/>

				</state>

				<!-- ASSEMBLE THE VIEW -->
				<state name={ShellFacade.ASSEMBLING} changed={ShellFacade.ASSEMBLE}>

			       <transition action={ShellFacade.ASSEMBLED} 
			       			   target={ShellFacade.NAVIGATING}/>
			       
			       <transition action={ShellFacade.ASSEMBLY_FAILED} 
			       			   target={ShellFacade.FAILING}/>

				</state>

				<!-- READY TO ACCEPT BROWSER OR USER NAVIGATION -->
				<state name={ShellFacade.NAVIGATING} changed={ShellFacade.NAVIGATE}/>
				
				<!-- REPORT FAILURE FROM ANY STATE -->
				<state name={ShellFacade.FAILING} changed={ShellFacade.FAIL}/>

			</fsm>;
			
			// Create and inject the StateMachine 
			var injector:FSMInjector = new FSMInjector( fsm );
			injector.initializeNotifier(this.multitonKey);
			injector.inject();
		}
	}
}
