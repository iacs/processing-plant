/**
 * Pixel Alchemy
 * etc
 */
 
import controlP5.*;

ControlP5 cp5;
String[] topBarOptions = {"Load", "Save", "Quartize", "Disc"};

// Cosmetic styles
int topBarHeight = 20;
int canvasPadding = 5;

int imgStartX;
int imgStartY;

boolean effect = false;

PImage loadedImg;


void setup() {
    size(1280, 720, P2D);
    
    imgStartX = width / 2;
    imgStartY = (height / 2) + canvasPadding;
    
    cp5 = new ControlP5(this);
    
    ButtonBar btnbar = cp5.addButtonBar("topbar")
        .setPosition(0,0)
        .setSize(width, topBarHeight)
        .addItems(topBarOptions);
}

void topbar(int n) {
    switch (n) {
        case 0:
        selectInput("Select an image file to open", "openImage");
        break;
        case 1:
        println("Save img...");
        break;
        case 2:
        println("Quartize...");
        effect = true;
        quartize();
        break;
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
        image(loadedImg, imgStartX - (loadedImg.width / 2), imgStartY - (loadedImg.height / 2));
    }
}

void quartize() {
    loadedImg.filter(GRAY);
    loadedImg.filter(POSTERIZE, 3);
    loadedImg.loadPixels();
    color[] colores = new color[0];
    color[] replace = { #FF0000, #00FF00, #0000FF, #000000};
    color c;
    boolean exists = false;
    for (int i = 0; i < loadedImg.pixels.length; ++i) {
        exists = false;
        c = loadedImg.pixels[i];
        for (int j = 0; j < colores.length; ++j) {
            //println("c: "+hex(c)+" colorArr: "+hex(colores[j]));
            if (hex(c).equals(hex(colores[j]))) {
                exists = true;
                loadedImg.pixels[i] = replace[j];
                break;
            }
        }
        if (!exists) {
            colores = append(colores, c);
            println("color: " + hex(c));
            println("longitut: "+colores.length);
            println("colores: "+hex(colores[colores.length - 1]));
            loadedImg.pixels[i] = replace[colores.length -1];
        }
    }
    loadedImg.updatePixels();
}