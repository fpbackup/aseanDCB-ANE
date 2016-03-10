package com.funkypanda.aseandcb.events
{
    import flash.events.Event;

    public class AseanDCBPaySuccessEvent extends Event
    {

        public static const ASEAN_DCB_PAY_SUCCESS : String = "aseanDCBPaySuccess";

        public function AseanDCBPaySuccessEvent(data : String)
        {
            super(ASEAN_DCB_PAY_SUCCESS);
            _message = data;
        }

        private var _message : String;
        public function get message() : String
        {
            return _message;
        }

    }
}
