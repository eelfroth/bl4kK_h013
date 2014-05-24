class PLAYER {
  
  final int SIZE = 6;
  
  final float orbit_time = 1f;
  final float jump_velocity = 10f;
  final float center_gravity = 0.01f;
  final float orbit_gravity = 0f;//0.001f;
  final float collision_range = 10f;
  
  float orbit_radius, orbit_angle, orbit_velocity, jump_orbit_radius, jump_orbit_angle, jump_orbit_velocity_pixels, jump_orbit_velocity_radians, center_velocity;
  
  boolean attached, alive, angle_set, right_down, left_down, ready_to_jump;
  
  PVector location;
  
  ORB attached_orb;
 
  PLAYER() {
   
    location = new PVector();
    orbit_radius = orb.radius + SIZE / 2;
    orbit_velocity = TAU / (orbit_time * GAME_SPEED);
   
  }
 
  void update() {
   
    if(attached) {
    
      if(right_down) {
        
        orbit_angle += orbit_velocity; 
        
      }
      else if(left_down) {
        
        orbit_angle -= orbit_velocity; 
        
      }
      
      location.x = orbit_radius * cos(orbit_angle) + attached_orb.location.x;
      location.y = orbit_radius * sin(orbit_angle) + attached_orb.location.y;
    
    }
    else {
      
      jump_orbit_angle += jump_orbit_velocity_radians;
      jump_orbit_velocity_radians += orbit_gravity;
      jump_orbit_radius = max(0, jump_orbit_radius + center_velocity);
      center_velocity -= center_gravity;
      location.x = jump_orbit_radius * cos(jump_orbit_angle) + black_hole.location.x;
      location.y = jump_orbit_radius * sin(jump_orbit_angle) + black_hole.location.y;
      
      for(int i = 0; i < orb_number; i++) {
       
        if(orbs[i].alive) {
         
          if(dist(location.x, location.y, orbs[i].location.x, orbs[i].location.y) <= collision_range) {
            
            attach_to_orb(orbs[i]);
            break; 
            
          }
         
        } 
        
      }
      
      if(jump_orbit_radius == 0f || jump_orbit_radius > black_hole.RADIUS+23) {
        
        alive = false; 
        
      }
      
    }
    
  }
 
  void display() {
   
    buffer.stroke(255);
    buffer.fill(0, 200);
    buffer.pushMatrix();
    buffer.translate(location.x, location.y);
    buffer.rotate(orbit_angle);
    buffer.rect(-SIZE / 2, - SIZE / 2, SIZE, SIZE);
    buffer.rotate(-orbit_angle);
    buffer.translate(-location.x, -location.y);
    buffer.popMatrix();
  }
 
  void attach_to_orb(ORB orb) {
   
    attached = true;
    attached_orb = orb;
    attached_orb.attached = true;
    
    if(angle_set) {
      
      orbit_angle += PI;
      
    }
    else {
      
      orbit_angle = random(TAU);
      
    }
   
  }
 
  void jump() {
   
    attached = false;
    attached_orb.attached = false;
    center_velocity = cos(orbit_angle - attached_orb.orbit_angle) * jump_velocity;
    jump_orbit_velocity_pixels = sin(orbit_angle - attached_orb.orbit_angle) * jump_velocity;
    jump_orbit_velocity_radians = (jump_orbit_velocity_pixels * TAU) / (black_hole.RADIUS * TAU);
    jump_orbit_radius = dist(location.x, location.y, black_hole.location.x, black_hole.location.y);
    jump_orbit_angle = atan2(location.y - black_hole.location.y, location.x - black_hole.location.x);
   
  }
 
  void spawn() {
   
    alive = true;
    attached = false;
    angle_set = false;
    right_down = false;
    left_down = false;
    ready_to_jump = true;
   
  } 
  
}
