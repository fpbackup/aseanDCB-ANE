package
{


import com.funkypanda.aseandcb.AseanDCB;
import com.funkypanda.aseandcb.events.AseanDCBDebugEvent;
import com.funkypanda.aseandcb.events.AseanDCBPayErrorEvent;
import com.funkypanda.aseandcb.events.AseanDCBPaySuccessEvent;

import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.PickerList;
import feathers.controls.ScrollContainer;
import feathers.controls.ScrollText;
import feathers.data.ListCollection;
import feathers.layout.HorizontalLayout;
import feathers.layout.TiledRowsLayout;
import feathers.themes.MetalWorksMobileTheme;

import flash.system.Capabilities;
import flash.text.TextFormat;

import starling.display.Sprite;
import starling.events.Event;

public class TestApp extends Sprite
{

    private const container: ScrollContainer = new ScrollContainer();
    private static var _instance : TestApp;
    private var logTF : ScrollText;
    private var buttonBarHeight : uint = 405;

    private var aseanDCB : AseanDCB;

    public function TestApp()
    {
        _instance = this;
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    public function log(str : String) : void
    {
        logTF.text += str + "\n";
        trace(str);
    }

    protected function addedToStageHandler(event : Event) : void
    {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        new MetalWorksMobileTheme();

        var layout : TiledRowsLayout = new TiledRowsLayout();
        layout.useSquareTiles = false;
        layout.gap = 3;
        container.layout = layout;
        container.width = stage.stageWidth;
        addChild(container);

        logTF = new ScrollText();
        logTF.width = stage.stageWidth;
        logTF.textFormat = new TextFormat(null, 22, 0xdedede);
        addChild(logTF);

        stage.addEventListener(Event.RESIZE, function(evt : Event) : void
        {
            logTF.height = stage.stageHeight - buttonBarHeight;
            logTF.width = stage.stageWidth;
            container.width = stage.stageWidth;
        });

        var countryList : PickerList = new PickerList();
        countryList.addEventListener(Event.OPEN, function(evt : Event):void{
            logTF.alpha = 0;
        });
        countryList.addEventListener(Event.CLOSE, function(evt : Event):void{
            logTF.alpha = 1;
        });
        countryList.listProperties.@itemRendererProperties.labelField = "text";
        countryList.labelField = "text";
        countryList.dataProvider = new ListCollection (
            [
                { text: "Malaysia" },
                { text: "Indonesia" },
                { text: "Singapore" },
                { text: "Sri Lanka" },
                { text: "IndoATM" },
                { text: "IndoVoucher" }
            ]);
        container.addChild(countryList);

        var priceG : LayoutGroup = new LayoutGroup();
        priceG.layout = new HorizontalLayout();
        HorizontalLayout(priceG.layout).verticalAlign = "middle";
        container.addChild(priceG);

        var priceLbl : Label = new Label();
        priceLbl.text = "Price:";
        priceG.addChild(priceLbl);

        var priceList : PickerList = new PickerList();
        priceList.addEventListener(Event.OPEN, function(evt : Event):void{
            logTF.alpha = 0;
        });
        priceList.addEventListener(Event.CLOSE, function(evt : Event):void{
            logTF.alpha = 1;
        });
        priceList.listProperties.@itemRendererProperties.labelField = "text";
        priceList.labelField = "text";
        priceList.dataProvider = new ListCollection (
                [
                    { text: "3" },{ text: "4" },{ text: "5" },{ text: "6" },{ text: "7" },{ text: "8" }, { text: "9" },
                    { text: "10" },{ text: "20" },{ text: "30" },{ text: "40" },{ text: "50" },{ text: "60" },{ text: "70" },{ text: "80" },{ text: "90" },
                    { text: "100" },{ text: "150" },{ text: "150" },{ text: "200" },{ text: "300" },{ text: "400" },{ text: "500" },{ text: "600" }, { text: "700" },{ text: "800" },{ text: "900" },
                    { text: "1000" },{ text: "1500" },{ text: "2000" },{ text: "2500" },{ text: "3000" },{ text: "4000" },{ text: "5000" },
                    { text: "10000" },{ text: "15000" },{ text: "20000" },{ text: "25000" },{ text: "50000" },{ text: "60000" },{ text: "100000" },{ text: "500000" }
                ]);
        priceG.addChild(priceList);

        var button : Button;

        button = new Button();
        button.addEventListener(Event.TRIGGERED, function (evt : Event) : void {
            var country : String = countryList.selectedItem.text;
            aseanDCB.pay(country, "Sample success message", "Sample item name",
                    "HMEINV604178575" , "NIKRCY676604865", priceList.selectedItem.text);
        });
        button.label = "Make Payment";
        button.validate();
        container.addChild(button);

        button = new Button();
        button.addEventListener(Event.TRIGGERED, function (evt : Event) : void {
            // prices must be for {Malaysia, Indonesia, Placeholder, Singapore, Sri Lanka}
            aseanDCB.payAutoDetectCountry("sample success message",
                    new <String>["100", "10000", "4", "3", "100"],
                    "Sample item name", "HMEINV604178575" , "NIKRCY676604865");
        });
        button.label = "pay DetectCountry";
        button.validate();
        container.addChild(button);

        button = new Button();
        button.addEventListener(Event.TRIGGERED, function (evt : Event) : void {
            logTF.text = "";
        });
        button.label = "clear log";
        button.validate();
        container.addChild(button);

        buttonBarHeight = Math.ceil(0.5 * container.numChildren) * 60 + 5;
        container.height = buttonBarHeight;
        logTF.height = stage.stageHeight - buttonBarHeight;
        logTF.y = buttonBarHeight + container.y;

        log("Testing application for the AseanDCB ANE.");

        try {
            aseanDCB = AseanDCB.instance;
        }
        catch (err : Error) {
            log("Cannot create AseanDCB " + err + "\n" + err.getStackTrace());
            return;
        }

        aseanDCB.addEventListener(AseanDCBDebugEvent.DEBUG, function (evt : AseanDCBDebugEvent) : void {
            log("DEBUG " + evt.message);
        });
        aseanDCB.addEventListener(AseanDCBDebugEvent.ERROR, function (evt : AseanDCBDebugEvent) : void {
            log("ERROR " + evt.message);
        });
        aseanDCB.addEventListener(AseanDCBPaySuccessEvent.ASEAN_DCB_PAY_SUCCESS, function (evt : AseanDCBPaySuccessEvent) : void {
            log("ASEAN_DCB_PAY_SUCCESS " + evt.toString());
        });
        aseanDCB.addEventListener(AseanDCBPayErrorEvent.ASEAN_DCB_PAY_ERROR, function (evt : AseanDCBPayErrorEvent) : void {
            log("ASEAN_DCB_PAY_ERROR " + evt.toString());
        });
    }

    private static function get isAndroid() : Boolean
    {
        return (Capabilities.manufacturer.indexOf("Android") > -1);
    }

    public static function log(str: String) : void
    {
        if (_instance)
        {
            _instance.log(str);
        }
        else
        {
            trace(str);
        }
    }

}
}
