/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
 package com.joelhooks.pipingthemachine.shell.controller.state
{
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.statemachine.StateMachine;

	public class FailCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			trace("Failing");
			sendNotification( StateMachine.ACTION, null, ShellFacade.FAIL );
		}
	}
}