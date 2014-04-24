//INFO//
final String AUTHOR = "EELFROTH";
final String GAME_TITLE = "bl4kK_h013";
final float GAME_VERSION = 0.1;
final String CREATION_DATE = "Prickle Prickle, the 41st day of Discord in the YOLD 3180";


//PREFERENCES//
final int BUFFER_WIDTH = 96;
final int BUFFER_HEIGHT = 96;
final int FRAME_WIDTH = 640;
final int FRAME_HEIGHT = 480;
final int FRAME_RATE = 60;
final int TEXTURE_SAMPLING = 2;
final boolean VERBOSE = true;

//SKETCH_VARIABLES//
PGraphics buffer;
PImage buffer_image;
color buffer_tint;
float delta;
int last_millis;

/////////////////////////
void setup() {
//STATE_YOUR_NAME_AND_OCCUPATION//
  println("--- " + GAME_TITLE + " ---\t" + GAME_VERSION + "\t by " + AUTHOR);
  println(CREATION_DATE + "\n");
      
//SET_UP_FRAME//
   size(FRAME_WIDTH, FRAME_HEIGHT, JAVA2D);
          if(VERBOSE) println("FRAME_SIZE: \t" + FRAME_WIDTH + "x" + FRAME_HEIGHT);
  
//SET_UP_BUFFER//
  //((PGraphicsOpenGL)g).textureSampling(TEXTURE_SAMPLING);
          if(VERBOSE) println("TEXTURE_SAMPLING: \t" + TEXTURE_SAMPLING);
          
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
  
  last_millis = millis();
          if(VERBOSE) println("SETUP_DONE_AT: \t" + millis() + "ms");
}

void draw() {
//GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * FRAME_RATE;
  last_millis = millis();
  
//DRAW_GAME_TO_BUFFER//
  buffer.beginDraw();
  {
    buffer.background(0);
    
    buffer.stroke(255);
    buffer.fill(255);
    
    buffer.ellipse(BUFFER_WIDTH/2, BUFFER_HEIGHT/2, 32, 32);
    
    buffer.fill(0);
    buffer.textAlign(CENTER);
    buffer.textSize(23);
    buffer.text("※", BUFFER_WIDTH/2, BUFFER_HEIGHT/2 + 8);
  }
  buffer.endDraw();
  
//WORKAROUND_FOR_CRISP_PIXELS//
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
