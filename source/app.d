import dsfml.graphics;
import std.stdio;

import resourcemanager;
import background;
import menu;

void main() {
  manager.load();

  auto background = new Background;

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  win.setVerticalSyncEnabled(true);

  auto menu = new Menu(win, background);
  menu.run;
}
