import dsfml.graphics;
import std.stdio;

import game;

void main() {
	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  auto game = new Game(win);

  game.run;
}
