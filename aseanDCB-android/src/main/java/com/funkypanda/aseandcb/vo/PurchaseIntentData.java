package com.funkypanda.aseandcb.vo;

import java.io.Serializable;

public class PurchaseIntentData implements Serializable {

    public enum PaymentTypes {DIRECT_CARRIER_BILLING, VOUCHER};

    public final String country;
    public final String successMsg;
    public final String item;
    public final String forestID;
    public final String forestKey;
    public String price = "";
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

    // voucher pay, this does not need price
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

}
