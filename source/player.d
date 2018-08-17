module player;

import resourcemanager;
import dsfml.graphics;

class Player: Sprite {
  this() {
    setTexture(manager.tex("player"));
  }
}
