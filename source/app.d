import dsfml.graphics;
import std.stdio;
import std.file;

import resourcemanager;
import background;
import menu;

static this() {
  manager.registerJSON("assets/assets.json".readText);
  manager.load();
}

void main() {
  auto background = new Background;

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  win.setVerticalSyncEnabled(true);

  auto menu = new Menu(win, background);
  menu.run;
}
