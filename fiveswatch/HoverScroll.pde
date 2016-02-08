import controlP5.*;
import java.util.*;

class HoverScroll extends ScrollableList {

  private boolean hover = false;

  HoverScroll(ControlP5 cp5, String name) {
    super(cp5, name);
  }

  public HoverScroll setValue(float val) {
    super.setValue(val);
    return this;
  }

  void onMove() {
    super.onMove();
    checkHover();
  }

  void checkHover() {
    if (cp5.isMouseOver(this)) {
      hover = true;
    }
    else {
      hover = false;
    }
  }

  public int getItemHover() {
    return itemHover;
  }

  public boolean getHover() {
    return hover;
  }

}
