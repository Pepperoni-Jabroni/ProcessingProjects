final int MEAN_DIVI = 2,
          STDDEV_DIVI = 3,
          BOX_SIZE = 100;
// Any of: "RADIAL", "LINE", "RANDOM"
final String BOX_COLOR_TYPE = "RANDOM";
int backgroundColor = #f2f2f2;
int wid, hei;
ArrayList<Integer> boxColors;

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
  int bufferW = int(usableWidth / wid) - BOX_SIZE;
  // Do height computaiton
  int usableHeight = (1117 - (2 * BOX_SIZE));
  float numBoxesHUnadj = 1.0 * usableHeight / BOX_SIZE;
  if (floor(numBoxesHUnadj) == numBoxesHUnadj) {
    hei = floor(numBoxesHUnadj) - 1;
  } else {
    hei = floor(numBoxesHUnadj);
  }
  hei--;
  int bufferH = int(usableHeight / hei) - BOX_SIZE;
  background(color(backgroundColor));
  for (int i = 0; i < wid; i++){
     for (int j = 0; j < hei; j++){
        drawBox((int)(BOX_SIZE + (i * BOX_SIZE)) + (i * bufferW), (int)(BOX_SIZE + (j * BOX_SIZE)) + (j * bufferH), i, j); 
     }
  }
}

void draw() {}

color getColorForGridLoc(int curW, int curH) {
  switch(BOX_COLOR_TYPE) {
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

void drawBox(int xOrigin, int yOrigin, int curW, int curH){
  int numDivisions = 0;
  do{
    numDivisions = (int)(randomGaussian() * STDDEV_DIVI + MEAN_DIVI);
  } while(numDivisions < 1);
  for (int i = 0; i < numDivisions; i++) {
    color c = getColorForGridLoc(curW, curH);
    drawDivision(xOrigin, yOrigin, c);
  }
}

color getColorDarker(color c) {
  float r = min(red(c) - 25.0, 255.0);
  float g = min(green(c) - 25.0, 255.0);
  float b = min(blue(c) - 25.0, 255.0);
  return color(r, g, b);
}

void drawDivision(int xOrigin, int yOrigin, color c) {
  int xCenter = xOrigin + (BOX_SIZE / 2);
  int yCenter = yOrigin + (BOX_SIZE / 2);
  stroke(getColorDarker(c));
  fill(c);
  int pointOneLoc = (int)(random(4 * BOX_SIZE));
  int pointTwoLoc = (int)(random(4 * BOX_SIZE));
  if (pointTwoLoc < pointOneLoc) {
    int tLoc = pointOneLoc;
    pointOneLoc = pointTwoLoc;
    pointTwoLoc = tLoc;
  }
  int pointOneSide = (int)(pointOneLoc / BOX_SIZE);
  int pointTwoSide = (int)(pointTwoLoc / BOX_SIZE);
  boolean isClockwise = (int)(random(2)) == 0 ? true : false;
  ArrayList<Integer> corners = getCorners(pointOneSide, pointTwoSide, isClockwise);
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

void drawDebugPoints(int xOrigin, int yOrigin, int pointOneLoc, int pointTwoLoc, ArrayList<Integer> corners) {
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

ArrayList<Integer> getCorners(int pointOneSide, int pointTwoSide, boolean isClockwise) {
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
  }
}
