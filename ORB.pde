////////////////////////////////////////////////////////////////////////////

int orb_iterator;

Orb createOrb(float radius, float x, float y) {
  Orb orb = new Orb(radius, x, y);
  orb.identificator = char(++orb_iterator);
     if(VERBOSE) println("CREATE_ORB: \t"+orb.identificator+" \t"+x+","+y);
     
  return orb;
}

////////////////////////////////////////////////////////////////////////////

class Orb {
  PVector location, velocity, accelleration;
  float radius, rotation, orientation;
  char identificator;
  color c_fill, c_stroke, c_symbol;
  
  Orb(float radius, float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    accelleration = new PVector();
    this.radius = radius;
    orientation = random(TWO_PI);
    rotation = 0.05;
    identificator = '※';
    c_fill = color(23, 100, 200);
    c_stroke = color(23, 100, 200);
    c_symbol = 0;
  }
  
  void update() {
    
  }
  
  void display() {
    buffer.pushMatrix();
    buffer.translate(location.x, location.y);
    buffer.rotate(orientation);
    {
      buffer.stroke(c_stroke);
      buffer.fill(c_fill);
      
      buffer.ellipse(0, 0, radius*2, radius*2);
      
      buffer.fill(c_symbol);
      buffer.textAlign(CENTER);
      buffer.textSize(radius*1.5);
      buffer.text(identificator, 0, 0 + radius/2);
    }
    buffer.popMatrix();
  }
}

////////////////////////////////////////////////////////////////////////////
