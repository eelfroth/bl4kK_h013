class MLog {
  PVector location;
  StringList lines;
  int display_lines;// = 25;
  float font_size;
  color c;
  float line_counter;
  int tab_size = 4;
  
  MLog(float x, float y) {
    location = new PVector(x, y);
    lines = new StringList();
    display_lines = floor(height / text_size) - 14;
    for(int i=0; i<display_lines;i++) {
      lines.append("");
    }
    
    font_size = 14;
    c = color(23+128, 100, 200);
  }
  
  void add_line(String line) {
    println(line);
    lines.append(replace_tabs(line));
  }
  
  void add_line() {
    println();
    lines.append("");
  }
  
  String replace_tabs(String input) {
    String[] subs = input.split("\t");
    String output = "";
    
    for(int i=0; i<subs.length; i++) {
      subs[i] += " ";
      while(subs[i].length() % tab_size != 0) subs[i] += " ";
      output += subs[i];
    }
    
    return output;
  }
  
  void update(float delta) {
    if(line_counter < lines.size()-1) { 
      line_counter += float(display_lines)/50 * delta;
      if(line_counter > lines.size()) line_counter = lines.size()-1;
    }
  }
  
  void display() {
    //fill(0);
    //stroke(230, 100, 255);
    //rect(0, 0, 128, 32);
    
    
    
    //textSize(font_size);
    String output = "";
    String line;
    if(lines.size() > 0) {
      for(int i = min(display_lines, floor(line_counter)); i >= 0 ; i--) {
        //if(floor(line_counter) < display_lines) break;
        line = lines.get(floor(line_counter-i));
        if (line != null) output += line + "\n";        
      }
    }
    
    pushMatrix();
    translate(location.x, location.y + font_size);
    fill(c);
    text(output, 0, 0);
    popMatrix();
  }

}
