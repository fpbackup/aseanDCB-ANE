package com.funkypanda.aseandcb.activity;

import android.app.Activity;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;

import com.forest_interactive.aseandcb.AdcbHelper;
import com.forest_interactive.aseandcb.Aseandcb;
import com.forest_interactive.aseandcb.AseandcbResult;

import com.funkypanda.aseandcb.Extension;
import com.funkypanda.aseandcb.FlashConstants;
import com.funkypanda.aseandcb.vo.PurchaseIntentData;
import org.json.JSONException;
import org.json.JSONObject;

public class PurchaseActivity extends Activity implements AseandcbResult{

    private Aseandcb aseanDCB;
    
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        PurchaseIntentData dat = (PurchaseIntentData) extras.getSerializable("purchaseData");
        aseanDCB = new Aseandcb(this, dat.forestID, dat.forestKey);
        AdcbHelper helper = aseanDCB.getHelper(); // is this needed?
        //////// finish button
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);
        setContentView(relativeLayout, rlp);

        getWindow().getDecorView().setBackgroundColor(0x99000000);

        Button finishButton = new Button(this);
        finishButton.setText("Click to finish");
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.WRAP_CONTENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        finishButton.setLayoutParams(lp);
        finishButton.setTextSize(TypedValue.COMPLEX_UNIT_SP, 25);
        finishButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                finish();
            }
        });
        relativeLayout.addView(finishButton);

        if (dat.paymentType == PurchaseIntentData.PaymentTypes.DIRECT_CARRIER_BILLING)
        {
            Extension.log("Starting DCB purchase process for '" + dat.item + "' with price '" + dat.price +
                    "' and country '" + dat.country + "'");
            try {
                aseanDCB.AseandcbPay(dat.country, dat.price, dat.successMsg, dat.item);
            }
            catch (Exception ex) {
                Extension.logError("DCB purchase failed " + ex.toString());
                finish();
            }
        }
        else if (dat.paymentType == PurchaseIntentData.PaymentTypes.PAY_DETECT)
        {
            Extension.log("Starting country autoDetect purchase process for '" + dat.item + "' with prices '" + dat.prices + "'");
            String[] pricesArr = dat.prices.toArray(new String[dat.prices.size()]);
            try {
                aseanDCB.AseandcbPay(dat.successMsg, pricesArr, dat.item);
            }
            catch (Exception ex) {
                Extension.logError("country autoDetect purchase failed " + ex.toString());
                finish();
            }
        }
        else
        {
            Extension.logError("Not recognized payment type!");
            finish();
        }
    }

   // @Override
    public void AseandcbChargingResult(String transactionID, String statusCode, String amount, String service) {

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
