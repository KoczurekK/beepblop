module game;

import std.math;
import dsfml.graphics;
import std.datetime: Duration;

import background;

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
    while(_window.isOpen) {
      for(Event ev; _window.pollEvent(ev);) {
        handleEvent(ev);
      }

      _window.clear(Color(30, 30, 30));
      _window.draw(_bg);

      _window.display;
    }
  }
}
