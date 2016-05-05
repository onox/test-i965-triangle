io.include("Aircraft/ExpansionPack/Nasal/init.nas");

with("refueling_boom");

check_version("refueling_boom", 8, 0);

var callback_pose = func {
    var heading_deg = getprop("/engines/engine[9]/n1") or 0.0;
    var pitch_deg   = getprop("/engines/engine[9]/n2") or 0.0;
    var distance    = getprop("/engines/engine[9]/rpm") or 0.0;
    return [heading_deg, pitch_deg, distance];
};

# Update receiver tracking state of the refueling boom
var tracking_updater = refueling_boom.RefuelingBoomTrackingUpdater.new(callback_pose);

# Update the actual state of the refueling boom
var boom_position_updater = refueling_boom.RefuelingBoomPositionUpdater.new(tracking_updater);
tracking_updater.set_chooser(boom_position_updater);

setlistener("/sim/signals/fdm-initialized", func {
    boom_position_updater.enable();
});
