import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.WatchUi;
import Toybox.Application;

// TODO
// * fix icons

class JasonWatchFaceView extends WatchUi.WatchFace {
var font = null;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) as Void {
        font = Application.loadResource( Rez.Fonts.fontAwesomeFreeSolid );
        // heartIcon = Application.loadResource( Rez.Drawables.HeartIcon ) as BitmapResource;
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {}

    // Update the view
    function onUpdate(dc) {
        var activityMonitorInfo = ActivityMonitor.getInfo();
        var activityInfo = Activity.getActivityInfo();
        var systemStats = System.getSystemStats();
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());

        // Time
        var clockTime = System.getClockTime();
        var hour = System.getDeviceSettings().is24Hour ? clockTime.hour : clockTime.hour % 12;
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            screenWidth / 2,
            screenHeight / 2 - dc.getFontHeight(Graphics.FONT_MEDIUM),
            Graphics.FONT_MEDIUM,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER);

        // Heart Rate
        var heartRateSample = activityInfo.currentHeartRate;
        var heartRateValue = null;
        if (heartRateSample != null) {
            heartRateValue = heartRateSample.format("%d");
        }
        if (heartRateValue == null) {
            heartRateValue = "-";
        }
        dc.drawText(
            screenWidth / 2,
            0 + dc.getFontHeight(font),
            Graphics.FONT_SMALL,
            heartRateValue,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            screenWidth / 2,
            0,
            font,
            "w",
            Graphics.TEXT_JUSTIFY_CENTER);

        // Floors
        var floors = activityMonitorInfo.floorsClimbed;
        dc.drawText(
            screenWidth * 0.25,
            screenHeight * 0.75,
            Graphics.FONT_SMALL,
            floors.toString(),
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            screenWidth * 0.25,
            screenHeight * 0.75 - dc.getFontHeight(Graphics.FONT_SMALL) / 2,
            font,
            "w",
            Graphics.TEXT_JUSTIFY_CENTER);

        // Steps
        var steps = activityMonitorInfo.steps;
        steps = 3459;
        var stepsString = steps.toString();
        if (steps > 999) {
            var stepThousands = steps / 1000.0;
            stepsString = Lang.format("$1$k", [stepThousands.format("%.1f")]);
        }
        dc.drawText(
            screenWidth * 0.75,
            screenHeight * 0.75,
            Graphics.FONT_SMALL,
            stepsString,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            screenWidth * 0.75,
            screenHeight * 0.75 - dc.getFontHeight(Graphics.FONT_SMALL) / 2,
            font,
            "w",
            Graphics.TEXT_JUSTIFY_CENTER);

        // battery
        var batteryString = Lang.format("$1$%", [systemStats.battery.format("%.0f")]);
        dc.drawText(
            screenWidth / 2,
            screenHeight - dc.getFontHeight(Graphics.FONT_SMALL),
            Graphics.FONT_SMALL,
            batteryString,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            screenWidth / 2,
            screenHeight - dc.getFontHeight(Graphics.FONT_SMALL) - dc.getFontHeight(font),
            font,
            "w",
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {}

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {}

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {}
}