PShader colorShader;
float cx;
float cy;

void setup() {
    size(640,360,P3D);
    noStroke();
    colorShader = loadShader("colorFrag.glsl");
    cx = width/2;
    cy = height/2;
}

void draw() {
    background(0);
    shader(colorShader);
    
    translate(width/2, height/2);
    
    beginShape(QUADS);
    normal(0,0,1);
    fill(255, 0, 255);
    vertex(-cx, +cy);
    vertex(+cx, +cy);
    vertex(+cx, -cy);
    vertex(-cx, -cy);
    endShape();
}

void keyPressed(){
  if (key == 'r') {
    loadShader("colorFrag.glsl");
  }
}