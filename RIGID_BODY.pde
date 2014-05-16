abstract class Body {
  PVector location, velocity, accelleration;
  float radius, rotation, orientation;
  color c_fill, c_stroke;
  
  Body(float radius, float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    accelleration = new PVector();
    this.radius = radius;
    orientation = random(TWO_PI);
    rotation = 0.05;
    c_fill = color(0, 0);
    c_stroke = color(23, 100, 200);
  }
  
  void update(float delta) {
    orientation += rotation * delta;
  }
  
  void display() {
    buffer.pushMatrix();
    buffer.translate(location.x, location.y);
    buffer.rotate(orientation);
    buffer.textFont(font_orb);
    {
      buffer.stroke(c_stroke);
      //buffer.fill(c_fill);
      buffer.noFill();
      
      buffer.ellipse(0, 0, radius*2, radius*2);      
    }
    buffer.popMatrix();
  }
}

////////////////////////////////////////////////////////////////////////////
