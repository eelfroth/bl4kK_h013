import java.awt.event.KeyEvent; 
import java.awt.Font;

////////////////////////////////////////////////////////////////////////////

//INFO//
final String AUTHOR = "BEN_SIRONKO & EELFROTH";
final String GAME_TITLE = "BLACK_HOLE";
final float GAME_VERSION = 0.4;
final String CREATION_DATE = "BOOMTIME\t\t69TH_OF_DISCORD\t\tYOLD_3180";

//PREFERENCES//
final int BUFFER_WIDTH = 320;
final int BUFFER_HEIGHT = 320;
final int WINDOW_WIDTH = 1100;
final int WINDOW_HEIGHT = 730;
final int GAME_SPEED = 60;
final boolean VERBOSE = true;
final int BUFFER_OPACITY = 200;

////////////////////////////////////////////////////////////////////////////

//SKETCH_VARIABLES//
PGraphics buffer;
color buffer_tint;
float delta;
int last_millis;
MLog log;
PFont font_log, font_orb; 
float text_size;
PShader scalingShader, whirlShader;
PImage bg_image;

//SHADER_VARIABLES//
int offset = 2;
int dif;
float swirlRadius = 160.0;
final float swirlAngle = 1;


void setup() { 
//SET_UP_FRAME// 
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P2D);
  noSmooth();
  colorMode(HSB);
  text_size = 14;//max(ceil(float(WINDOW_HEIGHT)/36), 14);
  
//MAKE_LOG//
  log = new MLog(6, text_size*3.5);
  
//STATE_YOUR_NAME_AND_DATE//
  log.add_line("-----------------------------------------------");
  log.add_line("| "+GAME_TITLE + " \t" + GAME_VERSION + " \t" + AUTHOR + "|");
  log.add_line("| "+CREATION_DATE+" |");
  log.add_line("-----------------------------------------------");
  log.add_line();
  
  int start_millis = millis();
          if(VERBOSE) log.add_line("SETUP_START_AT: " + start_millis + " ms");
          if(VERBOSE) log.add_line("WINDOW_SIZE: \t" + WINDOW_WIDTH + "x" + WINDOW_HEIGHT);

//SET_UP_BUFFER//
  buffer = createGraphics(BUFFER_WIDTH, BUFFER_HEIGHT, P2D);
          if(VERBOSE) log.add_line("BUFFER_SIZE: \t" + BUFFER_WIDTH + "x" + BUFFER_HEIGHT);
          
//DRAWING_PROPERTIES//
  //buffer.noSmooth();
  buffer.colorMode(HSB);
          if(VERBOSE) log.add_line("COLOR_MODE: \tHSB, \t255");
  buffer_tint = color(255, BUFFER_OPACITY);
          if(VERBOSE) log.add_line("BUFFER_OPACITY:\t" + BUFFER_OPACITY);
  
//CONTROL_THE_FLOW_OF_TIME//
  frameRate(60);
          if(VERBOSE) log.add_line("GAME_SPEED: \t" + GAME_SPEED);
          
//LOAD_FONT//
  String FONT_TYPE = "DejaVuSansMono";
  //String FONT_TYPE = "UbuntuMono-Regular";
  //String FONT_TYPE = "Code2002";

          if(VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-14.vlw");
  int mil = millis();
  font_log = loadFont(FONT_TYPE+"-14.vlw");
  textFont(font_log);
  textSize(text_size);
          if(VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
          if(VERBOSE) log.add_line("GLYPHS_IN_FONT:\t" + font_log.getGlyphCount());
          
//LOAD_SECOND_FONT//

          if(VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-48.vlw");
  mil = millis();
  font_orb = loadFont(FONT_TYPE+"-48.vlw");
          if(VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
          if(VERBOSE) log.add_line("GLYPHS_IN_FONT:\t" + font_orb.getGlyphCount());

  
  //font_orb = font_log;  
//LOAD_SHADERS//
          if(VERBOSE) log.add_line("LOAD_SHADER: \tscaling.frag");
  scalingShader = loadShader("scaling.frag");
  scalingShader.set("pixelSize", buffer.width / 1.0F, buffer.height / 1.0F); //WINDOW_WIDTH / BUFFER_WIDTH, WINDOW_HEIGHT / BUFFER_HEIGHT);
  scalingShader.set("pixelOffset", 0.5F / buffer.width, 0.5F / buffer.height);
            if(VERBOSE) log.add_line("LOAD_SHADER: \twhirl.frag, whirl.vert");
  /*whirlShader = loadShader("whirl.frag");
  whirlShader.set("resolution", float(buffer.width), float(buffer.height));
  whirlShader.set("time", 0.0F);*/
  scalingShader.set("rt_w", float(buffer.width));
  scalingShader.set("rt_h", float(buffer.height));
  scalingShader.set("radius", swirlRadius);
  scalingShader.set("angle", swirlAngle);
  scalingShader.set("center", float(buffer.width)/2, float(buffer.height)/2);
  scalingShader.set("time", 0.0F);
  
//HACKY STUFF//
  dif = (WINDOW_WIDTH*WINDOW_HEIGHT) - (BUFFER_WIDTH*BUFFER_HEIGHT);
  bg_image = loadImage("bg_image.png");
  
//FINISH_SETUP//
          if(VERBOSE) log.add_line("SETUP_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("SETUP_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();

          
//INITIALIZE_GAME_ELEMENTS//
  initialize(millis());
}

////////////////////////////////////////////////////////////////////////////


void draw() {
//GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * GAME_SPEED;
  last_millis = millis();
  
  offset += delta * GAME_SPEED;
  //if (offset > dif) offset -= dif;
  offset %= max(dif,1);
  
  update(delta);
  
//DRAW_BUFFER_TO_FRAME//
  scalingShader.set("radius", swirlRadius);
  scalingShader.set("angle", swirlAngle);
  //scalingShader.set("time", float(millis())/10000);
  shader(scalingShader);
  {
    tint(buffer_tint);
    image(buffer, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
  }
  resetShader();
 
//SHOW_ME_THE_RATES//
  fill(0);
  stroke(color(23, 100, 200));
  rect(text_size * 0.5, text_size * 0.5, text_size * 10, text_size * 2.64);
  fill(color(23, 100, 200));
  text("fR: " + frameRate + " \n∆t: " + delta, 10, max(ceil(float(WINDOW_HEIGHT)/36), text_size));
  //text(hex(dif) + "\n" + hex(offset), 10, 14);
  
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
    if(keyCode == KeyEvent.VK_F11) {
      setup();
    }
  } 
}


////////////////////////////////////////////////////////////////////////////
