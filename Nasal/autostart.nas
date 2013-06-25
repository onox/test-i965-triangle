# Lake of Constance Hangar :: M.Kraus
# May 2013
# This file is licenced under the terms of the GNU General Public Licence V2 or later
## ENGINES
##########
var run1 = props.globals.getNode("engines/engine[0]/running");
var run2 = props.globals.getNode("engines/engine[1]/running");
var run3 = props.globals.getNode("engines/engine[2]/running");
var run4 = props.globals.getNode("engines/engine[3]/running");
var auto_procedure = props.globals.initNode("b707/autoprocedure",0,"BOOL");
var step = 0;

# startup/shutdown functions
var startup = func
 {
 	auto_procedure.setValue(1);
 	step = 1;
 	screen.log.write("Have a look on engineers panel - External power pluged-in ", 1, 1, 1);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
 	setprop("b707/generator/gen-bus-tie[0]", 0);
	setprop("b707/generator/gen-bus-tie[1]", 0);
	setprop("b707/generator/gen-bus-tie[2]", 0);
	setprop("b707/generator/gen-bus-tie[3]", 0);
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
 	toggle_switch2();
 	
	# External Power Unit / see green lights
 	settimer( func{
 	  if(step == 1 and auto_procedure.getValue()){
	 		setprop("b707/external-power-connected", 1);
			toggle_switch3();
			step = 2;
		}else{
			step = 0;
			screen.log.write(" Problems with cutoff/bus-tie or fuel system - startup interrupted ", 1, 0, 0);
		}
	}, 1.0);
	 	
 	# Battery
 	settimer( func{
		if(step == 2 and auto_procedure.getValue()){
			setprop("b707/batt-cover", 1);
			toggle_switch3();
			step = 3;
		}else{
			step = 0;
			screen.log.write(" External power problem - startup interrupted ", 1, 0, 0);
		}
	}, 1.0);
 	settimer( func{
		if(step == 3 and auto_procedure.getValue()){
	 		setprop("b707/battery-switch", 1);
			toggle_switch3();
			step = 4;
		}else{
			step = 0;
			screen.log.write(" Battery cover is broken - startup interrupted ", 1, 0, 0);
		}
	}, 1.5);
 	settimer( func{
		if(step == 4 and auto_procedure.getValue()){
			setprop("b707/batt-cover", 0);
			setprop("b707/apu/off-start-run", 0);
			setprop("b707/generator/gen-drive[4]", 0);
			toggle_switch3();
			step = 5;
		}else{
			step = 0;
			screen.log.write(" Battery switch INOP - startup interrupted ", 1, 0, 0);
		}
	}, 2.0);

	# Volt-Loads-Selector
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 1);
			toggle_switch3();
		}
	}, 3.5);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 2);
			toggle_switch3();
		}
	}, 3.7);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 3);
			toggle_switch3();
		}
	}, 3.9);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 4);
			toggle_switch3();
		}
	}, 4.1);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 5);
			toggle_switch3();
		}
	}, 4.3);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()){ 
	 		setprop("b707/load-volt-selector", 0);
			toggle_switch3();
		}
	}, 4.5);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/load-volt-selector", 1);
			toggle_switch3();
		}
	}, 4.7);
	
	# Essential-Power-Selector
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ess-power-switch", 1);
			toggle_switch3();
		}
	}, 5.7);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ess-power-switch", 2);
			toggle_switch3();
		}
	}, 5.9);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ess-power-switch", 3);
			toggle_switch3();
		}
	}, 6.1);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ess-power-switch", 4);
			toggle_switch3();
		}
	}, 6.3);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ess-power-switch", 5);
			toggle_switch3();
		}
	}, 6.5);

	# AC-Paralleling-Selector
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 1);
			toggle_switch3();
		}
	}, 7.5);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 2);
			toggle_switch3();
		}
	}, 7.7);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 3);
			toggle_switch3();
		}
	}, 7.9);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 4);
			toggle_switch3();
		}
	}, 8.1);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 5);
			toggle_switch3();
		}
	}, 8.3);
 	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
	 		setprop("b707/ac/ac-para-select", 6);
			toggle_switch3();
		}
	}, 8.5);

	# Gen Drive
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[0]", 1);
			toggle_switch3();
		}
	}, 9.0);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[1]", 1);
			toggle_switch3();
		}
	}, 9.2);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[2]", 1);
			toggle_switch3();
		}
	}, 9.4);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[3]", 1);
			toggle_switch3();
		}
	}, 9.6);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive[3]", 1);
			toggle_switch2();
		}
	}, 9.8);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive[2]", 1);
			toggle_switch2();
		}
	},10.0);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive[1]", 1);
			toggle_switch2();
		}
	},10.2);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive[0]", 1);
			toggle_switch2();
		}
	},10.4);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[0]", 0);
			toggle_switch3();
		}
	},10.6);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[1]", 0);
			toggle_switch3();
		}
	},10.8);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[2]", 0);
			toggle_switch3();
		}
	},11.0);
	settimer( func{
	 	if(step == 5 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-drive-cover[3]", 0);
			toggle_switch3();
			step = 6;
		}
	},11.2);

	# external power to Power Bus Tie (sync bus)
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/ground-connect", 1);
			toggle_switch2();
		}else{
			step = 0;
			screen.log.write(" No External Power Unit found on bus - startup interrupted ", 1, 0, 0);
		}
	},12.0);
	
	# Gen Control
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[0]", 1);
			toggle_switch3();
		}
	},12.4);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[1]", 1);
			toggle_switch3();
		}
	},12.6);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[2]", 1);
			toggle_switch3();
		}
	},12.8);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[3]", 1);
			toggle_switch3();
		}
	},13.0);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control[3]", 1);
			toggle_switch2();
		}
	},13.2);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control[2]", 1);
			toggle_switch2();
		}
	},13.4);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control[1]", 1);
			toggle_switch2();
		}
	},13.6);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control[0]", 1);
			toggle_switch2();
		}
	},13.8);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[0]", 0);
			toggle_switch3();
		}
	},14.0);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[1]", 0);
			toggle_switch3();
		}
	},14.2);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[2]", 0);
			toggle_switch3();
		}
	},14.4);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-control-cover[3]", 0);
			toggle_switch3();
		}
	},14.6);
	
	# Gen - Breaker, so engines generator ar ready for start the engine
	settimer( func{
		if(step == 6 and auto_procedure.getValue()){
			setprop("b707/generator/gen-breaker[3]", 1);
			toggle_switch2();
		}
	},14.8);
	settimer( func{
		if(step == 6 and auto_procedure.getValue()){
			setprop("b707/generator/gen-breaker[2]", 1);
			toggle_switch2();
		}
	},15.0);
	settimer( func{
		if(step == 6 and auto_procedure.getValue()){
			setprop("b707/generator/gen-breaker[1]", 1);
			toggle_switch2();
		}
	},15.2);
	settimer( func{
		if(step == 6 and auto_procedure.getValue()){
			setprop("b707/generator/gen-breaker[0]", 1);
			toggle_switch2();
		}
	},15.4);
	
	# Gen bus-tie
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[0]", 1);
			toggle_switch3();
		}
	},16.0);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[1]", 1);
			toggle_switch3();
		}
	},16.2);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[2]", 1);
			toggle_switch3();
		}
	},16.4);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[3]", 1);
			toggle_switch3();
		}
	},16.6);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie[3]", 1);
			toggle_switch2();
		}
	},16.8);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie[2]", 1);
			toggle_switch2();
		}
	},17.0);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie[1]", 1);
			toggle_switch2();
		}
	},17.2);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie[0]", 1);
			toggle_switch2();
		}
	},17.4);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[0]", 0);
			toggle_switch3();
		}
	},17.6);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[1]", 0);
			toggle_switch3();
		}
	},17.8);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[2]", 0);
			toggle_switch3();
		}
	},18.0);
	settimer( func{
	 	if(step == 6 and auto_procedure.getValue()) {
			setprop("b707/generator/gen-bus-tie-cover[3]", 0);
			toggle_switch3();
			screen.log.write("Look down to your throttle levers on center pedestal.", 1, 1, 1);
			step = 8;
		}
	},18.2);

	# throttle levers
	settimer( func{
		if(step == 8 and auto_procedure.getValue()){
		interpolate("controls/engines/engine[0]/throttle", 0.25, 0.4);
		interpolate("controls/engines/engine[1]/throttle", 0.25, 0.4);
		interpolate("controls/engines/engine[2]/throttle", 0.25, 0.4);
		interpolate("controls/engines/engine[3]/throttle", 0.25, 0.4);
		}
	},20.0);
	
	settimer( func{
		if(step == 8 and auto_procedure.getValue()){
			setprop("controls/engines/engine[0]/cutoff", 0);
			toggle_switch2();
		}
	},21.0);	
	settimer( func{
		if(step == 8 and auto_procedure.getValue()){
			setprop("controls/engines/engine[1]/cutoff", 0);
			toggle_switch2();
		}
	},21.5);	
	settimer( func{
		if(step == 8 and auto_procedure.getValue()){
			setprop("controls/engines/engine[2]/cutoff", 0);
			toggle_switch2();
		}
	},22.0);	
	settimer( func{
		if(step == 8 and auto_procedure.getValue()){
			setprop("controls/engines/engine[3]/cutoff", 0);
			toggle_switch2();
			screen.log.write("We continue at the overhead panel.", 1, 1, 1);
			step = 9;
		}
	},22.5);

  # Starter in the overhead panel
	settimer( func{
	  if(step == 9 and auto_procedure.getValue()){
			setprop("b707/start/startercover[2]", 1);
			toggle_switch3();
		}
	},24.0);
	settimer( func{
	  if(step == 9 and auto_procedure.getValue()){
		setprop("controls/engines/engine[2]/starter", 1);
		setprop("controls/engines/engine[2]/cutoff", 1);
		toggle_switch2();
		}else{
			screen.log.write("WARNING: startup interrupted before ENGINE 3 ", 1, 0, 0);
		}
	},24.5);
	settimer(func{
		if(step == 9 and auto_procedure.getValue()){
			setprop("controls/engines/engine[2]/cutoff", 0);
		}
	},25.7);	
	settimer( func{
	  if(step == 9 and auto_procedure.getValue()){
			setprop("b707/start/startercover[2]", 0);
			toggle_switch3();
			step = 10;
		}
	},55.0); # 30 sec per engine

	settimer( func{	  
		if(step == 10 and auto_procedure.getValue()){
			setprop("b707/start/startercover[3]", 1);
			toggle_switch3();
		}
	},55.0);
	settimer( func{
	  if(step == 10 and auto_procedure.getValue() and run3.getBoolValue()){
			setprop("controls/engines/engine[3]/starter", 1);
			setprop("controls/engines/engine[3]/cutoff", 1);
			toggle_switch2();
		}else{
			screen.log.write("WARNING: startup interrupted at ENGINE 3 ", 1, 0, 0);
		}
	},55.5);
	settimer(func{
		if(step == 10 and auto_procedure.getValue()){
			setprop("controls/engines/engine[3]/cutoff", 0);
		}
	},56.7);	
	settimer( func{
	  if(step == 10 and auto_procedure.getValue()){
			setprop("b707/start/startercover[3]", 0);
			toggle_switch3();
			step = 11;
		}
	},85.0); # 30 sec per engine 	
	
	settimer( func{	  
		if(step == 11 and auto_procedure.getValue()){
			setprop("b707/start/startercover[1]", 1);
			toggle_switch3();
		}
	},85.0);
	settimer( func{
	  if(step == 11 and auto_procedure.getValue() and run3.getBoolValue() and run4.getBoolValue()){
			setprop("controls/engines/engine[1]/starter", 1);
			setprop("controls/engines/engine[1]/cutoff", 1);
			toggle_switch2();
		}else{
			screen.log.write("WARNING: startup interrupted at ENGINE 4 ", 1, 0, 0);
		}
	},85.5);
	settimer(func{
		if(step == 11 and auto_procedure.getValue()){
			setprop("controls/engines/engine[1]/cutoff", 0);
		}
	},86.7);	
	settimer( func{
	  if(step == 11 and auto_procedure.getValue()){
			setprop("b707/start/startercover[1]", 0);
			toggle_switch3();
			step = 12;
		}
	},115.0); # 30 sec per engine 

	settimer( func{	  
		if(step == 12 and auto_procedure.getValue()){
			setprop("b707/start/startercover[0]", 1);
			toggle_switch3();
		}
	},117.0);
	settimer( func{
	  if(step == 12 and auto_procedure.getValue() and run2.getBoolValue() and run3.getBoolValue() and run4.getBoolValue()){
			setprop("controls/engines/engine[0]/starter", 1);
			setprop("controls/engines/engine[0]/cutoff", 1);
			toggle_switch2();
		}else{
			screen.log.write("WARNING: startup interrupted at ENGINE 2 ", 1, 0, 0);
		}
	},117.5);
	settimer(func{
		if(step == 12 and auto_procedure.getValue()){
			setprop("controls/engines/engine[0]/cutoff", 0);
		}
	},118.7);	
	settimer( func{
	  if(step == 12 and auto_procedure.getValue()){
			setprop("b707/start/startercover[0]", 0);
			toggle_switch3();
			screen.log.write("Synchronisation of the engines now - have a look to the engineer panel", 1, 1, 1);
			step = 13;
		}
	},147.5); # 30 sec per engine 
   
	# synchronized the generator one and select this engine as ess-pwr
 	settimer( func{		
		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ac/ac-para-select", 1);
			toggle_switch3();
		}
	}, 149.0);

 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			interpolate("b707/generator/gen-freq[0]",400, 1.0);
		}	
	},149.5);
	
 	settimer( func{		
		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ac/ac-para-select", 2);
			toggle_switch3();
		}
	}, 151.0);

 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			interpolate("b707/generator/gen-freq[1]",400, 1.0);
		}	
	},151.5);
	
 	settimer( func{		
		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ac/ac-para-select", 3);
			toggle_switch3();
		}
	}, 152.6);
	
 	settimer( func{		
		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ac/ac-para-select", 4);
			toggle_switch3();
		}
	}, 153.0);

 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			interpolate("b707/generator/gen-freq[2]",400, 1.0);
		}	
	},153.5);
	
 	settimer( func{		
		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ac/ac-para-select", 5);
			toggle_switch3();
		}
	}, 154.6);

 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			interpolate("b707/generator/gen-freq[3]",400, 1.0);
		}	
	},155.0);
	
	# Essential-Power-Selector
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ess-power-switch", 4);
			toggle_switch3();
		}
	},155.5);
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ess-power-switch", 3);
			toggle_switch3();
		}
	},155.7);
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ess-power-switch", 2);
			toggle_switch3();
		}
	},155.9);
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/ess-power-switch", 1);
			toggle_switch3();
		}
	},156.1); 

	# switch generators to the sync bus now
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/generator/gen-bus-tie-cover[0]", 1);
			toggle_switch3();
		}
	}, 156.5);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie[0]", 1);
			toggle_switch2();
		}
	},157.0);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie-cover[0]", 0);
			toggle_switch3();
		}	
	},157.5);
	
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/generator/gen-bus-tie-cover[1]", 1);
			toggle_switch3();
		}
	}, 158.0);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie[1]", 1);
			toggle_switch2();
		}
	},158.5);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie-cover[1]", 0);
			toggle_switch3();
		}	
	},159.0);
	
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/generator/gen-bus-tie-cover[2]", 1);
			toggle_switch3();
		}
	}, 159.5);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie[2]", 1);
			toggle_switch2();
		}
	},160.0);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie-cover[2]", 0);
			toggle_switch3();
		}	
	},160.5);
	
 	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
	 		setprop("b707/generator/gen-bus-tie-cover[3]", 1);
			toggle_switch3();
		}
	}, 161.0);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie[3]", 1);
			toggle_switch2();
		}
	},161.5);
	settimer( func{
 		if(step == 13 and auto_procedure.getValue()){
			setprop("b707/generator/gen-bus-tie-cover[3]", 0);
			toggle_switch3();
			step = 14;
		}	
	},162.0);				

	# external power disconnected Power Bus Tie (sync bus)
	settimer( func{ 		
		if(step == 14 and auto_procedure.getValue()){
			setprop("b707/ground-connect", 0);
			toggle_switch2();
		}
	},163.0);
	
	# plug out
 	settimer( func{ 		
		if(step == 14 and auto_procedure.getValue()){
	 		setprop("b707/external-power-connected", 0);
			toggle_switch3();
		}
	},164.0);
	
	# always after startup
	settimer( func{
				auto_procedure.setValue(0);
			},164.5);
	

	 # lights on 
   if(getprop("sim/time/sun-angle-rad") > 1.55){
   	settimer( func{
   		screen.log.write("Switch lighting in the overhead panel.", 1, 1, 1);
			setprop("controls/lighting/beacon", 1);
			toggle_switch2();
		},166.5);
   	settimer( func{
			setprop("controls/lighting/landing-light[0]", 1);
			toggle_switch2();
		},167.5);
   	settimer( func{
			setprop("controls/lighting/landing-light[1]", 1);
			toggle_switch2();
		},168.5);
   	settimer( func{
			setprop("controls/lighting/landing-light[2]", 1);
			toggle_switch2();
		},169.5);
   	settimer( func{
			setprop("controls/lighting/nav-lights", 1);
			toggle_switch2();
		},170.5);
   	settimer( func{
			setprop("controls/lighting/cabin-lights", 1);
			toggle_switch2();
		},171.5);
   	settimer( func{
			interpolate("controls/lighting/cabin-dim", 0.8,0.5);
			toggle_switch2();
		},172.5);
   	settimer( func{
			setprop("controls/lighting/strobe", 1);
			toggle_switch2();
		},173.5);

   }else{
		 	settimer( func{
				setprop("controls/lighting/beacon", 1);
				toggle_switch2();
			},166.5);
		 	settimer( func{
				setprop("controls/lighting/nav-lights", 1);
				toggle_switch2();
			},167.5);   
   }    
		# switch on the FlightRallyeMode
		var frwKnob = getprop("instrumentation/frw/btn-mode");
		if (frwKnob == 0) {
		  setprop("instrumentation/frw/btn-mode",1);
		  b707.frw_mode();
		}
		

 };

var shutdown = func
 {
 	auto_procedure.setValue(1);
	setprop("b707/generator/gen-drive[0]", 1);
	setprop("b707/generator/gen-drive[1]", 1);
	setprop("b707/generator/gen-drive[2]", 1);
	setprop("b707/generator/gen-drive[3]", 1);
	setprop("b707/generator/gen-drive[4]", 1);
 	setprop("b707/generator/gen-bus-tie[0]", 0);
	setprop("b707/generator/gen-bus-tie[1]", 0);
	setprop("b707/generator/gen-bus-tie[2]", 0);
	setprop("b707/generator/gen-bus-tie[3]", 0);				
	setprop("/b707/generator/gen-breaker[0]", 0);			
	setprop("/b707/generator/gen-breaker[1]", 0);			
	setprop("/b707/generator/gen-breaker[2]", 0);			
	setprop("/b707/generator/gen-breaker[3]", 0);
 	setprop("b707/generator/gen-control[0]", 0);
	setprop("b707/generator/gen-control[1]", 0);
	setprop("b707/generator/gen-control[2]", 0);
	setprop("b707/generator/gen-control[3]", 0);
 	setprop("b707/generator/gen-freq[0]", 0);
	setprop("b707/generator/gen-freq[1]", 0);
	setprop("b707/generator/gen-freq[2]", 0);
	setprop("b707/generator/gen-freq[3]", 0);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
	setprop("/controls/wiper/degrees",0);
	setprop("b707/apu/off-start-run", 0);
	
	settimer( func{
				auto_procedure.setValue(0);
			},1.0);
			
	screen.log.write("The Aircraft Engines have been shut down.", 1, 1, 1);
 };

# listener to activate these functions accordingly
setlistener("sim/model/start-idling", func(idle)
 {
 var autorun = idle.getBoolValue();
 
 if (autorun and !run1.getBoolValue() and !run2.getBoolValue() and !run3.getBoolValue() and !run4.getBoolValue())
  {
  startup();
  }
 else
  {
  shutdown();
  }
 }, 0, 0);
 
## START PROCEDURE ON MAIN SWITCHES ###
#######################################
var starter = func(nr)
 {
 	var s_bat = getprop("b707/battery-switch") or 0;
	var s_ext_con = getprop("b707/external-power-connected") or 0;
	var s_ess_pwr = getprop("b707/ess-power-switch") or 0;
	var s_ess_bus = getprop("b707/ess-bus") or 0;
	var s_ground_c = getprop("b707/ground-connect") or 0;
	var s_par_sel = getprop("b707/ac/ac-para-select") or 0;
	var s_apu_start = getprop("b707/apu/off-start-run") or 0;
	var s_apu_gen = getprop("b707/generator/gen-drive[4]") or 0;			
	var s_bus_tie = getprop("/b707/generator/gen-bus-tie["~nr~"]") or 0;
	var s_gen_bre = getprop("/b707/generator/gen-breaker["~nr~"]") or 0;
	
	if(s_bat and s_ess_bus > 20 and s_gen_bre and s_bus_tie and 
			((s_ext_con and s_ess_pwr == 5 and s_ground_c == 1) or
		 	 ( s_ess_pwr == 0 and s_apu_start == 2 and s_apu_gen))
		){
	
			# not supported the fuel system for the moment
			setprop("consumables/fuel/tank[0]/selected", 1);
			setprop("consumables/fuel/tank[2]/selected", 1);
			setprop("consumables/fuel/tank[1]/selected", 1);
			setprop("controls/engines/engine["~nr~"]/starter", 0);
			setprop("controls/engines/engine["~nr~"]/cutoff", 1);
			setprop("controls/engines/engine["~nr~"]/starter", 1);
			setprop("b707/generator/gen-freq["~nr~"]", b707.my_rand(384,418));
			settimer(func
			{
				setprop("controls/engines/engine["~nr~"]/cutoff", 0);
			}, 1.2);
	
	}else{
		setprop("controls/engines/engine["~nr~"]/starter", 0);
	}
		
};

setlistener("b707/start/startercover[2]", func(open)
 {
 	var open = open.getBoolValue();
 	var s_bat = getprop("b707/battery-switch") or 0;
	var s_ext_con = getprop("b707/external-power-connected") or 0;
	var s_ess_pwr = getprop("b707/ess-power-switch") or 0;
	var s_ess_bus = getprop("b707/ess-bus") or 0;
	var s_ground_c = getprop("b707/ground-connect") or 0;
	var s_par_sel = getprop("b707/ac/ac-para-select") or 0;
	var s_apu_start = getprop("b707/apu/off-start-run") or 0;
	var s_apu_gen = getprop("b707/generator/gen-drive[4]") or 0;			
	var s_bus_tie = getprop("/b707/generator/gen-bus-tie[2]") or 0;
	var s_gen_bre = getprop("/b707/generator/gen-breaker[2]") or 0;
	
	if(open and s_bat and s_ess_bus > 20 and s_gen_bre and s_bus_tie and 
			((s_ext_con and s_ess_pwr == 5 and s_ground_c == 1) or
		 	 ( s_ess_pwr == 0 and s_apu_start == 2 and s_apu_gen))
		){
	 setprop("controls/engines/engine[2]/msg", 1);
	}
 }, 0, 0); 

setlistener("controls/engines/engine[0]/starter", func
 {
 	if(!run1.getBoolValue()){
	 starter(0);
	}
 }, 0, 0);
 
setlistener("controls/engines/engine[1]/starter", func
 {

 	if(!run2.getBoolValue()){
	 starter(1);
	}
 }, 0, 0);
 
setlistener("controls/engines/engine[2]/starter", func
 {
 	if(!run3.getBoolValue()){
	 starter(2);
	}
 }, 0, 0); 
 
setlistener("controls/engines/engine[3]/starter", func
 {
 	if(!run4.getBoolValue()){
	 starter(3);
	}
 }, 0, 0);

setlistener("engines/engine[0]/running", func
 {
 	if(run1.getBoolValue()){
	 setprop("controls/engines/msg", 2);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0);
 
setlistener("engines/engine[1]/running", func
 {
 	if(run2.getBoolValue()){
	 setprop("controls/engines/engine[0]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0);
 
setlistener("engines/engine[2]/running", func
 {
 	if(run3.getBoolValue()){
	 setprop("controls/engines/engine[3]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0); 
 
setlistener("engines/engine[3]/running", func
 {
 	if(run4.getBoolValue()){
	 setprop("controls/engines/engine[1]/msg", 1);
	}else{
	 setprop("controls/engines/engine[0]/msg", 0);
	 setprop("controls/engines/engine[1]/msg", 0);
	 setprop("controls/engines/engine[2]/msg", 0);
	 setprop("controls/engines/engine[3]/msg", 0);
	 setprop("controls/engines/msg", 0);
	}
 }, 0, 0);
 
## GEAR
#######

# prevent retraction of the landing gear when any of the wheels are compressed
setlistener("controls/gear/gear-down", func
 {
 var down = props.globals.getNode("controls/gear/gear-down").getBoolValue();
 if (!down and (getprop("gear/gear[0]/wow") or getprop("gear/gear[1]/wow") or getprop("gear/gear[2]/wow")))
  {
  props.globals.getNode("controls/gear/gear-down").setBoolValue(1);
  }
 });

var toggle_switch2 = func{

	if(getprop("/sim/sound/switch2") == 1){
  	 setprop("/sim/sound/switch2", 0); 
  }else{
  	 setprop("/sim/sound/switch2", 1);
  }

}

var toggle_switch3 = func{

	if(getprop("/sim/sound/switch3") == 1){
  	 setprop("/sim/sound/switch3", 0); 
  }else{
  	 setprop("/sim/sound/switch3", 1);
  }

}


######################## short Startup for testflight #################################

var short_startup = func
 {
	setprop("consumables/fuel/tank[0]/selected", 1);
	setprop("consumables/fuel/tank[2]/selected", 1);
	setprop("consumables/fuel/tank[1]/selected", 1);
 	setprop("b707/battery-switch", 1);
 	setprop("b707/apu/off-start-run", 0);
	setprop("b707/generator/gen-drive[4]", 0);
	setprop("b707/load-volt-selector", 1);
	setprop("b707/external-power-connected", 1);
	setprop("b707/ground-connect", 1);
	setprop("b707/ess-power-switch", 5);
	setprop("b707/ac/ac-para-select", 5);
	setprop("b707/ess-bus", 28);
	setprop("b707/generator/gen-drive[0]", 1);
	setprop("b707/generator/gen-drive[1]", 1);
	setprop("b707/generator/gen-drive[2]", 1);
	setprop("b707/generator/gen-drive[3]", 1);
 	setprop("b707/generator/gen-bus-tie[0]", 1);
	setprop("b707/generator/gen-bus-tie[1]", 1);
	setprop("b707/generator/gen-bus-tie[2]", 1);
	setprop("b707/generator/gen-bus-tie[3]", 1);
	setprop("b707/generator/gen-breaker[0]", 1);
	setprop("b707/generator/gen-breaker[1]", 1);
	setprop("b707/generator/gen-breaker[2]", 1);
	setprop("b707/generator/gen-breaker[3]", 1);
	setprop("b707/generator/gen-control[0]", 1);
	setprop("b707/generator/gen-control[1]", 1);
	setprop("b707/generator/gen-control[2]", 1);
	setprop("b707/generator/gen-control[3]", 1);

	setprop("controls/engines/engine[0]/throttle", 0.25);
	setprop("controls/engines/engine[1]/throttle", 0.25);
	setprop("controls/engines/engine[2]/throttle", 0.25);
	setprop("controls/engines/engine[3]/throttle", 0.25);
	setprop("controls/engines/engine[0]/cutoff", 1);
	setprop("controls/engines/engine[1]/cutoff", 1);
	setprop("controls/engines/engine[2]/cutoff", 1);
	setprop("controls/engines/engine[3]/cutoff", 1);
	setprop("controls/engines/engine[0]/starter", 1);
	setprop("controls/engines/engine[1]/starter", 1);
	setprop("controls/engines/engine[2]/starter", 1);
	setprop("controls/engines/engine[3]/starter", 1);

   settimer(func
    {
			setprop("controls/engines/engine[0]/cutoff", 0);
			setprop("controls/engines/engine[1]/cutoff", 0);
			setprop("controls/engines/engine[2]/cutoff", 0);
			setprop("controls/engines/engine[3]/cutoff", 0);
			setprop("b707/generator/gen-freq[0]", 400);
			setprop("b707/generator/gen-freq[1]", 400);
			setprop("b707/generator/gen-freq[2]", 400);
			setprop("b707/generator/gen-freq[3]", 400);
    }, 1);
    

   settimer(func
    {
			setprop("b707/ess-power-switch", 1);
			setprop("b707/ac/ac-para-select", 1);
    }, 30);

		
 };

 
