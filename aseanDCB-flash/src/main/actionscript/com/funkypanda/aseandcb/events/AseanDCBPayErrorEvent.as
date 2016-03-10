package com.funkypanda.aseandcb.events
{
    import flash.events.Event;

    public class AseanDCBPayErrorEvent extends Event
    {

        public static const ASEAN_DCB_PAY_ERROR : String = "aseanDCBPayError";

        public function AseanDCBPayErrorEvent(data : String)
        {
            super(ASEAN_DCB_PAY_ERROR);
            _message = data;
        }

        private var _message : String;
        public function get message() : String
        {
            return _message;
        }

    }
}
