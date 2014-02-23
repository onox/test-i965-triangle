###############################################################################
##  Nasal for dual control of the Common-Spruce CS 1 over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  For the CS 1, written in January 2012 by Marc Kraus
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/707/Models/707.xml";
var copilot_type = "Aircraft/707/Models/707-PAX.xml";

############################ PROPERTIES MP ###########################
var compressionW      = "sim/multiplay/generic/float[1]";
var rollspeedW        = "sim/multiplay/generic/float[2]";

var l_dual_control    = "dual-control/active";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Pilot section");
  setprop(l_dual_control, 1);

  return [
      ##################################################
      # Map copilot properties to buffer properties

      # copilot to pilot

  ];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}

######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Copilot section");
  setprop(l_dual_control, 1);
  
  setprop("sim/current-view/view-number",8);
  setprop("b707/shake-effect/effect",1);

  return [

      ##################################################
      # Map pilot properties to buffer properties
	  
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[1]"),
                         props.globals.getNode("sim/multiplay/generic/float[1]", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[2]"),
                         props.globals.getNode("sim/multiplay/generic/float[2]", 1))

  ];

}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
