import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

import java.awt.event.KeyEvent; 
//import java.awt.Font;

////////////////////////////////////////////////////////////////////////////

//INFO//
final String AUTHOR = "BEN_SIRONKO & EELFROTH";
final String GAME_TITLE = "BLACK_HOLE";
final float GAME_VERSION = 0.5;
final String CREATION_DATE = "PUNGENDAY\t\t70TH_OF_DISCORD\t\tYOLD_3180";

//PREFERENCES//
final int BUFFER_WIDTH = 320;
final int BUFFER_HEIGHT = 320;
final int FRAME_WIDTH = 640;
final int FRAME_HEIGHT = 480;
final int WINDOW_WIDTH = 640;//1100;
final int WINDOW_HEIGHT = 480;//730;
final int GAME_SPEED = 40;
final boolean VERBOSE = false;
final int BUFFER_OPACITY = 200;

////////////////////////////////////////////////////////////////////////////

//SKETCH_VARIABLES//
PGraphics buffer, framebuffer;
color buffer_tint;
float delta;
int last_millis;
MLog log;
PFont font_log, font_orb; 
float text_size;
PShader scalingShader, swirlShader, bgShader;
PImage bg_image, vignette;

//SHADER_VARIABLES//
int offset = 2;
int dif;
float swirlRadius = BUFFER_HEIGHT/2;
final float swirlAngle = 1;

ControlIO control;
Configuration config;
ControlDevice gpad;

Minim minim;
AudioPlayer OST, s_jump, s_land, s_die, s_jingle;


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
  if (VERBOSE) log.add_line("SETUP_START_AT: " + start_millis + " ms");
  if (VERBOSE) log.add_line("WINDOW_SIZE: \t" + WINDOW_WIDTH + "x" + WINDOW_HEIGHT);

  //SET_UP_BUFFER//
  buffer = createGraphics(BUFFER_WIDTH, BUFFER_HEIGHT, P2D);
  if (VERBOSE) log.add_line("BUFFER_SIZE: \t" + BUFFER_WIDTH + "x" + BUFFER_HEIGHT);
  framebuffer = createGraphics(FRAME_WIDTH, FRAME_HEIGHT, P2D);

  //DRAWING_PROPERTIES//
  //buffer.noSmooth();
  buffer.colorMode(HSB);
  if (VERBOSE) log.add_line("COLOR_MODE: \tHSB, \t255");
  buffer_tint = color(255, BUFFER_OPACITY);
  if (VERBOSE) log.add_line("BUFFER_OPACITY:\t" + BUFFER_OPACITY);

  //CONTROL_THE_FLOW_OF_TIME//
  frameRate(9999);
  if (VERBOSE) log.add_line("GAME_SPEED: \t" + GAME_SPEED);

  //LOAD_FONT//
  //String FONT_TYPE = "DejaVuSansMono";
  //String FONT_TYPE = "UbuntuMono-Regular";
  //String FONT_TYPE = "Code2002";
  String FONT_TYPE = "ChixaDemiBold";

  if (VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-14.vlw");
  int mil = millis();
  font_log = loadFont(FONT_TYPE+"-14.vlw");
  textFont(font_log);
  textSize(text_size);
  if (VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
  if (VERBOSE) log.add_line("GLYPHS_IN_FONT:\t" + font_log.getGlyphCount());

  //LOAD_SECOND_FONT//

  if (VERBOSE) log.add_line("LOAD_FONT: \t\t"+FONT_TYPE+"-28.vlw");
  mil = millis();
  font_orb = loadFont(FONT_TYPE+"-28.vlw");
  if (VERBOSE) log.add_line("LOAD_TIME: \t\t" + (millis() - mil) + " ms");
  if (VERBOSE) log.add_line("GLYPHS_IN_FONT:\t" + font_orb.getGlyphCount());


  //font_orb = font_log;  
  //LOAD_SHADERS//
  if (VERBOSE) log.add_line("LOAD_SHADER: \tscaling.frag");
  swirlShader = loadShader("swirl.frag");
  swirlShader.set("pixelSize", buffer.width / 1.0F, buffer.height / 1.0F); //WINDOW_WIDTH / BUFFER_WIDTH, WINDOW_HEIGHT / BUFFER_HEIGHT);
  swirlShader.set("pixelOffset", 0.5F / buffer.width, 0.5F / buffer.height);
  /*if(VERBOSE) log.add_line("LOAD_SHADER: \twhirl.frag, whirl.vert");
   whirlShader = loadShader("whirl.frag");
   whirlShader.set("resolution", float(buffer.width), float(buffer.height));
   whirlShader.set("time", 0.0F);*/
  swirlShader.set("texSize", float(buffer.width), float(buffer.height));
  swirlShader.set("radius", swirlRadius);
  swirlShader.set("angle", swirlAngle);
  swirlShader.set("center", float(buffer.width)/2, float(buffer.height)/2);
  swirlShader.set("time", 0.0F);
  if (VERBOSE) log.add_line("LOAD_SHADER: \tbg.frag");
  bgShader = loadShader("bg.frag");
  bgShader.set("texSize", float(buffer.width), float(buffer.height));
  bgShader.set("time", 0.0F);
  scalingShader = loadShader("scaling.frag");
  scalingShader.set("pixelSize", buffer.width / 1.0F, buffer.height / 1.0F); //WINDOW_WIDTH / BUFFER_WIDTH, WINDOW_HEIGHT / BUFFER_HEIGHT);
  scalingShader.set("pixelOffset", 0.5F / buffer.width, 0.5F / buffer.height);

  //HACKY STUFF//
  dif = (WINDOW_WIDTH*WINDOW_HEIGHT) - (BUFFER_WIDTH*BUFFER_HEIGHT);
  bg_image = loadImage("bg_image.png");
  vignette = loadImage("vignette.png");
  control = ControlIO.getInstance(this);
  gpad = control.getMatchedDevice("xbox_controller");
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  minim = new Minim(this);
  OST = minim.loadFile("black hole.mp3");
  OST.setVolume(2);
  OST.loop();
  s_jump  = minim.loadFile("jump off.wav");
  s_die = minim.loadFile("Suckin.wav");
  s_land = minim.loadFile("landon.wav");
  s_jingle = minim.loadFile("jingle.wav");

  //FINISH_SETUP//
  if (VERBOSE) log.add_line("SETUP_DONE_AT: \t" + millis() + " ms");
  if (VERBOSE) log.add_line("SETUP_RUNTIME: \t" + (millis()-start_millis) + " ms");
  if (VERBOSE) log.add_line();


  //INITIALIZE_GAME_ELEMENTS//
  initialize(millis());
}

////////////////////////////////////////////////////////////////////////////


void draw() {
  getGpad();
  //GET_DELTA_TIME//
  delta = float(millis() - last_millis)/1000 * GAME_SPEED;
  last_millis = millis();

  //UPDATE_AND_RENDER_THE_GAME//
  update(delta);

  //RENDER_BUFFER_TO_FRAMEBUFFER//
  swirlShader.set("radius", swirlRadius);
  swirlShader.set("angle", swirlAngle);
  //swirlShader.set("time", float(millis())/10000);
  framebuffer.beginDraw();
  framebuffer.shader(swirlShader);
  framebuffer.tint(buffer_tint);
  framebuffer.image(buffer, 0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  //framebuffer.text("fR: " + frameRate + " \n∆t: " + delta, 10, max(ceil(float(WINDOW_HEIGHT)/36), text_size));
  framebuffer.resetShader();

  framebuffer.shader(scalingShader);
  framebuffer.pushMatrix();
  framebuffer.translate(framebuffer.width/2, framebuffer.height/2);
  framebuffer.rotate(-float(millis())/1000);
  framebuffer.imageMode(CENTER);
  framebuffer.tint(255, 128);
  framebuffer.image(vignette, 0, 0, framebuffer.width*2, framebuffer.height*2);
  //framebuffer.image(vignette, 0, 0, framebuffer.width, framebuffer.height);
  framebuffer.imageMode(CORNER);
  framebuffer.popMatrix();

  framebuffer.endDraw();

  //&:THEN_TO_THE_WINDOW//
  shader(scalingShader);
  image(framebuffer, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
  resetShader();


  //SHOW_ME_THE_RATES//
  fill(0);
  stroke(color(23, 100, 200));
  //rect(text_size * 0.5, text_size * 0.5, text_size * 10, text_size * 2.64);
  fill(color(23, 100, 200));
  text("\nfR: " + frameRate/* + " \n∆t: " + delta*/, 10, max(ceil(float(WINDOW_HEIGHT)/36), text_size));
  text("GAME BY BEN_SIRONKO AND EELFROTH                  SFX AND OST BY FELIX_VON_DOHLEN AND BILI_RUBIN", 10, WINDOW_HEIGHT-14);
  //text(hex(dif) + "\n" + hex(offset), 10, 14);
  text("SCORE = " + score, 10, max(ceil(float(WINDOW_HEIGHT)/36), text_size));


  //DISPLAY_LOG//
  if (VERBOSE) log.update(delta);
  if (VERBOSE) log.display();
}

////////////////////////////////////////////////////////////////////////////

/*void keyPressed() {
 if(key == CODED) {
 if(keyCode == KeyEvent.VK_F12) {
 initialize(millis());
 }
 if(keyCode == KeyEvent.VK_F11) {
 setup();
 }
 } 
 }*/
void keyPressed() {
  if (player.alive) {

    if (key == CODED) {

      if (keyCode == UP && player.attached && player.ready_to_jump) {

        player.jump();
      } else if (keyCode == RIGHT) {

        player.right_down = true;
      } else if (keyCode == LEFT) {

        player.left_down = true;
      }
    }
  } else {

    if (key == CODED && keyCode == UP) {

      if (orbs[last_spawned].alive && !orbs[last_spawned].attached) {

        player.spawn();
        player.attach_to_orb(orbs[last_spawned]);
      }
    }
  }
}

void keyReleased() {

  if (player.alive) {

    if (key == CODED) {

      if (keyCode == UP) {

        player.ready_to_jump = true;
      } else if (keyCode == RIGHT) {

        player.right_down = false;
      } else if (keyCode == LEFT) {

        player.left_down = false;
      }
    }
  }
}

void getGpad() {
  if (player.alive) {
    if (gpad.getButton("JUMP").pressed()) {
      if (player.attached && player.ready_to_jump) player.jump();
    } else {
      player.ready_to_jump = true;
    }
    if (gpad.getSlider("X").getValue() > 0.1) player.right_down = true;
    else player.right_down = false;
    if (gpad.getSlider("X").getValue() < -0.1) player.left_down = true;
    else player.left_down = false;
  } else if (gpad.getButton("JUMP").pressed()) {
    if (orbs[last_spawned].alive && !orbs[last_spawned].attached) {

      player.spawn();
      player.attach_to_orb(orbs[last_spawned]);
      player.ready_to_jump = false;
      orb_iterator++;
      score = "";
      s_jingle.play(0);
    }
  }
}

////////////////////////////////////////////////////////////////////////////

