/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.common.view.components
{
	import mx.modules.ModuleBase;
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;

	public class PipeAwareModule extends ModuleBase implements IPipeAware
	{
		
		/**
		 * Standard output pipe name constant.
		 */
		public static const STDOUT:String	= 'pipe/standard/output';
		
		/**
		 * Standard input pipe name constant.
		 */
		public static const STDIN:String 	= 'pipe/standard/input';
		
		/**
		 * Standard log pipe name constant.
		 */
		public static const STDLOG:String 				= 'standardLog';
		
		/**
		 * Standard shell pipe name constant.
		 */
		public static const STDSHELL:String 			= 'standardShell';
		
		/**
		 * A read-only unique identifier for this module.
		 */		
		protected var _GUID:String;

		/**
		 * Constructor.
		 * <P>
		 * In subclass, create appropriate facade and pass 
		 * to super.</P>
		 */
		public function PipeAwareModule( facade:IFacade )
		{
			super();
			this.facade = facade;
			if(!this._GUID)
				this._GUID = UIDUtil.createUID()
		}
		
		/**
		 * public getter for this module's GUID property
		 * @return 
		 * 
		 */		
		public function get GUID():String
		{
			return this._GUID;
		}

		/**
		 * Accept an input pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptInputPipe( name:String, pipe:IPipeFitting ):void
		{
			facade.sendNotification( JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name );	
			trace(name, pipe)						
		}
		
		/**
		 * Accept an output pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptOutputPipe( name:String, pipe:IPipeFitting ):void
		{
			facade.sendNotification( JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name );	
			trace(name, pipe)						
		}
		
		public function connectToShell(shellJunction:ManagedJunction):void
		{
			// Shell-to-ModuleModule Dedicted OUTPUT
			var shellToModulePipe:IPipeFitting = new Pipe();
			shellJunction.registerPipe( this.GUID, Junction.OUTPUT, shellToModulePipe ); 
			
			// Tee Shell-to-ModuleModule Dedicated OUTPUT [and] Shell STDOUT [into] Module STDIN
			var moduleInTee:TeeMerge = new TeeMerge();
			moduleInTee.connectInput( shellToModulePipe );
			moduleInTee.connectInput( shellJunction.retrievePipe(PipeAwareModule.STDOUT) );
			this.acceptInputPipe( PipeAwareModule.STDIN, moduleInTee );
			shellJunction.addConnectionToPool(moduleInTee, shellJunction.retrievePipe(PipeAwareModule.STDOUT), this.GUID);
			
			// Connect ModuleModule STDOUT to Shell STDIN
			var moduleToShellPipe:Pipe = new Pipe();
			var shellInTee:TeeMerge = TeeMerge(shellJunction.retrievePipe(PipeAwareModule.STDIN))
			shellInTee.connectInput( moduleToShellPipe );
			this.acceptOutputPipe( PipeAwareModule.STDOUT, moduleToShellPipe );				
		}
		
		protected var facade:IFacade;
	}
}