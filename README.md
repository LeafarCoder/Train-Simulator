# Train-Simulator

This project simulates the parking break system of a train.

It was developed during my summer internship at Critical Software during the week at the HIS department (High Integrity Systems).


Last update: 24/08/2019


## Quick walkthrough:

To get started turn the vehicle ON [press V]. This enables the control of the parking break system.

To release the parking break multiple options are available: eigther press the release parking break button at cabine 1 [press 1] or cabine 2 [press 2] (if this cabine is available). Alternatively, remotely connect to the train through Line #11 and release the parking breaks. One other way to do it is to enable the WTB UIC communication protocol between cars and then increase the parking break pipe pressure.

After the parking breaks are released the train can be accelerated [press the UP arrow] or decelerated [press the DOWN arrow]. While moving the emergency breaks can also be activated [press the SPACE BAR].

There is a certain probability that the parking break gets stuck (eighter ON or OFF) due to harware failure. This is simulated with the variables *stuckOnProb* and *stuckOffProb* in the parkingBreakControl class. To unstuck it just [press R].


## Simulator controls:

### GRAPHIC CONTROLS:
* [F1] Show/Hide the Console
* [F2] Show/Hide the Parking Break schematic
* [F3] Show/Hide the Parking Break variables' state
* [F4] Show/Hide the background image
* [F5] Show/Hide the train
* [+]  Increase train size
* [-]  Decrease train size

### PARKING BREAK CONTROLS:
* [1] Press cabine 1 parking break release button
* [2] Press cabine 2 parking break release button
* [A] Activate line #11 (remote)
* [R] Resets the breaks' hardware in case it stucks
* [Q] Increases pressure on breaking pipe
* [W] Decreases pressure on breaking pipe
 
 ### TRAIN CONTROLS:
* [V] Turn the vehicle ON/OFF
* [O] Turn operation mode WTB UIC ON/OFF
* [UP arrow] Increase speed gear
* [DOWN arrow] Decrease speed gear
* [SPACE BAR] Activate the emergency breaks

### HELP
* [H] Shows/Hides help menu
