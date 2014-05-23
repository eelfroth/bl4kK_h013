////////////////////////////////////////////////////////////////////////////

//GAME_VARIABLES//
ArrayList<Orb> orbs;

void initialize(int start_millis) {
          if(VERBOSE) log.add_line("INITIALIZE_START_AT: \t" + start_millis + " ms");
  
  orbs = new ArrayList<Orb>();
          if(VERBOSE) log.add_line("NEW_ARRAY_LIST: \t\tORBS");
  
  //orbs.add(createOrb(23, BUFFER_WIDTH/2, BUFFER_HEIGHT/2));
  orbs.add(createOrb(random(23), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(23), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(23), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(23), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(23), BUFFER_WIDTH/2 -50 + random(100), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(42), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(42), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(42), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200)));
  orbs.add(createOrb(random(42), BUFFER_WIDTH/2 -160 + random(320), BUFFER_HEIGHT/2  -100 + random(200))); 

          if(VERBOSE) log.add_line("INITIALIZE_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("INITIALIZE_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();
          
  
          
  last_millis = millis();
}

////////////////////////////////////////////////////////////////////////////



void update(float delta) {
  
  
  //DRAW_GAME_TO_BUFFER//
  //buffer.shader(whirlShader);
  buffer.beginDraw();
  //buffer.shader(whirlShader);
  {
    //buffer.noSmooth();
    //buffer.pushMatrix();
    //buffer.translate(buffer.width/2, buffer.height/2);
    //buffer.rotate(float(millis())/10000);
    buffer.tint(255, random(255));//48 * delta);
    buffer.image(bg_image, 0, 0, buffer.width, buffer.height);
    //buffer.popMatrix();
    buffer.fill(0, 48 * delta);
    buffer.noStroke();
    //buffer.rect(0, 0, buffer.width, buffer.height);
    
    for(Orb orb : orbs) {
      orb.update(delta);
      orb.display();
    }
    //buffer.resetShader();
  }
  buffer.endDraw();
}
