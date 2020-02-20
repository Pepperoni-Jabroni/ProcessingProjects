//EDIT HERE
final int TRUCHET_LENGTH = 30;
final boolean DRAW_STROKE = false;
//END EDIT

int[][] truchetPattern;
int patternIndexX, 
    patternIndexY,
    designSize,
    patternSizeX = 4, 
    patternSizeY = 4;
boolean showPatternOutline = false,
        inDesignMode = false;
Color truchet1, strokeColor;
ArrayList<Color> secondaryColors;

class Color {
  int r, g, b;
  Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
};

void setup() {
  size(1920,1080);
  smooth(4);
  truchetPattern = new int[patternSizeX][patternSizeY];
  secondaryColors = new ArrayList<Color>();
  
  //EDIT HERE TOO
  //secondaryColors.add(new Color());
  /*truchet1 = new Color(255,255,255);
  secondaryColors.add(new Color(99, 28, 135));
  secondaryColors.add(new Color(85,35,110));
  secondaryColors.add(new Color(155, 26, 26));
  secondaryColors.add(new Color(132, 7, 7));*/
  truchet1 = new Color(85,34,85);
  secondaryColors.add(new Color(153,68,85));
  secondaryColors.add(new Color(255,187,153));
  secondaryColors.add(new Color(187,102,136));
  strokeColor = new Color(255,255,255);
  //END EDIT
  
  designSize = 40;
  for (int i = 0; i < patternSizeX; i++) {
    for (int j = 0; j < patternSizeY; j++) {
      truchetPattern[i][j] = (int)random(4);
    }
  }
  drawNormalMode();
}

void draw() {
  
}

void mouseClicked() {
  if(!inDesignMode){
    if (mouseButton == LEFT) {
      for (int i = 0; i < patternSizeX; i++) {
        for (int j = 0; j < patternSizeY; j++) {
          truchetPattern[i][j] = (int)random(4);
        }
      }
    } else{
      showPatternOutline = !showPatternOutline;
    }
    drawNormalMode();
  }
  else{
    int tempX = 0, tempY = 0;
    boolean cont = true;
    for(int i = 0; i < patternSizeY && cont; i++){
      for(int j = 0; j < patternSizeX && cont; j++){
        if(mouseX >= tempX && mouseX < tempX + designSize){
          if(mouseY >= tempY && mouseY < tempY + designSize){
            truchetPattern[j][i]++;
            if(truchetPattern[j][i] == 4)
              truchetPattern[j][i] = 0;
            cont = false;
          }
        }
        tempX += designSize;
      }
      tempY += designSize;
      tempX = 0;
    }
    drawDesignMode();
  }
}

void drawTruchet(int x, int y, int len, int orient, boolean drawStroke) {
  Color truchet2 = new Color(255,255,255);
  if(secondaryColors.size() > 0)
    truchet2 = secondaryColors.get((int)random(secondaryColors.size()));
  if(!drawStroke)
    stroke(truchet1.r,truchet1.g,truchet1.b);
  else
    stroke(strokeColor.r, strokeColor.b, strokeColor.g);
  if (orient == 0) {
    fill(truchet1.r, truchet1.g, truchet1.b);
    triangle(x, y, x+len, y, x, y+len);
    fill(truchet2.r, truchet2.g, truchet2.b);
    triangle(x + len, y + len, x, y + len, x + len, y);
    if(!drawStroke){
      stroke(truchet2.r, truchet2.g, truchet2.b);
      line(x + len, y + len, x, y + len);
      line(x + len, y + len, x + len, y);
    }
  } else if (orient == 1) {
    fill(truchet2.r, truchet2.g, truchet2.b);
    triangle(x, y, x+len, y, x, y+len);
    fill(truchet1.r, truchet1.g, truchet1.b);
    triangle(x + len, y + len, x, y + len, x + len, y);
    if(!drawStroke){
      stroke(truchet2.r, truchet2.g, truchet2.b);
      line(x, y, x+len, y);
      line(x, y, x, y+len);
    }
  } else if (orient == 2) {
    fill(truchet1.r, truchet1.g, truchet1.b);
    triangle(x, y, x + len, y, x + len, y + len);
    fill(truchet2.r, truchet2.g, truchet2.b);
    triangle(x, y, x, y + len, x + len, y + len);
    if(!drawStroke){
      stroke(truchet2.r, truchet2.g, truchet2.b);
      line(x, y, x+len, y + len);
      line(x, y, x, y+len);
    }
  } else {
    fill(truchet2.r, truchet2.g, truchet2.b);
    triangle(x, y, x + len, y, x + len, y + len);
    fill(truchet1.r, truchet1.g, truchet1.b);
    triangle(x, y, x, y + len, x + len, y + len);
    if(!drawStroke){
      stroke(truchet2.r, truchet2.g, truchet2.b);
      line(x, y, x+len, y);
      line(x, y, x+len, y+len);
    }
  }
}

void keyPressed(){
  if(key == 's' && !inDesignMode){
    saveFrame("Truchet#######.png");
    println("Saved!");
  }
  else if(key == 'd'){
    inDesignMode = !inDesignMode;
  }
  else if(key == 'k' && inDesignMode){
    patternSizeY++;
    int[][] temp = truchetPattern;
    truchetPattern = new int[patternSizeX][patternSizeY];
    for (int i = 0; i < patternSizeX; i++) {
      for (int j = 0; j < patternSizeY; j++) {
        try{
          truchetPattern[i][j] = temp[i][j];
        }catch(IndexOutOfBoundsException e){
          truchetPattern[i][j] = (int)random(4);
        }
      }
    }
  }
  else if(key == 'i' && inDesignMode){
    if(patternSizeY > 1){
      patternSizeY--;
      int[][] temp = truchetPattern;
      truchetPattern = new int[patternSizeX][patternSizeY];
      for (int i = 0; i < patternSizeX; i++) {
        for (int j = 0; j < patternSizeY; j++) {
          try{
            truchetPattern[i][j] = temp[i][j];
          }catch(IndexOutOfBoundsException e){
            truchetPattern[i][j] = (int)random(4);
          }
        }
      }
    }
  }
  else if(key == 'j' && inDesignMode){
    if(patternSizeX > 1){
      patternSizeX--;
      int[][] temp = truchetPattern;
      truchetPattern = new int[patternSizeX][patternSizeY];
      for (int i = 0; i < patternSizeX; i++) {
        for (int j = 0; j < patternSizeY; j++) {
          try{
            truchetPattern[i][j] = temp[i][j];
          }catch(IndexOutOfBoundsException e){
            truchetPattern[i][j] = (int)random(4);
          }
        }
      }
    }
  }
  else if(key == 'l' && inDesignMode){
    patternSizeX++;
    int[][] temp = truchetPattern;
    truchetPattern = new int[patternSizeX][patternSizeY];
    for (int i = 0; i < patternSizeX; i++) {
      for (int j = 0; j < patternSizeY; j++) {
        try{
          truchetPattern[i][j] = temp[i][j];
        }catch(IndexOutOfBoundsException e){
          truchetPattern[i][j] = (int)random(4);
        }
      }
    }
  }
  if(key != 's'){
    if(inDesignMode){
      drawDesignMode();
    }
    else{
      drawNormalMode();
    }
  }
}

void drawDesignMode(){
  background(0);
  int tempX = 0, tempY = 0;
  designSize = 40;
  while((designSize * patternSizeY > height) || (designSize * patternSizeX > width)){
    designSize--;
  }
  for (int i = 0; i < patternSizeY; i ++) {
    for (int j = 0; j < patternSizeX; j ++) {
        drawTruchet(tempX, tempY, designSize, truchetPattern[j][i], DRAW_STROKE);
        tempX += designSize;
    }
    tempY += designSize;
    tempX = 0;
  }
}

void drawNormalMode(){
  patternIndexX = patternIndexY = 0;
  for (int i = 0; i < height; i += TRUCHET_LENGTH) {
    for (int j = 0; j < width; j += TRUCHET_LENGTH) {
      drawTruchet(j, i, TRUCHET_LENGTH, truchetPattern[patternIndexX][patternIndexY], DRAW_STROKE);
      patternIndexX++;
      if (patternIndexX >= patternSizeX)
        patternIndexX = 0;
    }
    patternIndexX = 0;
    patternIndexY++;
    if (patternIndexY >= patternSizeY)
      patternIndexY = 0;
  }
  if (showPatternOutline) {
    fill(0, 0, 0, 0);
    stroke(255, 0, 0);
    rect(0, 0, TRUCHET_LENGTH*patternSizeX, TRUCHET_LENGTH*patternSizeY);
  }
}
