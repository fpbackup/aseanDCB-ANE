package com.funkypanda.aseandcb.activity;

import android.app.Activity;
import android.os.Bundle;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.forest_interactive.aseandcb.AseandcbResult;
import com.funkypanda.aseandcb.Extension;
import com.funkypanda.aseandcb.FlashConstants;
import com.funkypanda.aseandcb.vo.PurchaseIntentData;
import org.json.JSONException;
import org.json.JSONObject;

public class PurchaseActivity extends Activity implements AseandcbResult {

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        //////// test code
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);
        TextView tv = new TextView(this);
        tv.setText("Android purchase activity for AseanDCB payments");
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.WRAP_CONTENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        tv.setLayoutParams(lp);
        relativeLayout.addView(tv);
        setContentView(relativeLayout, rlp);
        ////////

        Bundle extras = getIntent().getExtras();
        PurchaseIntentData dat = (PurchaseIntentData) extras.getSerializable("purchaseData");

        Extension.log("Starting purchase process for '" + dat.item + "' with price '" + dat.price +
                      "', payment type '" + dat.paymentType + "' and country '" + dat.country + "'");
        if (dat.paymentType == PurchaseIntentData.PaymentTypes.DIRECT_CARRIER_BILLING)
        {
            Extension.aseandcb.AseandcbPay(this, dat.country, dat.successMsg, dat.price, dat.item, dat.forestID , dat.forestKey);
        }
        else if (dat.paymentType == PurchaseIntentData.PaymentTypes.VOUCHER)
        {
            Extension.aseandcb.AseandcbPay(this, dat.country, dat.successMsg, dat.item, dat.forestID , dat.forestKey);
        }
        else
        {
            Extension.logError("Not recognized payment type!");
            finish();
        }
    }

    @Override
    public void AseandcbChargingResult(String statusCode, String amount, String service) {

        Extension.dispatchStatusEventAsync(FlashConstants.DEBUG, "Received payment result " + statusCode + " " + amount + " " + service);

        statusCode = statusCode == null ? "UNDEFINED" : statusCode;
        amount = amount == null ? "UNDEFINED" : amount;
        service = service == null ? "UNDEFINED" : service;

        JSONObject toRet = new JSONObject();
        try {
            toRet.put("statusCode", statusCode);
            toRet.put("amount", amount);
            toRet.put("service", service);
        } catch (JSONException e) {
            Extension.dispatchStatusEventAsync(FlashConstants.ASEAN_DCB_PAY_ERROR, statusCode + " " + amount + " " + service + " JSONerror:" + e);
        }
        Extension.dispatchStatusEventAsync(FlashConstants.ASEAN_DCB_PAY_RESULT, toRet.toString());

        finish();
    }
}
