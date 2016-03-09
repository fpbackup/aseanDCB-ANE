package com.funkypanda.aseandcb.functions;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.funkypanda.aseandcb.Extension;

public class AseanDCBPayFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        Extension.log("test");

        Extension.aseandcb.AseandcbPay(ctx.getActivity(), "IndoATM", "Successful. You have purchased 100 Coins.", "super sword", "forestID", "forestKey");

        return null;
    }

}