module bullet;

import resourcemanager;
import dsfml.graphics;

class Bullet: Sprite {
  real velocity;

  this(in real vel) {
    setTexture(manager.get!Texture("bullet"));
    velocity = vel;
  }

  void update(real dt) {
    move(Vector2f(0, -velocity * dt));
  }
}
