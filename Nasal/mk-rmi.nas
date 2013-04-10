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
      needle1 = getprop("/instrumentation/nav[0]/heading-deg"); 
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
      needle2 = getprop("/instrumentation/nav[1]/heading-deg"); 
    }
  }

# Save Needle settings

  interpolate("/instrumentation/rmi/rmi-needle[0]/value", needle1, 1);
  interpolate("/instrumentation/rmi/rmi-needle[1]/value", needle2, 1);

# RMI updated 2 times / sec

  settimer(updateRMI, 1);
}


var adf_false_tick = func {
  setprop("/instrumentation/adf[0]/in-range", 0);
  setprop("/instrumentation/adf[1]/in-range", 0);
  settimer(adf_false_tick, 4);
}

updateRMI();
adf_false_tick();
