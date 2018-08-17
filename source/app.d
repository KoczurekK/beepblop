import dsfml.graphics;
import std.stdio;

import background;
import menu;

void main() {
  auto background = new Background;

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  win.setVerticalSyncEnabled(true);

  auto menu = new Menu(win, background);
  menu.run;
}
