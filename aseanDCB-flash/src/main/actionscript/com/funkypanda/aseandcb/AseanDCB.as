package com.funkypanda.aseandcb
{

import com.funkypanda.aseandcb.events.AseanDCBDebugEvent;

    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    public class AseanDCB extends EventDispatcher
    {

        public static const EXT_CONTEXT_ID : String = "com.funkypanda.aseanDCB";

        private static var _instance : AseanDCB;
        private static var _extContext : ExtensionContext;

        public static function get instance() : AseanDCB
        {
            if (_instance == null)
            {
                _instance = new AseanDCB();
            }
            return _instance;
        }
		
        public function AseanDCB()
        {
            if (_instance == null)
            {
                _extContext = ExtensionContext.createExtensionContext(EXT_CONTEXT_ID, null);
                _extContext.addEventListener(StatusEvent.STATUS, extension_statusHandler);
            }
            else
            {
                throw new Error("The AseanDCB singleton has already been created.");
            }
        }


        public function testFunction(testVal : String) : void
        {
            if (isAndroid)
            {
                _extContext.call("testFunction", testVal);
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////
        // NATIVE LIBRARY RESPONSE HANDLER
        //////////////////////////////////////////////////////////////////////////////////////

        private function extension_statusHandler(event : StatusEvent) : void
        {
            switch (event.code)
            {
                case AseanDCBDebugEvent.DEBUG:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.DEBUG, event.level));
                    break;
                case AseanDCBDebugEvent.ERROR:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.ERROR, event.level));
                    break;
                default:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.ERROR,
                            "Unknown event type received from the ANE. Data: " + event.level));
                    break;
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////
        // HELPERS
        //////////////////////////////////////////////////////////////////////////////////////

        private static function get isAndroid() : Boolean
        {
            return (Capabilities.manufacturer.indexOf("Android") > -1);
        }

    }
}
