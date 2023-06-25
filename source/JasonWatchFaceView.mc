import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.WatchUi;
import Toybox.Application;

class JasonWatchFaceView extends WatchUi.WatchFace {
    var crystalIconsFont = null;
    var HEART_ICON_CODE = "3";
    var BATTERY_ICON_CODE = "9";
    var FEET_ICON_CODE = "0";
    var STAIRS_ICON_CODE = "1";

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) as Void {
        crystalIconsFont = Application.loadResource( Rez.Fonts.crystalIcons );
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

        clearScreen(dc);
        drawTime(dc, screenWidth, screenHeight);
        drawHeartRate(dc, screenWidth, screenHeight, activityInfo);
        drawFloors(dc, screenWidth, screenHeight, activityMonitorInfo);
        drawSteps(dc, screenWidth, screenHeight, activityMonitorInfo);
        drawBattery(dc, screenWidth, screenHeight, systemStats);
    }

    function clearScreen(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
    }

    function drawTime(dc, screenWidth, screenHeight) {
        var clockTime = System.getClockTime();
        var hour = System.getDeviceSettings().is24Hour ? clockTime.hour : clockTime.hour % 12;
        var minute = clockTime.min.format("%02d");
        // var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            screenWidth / 2 - 3,
            screenHeight * 0.4,
            Graphics.FONT_NUMBER_THAI_HOT,
            hour.toString(),
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(
            screenWidth / 2 + 3,
            screenHeight * 0.4 - dc.getFontHeight(Graphics.FONT_NUMBER_MILD) / 4 - 7,
            Graphics.FONT_NUMBER_MILD,
            minute,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawHeartRate(dc, screenWidth, screenHeight, activityInfo) {
        var x = screenWidth / 2;
        var y = dc.getFontHeight(crystalIconsFont);
        var heartRateSample = activityInfo.currentHeartRate;
        var heartRateValue = null;
        if (heartRateSample != null) {
            heartRateValue = heartRateSample.format("%d");
        }
        if (heartRateValue == null) {
            heartRateValue = "-";
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            x,
            y,
            Graphics.FONT_XTINY,
            heartRateValue,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            x,
            y - dc.getFontHeight(crystalIconsFont),
            crystalIconsFont,
            HEART_ICON_CODE,
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawSteps(dc, screenWidth, screenHeight, activityMonitorInfo) {
        var x = screenWidth * 0.79;
        var y = screenHeight * 0.75;
        var steps = activityMonitorInfo.steps;
        var stepsString = steps.toString();
        if (steps > 999) {
            var stepThousands = steps / 1000.0;
            stepsString = Lang.format("$1$k", [stepThousands.format("%.1f")]);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            x,
            y,
            Graphics.FONT_XTINY,
            stepsString,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            x,
            y - dc.getFontHeight(Graphics.FONT_XTINY),
            crystalIconsFont,
            FEET_ICON_CODE,
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawBattery(dc, screenWidth, screenHeight, systemStats) {
        var x = screenWidth / 2;
        var y = screenHeight - dc.getFontHeight(Graphics.FONT_XTINY);
        var batteryPercentage = systemStats.battery;
        var batteryString = Lang.format("$1$%", [batteryPercentage.format("%.0f")]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            x,
            y,
            Graphics.FONT_XTINY,
            batteryString,
            Graphics.TEXT_JUSTIFY_CENTER);

        var iconX = x;
        var iconY = y - dc.getFontHeight(crystalIconsFont);
        var iconSize = dc.getTextDimensions(BATTERY_ICON_CODE, crystalIconsFont);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        // dc.fillRectangle(iconX, iconY, iconSize[0], iconSize[1]);

        // dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        // dc.fillRectangle(iconX, iconY, iconSize[0] * batteryPercentage / 100.0, iconSize[1]);

        // dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            iconX,
            iconY,
            crystalIconsFont,
            BATTERY_ICON_CODE,
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawFloors(dc, screenWidth, screenHeight, activityMonitorInfo) {
        var x = screenWidth * 0.21;
        var y = screenHeight * 0.75;
        var floors = activityMonitorInfo.floorsClimbed;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            x,
            y,
            Graphics.FONT_XTINY,
            floors.toString(),
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(
            x,
            y - dc.getFontHeight(Graphics.FONT_XTINY),
            crystalIconsFont,
            STAIRS_ICON_CODE,
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