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

void setup() {
//STATE_YOUR_NAME_AND_OCCUPATION//
  println("-----------------------------------------------");
  println("| "+GAME_TITLE + " \t" + GAME_VERSION + "\t" + AUTHOR + "\t\t |");
  println("| "+CREATION_DATE+" |");
  println("-----------------------------------------------\n");
  
  int start_millis = millis();
          if(VERBOSE) println("\nSTART_SETUP_AT: \t" + millis() + " ms");
      
//SET_UP_FRAME//
   size(FRAME_WIDTH, FRAME_HEIGHT, JAVA2D);
          if(VERBOSE) println("FRAME_SIZE: \t" + FRAME_WIDTH + "x" + FRAME_HEIGHT);
  
//SET_UP_BUFFER//
  //((PGraphicsOpenGL)g).textureSampling(TEXTURE_SAMPLING); //only in P2D
  //        if(VERBOSE) println("TEXTURE_SAMPLING: \t" + TEXTURE_SAMPLING);
          
  buffer = createGraphics(BUFFER_WIDTH, BUFFER_HEIGHT, JAVA2D);
  buffer_image = createImage(BUFFER_WIDTH, BUFFER_HEIGHT, RGB);
          if(VERBOSE) println("BUFFER_SIZE: \t" + BUFFER_WIDTH + "x" + BUFFER_HEIGHT);
          
//DRAWING_PROPERTIES//
  noSmooth();
  colorMode(HSB);
  buffer.noSmooth();
  buffer.colorMode(HSB);
  buffer_tint = color(255, 128);
  
//CONTROL_THE_FLOW_OF_TIME//
  frameRate(FRAME_RATE);
          if(VERBOSE) println("FRAME_RATE: \t" + FRAME_RATE);
          
//INITIALIZE_GAME_ELEMENTS//
  initialize(millis());
  
  last_millis = millis();
          if(VERBOSE) println("SETUP_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) println("SETUP_RUNTIME: \t" + (millis()-start_millis) + " ms\n");
}

////////////////////////////////////////////////////////////////////////////

//GAME_VARIABLES//
ArrayList<Orb> orbs;

void initialize(int start_millis) {
          if(VERBOSE) println("\nSTART_INITIALIZE_AT: \t" + start_millis + " ms");
  
  orbs = new ArrayList<Orb>();
          if(VERBOSE) println("INITIALIZE_ARRAY_LIST: \tORBS");
  
  orbs.add(createOrb(23, BUFFER_WIDTH/2, BUFFER_HEIGHT/2));
  
          if(VERBOSE) println("INITIALIZE_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) println("INITIALIZE_RUNTIME: \t" + (millis()-start_millis) + " ms\n");
}


////////////////////////////////////////////////////////////////////////////

void draw() {
//GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * FRAME_RATE;
  last_millis = millis();
  
//DRAW_GAME_TO_BUFFER//
  buffer.beginDraw();
  {
    buffer.background(0);
    
    for(Orb orb : orbs) {
      orb.update();
      orb.display();
    }
  }
  buffer.endDraw();
  
//P2D_WORKAROUND_FOR_CRISP_PIXELS// --- //WHICH_DOES_NOT_WORK_ANYMORE...//
  buffer.loadPixels();
  buffer_image.loadPixels();
  buffer_image.pixels = buffer.pixels;
  buffer_image.updatePixels();
  
//DRAW_BUFFER_TO_FRAME//
  tint(buffer_tint);
  image(buffer_image, 0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  
//SHOW_ME_DA_RATES//
  fill(0);
  stroke(230, 100, 255);
  rect(0, 0, 128, 32);
  fill(230, 100, 255);
  text("fR: " + frameRate + " \nΔ : " + delta, 6, 14);
}

////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if(key == CODED) {
    if(keyCode == KeyEvent.VK_F12) {
      initialize(millis());
    }
  } 
}
