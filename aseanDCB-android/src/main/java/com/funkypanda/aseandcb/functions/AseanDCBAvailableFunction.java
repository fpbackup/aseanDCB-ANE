package com.funkypanda.aseandcb.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.forest_interactive.aseandcb.Aseandcb;
import com.funkypanda.aseandcb.ANEUtils;
import com.funkypanda.aseandcb.Extension;

public class AseanDCBAvailableFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        if (args.length != 2)
        {
            Extension.logError("AseanDCBAvailable called with " + args.length + " params, it needs 2.");
            return null;
        }

        final String forestID = ANEUtils.getStringFromFREObject(args[0]);
        final String forestKey = ANEUtils.getStringFromFREObject(args[1]);

        Aseandcb aseandcb = new Aseandcb(ctx.getActivity(), forestID, forestKey);
        boolean isCountryAvailable = aseandcb.getHelper().isCountryAvailable();
        Extension.log("AseanDCB available: " + isCountryAvailable);

        return ANEUtils.booleanAsFREObject(isCountryAvailable);
    }

}