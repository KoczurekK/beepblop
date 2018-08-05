import dsfml.graphics;
import std.stdio;

import resourcemanager;
import game;

void main() {
  manager.load();

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  win.setVerticalSyncEnabled(true);

  auto game = new Game(win);

  game.run;
}
