import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.WatchUi;

class JasonWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var hour = System.getDeviceSettings().is24Hour ? clockTime.hour : clockTime.hour % 12;
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        var timeView = View.findDrawableById("TimeLabel") as Text;
        timeView.setText(timeString);

        var activityInfo = Activity.getActivityInfo();
        var heartRateSample = activityInfo.currentHeartRate;
        var heartRateValue = null;
        if (heartRateSample != null) {
            heartRateValue = heartRateSample.format("%d");
        }
        var heartRateView = View.findDrawableById("HeartRateLabel") as Text;
        if (heartRateValue == null) {
            heartRateValue = "-";
        }
        heartRateView.setText(heartRateValue);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
