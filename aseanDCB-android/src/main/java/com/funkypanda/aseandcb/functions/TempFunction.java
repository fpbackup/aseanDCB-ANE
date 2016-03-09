package com.funkypanda.aseandcb.functions;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.funkypanda.aseandcb.Extension;

public class TempFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        Extension.log("test");
        return null;
    }

}