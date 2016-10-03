Boeing 707-320B Advanced or 707-320C
====================================

This is a model of the Boeing 707-320B Advanced or 707-320C. It is based
on the 707 model made by Marc Kraus, who improved the original model, created
by Innis Cunningham, by adding new instruments, textures, and a JSBSim FDM.
The original Bendix PB-20 autopilot was written by Markus Bulik.

The model on which it is based uses the wing from the 707-320B Advanced or
707-320C, but used the Pratt and Whitney JT4A or Rolls-Royce Conway 508 from
the 707-320 aircraft, which is incorrect. Both engines have been removed
and replaced with the Pratt and Whitney JT3D-3 engine.

Multiplayer aerial refueling
----------------------------

This model has a boom and drogues that can track compatible aircraft. This means
that the boom and drogues will move and retract or extend in order to give
the appearance that the boom or drogue is actually connected to the aircraft.

For more information, see the [FlightGear wiki][url-fg-wiki-aar].

Dependencies
------------

Due to use of the ALS glass effect, FlightGear 2016.1 or higher is required.
Additionally, the [ExpansionPack][url-fg-expansion-pack] aircraft is required
in order to hear the thunder of lightning, see the drogues, receiver tracking
by drogues and boom, and to be able to receive damage.

Installation
------------

1. Rename this directory to `707` and place it in FlightGear's `Aircraft`
   directory.

2. Install the [ExpansionPack][url-fg-expansion-pack] aircraft.

New features
------------

* Exterior glass reflection

* ALS glass effect for rain and frost

* Thunder sounds

* Boomer can fully move the refueling boom. Boom will automatically 'snap'
  to any aircraft that is within range and has defined a fuel receptacle in
  its model XML file

* When a receiving aircraft disconnects from the boom or drogue, the tanker
  will publish the duration (in minutes and seconds) of contact in a text
  message

* Moving drogues

* Can be damaged by missiles

* ALS procedural lights for navigation lights and Pilot Director Lights

* Zoom in or out using mouse scrollwheel, up to a distance of 300 meters

  [url-fg-expansion-pack]: https://github.com/onox/ExpansionPack
  [url-fg-wiki-aar]: http://wiki.flightgear.org/Multiplayer_Aerial_refueling
