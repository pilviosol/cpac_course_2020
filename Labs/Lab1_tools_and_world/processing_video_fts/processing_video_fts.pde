import gab.opencv.*; //<>// //<>// //<>//
import processing.video.*;

Capture cam;
PImage old_frame;
PImage diff_frame;
boolean is_first_frame=true; 

/* EFFECTS CODE */
int NO_EFFECT=0;
int EFFECT_SWITCH_COLORS=1;
int EFFECT_DIFF_FRAMES=2;

int effect=EFFECT_DIFF_FRAMES;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[3]);
    cam.start();
    
  }
  
}

void copy2img(Capture camera, PImage img) {
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    img.pixels[i]=camera.pixels[i];
  }
  img.updatePixels();
}

void copy_img(PImage src, PImage dst) {
  
  dst.loadPixels();
  src.loadPixels();
  for (int i=0; i<src.width*src.height; i++) {
    dst.pixels[i]=src.pixels[i];
  }
  dst.updatePixels();
}


float[] getColors(color pixel) {
  float[] colors={red(pixel), blue(pixel),green(pixel)};
  return colors;
}

void effectDiffFrames(PImage img){
  if (is_first_frame) {
    old_frame = createImage(img.width, img.height, RGB);
    diff_frame = createImage(img.width, img.height, RGB);
    copy_img(img, old_frame);
    is_first_frame=false;
    img = createImage(0, 0, RGB);
    return; 
  }
  diff_frame.loadPixels();
  old_frame.loadPixels();  
  for (int i=0; i<cam.width*cam.height; i++) {
    float[] old_colors=getColors(old_frame.pixels[i]); //<>//
    float[] colors=getColors(img.pixels[i]);
    diff_frame.pixels[i]=color(abs(colors[0]-old_colors[0]), 
                                abs(colors[1]-old_colors[1]), 
                                abs(colors[2]-old_colors[2]));
    
  }
  diff_frame.updatePixels();
  copy_img(img, old_frame);
  copy_img(diff_frame, img);
  
}
void changeColors(PImage img){
  img.loadPixels();
  for (int i=0; i<img.width*img.height; i++) {
    img.pixels[i]=color(blue(img.pixels[i]),
                        red(img.pixels[i]),
                        green(img.pixels[i]));
  }
  img.updatePixels();
  
}
void draw() {
  if (! cam.available()) {return;}
  cam.read();
  
  PImage img=createImage(cam.width,cam.height,RGB);
  copy2img(cam, img);
  if(effect==EFFECT_DIFF_FRAMES){
     effectDiffFrames(img);
  }
  else if(effect==EFFECT_SWITCH_COLORS){
    changeColors(img);
  }
  else{
    /*NO EFFECT*/;
  }
  
  
  
  if(img.width>0){
    image(img, 0, 0);
  }

}
