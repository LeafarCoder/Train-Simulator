import static java.awt.event.KeyEvent.*;

// ######################################################################
// ######################### Global variables ###########################
// ######################################################################

char lastKeyPressed;

Menu menu;
Console console;
ParkingBreakControl parkingBreakControl;
Train train;
GraphicsControl graphicsControl;




// ######################################################################
// ################################ Setup ###############################
// ######################################################################

void setup(){
  surface.setVisible(false);
  size(100,100);
  
  // Declare objects
  console = new Console();
  parkingBreakControl = new ParkingBreakControl();
  train = new Train();
  graphicsControl = new GraphicsControl(1200, 800);
  
  // Tie console for all controlers
  train.setConsole(console);
  parkingBreakControl.setConsole(console);
  
  // Tie Train and ParkingBreakControl objects to GraphicsControl
  graphicsControl.setTrain(train);
  graphicsControl.setParkingBreakControl(parkingBreakControl);
  
  // Give initial information
  console.addEntry("Parking Break Simulator initialized!");
  console.addEntry("For help press H.");

}

// ######################################################################
// ############################## GRAPHICS ##############################
// ######################################################################

void draw(){

  // CONTROL SIMULATION
  controlSimulationFlow();
  
  // DISPLAY GRAPHICS
  graphicsControl.displayGraphics();

}


// ######################################################################
// ############################## CONTROL ###############################
// ######################################################################

private void controlSimulationFlow(){
  
  // ---------------------------- CONTROL PARKING BREAK ----------------------------
  // Check for break release by WTB UIC
  parkingBreakControl.parkingBrakeReleaseEnabledByWTBUIC(parkingBreakControl.OperationModeWTBUIC, train.getBreakPipePressure());
  // Check for break release by HW
  parkingBreakControl.parkingBreakReleaseEnabledByHWActivation(train.getCab1ParkingBreakReleasePressed(), train.getCab2ParkingBreakReleasePressed(), train.getCabActive(), parkingBreakControl.parkingBrakeReleaseEnabledByWTBUIC);
  
  // after knowing what to do with the Parking break tell the actuator to do something (break or release)
  parkingBreakControl.sendCommandToHW();
  
  // Read real hardware state (feedback)
  parkingBreakControl.feedbackEnableReleaseByHW = parkingBreakControl.parkingBreakRealHWState;

  parkingBreakControl.stuckOnHWEnablingParkingBrakeRelease(train.getVehicleState(), parkingBreakControl.parkingBreakReleaseEnabledByHWActivation, parkingBreakControl.feedbackEnableReleaseByHW);
  parkingBreakControl.stuckOffHWEnablingParkingBrakeRelease(train.getVehicleState(), parkingBreakControl.parkingBreakReleaseEnabledByHWActivation, parkingBreakControl.feedbackEnableReleaseByHW);

  parkingBreakControl.stuckOnHWClearance(parkingBreakControl.parkingBreakReleaseEnabledByHWActivation, parkingBreakControl.feedbackEnableReleaseByHW);
  parkingBreakControl.stuckOffHWClearance(parkingBreakControl.parkingBreakReleaseEnabledByHWActivation, parkingBreakControl.feedbackEnableReleaseByHW);
  
  if(!train.isStopped() && !parkingBreakControl.feedbackEnableReleaseByHW){
    if(!train.emergencyBreaksActivated){
    train.setEmergencyParkingBreaks(true);
    }
  }
  
  // ---------------------------- CONTROL PARKING BREAK (END) ----------------------------
  
  // ---------------------------- CONTROL TRAIN ----------------------------
  train.update();
  // ---------------------------- CONTROL TRAIN (END) ----------------------------
  
}


// ######################################################################
// ########################## AUX FUNCTIONS #############################
// ######################################################################



private void checkForceStuck(){
  if(parkingBreakControl.parkingBreakReleaseEnabledByHWActivation && random(1) < parkingBreakControl.stuckOnProb){
    parkingBreakControl.forceStuckOn = true;
  }
  if(!parkingBreakControl.parkingBreakReleaseEnabledByHWActivation && random(1) < parkingBreakControl.stuckOffProb){
    parkingBreakControl.forceStuckOff = true;
  }
  if(parkingBreakControl.forceStuckOn && parkingBreakControl.forceStuckOff){
    parkingBreakControl.forceStuckOff = false;
    parkingBreakControl.forceStuckOn = false;
  }
}

// ######################################################################
// ########################### KEY PRESSED ##############################
// ######################################################################

void keyPressed() {
  
  if(lastKeyPressed != key){
    if(key == '1'){
      if(!train.checkOperability() || !train.isStopped()){
        return;
      }
      train.setCab1ParkingBreakReleasePressed(!train.getCab1ParkingBreakReleasePressed());
      if(train.getCab1ParkingBreakReleasePressed()){
        console.addEntry("Cabine 1 parking brake button pressed!");
      }else{
        console.addEntry("Cabine 1 parking brake button released!");
      }
      checkForceStuck();
    }
    
    if(key == '2'){
      if(!train.checkOperability() || !train.isStopped()){
        return;
      }
      train.setCab2ParkingBreakReleasePressed(!train.getCab2ParkingBreakReleasePressed());
      if(train.getCab2ParkingBreakReleasePressed()){
        console.addEntry("Cabine 2 parking brake button pressed!");
      }else{
        console.addEntry("Cabine 2 parking brake button released!");
      }
      checkForceStuck();
    }
    
    if(key == 'A' || key == 'a'){
      if(!train.checkOperability() || !train.isStopped()){
        return;
      }
      train.setCabActive(!train.getCabActive());
      if(train.getCabActive()){
        console.addEntry("Cabine line #11 activated!");
      }else{
        console.addEntry("Cabine line #11 de-activated!");
      }
      checkForceStuck();
    }
    
    if(key == 'R' || key == 'r'){
      // [R]eset force stuck ON/OFF
      parkingBreakControl.forceStuckOn = false;
      parkingBreakControl.forceStuckOff = false;
      parkingBreakControl.stuckOFF = false;
      parkingBreakControl.stuckON = false;
    }
    
    if(key == 'V' || key == 'v'){
      if(!train.isStopped()){
        console.addEntry("Vehicle cannot be turned OFF while functioning!");
        return;
      }
      
      if(parkingBreakControl.feedbackEnableReleaseByHW){
        console.addEntry("Vehicle is not parked yet. Activate the parking breaks before shutting down the vehicle!");
        return;
      }
      
      train.setVehicleState(!train.getVehicleState());
      checkForceStuck();
    }
    
    if(key == 'O' || key == 'o'){
      if(!train.checkOperability()){
        return;
      }
      parkingBreakControl.OperationModeWTBUIC = !parkingBreakControl.OperationModeWTBUIC;
      if(parkingBreakControl.OperationModeWTBUIC){
        console.addEntry("Operation Mode WTB UIC activated!");
      }else{
        console.addEntry("Operation Mode WTB UIC de-activated!");
      }
      if(train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold){
        checkForceStuck();
      }
      
    }
    
    if(key == 'H' || key == 'h'){
      graphicsControl.showHelp = !graphicsControl.showHelp;
      graphicsControl.displayGraphics();
      if(graphicsControl.showHelp){
        noLoop();
      }else{
        loop();
      }
    }
    
    if(key == ' '){
      train.setEmergencyParkingBreaks(true);
    }
    
    if(key == '+'){
      train.changeGlobalResizeFactor('+');
    }

    if(key == '-'){
      train.changeGlobalResizeFactor('-');
    }
    
    if(key == CODED){
      if(keyCode == UP){
        if(!parkingBreakControl.feedbackEnableReleaseByHW){
          console.addEntry("Unable to accelerate with the parking break enabled! De-activate it first.");
          return;
        }
        train.gearUp();
      }
      
      if(keyCode == DOWN){
        if(!parkingBreakControl.feedbackEnableReleaseByHW){
          console.addEntry("Unable to accelerate with the parking break enabled! De-activate it first.");
          return;
        }
        train.gearDown();
      }
      
      if(keyCode == VK_F1){
        graphicsControl.showConsole = !graphicsControl.showConsole;
      }
      if(keyCode == VK_F2){
        graphicsControl.showSchematics = !graphicsControl.showSchematics;
      }
      if(keyCode == VK_F3){
        graphicsControl.showParkingBreakVariables = !graphicsControl.showParkingBreakVariables;
      }
      if(keyCode == VK_F4){
        graphicsControl.showBackground = !graphicsControl.showBackground;
      }
      if(keyCode == VK_F5){
        graphicsControl.showTrain = !graphicsControl.showTrain;
      }
      
    }

    lastKeyPressed = key;
  }
  
    if(key == 'Q' || key == 'q'){
      if(!train.checkOperability()){
        return;
      }
      float incr = 0.05;
      // check pressure sensor state change
      if(train.getBreakPipePressure() < parkingBreakControl.pressureThreshold && train.getBreakPipePressure() + incr >= parkingBreakControl.pressureThreshold && parkingBreakControl.OperationModeWTBUIC){
        checkForceStuck();
      }
      train.addBreakPipePressure_zero(incr);
  }
  
  if(key == 'W' || key == 'w'){
    if(!train.checkOperability()){
      return;
    }
    float decr = -0.05;
    // check pressure sensor state change
    if(train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold && train.getBreakPipePressure() + decr < parkingBreakControl.pressureThreshold && parkingBreakControl.OperationModeWTBUIC){
      checkForceStuck();
    }
    train.addBreakPipePressure_zero(decr);
  }
  
}

// ######################################################################
// ########################### KEY RELEASED #############################
// ######################################################################

void keyReleased() {
  //if(key == '1'){
  //  train.setCab1ParkingBreakReleasePressed(false);
  //  checkForceStuck();
  //}
  
  //if(key == '2'){
  //  train.setCab2ParkingBreakReleasePressed(false);
  //  checkForceStuck();
  //}
  if(key == ' '){
      train.setEmergencyParkingBreaks(false);
  }
    
  lastKeyPressed = '~';
}
