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

        public function payWithVoucher(country : String, successMsg : String, itemName : String,
                                       forestID : String, forestKey : String) : void
        {
            if (isAndroid)
            {
                _extContext.call("aseanDCBPay", country, successMsg, itemName, forestID, forestKey);
            }
            else {
                dispatchEvent(new AseanDCBDebugEvent(AseanDCBDebugEvent.DEBUG, "The AseanDCB ANE works only on Android"));
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
                    dispatchEvent(new AseanDCBPayErrorEvent(event.level));
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
            var amount : String = result.amount.toLowerCase();
            var service : String = result.service.toLowerCase();

             if (service == "ATMBCA".toLowerCase() || service == "ATMBersama".toLowerCase() ||
                 service == "ATMBersama".toLowerCase() || service == "XLVoucher".toLowerCase() ||
                 service == "Sevelin".toLowerCase() || service == "Smartfren".toLowerCase())
             {

                 if (statusCode == "SUCCESS".toUpperCase())
                 {
                     dispatchEvent( new AseanDCBPaySuccessEvent(statusCode + " " + amount + " " + service));
                 } else
                 {
                     // SUCCESS is the only case scenario for successful transaction.
                     // All other status codes denote failed transactions; including Pending and Waiting for confirmation.
                     // Despite what these two status codes suggest, they denote failed transactions and the user has to be
                     // prompted to go through the payment flow again. Balance will not be deducted.
                     dispatchEvent( new AseanDCBPayErrorEvent(statusCode + " " + amount + " " + service));
                 }
             }
             else if (service == "M1".toLowerCase())
             {
                 if (statusCode == "0")
                 {
                     dispatchEvent( new AseanDCBPaySuccessEvent(statusCode + " " + amount + " " + service));
                 }
                 else
                 {
                     // All other status codes than 0 are to be handled as failed transaction.
                     dispatchEvent( new AseanDCBPayErrorEvent(statusCode + " " + amount + " " + service));
                 }
             }
             else
             {
                 // TODO implement for all carriers
                 dispatchEvent( new AseanDCBPayErrorEvent("NOT IMPLEMENTED " + statusCode + " " + amount + " " + service));
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
