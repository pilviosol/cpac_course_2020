import gab.opencv.*; //<>// //<>// //<>//
import processing.video.*;

Capture cam;
PImage old_frame;
PImage diff_frame;
boolean is_first_frame=true;
int effect=0; // 0: diff of frames
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
  camera.loadPixels();
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    img.pixels[i]=camera.pixels[i];
  }
  img.updatePixels();
}
float[] getColors(color pixel) {
  float[] colors={red(pixel), blue(pixel),green(pixel)};
  return colors;
}

PImage effectDiffFrames(Capture cam){
  if (is_first_frame) {
    old_frame = createImage(cam.width, cam.height, RGB);
    diff_frame = createImage(cam.width, cam.height, RGB);
    copy2img(cam, old_frame);
    is_first_frame=false;
    return createImage(0, 0, RGB);
  }
  diff_frame.loadPixels();
  old_frame.loadPixels();  
  cam.loadPixels();
  for (int i=0; i<cam.width*cam.height; i++) {
    float[] old_colors=getColors(old_frame.pixels[i]); //<>//
    float[] colors=getColors(cam.pixels[i]);
    diff_frame.pixels[i]=color(abs(colors[0]-old_colors[0]), 
                                abs(colors[1]-old_colors[1]), 
                                abs(colors[2]-old_colors[2]));
    
  }
  diff_frame.updatePixels();
  copy2img(cam, old_frame);
  return diff_frame;
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  } 
  else{
    return;
  }
  PImage img=createImage(0,0,RGB);
  if(effect==0){
     img = effectDiffFrames(cam);
  }
  
  if(img.width>0){
    image(img, 0, 0);
  }

}
