module player;

import resourcemanager;
import dsfml.graphics;
import sounds;
import bullet;

class Player: Sprite {
  private Clock shoot_timeout;

  real shoot_rate = 1. / 5;
  real raw_acc_rate = 10;
  real speed = 1. / 2;
  Vector2f velocity;

  this() {
    velocity = Vector2f(0, 0);
    shoot_timeout = new Clock;
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

  Bullet[] attemptShoot() {
    if(!Keyboard.isKeyPressed(Keyboard.Key.Space)) {
      return [];
    }
    if(cast(real) shoot_timeout.getElapsedTime.total!"nsecs" / 1_000_000_000 < shoot_rate) {
      return [];
    }

    shoot_timeout.restart;

    auto b = new Bullet(1500);
    b.position = this.position;

    sound_pool.play("bzzz");

    return [b];
  }
}
