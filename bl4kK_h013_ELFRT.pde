import java.awt.event.KeyEvent; 
import java.awt.Font;

////////////////////////////////////////////////////////////////////////////

//INFO//
final String AUTHOR = "BEN_SIRONKO & EELFROTH";
final String GAME_TITLE = "bl4kK_h013";
final float GAME_VERSION = 0.2;
final String CREATION_DATE = "SETTING_ORANGE\t62TH_OF_DISCORD\tYOLD_3180";

//PREFERENCES//
final int BUFFER_WIDTH = 96;
final int BUFFER_HEIGHT = 96;
final int FRAME_WIDTH = 1100;
final int FRAME_HEIGHT = 760;
final int FRAME_RATE = 60;
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
PShader scalingShader;

void setup() { 
//SET_UP_FRAME// 
  size(FRAME_WIDTH, FRAME_HEIGHT, P2D);
  noSmooth();
  colorMode(HSB);
  text_size = max(ceil(float(FRAME_HEIGHT)/36), 14);
  
//MAKE_LOG//
  log = new MLog(6, text_size*3);
  
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
          if(VERBOSE) log.add_line("FRAME_RATE: \t" + FRAME_RATE);
          
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
          //if(VERBOSE) log.add_line("GLYPHS_IN_FONT: \t" + glyphs(font_log));
          
//LOAD_SECOND_FONT//
          if(VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-48.vlw");
  mil = millis();
  font_orb = loadFont(FONT_TYPE+"-48.vlw");
          if(VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
          //if(VERBOSE) log.add_line("GLYPHS_IN_FONT: \t" + glyphs(font_log));

          
//LOAD_SHADERS//
          if(VERBOSE) log.add_line("LOAD_SHADER: \tscaling.frag");
  scalingShader = loadShader("scaling.frag");
  scalingShader.set("pixelSize", buffer.width / 1.0F, buffer.height / 1.0F); //FRAME_WIDTH / BUFFER_WIDTH, FRAME_HEIGHT / BUFFER_HEIGHT);
  scalingShader.set("pixelOffset", 0.5F / buffer.width, 0.5F / buffer.height);
  
//FINISH_SETUP//
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
  offset %= max(dif,1);
  
  
  
//DRAW_GAME_TO_BUFFER//
  buffer.beginDraw();
  {
    //buffer.noSmooth();
    buffer.fill(0, 48 * delta);
    buffer.noStroke();
    buffer.rect(0, 0, buffer.width, buffer.height);
    
    for(Orb orb : orbs) {
      orb.update(delta);
      orb.display();
    }
  }
  buffer.endDraw();
  
//DRAW_BUFFER_TO_FRAME//
  tint(buffer_tint);
  shader(scalingShader);
  image(buffer, 0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  resetShader();
  
//SHOW_ME_THE_RATES//
  fill(0);
  stroke(color(23, 100, 200));
  rect(4, 0, FRAME_WIDTH/4, text_size * 2.64);
  fill(color(23, 100, 200));
  text("fR: " + frameRate + " \n∆t: " + delta, 10, max(ceil(float(FRAME_HEIGHT)/36), 14));
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
