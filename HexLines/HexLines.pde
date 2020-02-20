import java.util.Random;

//Mess with these values!
final boolean DRAW_NODES = false;
final int PIXEL_DENSITY = 15, //Lower = denser
          SCREEN_X = 960, //Also change size(x, y) in setup()
          SCREEN_Y = 600, // ^
          MEAN_LINE_LEN = 40,
          DEV_LINE_LEN = 15,
          LINE_THICK = 1,
          NUM_TRIES_TO_COMPLETE = 960; //recommended SCREEN_X
          
//Don't touch these please!
int curLineLength = 0,
    curNodeX,
    curNodeY,
    curDir,
    lineNum = 1;
int[][] visited;
Random RNJesus;
Color curColor;
boolean run = true;
ArrayList<Color> lineColors;

class Color{
  int r, g, b;
  Color(int arr, int gee, int bee){
    r = arr;
    g = gee;
    b = bee;
  }
}

void setup(){
  size(960,600);
  smooth(4);
  RNJesus = new Random();
  lineColors = new ArrayList<Color>();
  
  //MESS HERE TOO
  background(4, 73, 61);
  //lineColors.add(new Color());
  lineColors.add(new Color(114, 255, 142));
  lineColors.add(new Color(154, 72, 242));
  lineColors.add(new Color(223, 63, 255));
  lineColors.add(new Color(16, 112, 186));
  //END MESSING
  
  visited = new int[SCREEN_X / PIXEL_DENSITY][SCREEN_Y / PIXEL_DENSITY]; //default 0
  if(DRAW_NODES == true){
    for(int i = PIXEL_DENSITY; i <= SCREEN_X - PIXEL_DENSITY; i += PIXEL_DENSITY){
      for(int j = PIXEL_DENSITY; j <= SCREEN_Y - PIXEL_DENSITY; j += PIXEL_DENSITY){
        fill(255, 255, 255);
        ellipse(i, j, 1, 1);
      }
    }
  }
}

void draw(){
  if(run == true){
    if(curLineLength <= 0){
      do{
        curLineLength = (int)(RNJesus.nextGaussian() * DEV_LINE_LEN + MEAN_LINE_LEN);
      }while(curLineLength < 1 && curLineLength > (MEAN_LINE_LEN + (30*DEV_LINE_LEN)));
      int tries = 0;
      do{
        curNodeX = RNJesus.nextInt((SCREEN_X / PIXEL_DENSITY) - 1) + 1;
        curNodeY = RNJesus.nextInt((SCREEN_Y / PIXEL_DENSITY) - 1) + 1;
        tries++;
        if(tries == NUM_TRIES_TO_COMPLETE)
          break;
      }while(visited[curNodeX][curNodeY] != 0);
      if(tries == NUM_TRIES_TO_COMPLETE){
        run = false;
        saveFrame("HexLines####.png");
        println("Done!");
        return;
      }
      visited[curNodeX][curNodeY] = lineNum;
      lineNum++;
      curDir = RNJesus.nextInt(8); //0-7
      curColor = lineColors.get(RNJesus.nextInt(lineColors.size()));
      println("cll: "+curLineLength);
      println("cnx: "+curNodeX);
      println("cny: "+curNodeY);
      println("cd: "+curDir);
      println("");
    }else{
      stroke(curColor.r, curColor.g, curColor.b);
      strokeWeight(LINE_THICK);
      switch(curDir){
        case 0: //UP
          if(curNodeY > 1 && visited[curNodeX][curNodeY - 1] == 0){ //<>//
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, curNodeX * PIXEL_DENSITY, (curNodeY - 1) * PIXEL_DENSITY);
            curNodeY--;
          }
          break;
        case 1: //UP-RIGHT
          if(curNodeX < (SCREEN_X / PIXEL_DENSITY) - 1 && curNodeY > 1 && visited[curNodeX + 1][curNodeY - 1] == 0 && isNotCrossing(curNodeX, curNodeY, curNodeX + 1, curNodeY - 1)){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX + 1) * PIXEL_DENSITY, (curNodeY - 1) * PIXEL_DENSITY);
            curNodeX++;
            curNodeY--;
          }
          break;
        case 2: //RIGHT
          if(curNodeX < (SCREEN_X / PIXEL_DENSITY) - 1 && visited[curNodeX + 1][curNodeY] == 0){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX + 1) * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY);
            curNodeX++;
          }
          break;
        case 3: //DOWN-RIGHT
          if(curNodeX < (SCREEN_X / PIXEL_DENSITY) - 1 && curNodeY < (SCREEN_Y / PIXEL_DENSITY) - 1 && visited[curNodeX + 1][curNodeY + 1] == 0 && isNotCrossing(curNodeX, curNodeY, curNodeX + 1, curNodeY + 1)){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX + 1) * PIXEL_DENSITY, (curNodeY + 1) * PIXEL_DENSITY);
            curNodeX++;
            curNodeY++;
          }
          break;
        case 4: //DOWN
          if(curNodeY < (SCREEN_Y / PIXEL_DENSITY) - 1 && visited[curNodeX][curNodeY + 1] == 0){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, curNodeX * PIXEL_DENSITY, (curNodeY + 1) * PIXEL_DENSITY);
            curNodeY++;
          }
          break;
        case 5: //DOWN-LEFT
          if(curNodeX > 1 && curNodeY < (SCREEN_Y / PIXEL_DENSITY) - 1 && visited[curNodeX - 1][curNodeY + 1] == 0 && isNotCrossing(curNodeX, curNodeY, curNodeX - 1, curNodeY + 1)){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX - 1) * PIXEL_DENSITY, (curNodeY + 1) * PIXEL_DENSITY);
            curNodeX--;
            curNodeY++;
          }
          break;
        case 6: //LEFT
          if(curNodeX > 1 && visited[curNodeX - 1][curNodeY] == 0){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX - 1) * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY);
            curNodeX--;
          }
          break;
        case 7: //UP-LEFT
          if(curNodeX > 1 && curNodeY > 1 && visited[curNodeX - 1][curNodeY - 1] == 0 && isNotCrossing(curNodeX, curNodeY, curNodeX - 1, curNodeY - 1)){
            line(curNodeX * PIXEL_DENSITY, curNodeY * PIXEL_DENSITY, (curNodeX - 1) * PIXEL_DENSITY, (curNodeY - 1) * PIXEL_DENSITY);
            curNodeX--;
            curNodeY--;
          }
          break;
        default:
          println("wat");
          break;
      }
      visited[curNodeX][curNodeY] = lineNum;
      lineNum++;
      curDir = RNJesus.nextInt(8); //0-7
      curLineLength--;
    }
  }
}

void mouseClicked(){
  if(run == true){
    run = false;
    saveFrame("HexLines####.png");
    println("Paused!");
  }
  else
    run = true;
}

boolean isNotCrossing(int x1, int y1, int x2, int y2){
  return (visited[x1][y2] != visited[x2][y1]);
}