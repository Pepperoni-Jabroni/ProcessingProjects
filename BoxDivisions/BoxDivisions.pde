final int MEAN_DIVI = 2,
          STDDEV_DIVI = 1,
          BOX_SIZE = 100;
// Any of: "RADIAL", "LINE", "RANDOM"
String boxColorType = "LINE";
int backgroundColor = #f2f2f2;
boolean drawDebug = false;
boolean drawOutline = false;
int wid, hei, bufferW, bufferH;
ArrayList<Integer> boxColors;
ArrayList<Box> boxes;

class Division {
  int pointOneLoc;
  int pointTwoLoc;
  boolean isClockwise;
  color col;
  
  public Division(color c) {
    do {
      pointOneLoc = (int)(random(4 * BOX_SIZE));
      pointTwoLoc = (int)(random(4 * BOX_SIZE));
    } while(pointOneLoc == pointTwoLoc);
    if (pointTwoLoc < pointOneLoc) {
      int tLoc = pointOneLoc;
      pointOneLoc = pointTwoLoc;
      pointTwoLoc = tLoc;
    }
    isClockwise = (int)(random(2)) == 0 ? true : false;
    col = c;
  }
  
  public void draw(int xOrigin, int yOrigin) {
    int xCenter = xOrigin + (BOX_SIZE / 2);
    int yCenter = yOrigin + (BOX_SIZE / 2);
    ArrayList<Integer> corners = getCorners();
    stroke(col);
    fill(col);
    beginShape();
    vertex(xCenter, yCenter);
    vertex(xOrigin + getXValForIdx(pointOneLoc), yOrigin + getYValForIdx(pointOneLoc));
    for (int j = 0; j < corners.size(); j++) {
      vertex(xOrigin + getXValForIdx(corners.get(j)), yOrigin + getYValForIdx(corners.get(j)));
    }
    vertex(xOrigin + getXValForIdx(pointTwoLoc), yOrigin + getYValForIdx(pointTwoLoc));
    vertex(xCenter, yCenter);
    endShape(CLOSE);
  }
  
  public void drawWithDebug(int xOrigin, int yOrigin) {
    draw(xOrigin, yOrigin);
    ArrayList<Integer> corners = getCorners();
    int xCenter = xOrigin + (BOX_SIZE / 2);
    int yCenter = yOrigin + (BOX_SIZE / 2);
    stroke(#ff0000);
    fill(#ff0000);
    circle(xCenter, yCenter, 5);
    stroke(#FFFF00);
    fill(#FFFF00);
    circle(xOrigin + getXValForIdx(pointOneLoc), yOrigin + getYValForIdx(pointOneLoc), 5);
    for (int j = 0; j < corners.size(); j++) {
      stroke(#00FF00);
      fill(#00FF00);
      circle(xOrigin + getXValForIdx(corners.get(j)), yOrigin + getYValForIdx(corners.get(j)), 5);
    }
    stroke(#0000ff);
    fill(#0000ff);
    circle(xOrigin + getXValForIdx(pointTwoLoc), yOrigin + getYValForIdx(pointTwoLoc), 5);
  }

  public ArrayList<Integer> getCorners() {
    int pointOneSide = (int)(pointOneLoc / BOX_SIZE);
    int pointTwoSide = (int)(pointTwoLoc / BOX_SIZE);
    ArrayList<Integer> corners = new ArrayList<Integer>();
    if (pointOneSide == pointTwoSide && isClockwise) {
      return corners;
    }
    int tSide = pointOneSide;
    do {
      int destSide;
      if (isClockwise) {
        destSide = getCwSideForSide(tSide);
      } else {
        destSide = getCcwSideForSide(tSide);
      }
      corners.add(getCornerIdxForSides(tSide, destSide));
      tSide = destSide;
    } while (tSide != pointTwoSide);
    return corners;
  }
}

class Box {
 ArrayList<Division> divisions;
 int widIdx;
 int heiIdx;
 
 public Box(int widI, int heiI) {
  widIdx = widI;
  heiIdx = heiI;
  int numDivisions = 0;
  do{
    numDivisions = (int)(randomGaussian() * STDDEV_DIVI + MEAN_DIVI);
  } while(numDivisions < 1);
  divisions = new ArrayList<>();
  for (int i = 0; i < numDivisions; i++) {
    color c = getColorForGridLoc(widI, heiI);
    divisions.add(new Division(c));
  }
 }
 
 public void draw(int bufferW, int bufferH, boolean debug) {
   int xOrigin = (int)(BOX_SIZE + (widIdx * BOX_SIZE)) + (widIdx * bufferW);
   int yOrigin = (int)(BOX_SIZE + (heiIdx * BOX_SIZE)) + (heiIdx * bufferH);
   for(Division d : divisions) {
     if (debug) {
       d.drawWithDebug(xOrigin, yOrigin);
     } else {
       d.draw(xOrigin, yOrigin);
     }
   }
 }
}

void setup(){
  boxColors = new ArrayList<Integer>();
  boxColors.add(#b7094c);
  boxColors.add(#a01a58);
  boxColors.add(#892b64);
  boxColors.add(#723c70);
  boxColors.add(#5c4d7d);
  boxColors.add(#455e89);
  boxColors.add(#2e6f95);
  boxColors.add(#1780a1);
  boxColors.add(#0091ad);
  
  size(1728,1117);
  // Do width computaiton
  int usableWidth = (1728 - (2 * BOX_SIZE));
  float numBoxesWUnadj = 1.0 * usableWidth / BOX_SIZE;
  if (floor(numBoxesWUnadj) == numBoxesWUnadj) {
    wid = floor(numBoxesWUnadj) - 1;
  } else {
    wid = floor(numBoxesWUnadj);
  }
  wid--;
  bufferW = int(usableWidth / wid) - BOX_SIZE;
  // Do height computaiton
  int usableHeight = (1117 - (2 * BOX_SIZE));
  float numBoxesHUnadj = 1.0 * usableHeight / BOX_SIZE;
  if (floor(numBoxesHUnadj) == numBoxesHUnadj) {
    hei = floor(numBoxesHUnadj) - 1;
  } else {
    hei = floor(numBoxesHUnadj);
  }
  hei--;
  bufferH = int(usableHeight / hei) - BOX_SIZE;
  background(color(backgroundColor));
  generateNewBoxes();
}

void generateNewBoxes() {
  boxes = new ArrayList<>();
  for (int i = 0; i < wid; i++){
     for (int j = 0; j < hei; j++){
        boxes.add(new Box(i, j)); 
     }
  }
}

void draw() {
  background(color(backgroundColor));
  for (Box b : boxes) {
    for (Division d : b.divisions) {
      d.pointOneLoc++;
      if (d.pointOneLoc == 4 * BOX_SIZE) {
        d.pointOneLoc = 0;
      }
      d.pointTwoLoc++;
      if (d.pointTwoLoc == 4 * BOX_SIZE) {
        d.pointTwoLoc = d.pointOneLoc;
        d.pointOneLoc = 0;
        d.isClockwise = !d.isClockwise;
      }
    }
    b.draw(bufferW, bufferH, drawDebug);
  }
}

color getColorDarker(color c) {
  float r = max(red(c) - 25.0, 0.0);
  float g = max(green(c) - 25.0, 0.0);
  float b = max(blue(c) - 25.0, 0.0);
  return color(r, g, b);
}

color getColorForGridLoc(int curW, int curH) {
  switch(boxColorType) {
    case "LINE":
      float pct = ((1.0 * curW / wid) + (1.0 * curH / hei)) / 2.0;
      int idx = int(pct * boxColors.size());
      int arIdx = max(0, int(randomGaussian() + idx));
      arIdx = min(arIdx, boxColors.size() - 1);
      return color(boxColors.get(arIdx));
    case "RADIAL":
      pct = sqrt(sq(curW - (1.0 * wid / 2)) + sq(curH - (1.0 * hei / 2))) / hei;
      idx = int(pct * boxColors.size());
      arIdx = max(0, int(randomGaussian() + idx));
      arIdx = min(arIdx, boxColors.size() - 1);
      return color(boxColors.get(arIdx));
    case "RANDOM":
    default:
      return color(boxColors.get(int(random(boxColors.size()))));
  }
}

int getXValForIdx(int idx) {
  if (idx <= BOX_SIZE) {
     return idx;
  } else if (idx <= 2 * BOX_SIZE) {
     return BOX_SIZE;
  } else if (idx <= 3 * BOX_SIZE) {
     return (3 * BOX_SIZE) - idx;
  }
  return 0;
}

int getYValForIdx(int idx) {
  if (idx <= BOX_SIZE) {
     return 0;
  } else if (idx <= 2 * BOX_SIZE) {
     return idx - BOX_SIZE;
  } else if (idx <= 3 * BOX_SIZE) {
     return BOX_SIZE;
  }
  return BOX_SIZE - (idx - (3 * BOX_SIZE));
}

int getCornerIdxForSides(int sideOne, int sideTwo) {
   int minIdx = min(sideOne, sideTwo);
   int maxIdx = max(sideOne, sideTwo);
   if (minIdx == 0 && maxIdx == 3) {
      return 0;
   }
   return BOX_SIZE * (minIdx + 1);
}

int getCwSideForSide(int side) {
  return (side + 1) % 4;
}

int getCcwSideForSide(int side) {
  return side == 0 ? 3 : side - 1;
}

void keyPressed(){
  if(key == 's'){
    saveFrame("BoxDivisions#####.png");
    println("Saved");
  } else if(key == 'r'){
    generateNewBoxes();
  } else if(key == 'd') {
    drawDebug = !drawDebug;
  }  else if(key == 'o') {
    drawOutline = !drawOutline;
  } else if(key == 't') {
    if (boxColorType == "LINE") {
      boxColorType = "RANDOM";
    } else if (boxColorType == "RANDOM") {
      boxColorType = "RADIAL";
    } else {
      boxColorType = "LINE";
    }
    generateNewBoxes();
  } else if(key == 'i') {
    ArrayList<Integer> flipped = new ArrayList<>();
    for(int i = boxColors.size() - 1; i >= 0; i--) {
      flipped.add(boxColors.get(i));
    }
    boxColors = flipped;
    generateNewBoxes();
  }
}
