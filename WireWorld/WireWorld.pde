final int boxSize = 20, frameR = 10;
int curFrame, paintMode;
Color[][] boxVals;
Color blankC, outline, wire, elecH, elecT;
boolean running;

class Color{
  int r,g,b;
  Color(){
    r = g = b = 255;
  }
  Color(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

void setup(){
  size(960,600);
  running = false;
  curFrame = 1;
  paintMode = 0;
  blankC = new Color(0,0,0);
  outline = new Color(150,150,150);
  wire = new Color(255, 242, 0);
  elecH = new Color(0,0,255);
  elecT = new Color(255,0,0);
  boxVals = new Color[width/boxSize][height/boxSize];
  for(int i = 0; i < width/boxSize; i++){
    for(int j = 0; j < height/boxSize; j++){
      boxVals[i][j] = new Color(blankC.r, blankC.g, blankC.b);
    }
  }
  drawGrid();
}

void draw(){
  if(running){
    if(curFrame % frameR == 0){
      curFrame = 1;
      doStep();
      drawGrid();
    }
    else
      curFrame++;
  }
}

void mouseClicked(){
  int xI, yI;
  xI = mouseX/boxSize;
  yI = mouseY/boxSize;
  switch(paintMode){
    case 0:
      boxVals[xI][yI].r = blankC.r;
      boxVals[xI][yI].g = blankC.g;
      boxVals[xI][yI].b = blankC.b;
      break;
    case 1:
      boxVals[xI][yI].r = wire.r;
      boxVals[xI][yI].g = wire.g;
      boxVals[xI][yI].b = wire.b;
      break;
    case 2:
      boxVals[xI][yI].r = elecH.r;
      boxVals[xI][yI].g = elecH.g;
      boxVals[xI][yI].b = elecH.b;
      break;
    case 3:
      boxVals[xI][yI].r = elecT.r;
      boxVals[xI][yI].g = elecT.g;
      boxVals[xI][yI].b = elecT.b;
      break;
  }
  drawGrid();
}

void mouseDragged(){
  int xI, yI;
  Color c = new Color();
  xI = mouseX/boxSize;
  yI = mouseY/boxSize;
  switch(paintMode){
    case 0:
      boxVals[xI][yI].r = c.r = blankC.r;
      boxVals[xI][yI].g = c.g = blankC.g;
      boxVals[xI][yI].b = c.b = blankC.b;
      break;
    case 1:
      boxVals[xI][yI].r = c.r = wire.r;
      boxVals[xI][yI].g = c.g = wire.g;
      boxVals[xI][yI].b = c.b = wire.b;
      break;
    case 2:
      boxVals[xI][yI].r = c.r = elecH.r;
      boxVals[xI][yI].g = c.g = elecH.g;
      boxVals[xI][yI].b = c.b = elecH.b;
      break;
    case 3:
      boxVals[xI][yI].r = c.r = elecT.r;
      boxVals[xI][yI].g = c.g = elecT.g;
      boxVals[xI][yI].b = c.b = elecT.b;
      break;
  }
  stroke(outline.r,outline.g,outline.b);
  fill(c.r,c.g,c.b);
  xI *= boxSize;
  yI *= boxSize;
  rect(xI, yI, boxSize, boxSize);
}

void keyPressed(){
  //Step
  if(key == 's'){
    doStep();
    drawGrid();
  }
  //Erase
  if(key == 'e'){
    for(int i = 0; i < width/boxSize; i++){
      for(int j = 0; j < height/boxSize; j++){
        boxVals[i][j].r = blankC.r;
        boxVals[i][j].g = blankC.g;
        boxVals[i][j].b = blankC.b;
      }
    }
    drawGrid();
  }
  //Run
  if(key =='r')
    running = !running;
  //Change paint mode
  if(key == 't'){
    if(paintMode < 3)
      paintMode++;
    else
      paintMode = 0;
  }
}

int numNeighbors(int x, int y, Color[][] boxV){
  int numNei = 0;
  for(int i = x - 1; i < x + 2; i++){
    for(int j = y - 1; j < y + 2; j++){
      if(i != x || j != y){
        if(i >= 0 && j >= 0 && i < width/boxSize && j < height/boxSize){
          if(boxV[i][j].r == elecH.r && boxV[i][j].g == elecH.g && boxV[i][j].b == elecH.b){
            numNei++;
          }
        }
      }
    }
  }
  return numNei;
}

void drawGrid(){
  Color c;
  int xOr, yOr;
  for(int i = 0; i < width/boxSize; i++){
    for(int j = 0; j < height/boxSize; j++){
      c = boxVals[i][j];
      stroke(outline.r,outline.g,outline.b);
      fill(c.r,c.g,c.b);
      xOr = i*boxSize;
      yOr = j*boxSize;
      rect(xOr, yOr, boxSize, boxSize);
    }
  }
}

void doStep(){
 Color[][] temp = new Color[width/boxSize][height/boxSize];
  for(int i = 0; i < width/boxSize; i++){
    for(int j = 0; j < height/boxSize; j++){
      temp[i][j] = new Color(boxVals[i][j].r,boxVals[i][j].g,boxVals[i][j].b);
    }
  }
  Color c;
  int numN;
  for(int i = 0; i < width/boxSize; i++){
    for(int j = 0; j < height/boxSize; j++){
      numN = numNeighbors(i, j, temp);
      c = temp[i][j];
      //Turn tail into wire
      if(c.r == elecT.r && c.g == elecT.g && c.b == elecT.b){
        boxVals[i][j].r = wire.r;
        boxVals[i][j].g = wire.g;
        boxVals[i][j].b = wire.b;
      }
      //Turn head into tail
      else if(c.r == elecH.r && c.g == elecH.g && c.b == elecH.b){
        boxVals[i][j].r = elecT.r;
        boxVals[i][j].g = elecT.g;
        boxVals[i][j].b = elecT.b;
      }
      //Turn wire into head
      else if((numN == 1 || numN == 2) && c.r == wire.r && c.g == wire.g && c.b == wire.b){
        boxVals[i][j].r = elecH.r;
        boxVals[i][j].g = elecH.g;
        boxVals[i][j].b = elecH.b;
      }
    }
  }
}