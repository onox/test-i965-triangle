# RMI Driver
# Nasal code to calculate RMI needle deflections based on mode (VOR/ADF)
# and beacon range. Simplifies RMI animations.
#
# Reads two custom properties:
#   /instrumentation/rmi/rmi-needle[0]/switch		(values 'vor'|'adf', default 'vor')
#   /instrumentation/rmi/rmi-needle[1]/switch		(values 'vor'|'adf', default 'vor')
#
# These should be set by cockpit switches to control the two RMI needles.
#
# Function writes to two custom properties:
#  /instrumentation/rmi/rmi-needle[0]/value
#  /instrumentation/rmi/rmi-needle[1]/value
#
# These are read by the RMI instrument animations.
#
#
# Wolfram Gottfried aka 'Yakko'
# Gary Neely aka 'Buckaroo'
# with little changes by Lake of Constance Hangar :: M.Kraus


var updateRMI = func {

# Needle default 'off' or out-of-range positions:

  var needle1 = 90;
  var needle2 = 90;


# If RMI 1 set to ADF (mode 1):

  if (getprop("/instrumentation/rmi/rmi-needle[0]/switch")) {
    if (getprop("/instrumentation/adf[0]/in-range")) {
      needle1 = getprop("/instrumentation/adf[0]/indicated-bearing-deg");
    }
  }

# RMI 1 set to VOR (mode 0):

  else {
    if (getprop("/instrumentation/nav[0]/in-range")) {
      # Needle actual = needle bearing
      needle1 = indiBearingDeg(getprop("/instrumentation/nav[0]/heading-deg"),getprop("/orientation/heading-magnetic-deg")); 
    }
  }

# If RMI 2 set to ADF (mode 1):

  if (getprop("/instrumentation/rmi/rmi-needle[1]/switch")) {
    if (getprop("/instrumentation/adf[1]/in-range")) {
      needle2 = getprop("/instrumentation/adf[1]/indicated-bearing-deg");
    }
  }

# RMI 2 set to VOR (mode 0):

  else {
    if (getprop("/instrumentation/nav[1]/in-range")) {
      # Needle actual = needle bearing
      needle2 = indiBearingDeg(getprop("/instrumentation/nav[1]/heading-deg"),getprop("/orientation/heading-magnetic-deg")); 
    }
  }
  
  if(needle1 > 360) needle1 = needle1 - 360;
  if(needle2 > 360) needle2 = needle2 - 360;
  
  #screen.log.write("needle1 " ~needle1, 1.0, 0.1, 0.1);  
  #screen.log.write("needle2 " ~needle2, 1.0, 0.1, 0.1);
  
# Save Needle settings
  interpolate("/instrumentation/rmi/rmi-needle[0]/value", needle1, 1);
  interpolate("/instrumentation/rmi/rmi-needle[1]/value", needle2, 1);

# RMI updated 1 times / sec

  settimer(updateRMI, 1);
}


var adf_false_tick = func {
  setprop("/instrumentation/adf[0]/in-range", 0);
  setprop("/instrumentation/adf[1]/in-range", 0);
  settimer(adf_false_tick, 6);
}

updateRMI();
adf_false_tick();


############### Show the course correction deg ###################################
var rotation_degree = "/instrumentation/rmi/face-offset";

var mymod = func(x,y){
  var res = x/y;
  var resInt = int(res);
  var resSmall = y * resInt;
  return x - resSmall;
}

var indiBearingDeg = func(a,b){
  var diff = b-a;
  var newAngle = 0.0;
  if(diff > 180)
  {
      newAngle = mymod((diff + 180),360) - 180;
  }
  elsif(diff < -180)
  {
      newAngle = mymod((diff - 180),360) + 180;
  }
  else
  {
      newAngle = mymod(diff, 360);
  }
  return (360 - newAngle);
};

var rmiNavInfo = func (needle_nr) {
    var i = needle_nr - 1;
    #var rdfDeg = getprop(rotation_degree)*360;
    var rdfDeg = getprop(rotation_degree);
    
    var freqSel = getprop("/instrumentation/rmi/rmi-needle["~i~"]/switch"); # 1 = NDB, 0 = VOR or ILS
    var selected_freq = getprop("/instrumentation/nav["~i~"]/frequencies/selected-mhz") or 0;
    var text2 = "";
    if(freqSel == 1){
      var controlRange = getprop("/instrumentation/adf["~i~"]/in-range");
      var text = getprop("/instrumentation/adf["~i~"]/ident");
      if(text == "") text = "ADF "~needle_nr;
    }else{ 
      var controlRange = getprop("/instrumentation/nav["~i~"]/in-range");
      var text = getprop("/instrumentation/nav["~i~"]/nav-id");
      var dmeInRange = getprop("/instrumentation/dme["~i~"]/in-range");
      if(dmeInRange == 1){
        var dmeDistance = int(getprop("/instrumentation/dme["~i~"]/indicated-distance-nm"));
        text2 = "Distance "~dmeDistance~"nm";
      }
    }

    # there is a signal in range
    if (controlRange) {
    
			var newRdfDeg = rdfDeg;
			if (rdfDeg > 180){
				newRdfDeg = abs(360 - rdfDeg);
			}
			headCorrection = int(newRdfDeg);
			
			
			# is the face turn to range between 5 degree + or - of the needle heading?
			var needleDeg = getprop("/instrumentation/rmi/rmi-needle["~i~"]/value") or 0;
			if(needleDeg > 180){
				needleDeg = abs(360 - needleDeg);
			}else{
				needleDeg = needleDeg;
			}
			
			var diff_needle = abs(headCorrection - needleDeg);
			
      # build the heading correction message for the pilot
      mp_msg = "";

			if (diff_needle < 5){
		    if (rdfDeg > 180.5 and rdfDeg < 359.5){
		      mp_msg = text~" -> "~headCorrection~" degree to starboard";
		    }elsif(rdfDeg > 0.5 and rdfDeg < 179.5){
		      mp_msg = text~" -> "~headCorrection~" degree to port";
		    }elsif(rdfDeg >= 179.5 and rdfDeg <= 180.5){
		      mp_msg = text~" on 180 degree";
		    }elsif(rdfDeg >= 359.5 or rdfDeg <= 0.5){
		      mp_msg = text~" is straight ahead.";
		    }
		    
		    if(text2 != ""){
		      mp_msg = mp_msg~ ". " ~text2;
		    }
		    
		  }else{
        mp_msg = "Set first the rmi compass rose to the needle direction for calculation.";
		  }

    }else{
        mp_msg = "Nonviable calculation.";
    }
    
    help_win.write("Needle " ~needle_nr~" calculation: " ~mp_msg); #help_win is set in the mk-707.nas

}
