

// Connies
int margin = 8;        // The separation in px
int regsize = 16;      // Size of regular squares
int maxsize = 0;
int minsize = 5;

int bg = 200;
int fg = 75;

int columns = 0;
int rows = 0;

void setup() {
  size(1280, 720, P2D);
  //rectMode(CENTER);
  background(bg);
  columns = width / (regsize + margin);
  rows = height / (regsize + margin);
  println(columns + " columns and " + rows + " rows");
}

void draw() {
  fill(fg);
  
  int pointx = 0;
  int pointy = 0;
  
  for (int y = 0; y < rows; y++) {
    pointy = pointy + margin;
    for (int x = 0; x < columns; x++) {
      pointx = pointx + margin;
      rect(pointx, pointy, regsize, regsize);
      pointx = pointx + regsize;
    }
    pointx = 0;
    pointy = pointy + regsize;
  }
}