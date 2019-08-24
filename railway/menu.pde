
class Menu{
  
  Item[] items;
  int menu_width;
  int menu_height;
  
  int y_item_separation = 25;
  int y_offset = 30;
  int x_offset = 30;
  
  
  
  Menu(Item[] it){
    items = it;
  }
  
  Menu(int w, int h){
    items = new Item[0];
    menu_width = w;
    menu_height = h;
  }
  
  void display(){
    stroke(0);
    fill(255);
    int x = width - menu_width;
    rect(x, 0, menu_width, menu_height);
    
    for(int i = 0; i < items.length; i++){
      items[i].display(x + x_offset, y_offset + y_item_separation*i);
    }
    
  }
  
  void update(Item[] it){
    items = it;
  }
  

}
