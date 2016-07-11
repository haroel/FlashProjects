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
	import flash.system.Security;
	

	public class MainView extends MovieClip {
		
		public var Button_send:Button;
		public var Label_version:TextInput;
		public var Text_errorlog:TextArea;
		public var Text_output:TextArea;
		public var Text_outputLog:TextArea;

		
		private var jsonObj:Object = null;
		
		public function MainView() {
			// constructor code
						var jsonLoader:URLLoader = new URLLoader();
			jsonLoader.addEventListener(Event.COMPLETE, jsonLoaderComplete);
			jsonLoader.load(new URLRequest("cc.json"));
			
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}


		protected function jsonLoaderComplete(event:Event):void
		{
			jsonObj = JSON.parse(event.target.data);
			//new Security
			Security.loadPolicyFile("http://192.168.20.5:8080/crossdomain.xml");
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
				request.url = jsonObj.server;
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
				callLog("Unable to load URL");
			}
			 
			function loaderCompleteHandler(e:Event):void
			{
				Text_output.htmlText = e.target.data;
			}
			function httpStatusHandler (e:Event):void
			{
				callLog("httpStatusHandler:" + e);
			}
			function securityErrorHandler (e:Event):void
			{
				callLog("securityErrorHandler:" + e);
			}
			function ioErrorHandler(e:Event):void
			{
				callLog("ioErrorHandler: " + e);
			}
		}
		protected function callLog(str:String):void
		{
			Text_outputLog.text += str + "\n";
		}
		
	}
	
}
