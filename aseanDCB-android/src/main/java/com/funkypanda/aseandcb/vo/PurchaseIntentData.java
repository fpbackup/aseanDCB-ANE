package com.funkypanda.aseandcb.vo;

import java.io.Serializable;
import java.util.List;

public class PurchaseIntentData implements Serializable {

    public enum PaymentTypes {DIRECT_CARRIER_BILLING, VOUCHER, PAY_DETECT}

    public String country;
    public final String successMsg;
    public final String item;
    public final String forestID;
    public final String forestKey;
    public String price = "";
    public List<String> prices;
    public final PaymentTypes paymentType;

    public PurchaseIntentData(String country,
                              String successMsg,
                              String item,
                              String forestID,
                              String forestKey,
                              String price) {

        this.country = country;
        this.successMsg = successMsg;
        this.item = item;
        this.forestID = forestID;
        this.forestKey = forestKey;
        this.price = price;
        this.paymentType = PaymentTypes.DIRECT_CARRIER_BILLING;
    }

    // voucher payment, this does not need price
    public PurchaseIntentData(String country,
                              String successMsg,
                              String item,
                              String forestID,
                              String forestKey) {
        this.country = country;
        this.successMsg = successMsg;
        this.item = item;
        this.forestID = forestID;
        this.forestKey = forestKey;
        this.paymentType = PaymentTypes.VOUCHER;
    }

    // auto detect country payment
    public PurchaseIntentData(String successMsg,
                              List<String> prices,
                              String item,
                              String forestID,
                              String forestKey) {
        this.successMsg = successMsg;
        this.prices = prices;
        this.item = item;
        this.forestID = forestID;
        this.forestKey = forestKey;
        this.paymentType = PaymentTypes.PAY_DETECT;
    }
}
