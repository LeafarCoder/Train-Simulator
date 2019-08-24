
class Item{
  String name;
  String data_type;
  boolean state;
  float value;
  
  int text_offset = 20;
  int bool_radius = 15;
  
  Item(String name, boolean state){
    this.name = name;
    this.state = state;
    this.data_type = "Boolean";
  }
  
  Item(String name, float value){
    this.name = name;
    this.value = value;
    this.data_type = "Float";
  }
  
  Item(String name, int value){
    this.name = name;
    this.value = value;
    this.data_type = "Integer";
  }
  
  void display(int x, int y){
    // data
    if(data_type == "Boolean"){
      stroke(0);
      if(state){
        fill(0, 255, 0);
      }else{
        fill(255, 0, 0); 
      }
      ellipse(x, y - bool_radius/2, bool_radius, bool_radius);
    }else if(data_type == "Float"){
      fill(0);
      text(value, x - 20, y);
    }else if(data_type == "Integer"){
      fill(0);
      text(int(value), x - 5, y);
    }
    
    // name
    fill(0);
    textSize(15);
    textAlign(BASELINE);
    text(name, x + text_offset, y);
  }
}
