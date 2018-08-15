module resourcemanager;

import dsfml.graphics: Texture;
import std.string;
import std.array;
import std.stdio;
import std.json;

struct LoaderConfig {
  string path;
  bool smooth;

  this(string _path, bool _smooth = true) {
    path = _path;
    smooth = _smooth;
  }
}

class ResourceManager {
  alias Name = string;

  private this() {}
  private Texture[Name] loaded;
  private LoaderConfig[Name] registered;

  void register(in LoaderConfig conf, string name) {
    if((name in registered) !is null) {
      throw new StringException(
        "Can't register second texture with the same name:\n"
        ~ " name: \"" ~ name ~ "\"\n"
        ~ " current path: " ~ registered[name].path ~ "\n"
        ~ " new path: " ~ conf.path
      );
    }

    registered[name] = conf;
  }

  void registerJSON(JSONValue jval) {
    JSONValue texs = jval["textures"];
    foreach(tex; texs.array) {
      immutable path = tex["path"].str;
      immutable name = tex["name"].str;
      immutable smooth = tex["smooth"].isNull || tex["smooth"].integer == 1;

      register(LoaderConfig(path, smooth), name);
    }
  }

  void load() {
    foreach(p; registered.byPair) {
      loaded[p.key] = new Texture;
      if(!loaded[p.key].loadFromFile(p.value.path)) {
        writeln("couldn't load " ~ p.value.path ~ " as \"" ~ p.key ~ "\"");
      } else {
        loaded[p.key].setSmooth(p.value.smooth);
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
