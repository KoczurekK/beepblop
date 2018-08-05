module resourcemanager;

import dsfml.graphics: Texture;
import std.string;
import std.array;
import std.stdio;

class ResourceManager {
  alias Name = string;
  alias Path = string;

  private this() {}
  private Texture[Name] loaded;
  private Path[Name] registered;

  void register(string path, string name) {
    if((name in registered) !is null) {
      throw new StringException(
        "Can't register second texture with the same name:\n"
        ~ " name: \"" ~ name ~ "\"\n"
        ~ " current path: " ~ registered[name] ~ "\n"
        ~ " new path: " ~ path
      );
    }

    registered[name] = path;
  }

  void load() {
    foreach(p; registered.byPair) {
      loaded[p.key] = new Texture;
      if(loaded[p.key].loadFromFile(p.value)) {
        writeln("loaded " ~ p.value ~ " as \"" ~ p.key ~ "\"");
      }
    }
  }

  Texture opIndex(string name) {
    return loaded[name];
  }

  static ResourceManager instance;

  static this() {
    instance = new ResourceManager;
  }
}

alias manager = ResourceManager.instance;
