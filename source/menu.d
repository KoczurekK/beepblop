module menu;

import dsfml.graphics;
import std.stdio;

import resourcemanager;
import background;
import button;
import game;

static this() {
  manager.register(LoaderConfig("assets/start.png"), "startbtn");
}

class Menu {
  private RenderWindow _window;
  private Background _bg;
  private Button _start;

  private void start_game() {
    auto game = new Game(_window, _bg);
    game.run;
  }

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

    _start = new Button;
    _start.setTexture(manager["startbtn"]);
    _start.position = Vector2f(0, 0);

    _start.onHover = () {
      _start.color = Color(255, 100, 100);
    };
    _start.onUnhover = () {
      _start.color = Color.White;
    };
    _start.onClick = () {
      _start.color = Color.Red;
    };
    _start.onRelease = () { this.start_game; };
  }

  void run() {
    auto clk = new Clock;
    float total_secs = 0;

    while(_window.isOpen) {
      immutable dt = cast(real) clk.restart.total!"nsecs" / 1_000_000_000;
      total_secs += dt;

      for(Event ev; _window.pollEvent(ev);) {
        handleEvent(ev);
        _start.handler(ev, _window);
      }

      _bg.move(Vector2f(-1.2, .35) * dt * 70);

      _window.clear(Color(30, 30, 30));
      _window.draw(_bg);

      _window.draw(_start);

      _window.display;
    }
  }
}
