package com.funkypanda.aseandcb.functions;


import android.content.Intent;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.funkypanda.aseandcb.ANEUtils;
import com.funkypanda.aseandcb.Extension;
import com.funkypanda.aseandcb.activity.PurchaseActivity;
import com.funkypanda.aseandcb.vo.PurchaseIntentData;

import java.util.List;

public class AseanDCBPayDetectFunction implements FREFunction
{

    @Override
    public FREObject call(FREContext ctx, FREObject[] args)
    {
        if (args.length != 5)
        {
            Extension.logError("AseanDCBPayDetect called with " + args.length + " params, it needs 5");
            return null;
        }
        PurchaseIntentData dat;
        final String successMsg = ANEUtils.getStringFromFREObject(args[0]);
        final List<String> prices = ANEUtils.getListOfStringFromFREArray((FREArray) args[1]);
        final String item = ANEUtils.getStringFromFREObject(args[2]);
        final String forestID = ANEUtils.getStringFromFREObject(args[3]);
        final String forestKey = ANEUtils.getStringFromFREObject(args[4]);

        dat = new PurchaseIntentData( successMsg, prices, item, forestID, forestKey );

        Intent i = new Intent(ctx.getActivity().getApplicationContext(), PurchaseActivity.class);
        i.putExtra("purchaseData", dat);
        ctx.getActivity().startActivity(i);
        // the end of the purchase flow is in PurchaseActivity
        return null;
    }

}