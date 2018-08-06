module menu;

import dsfml.graphics;
import background;
import game;

class Menu {
  private RenderWindow _window;
  private Background _bg;

  private void handleEvent(in Event ev) {
    if(ev.type == Event.EventType.Closed
    || (ev.type == Event.EventType.KeyPressed
    &&  ev.key.code == Keyboard.Key.Escape)) {
      _window.close;
    }

    if(ev.type == Event.EventType.KeyPressed
    && ev.key.code == Keyboard.Key.Return) {
      auto game = new Game(_window, _bg);
      game.run;
    }
  }

  this(RenderWindow window, Background bg) {
    _window = window;
    _bg = bg;
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

      _bg.move(Vector2f(-1.2, .35) * dt * 70);

      _window.clear(Color(30, 30, 30));
      _window.draw(_bg);

      _window.display;
    }
  }
}
