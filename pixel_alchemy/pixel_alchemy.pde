/**
 * Pixel Alchemy
 * etc
 */
 
import controlP5.*;

ControlP5 cp5;
String[] topBarOptions = {"Load"};

// Cosmetic styles
int topBarHeight = 20;
int canvasPadding = 5;

int imgStartX = canvasPadding;
int imgStartY = topBarHeight + canvasPadding;

PImage loadedImg;


void setup() {
    size(1280, 720, P2D);
    
    cp5 = new ControlP5(this);
    
    // topBarOptions = ;
    ButtonBar btnbar = cp5.addButtonBar("topbar")
        .setPosition(0,0)
        .setSize(width, topBarHeight)
        .addItems(topBarOptions);
}

void topbar(int n) {
    //ButtonBar bb = (ButtonBar)cp5.get("topbar");
    if (topBarOptions[n] == "Load") {
        //println("Chose to load");
        selectInput("Select an image file to open", "openImage");
    }
}

void openImage(File file) {
    if (file != null) {
        loadedImg = loadImage(file.toString());
        // println("file: " + file);
    }
}

void draw() {
    background(220);
    if (loadedImg != null) {
        image(loadedImg, imgStartX, imgStartY);
    }
}