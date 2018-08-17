module game;

import std.datetime: Duration;
import dsfml.graphics;
import background;
import std.math;
import player;
import bullet;

class Game {
  private RenderWindow _window;
  private Background _bg;
  private Clock _clk;
  private real _time;

  private void handleEvent(in Event ev) {
    if(ev.type == Event.EventType.Closed
    || (ev.type == Event.EventType.KeyPressed
    &&  ev.key.code == Keyboard.Key.Escape)) {
      _window.close;
    }
  }

  this(RenderWindow window, Background bg) {
    _window = window;
    _bg = bg;

    _clk = new Clock;
  }

  real total_time() const {
    return _time;
  }
  real delta_time() {
    immutable dt = cast(real) _clk.restart.total!"nsecs" / 1_000_000_000;
    _time += dt;
    return dt;
  }

  void run() {
    auto player = new Player;
    Bullet[] bullets;

    player.position = Vector2f(
      (_window.getSize.x - player.getLocalBounds.width) / 2,
      0.9 * _window.getSize.y
    );

    while(_window.isOpen) {
      immutable dt = delta_time;

      for(Event ev; _window.pollEvent(ev);) {
        handleEvent(ev);
      }

      _bg.move(Vector2f(0, 1.6) * dt * 70);
      player.fly(0, _window.getSize.x, dt);
      bullets ~= player.attemptShoot();

      foreach(b; bullets) {
        b.update(dt);
      }

      _window.clear(Color(30, 30, 30));
      _window.draw(_bg);

      foreach(b; bullets) {
        _window.draw(b);
      }

      _window.draw(player);

      _window.display;
    }
  }
}
