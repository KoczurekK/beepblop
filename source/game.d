module game;

import std.math;
import dsfml.graphics;
import std.datetime: Duration;

import background;

class Game {
  private RenderWindow _window;
  private Background _bg;

  private void handleEvent(in Event ev) {
    if(ev.type == Event.EventType.Closed
    || (ev.type == Event.EventType.KeyPressed
    &&  ev.key.code == Keyboard.Key.Escape)) {
      _window.close;
    }
  }

  this(RenderWindow window) {
    _window = window;
    _bg = new Background;
  }

  void run() {
    auto clk = new Clock;
    float total_secs = 0;

    while(_window.isOpen) {
      immutable dt = cast(real) clk.restart.total!"nsecs" / 1_000_000_000;
      total_secs += dt;

      for(Event ev; _window.pollEvent(ev);) {
        handleEvent(ev);
      }

      _bg.move(Vector2f(-1.2, .35) * dt * 140);

      _window.clear(Color(30, 30, 30));
      _window.draw(_bg);

      _window.display;
    }
  }
}
