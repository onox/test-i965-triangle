io.include("Aircraft/ExpansionPack/Nasal/init.nas");

with("refueling_boom");

# Update the state of the refueling boom
var refueling_boom_updater = refueling_boom.RefuelingBoomPositionUpdater.new();
refueling_boom_updater.enable();
