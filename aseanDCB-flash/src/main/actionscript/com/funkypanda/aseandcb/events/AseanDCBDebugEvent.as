package com.funkypanda.aseandcb.events
{
    import flash.events.Event;

    public class AseanDCBDebugEvent extends Event
    {

        public static const DEBUG : String = "debug";
        public static const ERROR : String = "error";

        public function AseanDCBDebugEvent(_type : String, data : String)
        {
            super(_type);
            _message = data;
        }

        private var _message : String;
        public function get message() : String
        {
            return _message;
        }

    }
}
