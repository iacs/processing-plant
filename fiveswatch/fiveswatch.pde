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

JSONObject colorBookRaw;
HashMap<String, String> colorBook;
ArrayList<String> colorNamesLoaded;
String[] colorNames;

color[] swatch;
boolean paletteLoaded = false;
boolean visualsCached = false;

// Visuals
PGraphics paletteBackground;
PGraphics mainPalette;

void setup() {
    size(1280, 720, P2D);

    paletteNames = new ArrayList<String>();
    paletteSwatches = new ArrayList<String[]>();
    swatch = new color[5];
    colorNames = new String[5];
    colorBook = new HashMap<String, String>();
    colorNamesLoaded = new ArrayList<String>();

    cp5 = new ControlP5(this);

    updatePalettes();
    updateDefaultColorbook();

    hs = new HoverScroll(cp5, "palettes");
    // hs.registerProperty("value");
    hs.setPosition(width - 2*borderMargin - dropdownWidth, 2*borderMargin)
        .setSize(dropdownWidth, dropdownHeight)
        .setBarHeight(dropdownItemHeight)
        .setItemHeight(dropdownItemHeight)
        .setType(ScrollableList.LIST)
        .setOpen(false)
        .addItems(paletteNames);

    cp5.addButton("openColorBook")
        .setPosition(2*borderMargin, 2*borderMargin)
        .setSize(dropdownWidth, dropdownItemHeight);
}

void draw() {
    background(200);

    if (paletteLoaded) {
        generateVisuals();
        paletteLoaded = false;
    }
    
    if (visualsCached) {
        background(paletteBackground);
        imageMode(CENTER);
        image(mainPalette, width/2, height/2);
    }

    if (hs.getHover()) {
        palettePreview(hs.getItemHover());
    }
}

void generateVisuals() {
    paletteBackground = drawPaletteBackground();
    mainPalette = drawMainPalette();
    visualsCached = true;
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
    // println("n: " + n);
    visualsCached = false;
    String[] triplets = paletteSwatches.get(n);
    swatch[0] = color(unhex("FF" + triplets[0]));
    swatch[1] = color(unhex("FF" + triplets[1]));
    swatch[2] = color(unhex("FF" + triplets[2]));
    swatch[3] = color(unhex("FF" + triplets[3]));
    swatch[4] = color(unhex("FF" + triplets[4]));

    // id colors
    //colorNamesLoaded.clear();
    for (int i = 0; i < triplets.length; i++) {
        println("checking color: " + triplets[i]);
        if (colorBook.containsKey(triplets[i])) {
            println("Identified color");
            colorNames[i] = colorBook.get(triplets[i]);
        } else {
            colorNames[i] = "";
        }
    }

    // println("Idd colors: "+colorNamesLoaded);
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
    PGraphics mainPalette = createGraphics(1000, 400);
    
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

    mainPalette.fill(255, 255, 255);
    mainPalette.rect(0, 220, 1000, 100);

    mainPalette.fill(0, 0, 0);
    mainPalette.textSize(16);
    mainPalette.textAlign(CENTER);
    for (int i = 0; i < 5; ++i) {
        if (!colorNames[i].equals("")) {
            mainPalette.text(colorNames[i], 10 + 200*i, 230, 200, 90);
        }
    }

    mainPalette.endDraw();
    
    return mainPalette;
}

PGraphics drawPaletteBackground() {
    PGraphics paletteBackground = createGraphics(width, height);

    int stepSize = paletteBackground.width / (swatch.length - 1);

    paletteBackground.beginDraw();
    paletteBackground.noFill();
    for (int i = 0; i <= paletteBackground.width; i++) {
        color startC = swatch[i/stepSize];
        color endC   = swatch[min((i/stepSize)+1, swatch.length -1)];
        float amt = (float) (i % stepSize) / stepSize;
        color instantC = lerpColor(startC, endC, amt);
        paletteBackground.stroke(instantC);
        paletteBackground.line(i, 0, i, paletteBackground.height);
    }
    paletteBackground.endDraw();

    return paletteBackground;
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

JSONObject loadColorBook(String bookname) {
    JSONObject colorLib = loadJSONObject("color_library.json");
    JSONArray books = colorLib.getJSONArray("books");
    for (int i = 0; i < books.size(); i++) {
        JSONObject book = books.getJSONObject(i);
        if (book.getString("name").equals(bookname)) {
            return book;
        }
    }

    return null;
}

void updateDefaultColorbook() {
    colorBookRaw = loadColorBook("default");
    colorBook.clear();

    JSONArray bookColors = colorBookRaw.getJSONArray("colors");
    for (int i = 0; i < bookColors.size(); i++) {
        JSONObject c = bookColors.getJSONObject(i);
        colorBook.put(c.getString("triplet"), c.getString("name"));
    }
}