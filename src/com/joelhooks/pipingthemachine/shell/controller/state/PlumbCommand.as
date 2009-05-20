/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.shell.controller.state
{
	import com.joelhooks.pipingthemachine.common.view.components.ManagedJunction;
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModule;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	import com.joelhooks.pipingthemachine.shell.view.LoggerModuleMediator;
	import com.joelhooks.pipingthemachine.shell.view.ShellJunctionMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	import org.puremvc.as3.multicore.utilities.statemachine.StateMachine;

	public class PlumbCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			trace("Plumbing Underway");
			
			// --------------------------------------------
			// Prepare Shell
			// --------------------------------------------
			
			// Create a Junction for the Shell
			var shellJunction:ManagedJunction = new ManagedJunction();
			
			// Register the ShellJunctionMediator with this Junction
			var shellJunctionMediator:ShellJunctionMediator = new ShellJunctionMediator( shellJunction );
			facade.registerMediator( shellJunctionMediator );
			
			// Create the STDOUT splitting tee for communicating from the Shell to all modules 
			var shellOutTee:TeeSplit= new TeeSplit();
			shellJunction.registerPipe( PipeAwareModule.STDOUT,  Junction.OUTPUT, shellOutTee );
			
			// The STDIN merging tee for communicating to the Shell from all modules 
			var shellInTee:TeeMerge = new TeeMerge();
			shellJunction.registerPipe( PipeAwareModule.STDIN,  Junction.INPUT, shellInTee );
			shellJunction.addPipeListener( PipeAwareModule.STDIN, this, shellJunctionMediator.handlePipeMessage );

			// --------------------------------------------
			// Connect Shell < - > Logger Module
			// --------------------------------------------

			//Register a LoggerModuleMediator
			var loggerModule:LoggerModule = new LoggerModule();
			facade.registerMediator( new LoggerModuleMediator(loggerModule) );
			
			// Shell-to-LoggerModule Dedicted OUTPUT
			var shellToLoggerPipe:IPipeFitting = new Pipe();
			shellJunction.registerPipe( LoggerModule.NAME, Junction.OUTPUT, shellToLoggerPipe );
			
			// Tee Shell-to-LoggerModule Dedicated OUTPUT [and] Shell STDOUT [into] Logger STDIN
			var loggerInTee:TeeMerge = new TeeMerge();
			loggerInTee.connectInput( shellToLoggerPipe );
			loggerInTee.connectInput( shellOutTee );
			loggerModule.acceptInputPipe( PipeAwareModule.STDIN, loggerInTee );
			
			// Connect LoggerModule STDOUT to Shell STDIN
			var loggerToShellPipe:Pipe = new Pipe();
			shellInTee.connectInput( loggerToShellPipe );
			loggerModule.acceptOutputPipe( PipeAwareModule.STDOUT, loggerToShellPipe );			

			// ----------------------------
			// Plumbed!
			// ----------------------------
			sendNotification( StateMachine.ACTION, null, ShellFacade.PLUMBED );
		}
	}
}