module resourcemanager;

import dsfml.graphics: Texture;
import std.exception;
import std.string;
import std.array;
import std.stdio;
import std.file;
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
  private Texture[Name] tex_loaded;
  private LoaderConfig[Name] tex_registered;

  void tex_register(in LoaderConfig conf, string name) {
    if((name in tex_registered) !is null) {
      throw new StringException(
        "Can't register second texture with the same name:\n"
        ~ " name: \"" ~ name ~ "\"\n"
        ~ " current path: " ~ tex_registered[name].path ~ "\n"
        ~ " new path: " ~ conf.path
      );
    }

    tex_registered[name] = conf;
  }

  void registerJSON(in JSONValue jval) {
    immutable texs = jval["textures"];
    foreach(tex; texs.array) {
      immutable path = tex["path"].str;
      immutable name = tex["name"].str;
      immutable smooth = tex["smooth"].ifThrown(JSONValue(1)).integer == 1;

      tex_register(LoaderConfig(path, smooth), name);
    }
  }

  void registerJSON(string text) {
    registerJSON(text.parseJSON);
  }

  void registerJSONFile(string path) {
    registerJSON(path.readText);
  }

  void load() {
    uint textures_loaded = 0;
    foreach(p; tex_registered.byPair) {
      tex_loaded[p.key] = new Texture;
      if(!tex_loaded[p.key].loadFromFile(p.value.path)) {
        writeln("couldn't load " ~ p.value.path ~ " as \"" ~ p.key ~ "\"");
      } else {
        tex_loaded[p.key].setSmooth(p.value.smooth);
        ++textures_loaded;
      }
    }

    writeln("loaded ", textures_loaded, " texture(s)");
  }

  Texture tex(string name) {
    return tex_loaded[name];
  }

  static ResourceManager instance;

  static this() {
    instance = new ResourceManager;
  }
}

alias manager = ResourceManager.instance;
