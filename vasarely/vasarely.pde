

// Connies
int margin = 8;        // The separation in px
int regsize = 16;      // Size of regular squares
int maxsize = 25;
int minsize = 5;

int bg = 200;
int fg = 75;

int columns = 0;
int rows = 0;

int curX = 0;      // column of effect center
int curY = 0;      // row of effect center
int neighbors = 4; // area of effect


void setup() {
  size(1280, 720, P2D);
  //rectMode(CENTER);
  columns = width / (regsize + margin);
  rows = height / (regsize + margin);
  println(columns + " columns and " + rows + " rows");
  smooth();
  noStroke();
  fill(fg);
  curX = 9;
  curY = 15;
  noLoop();
}

void draw() {
  int pointx = 0;
  int pointy = 0;
  
  background(bg);
  
  for (int y = 0; y < rows; y++) {
    pointy = pointy + margin;
    for (int x = 0; x < columns; x++) {
      pointx = pointx + margin;
      int distance = effectDistance(x,y);
      if ( distance <= neighbors)  {
        float lerpAmount = float(distance) / neighbors;
        int start = minsize;
        int end = regsize;
        float newsize = lerp(start, end, lerpAmount);
        rect(pointx, pointy, newsize, newsize);
      } else {
        rect(pointx, pointy, regsize, regsize);
      }
      pointx = pointx + regsize;
    }
    pointx = 0;
    pointy = pointy + regsize;
  }
}

/**
 * Uses the current point and the selected cursor position to return the
 * distance to the cursor. This determines the strength. The closer to the cursor, the
 * stronger the effect
*/
int effectDistance(int x, int y) {
  return max(abs(x - curX), abs(y - curY));
}