PImage legoPiece;
ArrayList<Color> colors;
int[][] brickNum;
int curBrick = 1, numFilled = 0;

class Color{
  int r, g, b;
  Color(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
};

color ColorTocolor(Color c){
  return color(c.r, c.g, c.b);
}

void setup(){
  brickNum = new int[width/60][height/60];
  colors = new ArrayList<Color>();
  colors.add(new Color(66,133,244));
  colors.add(new Color(234,67,53));
  colors.add(new Color(251,188,5));
  colors.add(new Color(52,168,83));
  colors.add(new Color(103,58,183));
  size(1920,1080);
  legoPiece = loadImage("LegoPieceV2.png");
}

void draw(){
  if(numFilled < (width/60 * height/60)){
    int w, h, x, y;
    boolean isGood = true;
    do{
      w = (int)random(4) + 1;
      h = (int)random(4) + 1;
      x = (int)random(width/60);
      y = (int)random(height/60);
      tint(ColorTocolor(colors.get((int)random(colors.size()))));
      isGood = true;
      for(int i = 0; i < w; i++){
        for(int j = 0; j < h; j++){
          if(x + i < (width / 60) && y + j < (height / 60) && brickNum[x+i][y+j] != 0)
            isGood = false;
        }
      }
    }while(isGood == false);
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        if(x + i < (width / 60) && y + j < (height / 60) && brickNum[x+i][y+j] == 0){
          image(legoPiece, 60*(x+i), 60*(y+j));
          numFilled++;
          brickNum[x+i][y+j] = curBrick;
          try{
            if(i == 0 || (brickNum[x+i-1][y+j] != 0 && brickNum[x+i-1][y+j] != curBrick))
              line(60*(x+i), 60*(y+j), 60*(x+i), 60*(y+j) + 60);
          }catch(IndexOutOfBoundsException e){}
          try{
            if(i == w-1 || (brickNum[x+i+1][y+j] != 0 && brickNum[x+i+1][y+j] != curBrick))
              line(60*(x+i)+60, 60*(y+j), 60*(x+i)+60, 60*(y+j) + 60);
          }catch(IndexOutOfBoundsException e){}
          try{
            if(j == 0 || (brickNum[x+i][y+j-1] != 0 && brickNum[x+i][y+j-1] != curBrick))
              line(60*(x+i), 60*(y+j), 60*(x+i) + 60, 60*(y+j));
          }catch(IndexOutOfBoundsException e){}
          try{
            if(j == h-1 || (brickNum[x+i][y+j+1] != 0 && brickNum[x+i][y+j+1] != curBrick))
              line(60*(x+i), 60*(y+j)+60, 60*(x+i)+60, 60*(y+j) + 60);
          }catch(IndexOutOfBoundsException e){}
        }
      }
    }
    curBrick++;
  }
}

void mouseClicked(){
  numFilled = 0;
  rect(0,0,width, height);
  for(int i= 0; i < width/60; i++){
    for(int j= 0; j < height/60; j++){
      brickNum[i][j] = 0;
    }
  }
}

void keyPressed(){
  if(key == 's'){
    saveFrame("BoxDivisions#####.png");
    println("Saved");
  }
}
