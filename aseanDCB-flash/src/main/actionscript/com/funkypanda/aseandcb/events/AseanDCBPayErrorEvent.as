package com.funkypanda.aseandcb.events
{
    import flash.events.Event;

    public class AseanDCBPayErrorEvent extends Event
    {

        public static const ASEAN_DCB_PAY_ERROR : String = "aseanDCBPayError";
        private var _amount : Number;
        private var _statusCode : String;
        private var _service : String;

        public function AseanDCBPayErrorEvent(amount : Number, statusCode : String, service : String)
        {
            super(ASEAN_DCB_PAY_ERROR);
            _amount = amount;
            _statusCode = statusCode;
            _service = service;
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

        override public function clone() : Event
        {
            return new AseanDCBPayErrorEvent(_amount, _statusCode, _service);
        }

        override public function toString() : String
        {
            return "service: " + _service + " amount:" + _amount + " status:" + _statusCode;
        }
    }
}
