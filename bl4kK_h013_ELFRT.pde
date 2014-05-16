import java.awt.event.KeyEvent; 
import java.awt.Font;

////////////////////////////////////////////////////////////////////////////

//INFO//
final String AUTHOR = "BEN_SIRONKO & EELFROTH";
final String GAME_TITLE = "bl4kK_h013";
final float GAME_VERSION = 0.2;
final String CREATION_DATE = "SETTING_ORANGE\t62TH_OF_DISCORD\tYOLD_3180";

//PREFERENCES//
final int BUFFER_WIDTH = 320;
final int BUFFER_HEIGHT = 320;
final int FRAME_WIDTH = 640;
final int FRAME_HEIGHT = 480;
final int FRAME_RATE = 60;
final int TEXTURE_SAMPLING = 2;
final boolean VERBOSE = true;
final int BUFFER_OPACITY = 200;

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
//SET_UP_FRAME// 
  size(FRAME_WIDTH, FRAME_HEIGHT, JAVA2D);
  noSmooth();
  colorMode(HSB);
  
//MAKE_LOG//
  log = new MLog(6, 36);
  
//STATE_YOUR_NAME_AND_OCCUPATION//
  log.add_line("-----------------------------------------------");
  log.add_line("| "+GAME_TITLE + " \t" + GAME_VERSION + " \t" + AUTHOR + "|");
  log.add_line("| "+CREATION_DATE+" |");
  log.add_line("-----------------------------------------------");
  log.add_line();
  
  int start_millis = millis();
          if(VERBOSE) log.add_line("SETUP_START_AT: " + millis() + " ms");
          if(VERBOSE) log.add_line("FRAME_SIZE: \t" + FRAME_WIDTH + "x" + FRAME_HEIGHT);

//SET_UP_BUFFER//
  //((PGraphicsOpenGL)g).textureSampling(TEXTURE_SAMPLING); //only in P2D
  //        if(VERBOSE) log.add_line("TEXTURE_SAMPLING: \t" + TEXTURE_SAMPLING);
          
  buffer = createGraphics(BUFFER_WIDTH, BUFFER_HEIGHT, JAVA2D);
  buffer_image = createImage(BUFFER_WIDTH, BUFFER_HEIGHT, RGB);
          if(VERBOSE) log.add_line("BUFFER_SIZE: \t" + BUFFER_WIDTH + "x" + BUFFER_HEIGHT);
          
//DRAWING_PROPERTIES//
  //buffer.noSmooth();
  buffer.colorMode(HSB);
          if(VERBOSE) log.add_line("COLOR_MODE: \tHSB, \t255");
  buffer_tint = color(255, BUFFER_OPACITY);
          if(VERBOSE) log.add_line("BUFFER_OPACITY:\t" + BUFFER_OPACITY);
  
//CONTROL_THE_FLOW_OF_TIME//
  frameRate(60);
          if(VERBOSE) log.add_line("FRAME_RATE: \t" + FRAME_RATE);
          
//LOAD_FONT//
  String FONT_TYPE = "DejaVuSansMono";
  //String FONT_TYPE = "UbuntuMono-Regular";
  //String FONT_TYPE = "Code2002";

          if(VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-14.vlw");
  int mil = millis();
  font_log = loadFont(FONT_TYPE+"-14.vlw");
  textFont(font_log);
  textSize(max(ceil(float(FRAME_HEIGHT)/36), 14));
          if(VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
          //if(VERBOSE) log.add_line("GLYPHS_IN_FONT: \t" + glyphs(font_log));
          
//LOAD_SECOND_FONT//
          if(VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-48.vlw");
  mil = millis();
  font_orb = loadFont(FONT_TYPE+"-48.vlw");
          if(VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
          //if(VERBOSE) log.add_line("GLYPHS_IN_FONT: \t" + glyphs(font_log));
  
  
          if(VERBOSE) log.add_line("SETUP_DONE_AT: \t" + millis() + " ms");
          if(VERBOSE) log.add_line("SETUP_RUNTIME: \t" + (millis()-start_millis) + " ms");
          if(VERBOSE) log.add_line();
          
  //INITIALIZE_GAME_ELEMENTS//
  dif = (FRAME_WIDTH*FRAME_HEIGHT) - (BUFFER_WIDTH*BUFFER_HEIGHT);
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

int offset = 2;
int dif;

void draw() {
//GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * FRAME_RATE;
  last_millis = millis();
  
  offset += frameRate;
  //if (offset > dif) offset -= dif;
  offset %= dif;
  
  buffer.loadPixels();
  loadPixels();
  //int dif = pixels.length - buffer.pixels.length;
  //int offset = (frameCount * frameCount) % dif;
  for(int i=offset%(5); i<buffer.pixels.length; i+=(5)) {
    buffer.pixels[i] = pixels[i + offset];
  }
  buffer.updatePixels();
  //updatePixels();
  
//DRAW_GAME_TO_BUFFER//
  buffer.beginDraw();
  {
    buffer.noSmooth();
    //buffer.background(0):
    buffer.fill(0, 24 * delta);
    buffer.noStroke();
    buffer.rect(0, 0, buffer.width, buffer.height);
    
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
  stroke(color(23, 100, 200));
  rect(4, 0, 128, 36);
  fill(color(23, 100, 200));
  text("fR: " + frameRate + " \n∆t: " + delta, 10, 14);
  //text(hex(dif) + "\n" + hex(offset), 10, 14);
  
//DISPLAY_LOG//
  log.update(delta);
  log.display();
  
  //loadPixels();
  //for(int i=0; i<buffer.pixels.length; i++) {
//  pixels[offset] = color(0, 255, 255);
  //}
  //updatePixels();
  //stroke(color(random(255), random(255), random(255), random(255)));
  //line(offset%width, offset/width, (offset+buffer.pixels.length)%width, (offset+buffer.pixels.length)/width);
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

int glyphs(PFont font) {
  int a = 0;
  int i = 0;
  while(i>a) {
    while(font.getGlyph(i) == null) {
      i++;
    }
    a++;
    //if(i <= 0) break;
  }
  return a;
}
