final int boxSize = 20, frameR = 100;
int curFrame;
Color[][] boxVals;
Color blankC, outline;
ArrayList<Color> surviveC;
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
  curFrame = 0;
  blankC = new Color(255,255,255);
  outline = new Color(150,150,150);
  surviveC = new ArrayList<Color>();
  surviveC.add(new Color(183, 16, 16));
  surviveC.add(new Color(216, 133, 49));
  surviveC.add(new Color(252, 252, 15));
  surviveC.add(new Color(10, 181, 42));
  surviveC.add(new Color(22, 36, 124));
  surviveC.add(new Color(141, 42, 211));
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
      curFrame = 0;
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
  if(mouseButton == LEFT){
    boxVals[xI][yI].r = surviveC.get(0).r;
    boxVals[xI][yI].g = surviveC.get(0).g;
    boxVals[xI][yI].b = surviveC.get(0).b;
  }
  else{
    boxVals[xI][yI].r = blankC.r;
    boxVals[xI][yI].g = blankC.g;
    boxVals[xI][yI].b = blankC.b;
  }
  drawGrid();
}

void mouseDragged(){
  int xI, yI;
  Color c = new Color();
  xI = mouseX/boxSize;
  yI = mouseY/boxSize;
  if(mouseButton == LEFT){
    boxVals[xI][yI].r = c.r = surviveC.get(0).r;
    boxVals[xI][yI].g = c.g = surviveC.get(0).g;
    boxVals[xI][yI].b = c.b = surviveC.get(0).b;
  }
  else{
    boxVals[xI][yI].r = c.r = blankC.r;
    boxVals[xI][yI].g = c.g = blankC.g;
    boxVals[xI][yI].b = c.b = blankC.b;
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
}

int indexOfColor(Color c, ArrayList<Color> a){
  for(int i = 0; i < a.size(); i++){
    if(a.get(i).r == c.r && a.get(i).g == c.g && a.get(i).b == c.b)
      return i;
  }
  return -1;
}

boolean containsColor(Color c, ArrayList<Color> a){
  for(int i = 0; i < a.size(); i++){
    if(a.get(i).r == c.r && a.get(i).g == c.g && a.get(i).b == c.b)
      return true;
  }
  return false;
}

int numNeighbors(int x, int y, Color[][] boxV){
  int numNei = 0;
  for(int i = x - 1; i < x + 2; i++){
    for(int j = y - 1; j < y + 2; j++){
      if(i != x || j != y){
        if(i >= 0 && j >= 0 && i < width/boxSize && j < height/boxSize){
          if(boxV[i][j].r != blankC.r || boxV[i][j].g != blankC.g || boxV[i][j].b != blankC.b){
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
      rect(xOr, yOr, xOr + boxSize, yOr + boxSize);
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
      /*if(numN != 0)
        println(i+","+j+" is "+numN);*/
      c = temp[i][j];
      if(numN == 3 && c.r == blankC.r && c.g == blankC.g && c.b == blankC.b){
        //Born
        boxVals[i][j].r = surviveC.get(0).r;
        boxVals[i][j].g = surviveC.get(0).g;
        boxVals[i][j].b = surviveC.get(0).b;
      }
      else if((numN == 2 || numN == 3) && containsColor(c, surviveC)){
        //Survives
        Color next;
        int ind = indexOfColor(c, surviveC);
        if(ind < surviveC.size() - 1)
          next = surviveC.get(ind + 1);
        else
          next = surviveC.get(ind);
        boxVals[i][j].r = next.r;
        boxVals[i][j].g = next.g;
        boxVals[i][j].b = next.b;
      }
      else{
        //Dies
        boxVals[i][j].r = blankC.r;
        boxVals[i][j].g = blankC.g;
        boxVals[i][j].b = blankC.b;
      }
    }
  }
}