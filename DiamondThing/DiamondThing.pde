PImage whiteDiamond, grayDiamond;
final int NODE_DENSITY = 18, DIAMOND_SIZE = 40;
final float IMAGE_MULTIPLIER = 8;
float[][] dist;
int wid, hei;

void setup(){
  size(1920,1080);
  imageMode(CENTER);
  whiteDiamond = loadImage("WhiteDiamond.png");
  grayDiamond = loadImage("GrayDiamond.png");
  wid = hei = 0;
  for(int i = NODE_DENSITY+DIAMOND_SIZE; i+DIAMOND_SIZE < width; i += NODE_DENSITY+DIAMOND_SIZE){
    for(int j = NODE_DENSITY+DIAMOND_SIZE; j+DIAMOND_SIZE < height; j += NODE_DENSITY+DIAMOND_SIZE){
      if(i == NODE_DENSITY+DIAMOND_SIZE)
        hei++;
    }
    wid++;
  }
  dist = new float[wid][hei];
  drawNew();
}

void draw(){
  
}

void mouseClicked(){
  drawNew();
}

void drawNew(){
  int curX = (int)random(wid);
  int curY = (int)random(hei);
  background(170);
  for(int i = 0; i < wid; i++){
    for(int j = 0; j < hei; j++){
      dist[i][j] = sqrt(pow(curX - i, 2.0) + pow(curY - j, 2.0));
      float whiteSize = (float)(dist[i][j]*NODE_DENSITY/IMAGE_MULTIPLIER);
      if(whiteSize > DIAMOND_SIZE)
        whiteSize = DIAMOND_SIZE;
      /*if(dist[i][j]== 0){
        fill(255,0,0);
        rect((i+1)*(NODE_DENSITY+DIAMOND_SIZE)-(DIAMOND_SIZE/2)-2,(j+1)*(NODE_DENSITY+DIAMOND_SIZE)-(DIAMOND_SIZE/2)-2,DIAMOND_SIZE+3,DIAMOND_SIZE+3);
      }*/
      image(grayDiamond,  (i+1)*(NODE_DENSITY+DIAMOND_SIZE), (j+1)*(NODE_DENSITY+DIAMOND_SIZE), DIAMOND_SIZE, DIAMOND_SIZE);
      image(whiteDiamond, (i+1)*(NODE_DENSITY+DIAMOND_SIZE), (j+1)*(NODE_DENSITY+DIAMOND_SIZE), whiteSize, whiteSize);
    }
  }
  saveFrame("DiamondThing.png");
}
