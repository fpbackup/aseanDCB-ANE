package com.funkypanda.aseandcb
{

    import com.funkypanda.aseandcb.events.AseanDCBDebugEvent;
    import com.funkypanda.aseandcb.events.AseanDCBPayErrorEvent;
    import com.funkypanda.aseandcb.events.AseanDCBPaySuccessEvent;

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

        //////////////////////////////////////////////////////////////////////////////////////
        // API
        //////////////////////////////////////////////////////////////////////////////////////

        public function payAutoDetectCountry(successMsg : String, prices : Vector.<String>,
                                      itemName : String, forestID : String, forestKey : String) : void
        {
            if (isAndroid)
            {
                var pricesArr : Array = [];
                for (var i:int = 0; i < prices.length; i++) {
                    pricesArr.push(prices[i]);
                }
                _extContext.call("aseanDCBPayDetect", successMsg, pricesArr, itemName, forestID, forestKey);
            }
            else {
                dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.DEBUG, "The AseanDCB ANE works only on Android"));
            }
        }

        public function pay(country : String, successMsg : String, itemName : String,
                            forestID : String, forestKey : String, price : String) : void
        {
            if (isAndroid)
            {
                _extContext.call("aseanDCBPay", country, successMsg, itemName, forestID, forestKey, price);
            }
            else {
                dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.DEBUG, "The AseanDCB ANE works only on Android"));
            }
        }

        /**
         * SIM card based country check whether AseanDCB payment method is usable
         */
        public function isAvailable(forestID : String, forestKey : String) : Boolean
        {
            if (isAndroid)
            {
                return _extContext.call("aseanDCBAvailable", forestID, forestKey);
            }
            else
            {
                return false;
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////
        // NATIVE LIBRARY RESPONSE HANDLER
        //////////////////////////////////////////////////////////////////////////////////////

        private function extension_statusHandler(event : StatusEvent) : void
        {
            switch (event.code)
            {
                case FlashConstants.DEBUG:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.DEBUG, event.level));
                    break;
                case FlashConstants.ERROR:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.ERROR, event.level));
                    break;
                case FlashConstants.ASEAN_DCB_PAY_RESULT:
                    parsePayResult(JSON.parse(event.level));
                    break;
                case FlashConstants.ASEAN_DCB_PAY_ERROR:
                    dispatchEvent(new AseanDCBPayErrorEvent(0, event.level, "NONE"));
                    break;
                default:
                    dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.ERROR,
                            "Unknown event type received from the ANE:" + event.code + " Data: " + event.level));
                    break;
            }
        }

        private function parsePayResult(result : Object) : void
        {
            var statusCode : String = result.statusCode.toLowerCase();
            var amountStr : String = result.amount.toLowerCase();
            var amount : Number = parseFloat(amountStr);
            var service : String = result.service.toLowerCase();
            var success : Boolean = result.success;
            if (success)
            {
                dispatchEvent( new AseanDCBPaySuccessEvent(amount, statusCode, service));
            }
            else
            {
                dispatchEvent( new AseanDCBPayErrorEvent(amount, statusCode, service));
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
