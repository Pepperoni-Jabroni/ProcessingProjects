PImage sample;
float curX, curY, curThet, a, b, start;
final float E = 2.7182818284;

class Point{
  float x, y;
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
}

void setup(){
  size(600, 600);
  curX = width / 2;
  curY = height / 2;
  curThet = 0;
  a = 1;
  b = 1;
  start = .5;
  sample = loadImage("pic.png");
  imageMode(CORNER);
  image(sample, 0, 0, width, height);
  loadPixels();
  //background(155);
  for(int r = 10; r < (width / 2); r += 1){
    //drawPolarEllipse(curX, curY, curThet, r*.05*pow(E, curThet*b), 10, 10);
    Point p = toPoint(curX, curY, curThet, r);
    color c = pixels[(int)(p.y*width + p.x)];
    fill(c);
    drawPolarEllipse(curX, curY, curThet, r, 10, 10);
    curThet += start;
    if(curThet > 2 * PI)
      curThet -= 2 * PI;
  }
}

void draw(){
  
}

void drawPolarEllipse(float xOr, float yOr, float theta, float radius, float w, float h){
  //Plus x because 0 is in positive direction but minus y because pi/2 is in negative direction
  ellipse(xOr+radius*cos(theta), yOr-radius*sin(theta), w, h);
}

Point toPoint(float xOr, float yOr, float theta, float radius){
  return new Point(xOr+radius*cos(theta), yOr-radius*sin(theta));
}