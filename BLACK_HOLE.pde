class BLACK_HOLE {
  
  final int RADIUS = 160; 
  
  PVector location;
  
  BLACK_HOLE() {
    
    location = new PVector(BUFFER_WIDTH / 2, BUFFER_HEIGHT / 2);
    
  }
  
  void display() {
    
    noStroke();
    fill(42);
    ellipse(location.x, location.y, 630, 630);
    fill(35);
    ellipse(location.x, location.y, 540, 540);
    fill(28);
    ellipse(location.x, location.y, 450, 450);
    fill(21);
    ellipse(location.x, location.y, 360, 360);
    fill(14);
    ellipse(location.x, location.y, 270, 270);
    fill(7);
    ellipse(location.x, location.y, 180, 180);
    fill(0);
    ellipse(location.x, location.y, 90, 90); 
    
  }
  
}
