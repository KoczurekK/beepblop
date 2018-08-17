module player;

import resourcemanager;
import dsfml.graphics;

class Player: Sprite {
  real raw_acc_rate = 10;
  real speed = 1. / 2;
  Vector2f velocity;

  this() {
    velocity = Vector2f(0, 0);
    setTexture(manager.tex("player"));
    this.origin = cast(Vector2f) manager.tex("player").getSize / 2;
  }

  void fly(real from_x, real to_x, real dt) {
    immutable range = to_x - from_x;

    auto direction = Vector2f(0, 0);
    if(Keyboard.isKeyPressed(Keyboard.Key.Left)) {
      direction = Vector2f(-1, 0);
    }
    if(Keyboard.isKeyPressed(Keyboard.Key.Right)) {
      direction = Vector2f(1, 0);
    }

    immutable acc_rate = dt * raw_acc_rate;
    velocity = velocity * (1 - acc_rate) + direction * acc_rate;

    this.move(velocity * speed * range * dt);
  }
}
