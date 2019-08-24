
class GraphicsControl{
  
  // ######################################################################
  // ########################### Global Vars ##############################
  // ######################################################################
  boolean showConsole;
  boolean showSchematics;
  boolean showParkingBreakVariables;
  boolean showBackground;
  boolean showTrain;
  boolean showHelp;
  
  PImage background;
  PVector windowSize;
  
  Menu parkingBreakVariablesMenu;
  ParkingBreakControl parkingBreakControl;
  Train train;
  
  int rightPanel_width = 550;
  int parkingBreakVariablesMenu_height = 320;
  
  // constants
  final int Y_AXIS = 1;
  final int X_AXIS = 2;
  
  
  // ######################################################################
  // ########################### Constructor ##############################
  // ######################################################################
  GraphicsControl(int sizeX, int sizeY){
    
    showConsole = true;
    showSchematics = true;
    showParkingBreakVariables = true;
    showBackground = true;
    showTrain = true;
    
    parkingBreakVariablesMenu = new Menu(rightPanel_width, parkingBreakVariablesMenu_height);
    
    // backgrounds
    float[] background_rs = {1.6, 0.4};
    int background_idx = 0;
    background = loadImage("/images/background_" + str(background_idx + 1) + ".png");
    background = resizeImage(background, background_rs[background_idx]);
    
    // Define window size
    windowSize = new PVector(sizeX, sizeY);
    
    // Control window size
    surface.setResizable(true);
    surface.setSize(int(windowSize.x), int(windowSize.y));
    surface.setLocation(displayWidth - width >> 1, displayHeight - height >> 1);
    surface.setVisible(true);
  }

  
  // ######################################################################
  // ######################### DISPLAY FUNCTION ###########################
  // ######################################################################
  public void displayGraphics(){
    background(200);
  
  if(showBackground){
    image(background, 0, 0);
  }
    
  // draw Menu
  if(showParkingBreakVariables){
    Item[] items = updateMenu();
    parkingBreakVariablesMenu.update(items);
    parkingBreakVariablesMenu.display();
    
    drawPressionBar();
  }

  // draw schematics
  if(showSchematics){
    drawSchematics();
  }
  
  // draw console
  if(showConsole){
    console.display(width - rightPanel_width, parkingBreakVariablesMenu_height, rightPanel_width, height/4);
  }
  
  // draw trains
  if(showTrain){
    train.display();
  }
  
  if(showHelp){
    displayHelp();
  }
  
  }
  
  // ######################################################################
  // ########################## Aux Functions #############################
  // ######################################################################
  
  public void setTrain(Train train){
    this.train = train;
  }
  
  public void setParkingBreakControl(ParkingBreakControl parkingBreakControl){
    this.parkingBreakControl = parkingBreakControl;
  }
  
  private PImage resizeImage(PImage img, float r_f){
    img.resize(floor(img.width/r_f), floor(img.height/r_f));
    return img;
  }
  
  private void displayHelp(){
    int x_offset = 100;
    int y_offset = 100;
    int y_accum = y_offset;
    String txt;
    textLeading(10);
    
    // box
    fill(0, 220);
    strokeWeight(3);
    stroke(255);
    rect(x_offset, y_offset, width - 2*x_offset, height - 2*y_offset);
    strokeWeight(1);
    
    
    // title
    y_accum += 50;
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("HELP", width/2, y_accum);
    
    // introduction
    y_accum += 50;
    textAlign(BASELINE);
    textSize(16);
    textLeading(20);
    txt = "This is a simulator for testing the Parking Break system of a train!";
    text(txt, x_offset + 20, y_accum);
    
    // Graphics help
    y_accum += 50;
    textAlign(BASELINE);
    textSize(16);
    textLeading(20);
    txt = "GRAPHIC CONTROLS:\n";
    txt += "[F1] Show/Hide the Console\n";
    txt += "[F2] Show/Hide the Parking Break schematic\n";
    txt += "[F3] Show/Hide the Parking Break variables' state\n";
    txt += "[F4] Show/Hide the background image' state\n";
    txt += "[F5] Show/Hide the train\n";
    txt += "[+]  Increase train size\n";
    txt += "[-]  Decrease train size\n";
    text(txt, x_offset + 20, y_accum);
    
    // Parking break controls
    y_accum += 190;
    textAlign(BASELINE);
    textSize(16);
    textLeading(20);
    txt = "PARKING BREAK CONTROLS:\n";
    txt += "[1] Press cabine 1 parking break release button\n";
    txt += "[2] Press cabine 2 parking break release button\n";
    txt += "[A] Activate line #11 (remote)\n";
    txt += "[V] Turn the vehicle ON/OFF\n";
    txt += "[O] Turn operation mode WTB UIC ON/OFF\n";
    txt += "[R] Resets the breaks' hardware in case it stucks\n";
    text(txt, x_offset + 20, y_accum);
    
    // Developer
    y_accum += 170;
    textAlign(BASELINE);
    textSize(16);
    textLeading(20);
    txt = "DEVELOPER:\n";
    txt += "Rafael Correia @ Crtical Software (Summer internship)\n";
    text(txt, x_offset + 20, y_accum);
  }
  
  void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

    noFill();
  
    if (axis == Y_AXIS) {  // Top to bottom gradient
      for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }  
    else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = x; i <= x+w; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
  
  public Item[] updateMenu(){
    Item[] items = new Item[0];
    items = (Item[])append(items, new Item("Parking Brake Release Enabled By WTB UIC", parkingBreakControl.parkingBrakeReleaseEnabledByWTBUIC));
    items = (Item[])append(items, new Item("Parking Brake Release Enabled By HW Activation", parkingBreakControl.parkingBreakReleaseEnabledByHWActivation));
    items = (Item[])append(items, new Item("Feedback Release Enabled By HW", parkingBreakControl.feedbackEnableReleaseByHW));
    items = (Item[])append(items, new Item("Stuck OFF", parkingBreakControl.stuckOFF));
    items = (Item[])append(items, new Item("Stuck ON", parkingBreakControl.stuckON));
    items = (Item[])append(items, new Item("Operation Mode WTB UIC [O]", parkingBreakControl.OperationModeWTBUIC));
    items = (Item[])append(items, new Item("Cabine Button 1 Pressed [1]", train.getCab1ParkingBreakReleasePressed()));
    items = (Item[])append(items, new Item("Cabine Button 2 Pressed [2]", train.getCab2ParkingBreakReleasePressed()));
    items = (Item[])append(items, new Item("Cabine Active [A]", train.getCabActive()));
    items = (Item[])append(items, new Item("Vehicle State [V]", train.getVehicleState()));
    items = (Item[])append(items, new Item("Pressure above threshold", train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold));
    items = (Item[])append(items, new Item("Speed gear", train.speedGear));
    
    return items;
  }
  
  public void drawPressionBar(){
    
    int pressure_h = 260;
    int pressure_w = 60;
    int pressure_x = width - pressure_w - 30;
    int pressure_y = 0;
    
    
    stroke(0);
    fill(255);
    rect(pressure_x - pressure_w/2, pressure_y, pressure_w * 2, pressure_h + 60);
    
    fill(0);
    text("Pressure", pressure_x - 10, pressure_y + 20);
    text(nf(train.getBreakPipePressure(),0,3) + " [bars]", pressure_x - 20, pressure_y + 35);
    fill(255);
    
    setGradient(pressure_x, pressure_y + 40, pressure_w, pressure_h, color(255,0,0), color(0,255,0), Y_AXIS);
    
    fill(255);
    noStroke();
    int pressure_mark = int(map(parkingBreakControl.pressureThreshold, 0, 5, pressure_h, 0));
    int pressure_new_h = int(map(train.getBreakPipePressure(), 0, 5, pressure_h, 0));
    pressure_new_h = min(pressure_new_h, pressure_h);
    pressure_new_h = max(pressure_new_h, 0);
    rect(pressure_x, pressure_y + 40, pressure_w, pressure_new_h);
  
    stroke(0);
    line(pressure_x, pressure_y + pressure_mark + 40, pressure_x + pressure_w, pressure_y + pressure_mark + 40);
    
    noFill();
    
    rect(pressure_x, pressure_y + 40, pressure_w, pressure_h);
  }
  
  public void drawSchematics(){
    int x = 70;
    int y = 50;
    int w = 350;
    int h = 300;
    int d = h/4;
    int r = 10;
    int g = 50;
    
    stroke(0);
    strokeWeight(2);
    
    // main horizontal
    if(parkingBreakControl.parkingBreakReleaseEnabledByHWActivation){stroke(255,0,0);}else{stroke(0);}
    line(x, y, x + w, y);
    line(x, y + h, x + w + 70, y + h);
    
    // main vertical
    if(train.getCab1ParkingBreakReleasePressed()){stroke(255,0,0);}else{stroke(0);}
    line(x, y, x, y + d);
    line(x, y + d + g, x, y + h);
    if(train.getCab2ParkingBreakReleasePressed()){stroke(255,0,0);}else{stroke(0);}
    line(x + w/3, y, x + w/3, y + d);
    line(x + w/3, y + d + g, x + w/3, y + h);
    if(train.getCabActive()){stroke(255,0,0);}else{stroke(0);}
    line(x + 2*w/3, y, x + 2*w/3, y + d);
    line(x + 2*w/3, y + d + g, x + 2*w/3, y + h);
    if(parkingBreakControl.OperationModeWTBUIC && train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold){stroke(255,0,0);}else{stroke(0);}
    line(x + w, y, x + w, y + d);
    line(x + w, y + d + g, x + w, y + d + g + 70);
    line(x + w, y + d + 2*g + 70, x + w, y + h);
  
    if(train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold){stroke(255,0,0);}else{stroke(0);}
    noFill();
    rect(x + w - 25, y + d + g + 55, 50, 80);
    
    stroke(0);
    // nodes
    fill(0);
    ellipse(x, y, r, r);
    ellipse(x, y + h, r, r);
    ellipse(x + w/3, y, r, r);
    ellipse(x + 2*w/3, y, r, r);
    ellipse(x + w, y, r, r);
    ellipse(x + w/3, y + h, r, r);
    ellipse(x + 2*w/3, y + h, r, r);
    ellipse(x + w, y + h, r, r);
    
    // switches
    strokeWeight(4);
    if(train.getCab1ParkingBreakReleasePressed()){
      line(x, y + d + g, x, y + d);
    }else{
      line(x-20, y + d + g - 20, x, y + d);
    }
    if(train.getCab2ParkingBreakReleasePressed()){
      line(x + w/3, y + d + g, x + w/3, y + d);
    }else{
      line(x-20 + w/3, y + d + g - 20, x + w/3, y + d);
    }
    if(train.getCabActive()){
      line(x + 2*w/3, y + d + g, x + 2*w/3, y + d);
    }else{
      line(x-20 + 2*w/3, y + d + g - 20, x + 2*w/3, y + d);
    }
    if(parkingBreakControl.OperationModeWTBUIC){
      line(x + w, y + d + g, x + w, y + d);
    }else{
      line(x-20 + w, y + d + g - 20, x + w, y + d);
    }
    if(train.getBreakPipePressure() >= parkingBreakControl.pressureThreshold){
      line(x + w, y + d + g + 70, x + w, y + d + 2*g + 70);
    }else{
      line(x-20 + w, y + d + 2*g + 50, x + w, y + d + g + 70);
    }
    
    // labels
    textLeading(20);
    
    pushMatrix();
    translate(x - 5, y + h - 20);
    rotate(-HALF_PI);
    text("Cab 1 Pressed",0,0);
    popMatrix();
    
    pushMatrix();
    translate(x + w/3 - 5, y + h - 20);
    rotate(-HALF_PI);
    text("Cab 2 Pressed",0,0);
    popMatrix();
    
    pushMatrix();
    translate(x + 2*w/3 - 5, y + h - 20);
    rotate(-HALF_PI);
    text("Cab Active (line #11)",0,0);
    popMatrix();
    
    pushMatrix();
    translate(x + w - 55, y + h - 50);
    rotate(-HALF_PI);
    text("Pressure\nsensor",0,0);
    popMatrix();
    
    pushMatrix();
    translate(x + w - 35, y + h/2 - 20);
    rotate(-HALF_PI);
    text("WTB UIC",0,0);
    popMatrix();
    
    
    
    // output break
    strokeWeight(2);
    String txt = "Parking\nBreak";
    strokeWeight(4);
    if(parkingBreakControl.feedbackEnableReleaseByHW){
      fill(0, 255, 0);
      txt += "\nReleased";
    }else{
      fill(255, 0, 0);
      txt += "\nLocked";
    }
    
    rect(x + w + 70, y + h - 50, 100, 100);
    fill(0);
    textAlign(CENTER, CENTER);
    text(txt, x + w + 120, y + h);
    textAlign(LEFT, BASELINE);
    
    strokeWeight(1);
    textLeading(48);
  }
}
