import dsfml.graphics;
import std.stdio;

import resourcemanager;
import game;

void main() {
  manager.load();

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  auto game = new Game(win);

  game.run;
}
