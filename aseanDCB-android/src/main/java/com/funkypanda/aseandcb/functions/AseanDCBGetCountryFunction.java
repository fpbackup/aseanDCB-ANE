package com.funkypanda.aseandcb.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.forest_interactive.aseandcb.Aseandcb;
import com.funkypanda.aseandcb.ANEUtils;
import com.funkypanda.aseandcb.Extension;

// SIM based country detection. Can return one of the supported countries or null.
public class AseanDCBGetCountryFunction implements FREFunction
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
        String country = aseandcb.getHelper().getCountry();
        Extension.log("AseanDCB country: " + country);

        return ANEUtils.stringAsFREObject(country);
    }

}