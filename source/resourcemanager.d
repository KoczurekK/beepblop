module resourcemanager;

import dsfml.audio: SoundBuffer;
import dsfml.graphics: Texture;
import std.exception;
import std.string;
import std.array;
import std.stdio;
import std.file;
import std.json;

struct LoaderConfig {
  string path;

  ///Only applies for textures
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

  private SoundBuffer[Name] audio_loaded;
  private LoaderConfig[Name] audio_registered;

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

  void audio_register(in LoaderConfig conf, string name) {
    if((name in audio_registered) !is null) {
      throw new StringException(
        "Can't register second audio file with the same name:\n"
        ~ " name: \"" ~ name ~ "\"\n"
        ~ " current path: " ~ audio_registered[name].path ~ "\n"
        ~ " new path: " ~ conf.path
      );
    }

    audio_registered[name] = conf;
  }

  void registerJSON(in JSONValue jval) {
    immutable texs = jval["textures"];
    foreach(tex; texs.array) {
      immutable path = tex["path"].str;
      immutable name = tex["name"].str;
      immutable smooth = tex["smooth"].ifThrown(JSONValue(1)).integer == 1;

      tex_register(LoaderConfig(path, smooth), name);
    }

    immutable audios = jval["audio"];
    foreach(audio; audios.array) {
      immutable path = audio["path"].str;
      immutable name = audio["name"].str;

      audio_register(LoaderConfig(path), name);
    }
  }

  void registerJSON(string text) {
    registerJSON(text.parseJSON);
  }

  void registerJSONFile(string path) {
    registerJSON(path.readText);
  }

  void load() {
    uint total_textures_loaded = 0;
    foreach(p; tex_registered.byPair) {
      tex_loaded[p.key] = new Texture;
      if(!tex_loaded[p.key].loadFromFile(p.value.path)) {
        writeln("couldn't load " ~ p.value.path ~ " as \"" ~ p.key ~ "\"");
      } else {
        tex_loaded[p.key].setSmooth(p.value.smooth);
        ++total_textures_loaded;
      }
    }

    uint total_audio_loaded = 0;
    foreach(p; audio_registered.byPair) {
      audio_loaded[p.key] = new SoundBuffer;
      if(!audio_loaded[p.key].loadFromFile(p.value.path)) {
        writeln("couldn't load " ~ p.value.path ~ " as \"" ~ p.key ~ "\"");
      } else {
        ++total_audio_loaded;
      }
    }

    writeln("loaded ", total_textures_loaded, " texture(s)");
    writeln("loaded ", total_audio_loaded, " audio files(s)");
  }

  Texture tex(string name) {
    return tex_loaded[name];
  }

  SoundBuffer audio(string name) {
    return audio_loaded[name];
  }

  static ResourceManager instance;

  static this() {
    instance = new ResourceManager;
  }
}

alias manager = ResourceManager.instance;
