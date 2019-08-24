class Train{

  boolean cab1ParkingBreakReleasePressed;
  boolean cab2ParkingBreakReleasePressed;
  boolean vehicleState;
  boolean emergencyBreaksActivated;
  float breakPipePressure;
  float breakPipePressure_zero;

  // TRAXX_I-32342 - Signal description - TL27Pin
  boolean cabActive;
  
  float global_resize_factor;
  float train_resize_factor;
  float breakSpark_resize_factor;
  PImage train_front_on;
  PImage train_front_off;
  PImage train_pass_1;
  PImage[] break_sparks;
  
  
  int num_pass_cars;
  int num_total_cars;
  boolean back_cab;
  PVector cabs_coords[];
  PVector cabs_vel[];
  int initial_x;

  int speedGear;
  
  int maxGear = 10;
  int minGear = -2;
  
  Console console;
  
  Train(){
    cab1ParkingBreakReleasePressed = false;
    cab2ParkingBreakReleasePressed = false;
    vehicleState = false;
    emergencyBreaksActivated = false;
    breakPipePressure = 2.;
    back_cab = false;
    num_pass_cars = 2;
    speedGear = 0;
    breakPipePressure_zero = 2;

    // resize factor for sprites
    global_resize_factor = 0.7;
    train_resize_factor = 2.5 * global_resize_factor;
    breakSpark_resize_factor = 15 * global_resize_factor;
    
    if(back_cab){
      num_total_cars = num_pass_cars + 2;
      cabs_coords = new PVector[num_total_cars];
      cabs_vel = new PVector[num_total_cars];
    }else{
      num_total_cars = num_pass_cars + 1;
      cabs_coords = new PVector[num_total_cars];
      cabs_vel = new PVector[num_total_cars];
    }
    
    initial_x = 0;
    loadSprites(initial_x);
    
    cabs_vel[0] = new PVector(0, 0);
    
    for(int i = 1; i < num_total_cars; i++){
      cabs_coords[i] = new PVector(initial_x - (i * train_pass_1.width), height - train_pass_1.height);
      cabs_vel[i] = new PVector(0, 0);
    }
    
    
  }
  
  public boolean getCab1ParkingBreakReleasePressed(){
    return cab1ParkingBreakReleasePressed;
  }
  
  public boolean getCab2ParkingBreakReleasePressed(){
    return cab2ParkingBreakReleasePressed;
  }
  
  public boolean getVehicleState(){
    return vehicleState;
  }
  
  public boolean getCabActive(){
    return cabActive;
  }
  
  public float getBreakPipePressure(){
    return breakPipePressure;
  }
  
  public void addBreakPipePressure_zero(float add){
    breakPipePressure_zero += add;
    if(breakPipePressure_zero < 0){
      breakPipePressure_zero = 0;
    }
    if(breakPipePressure_zero >= 5){
      breakPipePressure_zero = 5;
    }
  }
  
  private void setBreakPipePressure(float value){
    breakPipePressure = value;
    if(getBreakPipePressure() > 5){
      breakPipePressure = 5;
    }
    if(getBreakPipePressure() < 0){
      breakPipePressure = 0;
    }
  }
  
  public void setCab1ParkingBreakReleasePressed(boolean cab1Pressed){
    cab1ParkingBreakReleasePressed = cab1Pressed;
  }
  
  public void setCab2ParkingBreakReleasePressed(boolean cab2Pressed){
    this.cab2ParkingBreakReleasePressed = cab2Pressed;
  }
  
  public void setVehicleState(boolean vehicleState){
    this.vehicleState = vehicleState;
    
    if(!train.getVehicleState()){
      console.addEntry("Vehicle has been switched OFF!");
    }else{
      console.addEntry("Vehicle has been switched ON!");
    }
      
    if(!vehicleState){
      this.cab1ParkingBreakReleasePressed = false;
      this.cab2ParkingBreakReleasePressed = false;
      this.cabActive = false;
    }
  }
  
  public void setCabActive(boolean cabActive){
    this.cabActive = cabActive;
  }

  public void setConsole(Console console){
    this.console = console;
  }
  
  private boolean checkOperability(){
    if(!vehicleState){
      console.addEntry("Train cannot be operated while the vehicle is switched OFF!");
    }
    
    return (vehicleState);
  }
  
  public boolean isStopped(){
    return cabs_vel[0].x == 0;
  }
  
  public void gearDown(){
    if(!checkOperability()){
      return;
    }
    
    if(emergencyBreaksActivated){
      return;
    }
    if(speedGear <= minGear){
      speedGear = minGear;
    }else{
      speedGear--;
    }
  }
  
  public void gearUp(){
    if(!checkOperability()){
      return;
    }
    if(emergencyBreaksActivated){
      return;
    }
    if(speedGear >= maxGear){
      speedGear = maxGear;
    }else{
      speedGear++;
    }
  }
  
  private PImage resizeImage(PImage img, float r_f){
    img.resize(floor(img.width/r_f), floor(img.height/r_f));
    return img;
  }
  
  public void setEmergencyParkingBreaks(boolean set){
    emergencyBreaksActivated = set;
  }
  
  private void drawCab(PImage img, float x, float y, boolean frontCab){
    // draw cab
    image(img, x, y);
    
    // draw breeaking sparks
    if(emergencyBreaksActivated && abs(cabs_vel[0].x) > 0.5){
      // get direction in which train is traveling (1: forward; -1: backwards)
      int dir = int(cabs_vel[0].x / abs(cabs_vel[0].x));
      // cab width
      int cw = img.width;
      // get copy of current sprite
      PImage sprite = break_sparks[frameCount%break_sparks.length].copy();
      // get sprite height and width
      int sw = break_sparks[0].width;
      int sh = break_sparks[0].height;
      
      int h = int(y + img.height - (0.5 - 0.20)*sh);
      int xw = dir*int((-0.5 + 0.8)*sw); 
      
      pushMatrix();
      scale(dir,1);
      if(frontCab){
        drawBreakSparks(sprite, dir*(x + cw*0.08 - xw),  h);
        drawBreakSparks(sprite, dir*(x + cw*0.2 - xw), h);
        drawBreakSparks(sprite, dir*(x + cw*0.7 - xw), h);
        drawBreakSparks(sprite, dir*(x + cw*0.84 - xw), h);
      }else{
        drawBreakSparks(sprite, dir*(x + cw*0.92 - xw), h);
        drawBreakSparks(sprite, dir*(x + cw*0.80 - xw), h);
        drawBreakSparks(sprite, dir*(x + cw*0.10 - xw), h);
      }
      popMatrix();
    }
    
  }
  
  public void drawBreakSparks(PImage img, float x, float y){
  
    float alpha = map(abs(cabs_vel[0].x), 0, maxGear, 0, 500);
    tint(255, alpha);
    
    imageMode(CENTER);
    image(img, x, y);
    imageMode(CORNER);
    
    tint(255, 255);
  }
  
  public void changeGlobalResizeFactor(char chr){
    if(chr == '+'){
      global_resize_factor -= 0.1;
    }else if(chr == '-'){
      global_resize_factor += 0.1;
    }
    if(global_resize_factor < 0.1){
      global_resize_factor = 0.1;
    }
    
    // update size
    train_resize_factor = 2.5 * global_resize_factor;
    breakSpark_resize_factor = 15 * global_resize_factor;
    
    loadSprites(int(cabs_coords[0].x));
  }
  
  private void loadSprites(int initial_x){
    // train
    train_front_on = loadImage("/images/train_front_on.png");
    train_front_off = loadImage("/images/train_front_off.png");
    train_pass_1 = loadImage("/images/train_pass_1.png");
    train_front_on = resizeImage(train_front_on, train_resize_factor);
    train_front_off = resizeImage(train_front_off, train_resize_factor);
    train_pass_1 = resizeImage(train_pass_1, train_resize_factor);
    
    // break sprites
    break_sparks = new PImage[10];
    for(int i = 0; i < break_sparks.length; i++){
      String num = "";
      if(i < 10){
        num = "0" + str(i);
      }else{
        num = str(i);
      }
      break_sparks[i] = loadImage("/images/breaks/frame_" + num + "_delay-0.04s.gif");
      break_sparks[i] = resizeImage(break_sparks[i], breakSpark_resize_factor);
    }
    
    cabs_coords[0] = new PVector(initial_x, height - train_front_on.height);
    for(int i = 1; i < num_total_cars; i++){
      cabs_coords[i] = new PVector(initial_x - (i * train_pass_1.width), height - train_pass_1.height);
    }
  }
  
  // #########################################################################
  // ############################ UPDATE #####################################
  // #########################################################################
  
  public void update(){
    if(emergencyBreaksActivated){
      speedGear = 0;
    }
    
    if(abs(speedGear - cabs_vel[0].x) < 0.1){
     cabs_vel[0].x = speedGear;
     if(emergencyBreaksActivated){
       emergencyBreaksActivated = false;
     }
    }else{
      if(cabs_vel[0].x < speedGear){
        cabs_vel[0].x += abs(speedGear - cabs_vel[0].x)/50;
      }
      if(cabs_vel[0].x > speedGear){
        cabs_vel[0].x -= abs(speedGear - cabs_vel[0].x)/50;
      }
    }
    cabs_coords[0].add(cabs_vel[0]);
    cabs_coords[0].y = height - train_front_on.height;
    
    for(int i = 1; i < num_total_cars; i++){
      cabs_vel[i] = cabs_vel[0].copy();
      cabs_coords[i].add(cabs_vel[i]);
      cabs_coords[i].y = height - train_pass_1.height;
    }
     
    // vary pressure
    if(vehicleState){
      setBreakPipePressure(breakPipePressure_zero + (noise(frameCount/100.) - 0.5) * 0.3);
    }else{
      setBreakPipePressure(breakPipePressure_zero);
    }
    
  }

  // #########################################################################
  // ############################ DISPLAY ####################################
  // #########################################################################
  
  public void display(){
    // display front cab
    if(cabs_coords[0].x + train_front_on.width >= width){
      if(cabs_coords[0].x > width){
        cabs_coords[0].x = width - cabs_coords[0].x;
      }else{
        if(vehicleState){
          drawCab(train_front_on, cabs_coords[0].x - width, cabs_coords[0].y, true);
        }else{
          drawCab(train_front_off, cabs_coords[0].x - width, cabs_coords[0].y, true);
        }
      }
    }
    if(vehicleState){
      drawCab(train_front_on, cabs_coords[0].x, cabs_coords[0].y, true);
    }else{
      drawCab(train_front_off, cabs_coords[0].x, cabs_coords[0].y, true);
    }
    
    // display other cabs
    for(int i = 1; i < num_total_cars; i++){
      if(cabs_coords[i].x + train_pass_1.width >= width){
        if(cabs_coords[i].x > width){
          cabs_coords[i].x = cabs_coords[0].x - (i * train_pass_1.width); 
        }else{
          drawCab(train_pass_1, cabs_coords[0].x - (i * train_pass_1.width), cabs_coords[i].y, false);
        }
      }
      drawCab(train_pass_1, cabs_coords[i].x, cabs_coords[i].y, false);
    }
  }
  
  

}
