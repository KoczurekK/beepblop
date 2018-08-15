import dsfml.graphics;
import std.stdio;
import std.file;
import std.json;

import resourcemanager;
import background;
import menu;

static this() {
  auto jval = parseJSON("assets/assets.json".readText);
  manager.registerJSON(jval);
}

void main() {
  manager.load();

  auto background = new Background;

	auto win = new RenderWindow(VideoMode.getDesktopMode, "game", Window.Style.Fullscreen);
  win.setVerticalSyncEnabled(true);

  auto menu = new Menu(win, background);
  menu.run;
}
