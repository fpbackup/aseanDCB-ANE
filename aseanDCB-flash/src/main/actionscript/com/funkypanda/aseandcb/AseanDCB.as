package com.funkypanda.aseandcb
{

    import com.funkypanda.aseandcb.events.AseanDCBDebugEvent;
    import com.funkypanda.aseandcb.events.AseanDCBPayErrorEvent;
    import com.funkypanda.aseandcb.events.AseanDCBPaySuccessEvent;

    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;
import flash.utils.setTimeout;

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
                if (isAndroid)
                {
                    _extContext = ExtensionContext.createExtensionContext(EXT_CONTEXT_ID, null);
                    _extContext.addEventListener(StatusEvent.STATUS, extension_statusHandler);
                }
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

        /**
         * Makes a debug payment that always succeeds. The transaction ID is not a real one, just a random string.
         */
        public function payDebugSuccess(successMsg : String, prices : Vector.<String>,
                                        itemName : String, forestID : String, forestKey : String) : void
        {
            setTimeout(function():void
            {
                parsePayResult({transactionID:"DEBUG_PAYMENT_OK", statusCode:"OK", amount:"100", service:"TelkomSel", success:true});
            }, 1000);
        }

        /**
         * Makes a debug payment that always fails. The transaction ID is not a real one, just a random string.
         */
        public function payDebugFail(successMsg : String, prices : Vector.<String>,
                                     itemName : String, forestID : String, forestKey : String) : void
        {
            setTimeout(function():void
            {
                parsePayResult({transactionID:"DEBUG_PAYMENT_FAIL", statusCode:"payment error -1", amount:"345", service:"SmartFren", success:false});
            }, 1000);
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
            var transactionID : String = result.transactionID;
            var statusCode : String = result.statusCode.toLowerCase();
            var amountStr : String = result.amount.toLowerCase();
            var amount : Number = parseFloat(amountStr);
            var service : String = result.service.toLowerCase();
            var success : Boolean = result.success;
            if (success)
            {
                dispatchEvent( new AseanDCBPaySuccessEvent(amount, statusCode, service, transactionID));
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
