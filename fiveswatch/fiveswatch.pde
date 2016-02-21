import controlP5.*;
import java.util.*;

// Interficie
ControlP5 cp5;
HoverScroll hs;

// Aesthetics
int borderMargin = 10;
int dropdownWidth = 200;
int dropdownHeight = 100;
int dropdownItemHeight = 20;

// Data
JSONArray paletteData;
ArrayList<String> paletteNames;
ArrayList<String[]> paletteSwatches;

color[] swatch;
boolean paletteLoaded = false;

void setup() {
    size(1280, 720);

    paletteNames = new ArrayList<String>();
    paletteSwatches = new ArrayList<String[]>();
    swatch = new color[5];

    cp5 = new ControlP5(this);

    updatePalettes();

    hs = new HoverScroll(cp5, "palettes");
    // hs.registerProperty("value");
    hs.setPosition(width - 2*borderMargin - dropdownWidth, 2*borderMargin)
        .setSize(dropdownWidth, dropdownHeight)
        .setBarHeight(dropdownItemHeight)
        .setItemHeight(dropdownItemHeight)
        .setType(ScrollableList.LIST)
        .setOpen(false)
        .addItems(paletteNames);
}

void draw() {
    background(200);

    if (hs.getHover()) {
        palettePreview(hs.getItemHover());
    }

    if (paletteLoaded) {
        PGraphics mainPalette = drawMainPalette();
        imageMode(CENTER);
        image(mainPalette, width/2, height/2);
    }
}

void palettePreview(int index) {
    if (index >= 0 && index < paletteNames.size()) {
        PGraphics paletteCard = createGraphics(120, 40);
        PGraphics strip = colorStrip(index);

        int xpos = width - 120 - 3*borderMargin - dropdownWidth;

        paletteCard.beginDraw();
        paletteCard.stroke(0);
        paletteCard.fill(200);
        paletteCard.rect(0, 0, 120-1, 40-1);
        paletteCard.image(strip, 10, 10);
        paletteCard.endDraw();

        image(paletteCard, xpos, pmouseY);
    }
}

void palettes(int n) {
    println("n: " + n);
    String[] triplets = paletteSwatches.get(n);
    swatch[0] = color(unhex("FF" + triplets[0]));
    swatch[1] = color(unhex("FF" + triplets[1]));
    swatch[2] = color(unhex("FF" + triplets[2]));
    swatch[3] = color(unhex("FF" + triplets[3]));
    swatch[4] = color(unhex("FF" + triplets[4]));
    paletteLoaded = true;
}

PGraphics colorStrip(int index) {
    PGraphics strip = createGraphics(100, 20);
    String[] swatches = paletteSwatches.get(index);
    strip.beginDraw();
    strip.noStroke();
    for (int i = 0; i < swatches.length; ++i) {
        strip.fill(color(unhex("FF" + swatches[i])));
        strip.rect(0 + i * 20, 0, 20, 20);
    }
    strip.endDraw();

    return strip;
}

PGraphics drawMainPalette() {
    PGraphics mainPalette = createGraphics(1000, 200);
    
    mainPalette.beginDraw();
    mainPalette.noStroke();
    mainPalette.fill(swatch[0]);
    mainPalette.rect(0, 0, 200, 200);
    mainPalette.fill(swatch[1]);
    mainPalette.rect(200, 0, 200, 200);
    mainPalette.fill(swatch[2]);
    mainPalette.rect(400, 0, 200, 200);
    mainPalette.fill(swatch[3]);
    mainPalette.rect(600, 0, 200, 200);
    mainPalette.fill(swatch[4]);
    mainPalette.rect(800, 0, 200, 200);
    mainPalette.endDraw();
    
    return mainPalette;
}

void updatePalettes() {
    paletteData = loadJSONArray("palettes.json");
    paletteNames.clear();
    paletteSwatches.clear();

    for (int i = 0; i < paletteData.size(); i++) {
        JSONObject p = paletteData.getJSONObject(i);
        // println("name: "+p.getString("name"));
        paletteNames.add(p.getString("name"));
        paletteSwatches.add(p.getJSONArray("colors").getStringArray());
    }
}