module game;

import dsfml.graphics;

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
