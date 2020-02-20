/*To enable record mode, do the following
  RECORD_MODE = true
  REC_COLOR = 0
  B_COLOR = 30
  BACKG = 140
  DARK_LARGE = false
  NUM_ROT = 46.0
  
  In order to make sure you don't invert the image
  DARK_LARGE = false -> big B_COLOR, small BACKG
  DARK_LARGE = true  -> small B_COLOR, big BACKG
*/
PImage imageToSpiralize;
final float A = 2.0, B = 1.5, DOT_MIN = 0.7, DOT_MAX = 3.7, NUM_ROT = 80.0;
final boolean USE_B_COLOR = true, DARK_LARGE = true, RECORD_MODE = false;
final color REC_COLOR = color(0);
final color B_COLOR = color(0);
final color BACKG = color(128);

void setup(){
  size(1920, 1080);
  smooth(8);
  imageToSpiralize = loadImage("pic3.jpg");
  imageMode(CENTER);
  image(imageToSpiralize, width/2, height/2, 700, 750);
  loadPixels();
  background(BACKG);
  float x, y, size;
  int loc;
  if(RECORD_MODE){
    stroke(REC_COLOR);
    fill(REC_COLOR);
    ellipse(width/2, height/2, height, height);
  }
  stroke(B_COLOR);
  fill(B_COLOR);
  for(float t = 0.0; t < PI*NUM_ROT; t += PI/720){
    x = width/2 + ((A*t)+sin(B*t*t))*cos(t);
    y = height/2 - ((A*t)+sin(B*t*t))*sin(t);
    loc = width*int(y)+int(x);
    size = 1.0;
    if(loc >= 0 && loc < width * height){
      if(!USE_B_COLOR){
        stroke(pixels[loc]);
        fill(pixels[loc]);
      }
      if(DARK_LARGE)
        size = map(abs(255-brightness(pixels[loc])), 0, 255, DOT_MIN, DOT_MAX);
      else
        size = map(brightness(pixels[loc]), 0, 255, DOT_MIN, DOT_MAX);
    }
    ellipse(x, y, DOT_MIN, DOT_MIN);
  }
  if(RECORD_MODE){
    stroke(255);
    fill(94, 155, 255);
    ellipse(width/2, height/2, 140, 140);
    stroke(255);
    fill(BACKG);
    ellipse(width/2, height/2, 40, 40);
  }
}

void draw(){
  
}

void keyPressed(){
  if(key == 's'){
    saveFrame();
    println("Saved!");
  }
}
