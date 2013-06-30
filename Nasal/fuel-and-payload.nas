# Overwrite the original menu
gui.menuBind("fuel-and-payload", "b707.WeightFuelDialog()");

var showDialog = func(name) {
    fgcommand("dialog-show", props.Node.new({ "dialog-name" : name }));
}

########################################################################
# Private Stuff:
########################################################################

var fdm = getprop("/sim/flight-model");
var c0 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]"); # crew
var c1 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]"); # first-class
var c2 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]"); # second-class wing
var c3 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]"); # second-class rear
var c4 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]"); # lugage front
var c5 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]"); # lugage center
var c6 = props.globals.getNode("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]"); # lugage rear

########################################################################
# Widgets & Layout Management
########################################################################

##
# A "widget" class that wraps a property node.  It provides useful
# helper methods that are difficult or tedious with the raw property
# API.  Note especially the slightly tricky addChild() method.
#
var Widget = {
    set : func { me.node.getNode(arg[0], 1).setValue(arg[1]); },
    prop : func { return me.node; },
    new : func { return { parents : [Widget], node : props.Node.new() } },
    addChild : func {
        var type = arg[0];
        var idx = size(me.node.getChildren(type));
        var name = type ~ "[" ~ idx ~ "]";
        var newnode = me.node.getNode(name, 1);
        return { parents : [Widget], node : newnode };
    },
    setColor : func(r, g, b, a = 1) {
        me.node.setValues({ color : { red:r, green:g, blue:b, alpha:a } });
    },
    setFont : func(n, s = 13, t = 0) {
        me.node.setValues({ font : { name:n, "size":s, slant:t } });
    },
    setBinding : func(cmd, carg = nil) {
        var idx = size(me.node.getChildren("binding"));
        var node = me.node.getChild("binding", idx, 1);
        node.getNode("command", 1).setValue(cmd);
        if (cmd == "nasal") {
            node.getNode("script", 1).setValue(carg);
        } elsif (carg != nil and (cmd == "dialog-apply" or cmd == "dialog-update")) {
            node.getNode("object-name", 1).setValue(carg);
        }
    },
};

########################################################################
# Dialog Boxes
########################################################################

var dialog = {};

var setWeight = func(wgt, opt) {
    var lbs = opt.getNode("lbs", 1).getValue();
    wgt.getNode("weight-lb", 1).setValue(lbs);

    # Weights can have "tank" indices which set the capacity of the
    # corresponding tank.  This code should probably be moved to
    # something like fuel.setTankCap(tank, gals)...
    if(wgt.getNode("tank",0) == nil) { return 0; }
    var ti = wgt.getNode("tank").getValue();
    var gn = opt.getNode("gals");
    var gals = gn == nil ? 0 : gn.getValue();
    var tn = props.globals.getNode("consumables/fuel/tank["~ti~"]", 1);
    var ppg = tn.getNode("density-ppg", 1).getValue();
    var lbs = gals * ppg;
    var curr = tn.getNode("level-gal_us", 1).getValue();
    curr = curr > gals ? gals : curr;
    tn.getNode("capacity-gal_us", 1).setValue(gals);
    tn.getNode("level-gal_us", 1).setValue(curr);
    tn.getNode("level-lbs", 1).setValue(curr * ppg);
    return 1;
}

# Checks the /sim/weight[n]/{selected|opt} values and sets the
# appropriate weights therefrom.
var setWeightOpts = func {
    var tankchange = 0;
    foreach(var w; props.globals.getNode("sim").getChildren("weight")) {
        var selected = w.getNode("selected");
        if(selected != nil) {
            foreach(var opt; w.getChildren("opt")) {
                if(opt.getNode("name", 1).getValue() == selected.getValue()) {
                    if(setWeight(w, opt)) { tankchange = 1; }
                    break;
                }
            }
        }
    }
    return tankchange;
}
# Run it at startup and on reset to make sure the tank settings are correct
_setlistener("/sim/signals/fdm-initialized", func { settimer(setWeightOpts, 0) });
_setlistener("/sim/signals/reinit", func(n) { props._getValue(n, []) or setWeightOpts() });


# Called from the F&W dialog when the user selects a weight option
var weightChangeHandler = func {
    var tankchanged = setWeightOpts();

    # This is unfortunate.  Changing tanks means that the list of
    # tanks selected and their slider bounds must change, but our GUI
    # isn't dynamic in that way.  The only way to get the changes on
    # screen is to pop it down and recreate it.
    if(tankchanged) {
        var p = props.Node.new({"dialog-name": "WeightAndFuel"});
        fgcommand("dialog-close", p);
        WeightFuelDialog();
    }
}

##
# Dynamically generates a weight & fuel configuration dialog specific to
# the aircraft.
#
var WeightFuelDialog = func {
    var name = "WeightAndFuel";
    var title = "BOEING 707 Weight and Fuel Settings";
    #
    # General Dialog Structure
    #
    dialog[name] = Widget.new();
    dialog[name].set("name", name);
    dialog[name].set("layout", "vbox");

    var header = dialog[name].addChild("group");
    header.set("layout", "hbox");
    header.addChild("empty").set("stretch", "1");
    header.addChild("text").set("label", title);
    header.addChild("empty").set("stretch", "1");
    var w = header.addChild("button");
    w.set("pref-width", 16);
    w.set("pref-height", 16);
    w.set("legend", "");
    w.set("default", 1);
    w.set("key", "esc");
    w.setBinding("nasal", "delete(b707.dialog, \"" ~ name ~ "\")");
    w.setBinding("dialog-close");

    dialog[name].addChild("hrule");

    var fdmdata = {
        grosswgt : "/fdm/jsbsim/inertia/weight-lbs",
        grosskg  : "/b707/weight-kg",
        payload  : "/payload",
        cg       : "/fdm/jsbsim/inertia/cg-x-in",
    };

    var contentArea = dialog[name].addChild("group");
    contentArea.set("layout", "hbox");
    contentArea.set("default-padding", 10);

    dialog[name].addChild("empty");

    var limits = dialog[name].addChild("group");
    limits.set("layout", "table");
    limits.set("halign", "center");
    var row = 0;

    var massLimits = props.globals.getNode("/limits/mass-and-balance");

    var tablerow = func(name, node, format ) {

        var n = isa( node, props.Node ) ? node : massLimits.getNode( node );
        if( n == nil ) return;

        var label = limits.addChild("text");
        label.set("row", row);
        label.set("col", 0);
        label.set("halign", "right");
        label.set("label", name ~ ":");

        var val = limits.addChild("text");
        val.set("row", row);
        val.set("col", 1);
        val.set("halign", "left");
        val.set("label", "0123457890123456789");
        val.set("format", format);
        val.set("property", n.getPath());
        val.set("live", 1);
          
        row += 1;
    }

    var grossWgt = props.globals.getNode(fdmdata.grosswgt);
    var grosskg = props.globals.getNode("/b707/weight-kg");
    if(grossWgt != nil) {
        tablerow("Gross Weight", grossWgt, "%.0f lbs");
    }

    if(massLimits != nil ) {
        tablerow("Max. Ramp Weight", "maximum-ramp-mass-lbs", "%.0f lbs" );
        tablerow("Max. Takeoff", "maximum-takeoff-mass-lbs", "%.0f lbs" );
        tablerow("Max. Landing", "maximum-landing-mass-lbs", "%.0f lbs" );
        tablerow("Max. Arrested Landing  Weight", "maximum-arrested-landing-mass-lbs", "%.0f lbs" );
        tablerow("Max. Zero Fuel Weight", "maximum-zero-fuel-mass-lbs", "%.0f lb" );
    }

    #if( fdmdata.cg != nil ) { 
    #    var n = props.globals.getNode("/limits/mass-and-balance/cg/dimension");
    #    tablerow("Center of Gravity", props.globals.getNode(fdmdata.cg), "%.1f " ~ (n == nil ? "in" : n.getValue()));
    #}

    dialog[name].addChild("hrule");

    var buttonBar = dialog[name].addChild("group");
    buttonBar.set("layout", "hbox");
    buttonBar.set("default-padding", 10);

    var close = buttonBar.addChild("button");
    close.set("legend", "Close");
    close.set("default", "true");
    close.set("key", "Enter");
    close.setBinding("dialog-close");

    # Temporary helper function
    var tcell = func(parent, type, row, col) {
        var cell = parent.addChild(type);
        cell.set("row", row);
        cell.set("col", col);
        return cell;
    }

    #
    # Fill in the content area
    #
    var fuelArea = contentArea.addChild("group");
    fuelArea.set("layout", "vbox");
    fuelArea.addChild("text").set("label", "Fuel Tanks");

    var fuelTable = fuelArea.addChild("group");
    fuelTable.set("layout", "table");

    fuelArea.addChild("empty").set("stretch", 1);

    tcell(fuelTable, "text", 0, 0).set("label", "Tank"); 
    var lbs = tcell(fuelTable, "text", 0, 3);
    lbs.set("label", "lbs");
    lbs.set("halign", "left");
    
    var kg = tcell(fuelTable, "text", 0, 4);
    kg.set("label", "kg");
    kg.set("halign", "left");
    
    var tnames = ["Main 4", "Main 3", "Center", "Main 2", "Main 1", "Res 1", "Res 4"];

    var tanks = props.globals.getNode("/consumables/fuel").getChildren("tank");
    for(var i=0; i<size(tanks); i+=1) {
        var t = tanks[i];
        var tname = tnames[i-1] ~ "";
        var tnode = t.getNode("name");
        if(tnode != nil) { tname = tnode.getValue(); }

        var tankprop = "/consumables/fuel/tank["~i~"]";

        var cap = t.getNode("capacity-gal_us", 0);

        # Hack, to ignore the "ghost" tanks created by the C++ code.
        if(cap == nil ) { continue; }
        cap = cap.getValue();

        # Ignore tanks of capacity 0
        if (cap == 0) { continue; }

        var title = tcell(fuelTable, "text", i+1, 0);
        title.set("label", tname);
        title.set("halign", "left");

        var selected = props.globals.initNode(tankprop ~ "/selected", 1, "BOOL");
        if (selected.getAttribute("writable")) {
            var sel = tcell(fuelTable, "checkbox", i+1, 1);
            sel.set("property", tankprop ~ "/selected");
            sel.set("live", 1);
            sel.setBinding("dialog-apply");
        }

        var slider = tcell(fuelTable, "slider", i+1, 2);
        slider.set("property", tankprop ~ "/level-gal_us");
        slider.set("live", 1);
        slider.set("min", 0);
        slider.set("max", cap);
        slider.setBinding("dialog-apply");

        var lbs = tcell(fuelTable, "text", i+1, 3);
        lbs.set("property", tankprop ~ "/level-lbs");
				lbs.set("label", "0123456");
				lbs.set("format", "%.1f" );
				lbs.set("halign", "right");
				lbs.set("live", 1);

        var kg = tcell(fuelTable, "text", i+1, 4);
        kg.set("property", tankprop ~ "/level-kg");
				kg.set("label", "0123456");
				kg.set("format", "%.1f" );
				kg.set("halign", "right");
				kg.set("live", 1);
    }

    var bar = tcell(fuelTable, "hrule", size(tanks)+1, 0);
    bar.set("colspan", 5);

    var total_label = tcell(fuelTable, "text", size(tanks)+2, 0);
    total_label.set("label", "Total");
    total_label.set("halign", "left");
    
    # set all tanks to the same fraction
    var calcFuel = tcell(fuelTable, "button", size(tanks)+2, 2);  
    calcFuel.set("pref-width", 70);
    calcFuel.set("pref-height", 20);
    calcFuel.set("legend", "Levelling");
    calcFuel.setBinding("nasal", "b707.calc_fuel()");

    var lbs = tcell(fuelTable, "text", size(tanks)+2, 3);
    lbs.set("property", "/consumables/fuel/total-fuel-lbs");
    lbs.set("label", "0123456");
    lbs.set("format", "%.1f" );
    lbs.set("halign", "right");
    lbs.set("live", 1);

    var kg = tcell(fuelTable, "text",size(tanks) +2, 4);
    kg.set("property", "/consumables/fuel/total-fuel-kg");
    kg.set("label", "0123456");
    kg.set("format", "%.1f" );
    kg.set("halign", "right");
    kg.set("live", 1);

    var weightArea = contentArea.addChild("group");
    weightArea.set("layout", "vbox");
    weightArea.addChild("text").set("label", "Payload");

    var weightTable = weightArea.addChild("group");
    weightTable.set("layout", "table");

    weightArea.addChild("empty").set("stretch", 1);

    tcell(weightTable, "text", 0, 0).set("label", "Location");
    var lbs = tcell(weightTable, "text", 0, 2);
    lbs.set("label", "lbs");
    lbs.set("halign", "left");

    var kg = tcell(weightTable, "text", 0, 3);
    kg.set("label", "kg");
    kg.set("halign", "left");
    
    var pers = tcell(weightTable, "text", 0, 4);
    pers.set("label", "Pers.");
    pers.set("halign", "left");

    var payload_base = props.globals.getNode(fdmdata.payload);
    if (payload_base != nil)
        var wgts = payload_base.getChildren("weight");
    else
        var wgts = [];
    for(var i=0; i<size(wgts); i+=1) {
        var w = wgts[i];
        var wname = w.getNode("name", 1).getValue();
        var wprop = fdmdata.payload ~ "/weight[" ~ i ~ "]";

        var title = tcell(weightTable, "text", i+1, 0);
        title.set("label", wname);
        title.set("halign", "left");

        if(w.getNode("opt") != nil) {
            var combo = tcell(weightTable, "combo", i+1, 1);
            combo.set("property", wprop ~ "/selected");

            # Simple code we'd like to use:
            #foreach(opt; w.getChildren("opt")) {
            #    var ent = combo.addChild("value");
            #    ent.prop().setValue(opt.getNode("name", 1).getValue());
            #}

            # More complicated workaround to move the "current" item
            # into the first slot, because dialog.cxx doesn't set the
            # selected item in the combo box.
            var opts = [];
            var curr = w.getNode("selected");
            curr = curr == nil ? "" : curr.getValue();
            foreach(opt; w.getChildren("opt")) {
                append(opts, opt.getNode("name", 1).getValue());
            }
            forindex(oi; opts) {
                if(opts[oi] == curr) {
                    var tmp = opts[0];
                    opts[0] = opts[oi];
                    opts[oi] = tmp;
                    break;
                }
            }
            foreach(opt; opts) {
                combo.addChild("value").prop().setValue(opt);
            }

            combo.setBinding("dialog-apply");
            combo.setBinding("nasal", "b707.weightChangeHandler()");
        } else {
            var slider = tcell(weightTable, "slider", i+1, 1);
            slider.set("property", wprop ~ "/weight-lb");
            var min = w.getNode("min-lb", 1).getValue();
            var max = w.getNode("max-lb", 1).getValue();
            slider.set("min", min != nil ? min : 0);
            slider.set("max", max != nil ? max : 100);
            slider.set("live", 1);
            slider.setBinding("dialog-apply");
        }

        var lbs = tcell(weightTable, "text", i+1, 2);
        lbs.set("property", wprop ~ "/weight-lb");
        lbs.set("label", "0123456");
        lbs.set("format", "%.0f");
        lbs.set("halign", "right");
        lbs.set("live", 1);
        
        var kg = tcell(weightTable, "text", i+1, 3);
        kg.set("property", "b707/passengers/weight-kg["~i~"]");
        kg.set("label", "0123456");
        kg.set("format", "%.0f");
        kg.set("halign", "right");
        kg.set("live", 1);
        
        if( i < 4){
		      var pas = tcell(weightTable, "text", i+1, 4);
		      pas.set("property", "b707/passengers/count["~i~"]");
		      pas.set("label", "0123456");
		      pas.set("format", "%.0f");
		      pas.set("halign", "right");
		      pas.set("live", 1);
		    }    
    }
    
    var bar = tcell(weightTable, "hrule", size(wgts)+1, 0);
    bar.set("colspan", 5);
    
    var total_label = tcell(weightTable, "text", size(wgts)+2, 0);
    total_label.set("label", "Total Load/Passengers");
    total_label.set("halign", "left");

    # set 120 passengers
    var standLoad = tcell(weightTable, "button", size(wgts)+2, 1);  
    standLoad.set("pref-width", 70);
    standLoad.set("pref-height", 20);
    standLoad.set("legend", "Standard");
    standLoad.setBinding("nasal", "b707.standard_load()");
    
    var lbs = tcell(weightTable, "text",size(wgts) +2, 2);
    lbs.set("property", "b707/passengers/load-weight");
    lbs.set("label", "0123456");
    lbs.set("format", "%.0f" );
    lbs.set("halign", "right");
    lbs.set("live", 1);

    var kg = tcell(weightTable, "text",size(wgts) +2, 3);
    kg.set("property", "b707/passengers/load-weight-kg");
    kg.set("label", "0123456");
    kg.set("format", "%.0f" );
    kg.set("halign", "right");
    kg.set("live", 1);

    var ps = tcell(weightTable, "text",size(wgts) +2, 4);
    ps.set("property", "b707/passengers/count-all");
    ps.set("label", "0123456");
    ps.set("format", "%.0f" );
    ps.set("halign", "right");
    ps.set("live", 1);

    # All done: pop it up
    fgcommand("dialog-new", dialog[name].prop());
    showDialog(name);
}

########################################### Helper #################################
var count_all = func{
 var pass_weight = c0.getValue() + c1.getValue() + c2.getValue() + c3.getValue();
 var lug_weight = c4.getValue() + c5.getValue() + c6.getValue();
 var load = pass_weight + lug_weight;
 var pass = (pass_weight > 0) ? pass_weight/180 : 0;
 setprop("b707/passengers/count-all", pass);
 setprop("b707/passengers/load-weight", load);
 setprop("b707/passengers/load-weight-kg", load*0.45359237);
}


#Linie 324
var calc_fuel = func{
  var cfuel = props.globals.getNode("/consumables/fuel");
  var tanks = cfuel.getChildren("tank");
  var fn = cfuel.getChild("total-fuel-norm");
  for(var i=0; i<size(tanks); i+=1) {
      var t = tanks[i].getChild("level-norm");
			t.setValue(fn.getValue());
	}

}

var standard_load = func{
	var st = getprop("/b707/standard-load") or 0;
  if(!st){
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 1068.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 3429.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 6713.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 11529.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 2805.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 6104.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 7532.0);
		setprop("/b707/standard-load", 1);
		settimer(calc_fuel, 0.2);
	}else{
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", 540.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", 0.0);
		setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", 0.0);
		setprop("/b707/standard-load", 0);	
	}
}

# the passengers quantity
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[0]", func(wlbs){
	var pers = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[0]", pers*0.45359237);
  pers = (pers > 0) ? pers/180 : 0;  # 180lbs per crew member
  setprop("b707/passengers/count[0]", pers);  
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[1]", func(wlbs){
	var pers = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[1]", pers*0.45359237);
  pers = (pers > 0) ? pers/180 : 0;  # 180lbs per passanger
  setprop("b707/passengers/count[1]", pers);
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[2]", func(wlbs){
	var pers = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[2]", pers*0.45359237);
  pers = (pers > 0) ? pers/180 : 0;  # 180lbs per passanger
  setprop("b707/passengers/count[2]", pers);
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[3]", func(wlbs){
	var pers = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[3]", pers*0.45359237);
  pers = (pers > 0) ? pers/180 : 0;  # 180lbs per passanger
  setprop("b707/passengers/count[3]", pers);
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[4]", func(wlbs){
	var lag = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[4]", lag*0.45359237);
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[5]", func(wlbs){
	var lag = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[5]", lag*0.45359237);
  count_all();
},1,0);
setlistener("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]", func(wlbs){
	var lag = wlbs.getValue() or 0;
	setprop("b707/passengers/weight-kg[6]", lag*0.45359237);
  count_all();
},1,0);

setlistener("/fdm/jsbsim/inertia/weight-lbs", func(wlbs){
	var wlbs = wlbs.getValue();
  wlbs = (wlbs > 0) ? wlbs*0.45359237 : 0;  # 0.45359237
  setprop("b707/weight-kg", wlbs);
},1,0);

################################# FUEL PANEL IN ENGINEER PANEL ###############################################
var valve_pos = func(nr) {
	setprop("b707/fuel/valves/valve-pos["~nr~"]", 0);
	settimer( func { setprop("b707/fuel/valves/valve-pos["~nr~"]", 1) }, 1.8 );
}
var shutoff_pos = func(nr) {
	setprop("b707/fuel/valves/fuel-shutoff-pos["~nr~"]", 0);
	settimer( func { setprop("b707/fuel/valves/fuel-shutoff-pos["~nr~"]", 1) }, 1.8 );
}

var fuel_temp_selector = func{
  setprop("b707/fuel/temperature", 0);
	var temp = getprop("/environment/temperature-degc") or 0;
	interpolate("b707/fuel/temperature", temp, 1.2);
}

#################################### Loop for fuel temperature ################################################

var set_fuel_temp = func {
	var airtemp = getprop("/environment/temperature-degc") or 0;
	interpolate("b707/fuel/temperature", airtemp, 1.2);
	settimer( set_fuel_temp, 5);
}

set_fuel_temp();





