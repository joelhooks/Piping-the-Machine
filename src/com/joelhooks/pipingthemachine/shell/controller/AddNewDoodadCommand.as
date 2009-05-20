package com.joelhooks.pipingthemachine.shell.controller
{
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;
	import com.joelhooks.pipingthemachine.modules.doodad.DoodadModule;
	import com.joelhooks.pipingthemachine.modules.logger.LoggerModule;
	import com.joelhooks.pipingthemachine.shell.ShellFacade;
	import com.joelhooks.pipingthemachine.shell.view.DoodadModuleMediator;
	import com.joelhooks.pipingthemachine.shell.view.LoggerModuleMediator;
	import com.joelhooks.pipingthemachine.shell.view.ShellJunctionMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;

	public class AddNewDoodadCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			trace("add a new doodad");

			var shellJunctionMediator:ShellJunctionMediator = facade.retrieveMediator( ShellJunctionMediator.NAME ) as ShellJunctionMediator;
			var shellJunction:Junction = shellJunctionMediator.getViewComponent() as Junction;
			
			// --------------------------------------------
			// Connect Shell < - > Doodad Module
			// --------------------------------------------		
			
			//Register a DoodadModuleMediator
			var doodadModule:DoodadModule = new DoodadModule()
			var doodadModuleMediator:DoodadModuleMediator = new DoodadModuleMediator( doodadModule );
			facade.registerMediator(doodadModuleMediator);
			
			// Shell-to-DoodadModule Dedicted OUTPUT
			var shellToDoodadPipe:IPipeFitting = new Pipe();
			shellJunction.registerPipe( doodadModule.GUID, Junction.OUTPUT, shellToDoodadPipe ); 
			
			// Tee Shell-to-DoodadModule Dedicated OUTPUT [and] Shell STDOUT [into] Doodad STDIN
			var doodadInTee:TeeMerge = new TeeMerge();
			doodadInTee.connectInput( shellToDoodadPipe );
			doodadInTee.connectInput( shellJunction.retrievePipe(PipeAwareModule.STDOUT) );
			doodadModule.acceptInputPipe( PipeAwareModule.STDIN, doodadInTee );
			shellJunctionMediator.addConnectionToPool(doodadInTee, shellJunction.retrievePipe(PipeAwareModule.STDOUT), doodadModule.GUID);
			
			// Connect DoodadModule STDOUT to Shell STDIN
			var doodadToShellPipe:Pipe = new Pipe();
			var shellInTee:TeeMerge = TeeMerge(shellJunction.retrievePipe(PipeAwareModule.STDIN))
			shellInTee.connectInput( doodadToShellPipe );
			doodadModule.acceptOutputPipe( PipeAwareModule.STDOUT, doodadToShellPipe );		
			
			sendNotification(ShellFacade.GET_DOODAD_UI, doodadModule.GUID );		
		}
		
	}
}