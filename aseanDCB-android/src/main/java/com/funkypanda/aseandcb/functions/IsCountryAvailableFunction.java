package com.funkypanda.aseandcb.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.funkypanda.aseandcb.ANEUtils;
import com.funkypanda.aseandcb.Extension;

public class IsCountryAvailableFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        if (args.length != 0)
        {
            Extension.logError("IsCountryAvailableFunction called with " + args.length + " params, it needs 0.");
            return null;
        }
        Boolean isCountryAvailable = Extension.aseandcb.isCountryAvailable(ctx.getActivity());
        return ANEUtils.booleanAsFREObject(isCountryAvailable);
    }

}