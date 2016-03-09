package
{


import com.funkypanda.aseandcb.AseanDCB;
import com.funkypanda.aseandcb.events.AseanDCBDebugEvent;

import feathers.controls.Button;
import feathers.controls.ScrollContainer;
import feathers.controls.ScrollText;
import feathers.layout.TiledColumnsLayout;
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

        var layout : TiledColumnsLayout = new TiledColumnsLayout();
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
        var button : Button;

        button = new Button();
        button.addEventListener(Event.TRIGGERED, function (evt : Event) : void {
           aseanDCB.aseanDCBPay("test");
        });
        button.label = "test1";
        button.validate();
        container.addChild(button);

        button = new Button();
        button.addEventListener(Event.TRIGGERED, function (evt : Event) : void {
            logTF.text = "";
        });
        button.label = "clear";
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
