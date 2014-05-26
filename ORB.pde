class ORB {
  
  // float RADIUS = 10;
  
  final float min_orbit_time = 0f;
  final float max_orbit_time = 10f;
  final float time_to_center = 15f;
  //final float center_gravity = 0.0001f;
  final float orbit_gravity = 0.01f;
  
  float base_orbit_radius, orbit_radius, orbit_angle, delta_orbit_time, orbit_time, orbit_velocity, center_velocity, center_gravity;
  
  boolean alive, attached;
  
  PVector location;
  
  float radius, rotation, orientation;
  char identificator;
  color c_fill, c_stroke, c_symbol;
 
  ORB(float radius) {
    this.radius = radius;
    
    
   
    location = new PVector();
    base_orbit_radius = black_hole.RADIUS - radius;
    delta_orbit_time = max_orbit_time - min_orbit_time;
    center_gravity = 2 * base_orbit_radius / sq(time_to_center * GAME_SPEED);
    spawn();
    
    
    orientation = random(TWO_PI);
    rotation = 0.05;
    //identificator = '※';
    c_fill = color(0, 200);
    c_stroke = color(23, 70, 220);
    c_symbol = color(23, 50, 255);
   
  }
 
  void update() {
   
    orbit_time = min_orbit_time + delta_orbit_time * (orbit_radius / base_orbit_radius);
    
    if(orbit_time > 0f) {
    
      orbit_velocity = TAU / (orbit_time * GAME_SPEED);
      orbit_angle += orbit_velocity;
      orbit_radius = max(0f, orbit_radius - center_velocity);
      center_velocity += center_gravity;
      
    }
    else {
      
      orbit_radius = 0f; 
      
    }
    
    location.x = orbit_radius * cos(orbit_angle) + black_hole.location.x;
    location.y = orbit_radius * sin(orbit_angle) + black_hole.location.y;
    
    if(orbit_radius == 0f) {
      
      alive = false;
    
      if(attached) {
       
        attached = false;
        player.alive = false;
        
       s_die.play(0); 
       
      } 
      
    }
   rotation = -1/orbit_radius;
     orientation += rotation * delta;
     
  }
 
  void display() {
   
    buffer.pushMatrix();
    buffer.translate(location.x, location.y);
    buffer.rotate(orientation);
    buffer.textFont(font_orb);
    
      buffer.stroke(c_stroke);
      buffer.fill(c_fill);
      buffer.strokeWeight(1);
      //buffer.noFill();
      
      buffer.ellipse(0, 0, radius*2, radius*2);
      
      buffer.fill(c_symbol);
      buffer.textAlign(CENTER);
      buffer.textSize(radius*2);
      buffer.text(identificator, 0, 0 + radius/1.5);
     // buffer.text(identificator, 0, 0 + radius/1.5);
    
    buffer.popMatrix();
    buffer.fill(255, 32);
   // buffer.ellipse(location.x+10, location.y+10, radius*2, radius*2);
   print(identificator);
  } 
  
  void spawn() {
    
    //NEXT_GLYPH//
  identificator = char(++orb_iterator);
  
//ONLY_USE_GLYPHS_THAT_ARE_IN_THE_FONT//
  while(font_orb.getGlyph(identificator) == null) {
    identificator = char(++orb_iterator);
  }
   
    alive = true;
    orbit_radius = base_orbit_radius;
    center_velocity = 0f; 
    orbit_angle = random(TAU);
    orientation = random(TWO_PI);
    
    
    println("\nspawn("+identificator + ")");
  }
  
}
