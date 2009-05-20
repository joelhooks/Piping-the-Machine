/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.joelhooks.pipingthemachine.common.model.message
{
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;

	/**
	 * UI Query Message. 
	 * <P>
	 * Used to request that a module import or export a ui component.
	 * The Shell will send a GET query when it wants a module to export
	 * a component, or a SET query when it wants the module to replace
	 * a UI component with one that is passed in. A DESTROY is sent
	 * when we want to remove a compoent previously created.</P>
	 * <P>
	 * In response to a GET action query, a module will send a SET 
	 * action query message with the component in the body of the 
	 * message. To a DESTROY query, the module will remove mediators
	 * and references to the component.</P>
	 */
	public class UIQueryMessage extends Message
	{
		public static const GET:String 			= 'get';
		public static const SET:String 			= 'set';
		public static const DESTROY:String 		= 'destroy';
				
		public function UIQueryMessage( action:String, name:String, component:Object=null)
		{
			var headers:Object = { action:action, name:name };
			super( Message.NORMAL, headers, component );
		}

		/**
		 * Get UIQuery Action (GET or SET).
		 */
		public function get action():String
		{
			return header.action as String;
		}

		/**
		 * Get UI Component Name.
		 */
		public function get name():String
		{
			return header.name as String;
		}

		/**
		 * Get UI Component.
		 */
		public function get component():UIComponent
		{
			return body as UIComponent;
		}
		
	}
}