package com.joelhooks.pipingthemachine.modules.logger
{
	import com.joelhooks.pipingthemachine.common.view.components.PipeAwareModule;

	public class LoggerModule extends PipeAwareModule
	{
		public static const NAME:String = "LoggerModule";
		
		public static const LOG_WINDOW_UI:String = "LogWindowUI";
		
		public function LoggerModule()
		{
			super(LoggerModuleFacade.getInstance(NAME));
			LoggerModuleFacade(this.facade).startup(this);
		}
		
	}
}