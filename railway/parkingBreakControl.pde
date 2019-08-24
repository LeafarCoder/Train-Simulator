
class ParkingBreakControl{
  
  
  // ######################################################################
  // ######################### Global variables ###########################
  // ######################################################################


  Console console;
  
  boolean parkingBrakeReleaseEnabledByWTBUIC;
  boolean parkingBreakReleaseEnabledByHWActivation;
  boolean parkingBreakRealHWState;
  boolean feedbackEnableReleaseByHW;
  boolean stuckOFF;
  boolean stuckON;
  
  // TRAXX_I-28038 - Selection of WTB-UIC mode 
  boolean OperationModeWTBUIC;
  
  // pressure threshold (units: bars) as given in TRAXX_I-7083 - BSV_PpHiLimBrPipPrsSwChk
  float pressureThreshold = 3.2;

  // VARIABLES FOR SIMULATION PURPOSES
  // stuck ON/OFF probabilities
  float stuckOnProb = 0.02;
  float stuckOffProb = 0.02;
  // force stuck control variables
  boolean forceStuckOn;
  boolean forceStuckOff;


  ParkingBreakControl(){
    stuckOFF = false;
    stuckON = false;
    
    forceStuckOn = false;
    forceStuckOff = false;
  }

  // ######################################################################
  // ################## Parking Break Control Functions ###################
  // ######################################################################
  
  // Software requirement: TRAXX_I-33330 - Parking Brake Release Enabled by WTB UIC - Monitoring
  public void parkingBrakeReleaseEnabledByWTBUIC(boolean OperationModeWTBUIC, float breakPipePressure){
    // If all conditions are met THEN the parking brake release enable by WTB UIC is active
    parkingBrakeReleaseEnabledByWTBUIC = (OperationModeWTBUIC && (breakPipePressure >= pressureThreshold));
  }
  
  // Software requirement: TRAXX_I-33332 - Parking Brake Release Enable by HW activation - Monitoring
  public void parkingBreakReleaseEnabledByHWActivation(boolean cab1Pressed, boolean cab2Pressed, boolean cabActive, boolean parkingBrakeReleaseEnabledByWTBUIC){
    
    // If all conditions are met THEN enabling release parking brake by HW is active
    parkingBreakReleaseEnabledByHWActivation = (cab1Pressed || cab2Pressed || cabActive || parkingBrakeReleaseEnabledByWTBUIC);
  }
  
  public void stuckOffHWEnablingParkingBrakeRelease(boolean vehicleState, boolean parkingBreakReleaseEnabledByHWActivation, boolean feedbackEnableReleaseByHW){
    if(vehicleState && parkingBreakReleaseEnabledByHWActivation){
      if(!feedbackEnableReleaseByHW){
        if(!stuckOFF){
          stuckOFF = true;
          sendDiagnosticStuckOffMessage();
        }
      }
    }
  }
  
  public void stuckOnHWEnablingParkingBrakeRelease(boolean vehicleOn, boolean parkingBreakReleaseEnabledByHWActivation, boolean feedbackEnableReleaseByHW){
    if(vehicleOn && !parkingBreakReleaseEnabledByHWActivation){
      if(feedbackEnableReleaseByHW){
        if(!stuckON){
          stuckON = true;
          sendDiagnosticStuckOnMessage();
        }
      }
    }
  }
  
  public void stuckOffHWClearance(boolean parkingBreakReleaseEnabledByHWActivation, boolean feedbackEnableReleaseByHW){
    if(parkingBreakReleaseEnabledByHWActivation && feedbackEnableReleaseByHW){
      stuckOFF = false;
    }
  }
  
  public void stuckOnHWClearance(boolean parkingBreakReleaseEnabledByHWActivation, boolean feedbackEnableReleaseByHW){
    if(!parkingBreakReleaseEnabledByHWActivation && !feedbackEnableReleaseByHW){
      stuckON = false;
    }
  }
  
  public void sendDiagnosticStuckOffMessage(){
    if(stuckOFF){
      console.addEntry("Parking brake stuck OFF.");
    }
  }
  
  public void sendDiagnosticStuckOnMessage(){
    if(stuckON){
      console.addEntry("Parking brake stuck ON.");
    }
  }

  // ######################################################################
  // ########################## Aux Functions #############################
  // ######################################################################

  public void setConsole(Console console){
    this.console = console;
  }
  
  public void sendCommandToHW(){
  if(forceStuckOn){
    parkingBreakRealHWState = true;
  }else if(forceStuckOff){
    parkingBreakRealHWState = false;
  }else{
    // if everything is working properly then activation of HW will work
    parkingBreakRealHWState = parkingBreakReleaseEnabledByHWActivation;
  }
}

}
