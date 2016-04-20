package com.funkypanda.aseandcb.events
{
    import flash.events.Event;

    public class AseanDCBPaySuccessEvent extends Event
    {

        public static const ASEAN_DCB_PAY_SUCCESS : String = "aseanDCBPaySuccess";
        private var _amount : Number;
        private var _statusCode : String;
        private var _service : String;
        private var _transactionID : String;

        public function AseanDCBPaySuccessEvent(amount : Number, statusCode : String, service : String, transactionID : String)
        {
            super(ASEAN_DCB_PAY_SUCCESS);
            _amount = amount;
            _statusCode = statusCode;
            _service = service;
            _transactionID = transactionID;
        }

        public function get amount():Number
        {
            return _amount;
        }

        public function get statusCode():String
        {
            return _statusCode;
        }

        public function get service():String
        {
            return _service;
        }

        public function get transactionID():String
        {
            return _transactionID;
        }

        override public function clone() : Event
        {
            return new AseanDCBPaySuccessEvent(_amount, _statusCode, _service, _transactionID);
        }

        override public function toString() : String
        {
            return "service: " + _service + " amount:" + _amount + " status:" + _statusCode + " transactionID:" + _transactionID;
        }
    }
}
