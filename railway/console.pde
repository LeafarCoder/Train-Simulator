class Console{

  StringList log;
  int text_interline_space = 20;
  int sidesOffset = 10;
  
  Console(){
    log = new StringList();
  }
  
  public void addEntry(String str){
    String sec = "";
    if(second() < 10){
      sec = "0" + str(second());
    }else{
      sec = str(second());
    }
    
    log.append("["+hour()+":"+minute()+":"+sec+"]  " + str);
  }
  
  public void display(int x, int y, int w, int h){
    fill(255);
    stroke(0);
    
    // background
    rect(x,y,w,h);
    
    // write log entries
    fill(0);  
    textLeading(text_interline_space);
    int cur_line = 0;
    for(int i = log.size() - 1; i >= 0; i--){
      float str_len = textWidth(log.get(i));
      int num_lines = ceil(str_len / (w - 2 * sidesOffset));
      cur_line += num_lines;
      int y_cur = y + h - (cur_line)*text_interline_space - 10;
      if(y_cur < y){
        break;
      }
      text(log.get(i), x + sidesOffset, y_cur, w - sidesOffset, 3 * text_interline_space);
    }
    textLeading(48);
  }

}
