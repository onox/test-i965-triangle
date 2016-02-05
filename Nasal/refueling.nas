io.include("Aircraft/ExpansionPack/Nasal/init.nas");

with("refueling_boom");

check_version("refueling_boom", 5, 0);

# Update receiver tracking state of the refueling boom
var tracking_updater = refueling_boom.RefuelingBoomTrackingUpdater.new();

# Update the actual state of the refueling boom
var boom_position_updater = refueling_boom.RefuelingBoomPositionUpdater.new(tracking_updater);
tracking_updater.set_chooser(boom_position_updater);

boom_position_updater.enable();
