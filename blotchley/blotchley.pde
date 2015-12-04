/**
 * Generator of those cwadres
 * Blotchley pork
 */

import controlP5.*;

import java.util.*;
import java.util.Map.Entry;

ControlP5 cp5;

JSONArray palettes;
JSONObject example;

int xpos, ypos;

void setup() {
    size(500, 500, P2D);

    cp5 = new ControlP5(this);

    palettes = loadJSONArray("palettes.json");
    // example = palettes.getJSONObject(0);
    
    MenuList m = new MenuList(cp5, "menu", 200, 300);
    m.setPosition(40, 40);
    
    for (int i = 0; i < palettes.size(); i++) {
        println("palette num: " + i);
        JSONObject p = palettes.getJSONObject(i);
        String name = p.getString("name");
        String[] colors = p.getJSONArray("colors").getStringArray();
        PImage strip = createImage(100, 20, RGB);
        strip.loadPixels();
        int step = 0;
        for (int j = 0; j < strip.pixels.length; j++) {
            strip.pixels[j] = color(unhex("FF" + colors[step % 5]));
            if (j % 20 == 0) step++;
        }
        strip.updatePixels();
        m.addItem(makeItem(name, strip));
    }

    noStroke();
    noLoop();

    xpos = 0;
    ypos = 0;
}

Map<String, Object> makeItem(String title, PImage image) {
    Map m = new HashMap<String, Object>();
    m.put("title", title);
    m.put("image", image);
    return m;
}

void draw() {
    // xpos = 10;
    // ypos = 10;
    // String[] colors = example.getJSONArray("colors").getStringArray();
    //background(color(unhex(colors[0])));
    // for (int i = 0; i < colors.length; i++) {
    //     fill(color(unhex("FF" + colors[i])));
    //     rect(xpos, ypos, 40, 40);
    //     xpos = xpos + 40 + 10;
    // }
}

class MenuList extends Controller<MenuList> {

  float pos, npos;
  int itemHeight = 100;
  int scrollerLength = 40;
  List< Map<String, Object>> items = new ArrayList< Map<String, Object>>();
  PGraphics menu;
  boolean updateMenu;

  MenuList(ControlP5 c, String name, int w, int h) {
    super( c, name, 0, 0, w, h );
    c.register( this );
    menu = createGraphics(getWidth(), getHeight() );

    setView(new ControllerView<MenuList>() {

      public void display(PGraphics pg, MenuList t ) {
        if (updateMenu) {
          updateMenu();
        }
        if (inside() ) {
          menu.beginDraw();
          int len = -(itemHeight * items.size()) + getHeight();
          int ty = int(map(pos, len, 0, getHeight() - scrollerLength - 2, 2 ) );
          menu.fill(255 );
          menu.rect(getWidth()-4, ty, 4, scrollerLength );
          menu.endDraw();
        }
        pg.image(menu, 0, 0);
      }
    }
    );
    updateMenu();
  }

  /* only update the image buffer when necessary - to save some resources */
  void updateMenu() {
    int len = -(itemHeight * items.size()) + getHeight();
    npos = constrain(npos, len, 0);
    pos += (npos - pos) * 0.1;
    menu.beginDraw();
    menu.noStroke();
    menu.background(255, 64 );
    // menu.textFont(cp5.getFont().getFont());
    menu.pushMatrix();
    menu.translate( 0, pos );
    menu.pushMatrix();

    int i0 = PApplet.max( 0, int(map(-pos, 0, itemHeight * items.size(), 0, items.size())));
    int range = ceil((float(getHeight())/float(itemHeight))+1);
    int i1 = PApplet.min( items.size(), i0 + range );

    menu.translate(0, i0*itemHeight);

    for (int i=i0;i<i1;i++) {
      Map m = items.get(i);
      menu.fill(255, 100);
      menu.rect(0, 0, getWidth(), itemHeight-1 );
      menu.fill(255);
      // menu.textFont(f1);
      menu.text(m.get("title").toString(), 10, 20 );
      // menu.textFont(f2);
      // menu.textLeading(12);
      // menu.text(m.get("subline").toString(), 10, 35 );
      // menu.text(m.get("copy").toString(), 10, 50, 120, 50 );
      menu.image(((PImage)m.get("image")), 140, 10, 50, 50 );
      menu.translate( 0, itemHeight );
    }
    menu.popMatrix();
    menu.popMatrix();
    menu.endDraw();
    updateMenu = abs(npos-pos)>0.01 ? true:false;
  }
  
  /* when detecting a click, check if the click happend to the far right, if yes, scroll to that position, 
   * otherwise do whatever this item of the list is supposed to do.
   */
  public void onClick() {
    if (getPointer().x()>getWidth()-10) {
      npos= -map(getPointer().y(), 0, getHeight(), 0, items.size()*itemHeight);
      updateMenu = true;
    } 
    else {
      int len = itemHeight * items.size();
      int index = int( map( getPointer().y() - pos, 0, len, 0, items.size() ) ) ;
      setValue(index);
    }
  }
  
  public void onMove() {
  }

  public void onDrag() {
    npos += getPointer().dy() * 2;
    updateMenu = true;
  } 

  public void onScroll(int n) {
    npos += ( n * 8 );
    updateMenu = true;
  }

  void addItem(Map<String, Object> m) {
    items.add(m);
    updateMenu = true;
  }
  
  Map<String,Object> getItem(int theIndex) {
    return items.get(theIndex);
  }
}