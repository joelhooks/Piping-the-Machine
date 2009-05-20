/*
 PureMVC AS3 MultiCore Pipes and Statemachine Integration – Piping the Machine
 Copyright (c) 2009 Joel Hooks <joel.hooks@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.shell.controller
{
	import com.joelhooks.pipingthemachine.shell.controller.state.InjectFSMCommand;
	import com.joelhooks.pipingthemachine.shell.controller.state.StartShellCommand;
	
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class StartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand( InjectFSMCommand );
			addSubCommand( StartShellCommand );	
		}
		
	}
}