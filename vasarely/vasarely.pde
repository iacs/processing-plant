import netP5.*;
import oscP5.*;


// Connies
int margin = 8;        // The separation in px
int regsize = 16;      // Size of regular squares
int maxsize = 25;
int minsize = 5;

int bg = 200;
int fg = 75;

int columns = 0;
int rows = 0;

int curX;      // column of effect center
int curY;      // row of effect center
int neighbors = 4; // area of effect


void setup() {
  //size(1280, 720, P2D);
  size(500, 500, P2D);
  rectMode(CENTER);
  columns = width / (regsize + margin);
  rows = height / (regsize + margin);
  println(columns + " columns and " + rows + " rows");
  smooth();
  noStroke();
  fill(fg);
  
  //OSC stuff
  int port = 8000;
  OscP5 osc = new OscP5(this, port);
}

void draw() {
  int pointx = margin;
  int pointy = margin;
  
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
    pointx = margin;
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

void oscEvent(OscMessage message) {
  //println("pattern: " + message.addrPattern() + " : " + message.typetag());
  //message.print();
  
  // Position
  if (message.checkAddrPattern("/1/xy1") == true) {
    float xpos, ypos;
    xpos = message.get(0).floatValue();
    ypos = message.get(1).floatValue();
    
    curX = int(map(xpos, 0, 100, 1, columns));
    curY = int(map(ypos, 0, 100, 1, rows));
    println("new xy: " + curX + "," + curY);
  }
  
  // Strength
  if (message.checkAddrPattern("/1/rotary1") == true) {
    float strength;
    strength = message.get(0).floatValue();
    neighbors = int(map(strength, 0, 100, 0, min(columns, rows)));
  }
  
  //if (message.checkAddrPattern() == true) {}
}