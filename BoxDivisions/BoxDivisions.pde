final int MEAN_DIVI = 7,
          STDDEV_DIVI = 3,
          BOX_SIZE = 100,
          BOX_DENS = 25;
int wid, hei;
ArrayList<Color> boxColors;
Color backgroundC;

class Color{
  int r, g, b;
  Color(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
};

void setup(){
  boxColors = new ArrayList<Color>();
  /*backgroundC = new Color(230,230,230);
  boxColors.add(new Color(250,171,62));
  boxColors.add(new Color(163,56,21));
  boxColors.add(new Color(255,218,1));
  boxColors.add(new Color(232,24,2));
  boxColors.add(new Color(161,213,1));*/
  
  /*backgroundC = new Color(0, 0, 0);
  boxColors.add(new Color(13, 67, 0));
  boxColors.add(new Color(58, 158, 0));
  boxColors.add(new Color(224, 215, 0));
  boxColors.add(new Color(72, 72, 72));
  boxColors.add(new Color(30, 30, 30));*/
  
  backgroundC = new Color(43,8,27);
  boxColors.add(new Color(49,9,46));
  boxColors.add(new Color(76,16,34));
  boxColors.add(new Color(126,64,41));
  boxColors.add(new Color(175,132,57));
  
  size(1920,1080);
  wid = hei = 0;
  for(int i = BOX_SIZE + BOX_DENS; i < width - (BOX_SIZE / 2); i += (BOX_SIZE + BOX_DENS)){
    for(int j = BOX_SIZE + BOX_DENS; j < height - (BOX_SIZE / 2); j += (BOX_SIZE + BOX_DENS)){
      if(i == (BOX_SIZE + BOX_DENS))
        hei++;
    }
    wid++;
  }
  drawGrid();
}

void draw(){
  
}

void mouseClicked(){
  drawGrid();
}

void keyPressed(){
  if(key == 's'){
    saveFrame("BoxDivisions#####.png");
    println("Saved");
  }
}

void drawGrid(){
  background(backgroundC.r,backgroundC.g,backgroundC.b);
  for(int i = 0; i < wid; i++){
    for(int j = 0; j < hei; j++){
      drawBox((i+1)*(BOX_DENS+BOX_SIZE), (j+1)*(BOX_DENS+BOX_SIZE));
    }
  }
}

/*enum Side{
  0   1      2       3
  TOP, RIGHT, BOTTOM, LEFT
}*/

void drawBox(int xCenter, int yCenter){
  int numDivisions;
  do{
    numDivisions = (int)(randomGaussian() * STDDEV_DIVI + MEAN_DIVI);
  }while(numDivisions < 1);
  Color temp;
  int tr1x, tr1y, tr2x, tr2y;
  for(int i = 0; i < numDivisions; i++){
    if((int)random(2) == 0){
      tr1x = (int)(random(BOX_SIZE) + xCenter - (BOX_SIZE / 2));
      if((int)random(2) == 0)
        tr1y = yCenter - (BOX_SIZE / 2);
      else
        tr1y = yCenter + (BOX_SIZE / 2);
    }
    else{
      tr1y = (int)(random(BOX_SIZE) + yCenter - (BOX_SIZE / 2));
      if((int)random(2) == 0)
        tr1x = xCenter - (BOX_SIZE / 2);
      else
        tr1x = xCenter + (BOX_SIZE / 2);
    }
    if((int)random(2) == 0){
      tr2x = (int)(random(BOX_SIZE) + xCenter - (BOX_SIZE / 2));
      if((int)random(2) == 0)
        tr2y = yCenter - (BOX_SIZE / 2);
      else
        tr2y = yCenter + (BOX_SIZE / 2);
    }
    else{
      tr2y = (int)(random(BOX_SIZE) + yCenter - (BOX_SIZE / 2));
      if((int)random(2) == 0)
        tr2x = xCenter - (BOX_SIZE / 2);
      else
        tr2x = xCenter + (BOX_SIZE / 2);
    }
    temp = boxColors.get((int)random(boxColors.size()));
    fill(temp.r, temp.g, temp.b);
    stroke(temp.r,temp.g,temp.b);
    if(!isInvalid(tr1x, tr1y, tr2x, tr2y) && isSideTriangle(tr1x, tr1y, tr2x, tr2y))
      triangle(tr1x, tr1y, tr2x, tr2y, xCenter, yCenter);
    else if(!isInvalid(tr1x, tr1y, tr2x, tr2y)){
      int s1, s2;
      s1 = PointOn(tr1x, tr1y, xCenter, yCenter);
      s2 = PointOn(tr2x, tr2y, xCenter, yCenter);
      if((s1 == 0 && s2 == 1) || (s1 == 1 && s2 == 0))
        quad(tr1x, tr1y, xCenter - BOX_SIZE /2, yCenter - BOX_SIZE / 2, tr2x, tr2y, xCenter, yCenter);
      if((s1 == 0 && s2 == 3) || (s1 == 3 && s2 == 0))
        quad(tr1x, tr1y, xCenter + BOX_SIZE /2, yCenter - BOX_SIZE / 2, tr2x, tr2y, xCenter, yCenter);
      if((s1 == 2 && s2 == 1) || (s1 == 1 && s2 == 2))
        quad(tr1x, tr1y, xCenter - BOX_SIZE /2, yCenter + BOX_SIZE / 2, tr2x, tr2y, xCenter, yCenter);
      if((s1 == 2 && s2 == 3) || (s1 == 3 && s2 == 2))
        quad(tr1x, tr1y, xCenter + BOX_SIZE /2, yCenter + BOX_SIZE / 2, tr2x, tr2y, xCenter, yCenter);
    }
    else
      i--;
  }
}

boolean isSideTriangle(int x1, int y1, int x2, int y2){
  return (x1 == x2) || (y1 == y2);
}

int PointOn(int x1, int y1, int xCenter, int yCenter){
  if(x1 == xCenter - (BOX_SIZE / 2))
    return 1;
  if(x1 == xCenter + (BOX_SIZE / 2))
    return 3;
  if(y1 == yCenter - (BOX_SIZE / 2))
    return 0;
  if(y1 == yCenter + (BOX_SIZE / 2))
    return 2;
  else
    return 0;
}

boolean isInvalid(int x1, int y1, int x2, int y2){
  return (abs(x2 - x1) == BOX_SIZE || abs(y2 - y1) == BOX_SIZE);
}
