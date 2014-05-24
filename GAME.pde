////////////////////////////////////////////////////////////////////////////
final float ORB_SPAWN_TIME = 3f;
final float START_RADIUS = 20;

//GAME_VARIABLES//
//ArrayList<Orb> orbs;
int orb_number, max_orb_number, last_spawned;
float orb_spawn_timer;

BLACK_HOLE black_hole;
ORB orb;
ORB[] orbs;
PLAYER player;

void initialize(int start_millis) {
          if(VERBOSE) log.add_line("INITIALIZE_START_AT: \t" + start_millis + " ms");
  
  /*orbs = new ArrayList<Orb>();
          if(VERBOSE) log.add_line("NEW_ARRAY_LIST: \t\tORBS");
  
  //orbs.add(createOrb(23, BUFFER_WIDTH/2, BUFFER_HEIGHT/2));
  orbs.add(createOrb(10+random(13), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(13), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(13), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(13), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(13), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(32), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(32), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(32), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(10+random(32), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200))); 

          if(VERBOSE) log.add_line("INITIALIZE_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("INITIALIZE_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();
          
  */
  
  black_hole = new BLACK_HOLE();
  orb = new ORB(START_RADIUS);
  player = new PLAYER();
  max_orb_number = ceil(orb.time_to_center / ORB_SPAWN_TIME) + 1;
  orbs = new ORB[max_orb_number];
  orbs[0] = orb;
  orb_number = 1;
  last_spawned = 0;
  orb_spawn_timer = 0f;
          
  last_millis = millis();
}

////////////////////////////////////////////////////////////////////////////

float modulo = 1;

void update(float delta) {
  
  
  //DRAW_GAME_TO_BUFFER//
  //buffer.shader(whirlShader);
 // bg_image = buffer.get();
  buffer.beginDraw();
  //buffer.shader(whirlShader);
  {
    //buffer.noSmooth();
    buffer.pushMatrix();
    buffer.translate(buffer.width/2, buffer.height/2);
    //buffer.rotate(float(millis())/10000);
    buffer.tint(255, 0);
    bgShader.set("time", -float(millis()) / 50.0);
    bgShader.set("modulo", 3.0F);
    buffer.shader(bgShader);
    buffer.imageMode(CENTER);
    buffer.image(bg_image, 0, 0, buffer.width*1.5, buffer.height*1.5);
    buffer.resetShader();
    buffer.popMatrix();
    buffer.fill(0, 48 * delta);
    buffer.noStroke();
    //buffer.rect(0, 0, buffer.width, buffer.height);
    
    
    orb_spawn_timer++;
  
  if(orb_spawn_timer > ORB_SPAWN_TIME * GAME_SPEED) {
    
    if(orb_number < max_orb_number) {
    
      orb_spawn_timer = 0f;
      orbs[orb_number] = new ORB(START_RADIUS);
      last_spawned = orb_number;
      orb_number++;
   
    }
    else {
     
      for(int i = 0; i < orb_number; i++) {
        
        if(!orbs[i].alive) {
         
          orbs[i].spawn();
          last_spawned = i;
          break;
         
        } 
        
      }
     
    } 
    
  }
  
  //background(BACKGROUND_COLOR);
 // black_hole.display();
  
  for(int i = 0; i < orb_number; i++) {
    
    if(orbs[i].alive) {
       
      orbs[i].update();
      orbs[i].display();
     
    } 
    
  }
  
  if(player.alive) {
    
    player.update();
    player.display();
   
  } 
    
   /* for(Orb orb : orbs) {
      orb.update(delta);
      orb.display();
    }*/
    //buffer.resetShader();
    
    //buffer.shader(bgShader);
    
    
    //buffer.resetShader();
  }
  buffer.endDraw();
}
