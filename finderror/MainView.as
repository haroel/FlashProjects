package  {
	
	import flash.display.MovieClip;
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.events.Event;
	import fl.events.ComponentEvent;
	
	import flash.events.MouseEvent;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import flash.net.*;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	

	public class MainView extends MovieClip {
		
		public var Button_send:Button;
		public var Label_version:TextInput;
		public var Text_errorlog:TextArea;
		public var Text_output:TextArea;
		
		
		public function MainView() {
			// constructor code
			
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		public function enterFrameHandler(event:Event):void
		{
			
			Button_send.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		public function clickHandler(event:MouseEvent):void
		{
			trace("click");
			if (Label_version.text == "" || Text_errorlog.text == "")
			{
				Text_output.text = "版本号或日志不能为空！";
				return;
			}
			sendText(Label_version.text,Text_errorlog.text);
		}
		
		protected function sendText(version:String,errorlog:String):void
		{
			
			var requestVars:URLVariables = new URLVariables();
				requestVars.version = version;
				requestVars.errorlog = errorlog;
			 
			var request:URLRequest = new URLRequest();
				request.url = "http://127.0.0.1:8080";
				request.method = URLRequestMethod.GET; 
				request.data = requestVars;
			 
				for (var prop:String in requestVars) {
					trace("Sent " + prop + " as: " + requestVars[prop]);
				}
			var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			 
				
			try
			{
				loader.load(request);
			}
			catch (error:Error)
			{
				trace("Unable to load URL");
			}
			 
			function loaderCompleteHandler(e:Event):void
			{
				Text_output.text = e.target.data;
				 var variables:URLVariables = new URLVariables( e.target.data );
				if(variables.success)
				{
					
					trace(variables.path);		
				}
			}
			function httpStatusHandler (e:Event):void
			{
				//trace("httpStatusHandler:" + e);
			}
			function securityErrorHandler (e:Event):void
			{
				trace("securityErrorHandler:" + e);
			}
			function ioErrorHandler(e:Event):void
			{
				trace("ioErrorHandler: " + e);
			}
		}
		
	}
	
}
