package com.funkypanda.aseandcb;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.funkypanda.aseandcb.functions.*;

import java.util.HashMap;
import java.util.Map;

public class ExtensionContext extends FREContext
{
    public ExtensionContext() {}

    @Override
    public void dispose() {}

    @Override
    public Map<String, FREFunction> getFunctions()
    {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        functionMap.put(FlashConstants.aseanDCBPay, new AseanDCBPayFunction());
        functionMap.put(FlashConstants.isCountryAvailable, new IsCountryAvailableFunction());
        functionMap.put(FlashConstants.aseanDCBPayDetect, new AseanDCBPayDetectFunction());

        return functionMap;
    }


}