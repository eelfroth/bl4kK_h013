import java.awt.event.KeyEvent; 

////////////////////////////////////////////////////////////////////////////

//INFO//
final String AUTHOR = "EELFROTH";
final String GAME_TITLE = "bl4kK_h013";
final float GAME_VERSION = 0.1;
final String CREATION_DATE = "PRICKLE_PRICKLE\t41ST_OF_DISCORD\tYOLD_3180";

//PREFERENCES//
final int BUFFER_WIDTH = 96;
final int BUFFER_HEIGHT = 96;
final int FRAME_WIDTH = 640;
final int FRAME_HEIGHT = 480;
final int FRAME_RATE = 60;
final int TEXTURE_SAMPLING = 2;
final boolean VERBOSE = true;

////////////////////////////////////////////////////////////////////////////

//SKETCH_VARIABLES//
PGraphics buffer;
PImage buffer_image;
color buffer_tint;
float delta;
int last_millis;
MLog log;
PFont font_log, font_orb; 

void setup() {
  size(FRAME_WIDTH, FRAME_HEIGHT, JAVA2D);
  
//MAKE_LOG//
  log = new MLog(6, 36);
  
//STATE_YOUR_NAME_AND_OCCUPATION//
  log.add_line("-----------------------------------------------");
  log.add_line("| "+GAME_TITLE + " \t" + GAME_VERSION + " \t" + AUTHOR + "\t\t\t  |");
  log.add_line("| "+CREATION_DATE+" |");
  log.add_line("-----------------------------------------------");
  log.add_line();
  
  int start_millis = millis();
          if(VERBOSE) log.add_line("SETUP_START_AT: " + millis() + " ms");
      
//SET_UP_FRAME//
          if(VERBOSE) log.add_line("FRAME_SIZE: \t" + FRAME_WIDTH + "x" + FRAME_HEIGHT);
  
//SET_UP_BUFFER//
  //((PGraphicsOpenGL)g).textureSampling(TEXTURE_SAMPLING); //only in P2D
  //        if(VERBOSE) log.add_line("TEXTURE_SAMPLING: \t" + TEXTURE_SAMPLING);
          
  buffer = createGraphics(BUFFER_WIDTH, BUFFER_HEIGHT, JAVA2D);
  buffer_image = createImage(BUFFER_WIDTH, BUFFER_HEIGHT, RGB);
          if(VERBOSE) log.add_line("BUFFER_SIZE: \t" + BUFFER_WIDTH + "x" + BUFFER_HEIGHT);
          
//DRAWING_PROPERTIES//
  noSmooth();
  colorMode(HSB);
  //buffer.noSmooth();
  buffer.colorMode(HSB);
  buffer_tint = color(255, 64);
  
//CONTROL_THE_FLOW_OF_TIME//
  frameRate(60);
          if(VERBOSE) log.add_line("FRAME_RATE: \t" + FRAME_RATE);
          
//LOAD_FONT//
          if(VERBOSE) log.add_line("LOAD_FONT: \t\tDejaVuSansMono-14.vlw");
  int mil = millis();
  font_log = loadFont("DejaVuSansMono-14.vlw");
  textFont(font_log);
          if(VERBOSE) log.add_line("SUCCESS_AFTER: \t" + (millis() - mil) + " ms");
          
//LOAD_SECOND_FONT//
          if(VERBOSE) log.add_line("LOAD_FONT: \t\tDejaVuSansMono-48.vlw");
  mil = millis();
  font_orb = loadFont("DejaVuSansMono-48.vlw");
          if(VERBOSE) log.add_line("SUCCESS_AFTER: \t" + (millis() - mil) + " ms");
  
  
          if(VERBOSE) log.add_line("SETUP_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("SETUP_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();
          
  //INITIALIZE_GAME_ELEMENTS//
  initialize(millis());
}

////////////////////////////////////////////////////////////////////////////

//GAME_VARIABLES//
ArrayList<Orb> orbs;

void initialize(int start_millis) {
          if(VERBOSE) log.add_line("INITIALIZE_START_AT: \t" + start_millis + " ms");
  
  orbs = new ArrayList<Orb>();
          if(VERBOSE) log.add_line("NEW_ARRAY_LIST: \t\tORBS");
  
  orbs.add(createOrb(23, BUFFER_WIDTH/2 + 16, BUFFER_HEIGHT/2));
  
          if(VERBOSE) log.add_line("INITIALIZE_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("INITIALIZE_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();
          
  last_millis = millis();
}


////////////////////////////////////////////////////////////////////////////

void draw() {
//GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * FRAME_RATE;
  last_millis = millis();
  
//DRAW_GAME_TO_BUFFER//
  buffer.beginDraw();
  {
    //buffer.noSmooth();
    buffer.background(0);
    
    for(Orb orb : orbs) {
      orb.update(delta);
      orb.display();
    }
  }
  buffer.endDraw();
  
//P2D_WORKAROUND_FOR_CRISP_PIXELS//
  buffer.loadPixels();
  buffer_image.loadPixels();
  buffer_image.pixels = buffer.pixels;
  buffer_image.updatePixels();
  
//DRAW_BUFFER_TO_FRAME//
  tint(buffer_tint);
  image(buffer_image, 0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  
//SHOW_ME_THE_RATES//
  fill(0);
  stroke(230, 100, 255);
  rect(4, 0, 128, 36);
  fill(230, 100, 255);
  text("fR: " + frameRate + " \nΔt: " + delta, 10, 14);
  
//DISPLAY_LOG//
  log.update(delta);
  log.display();
}

////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if(key == CODED) {
    if(keyCode == KeyEvent.VK_F12) {
      initialize(millis());
    }
  } 
}
