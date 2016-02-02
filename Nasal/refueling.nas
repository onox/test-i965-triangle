io.include("Aircraft/ExpansionPack/Nasal/init.nas");

with("refueling_boom");

check_version("refueling_boom", 4, 0);

# Update receiver tracking state of the refueling boom
var tracking_updater = refueling_boom.RefuelingBoomTrackingUpdater.new();
tracking_updater.enable();

# Update the actual state of the refueling boom
var boom_position_updater = refueling_boom.RefuelingBoomPositionUpdater.new(tracking_updater);
boom_position_updater.enable();
