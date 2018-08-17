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

  void load() {
    import ct_files: CTAsset, static_assets;
    foreach(asset; static_assets) {
      final switch(asset.type) {
        case "textures":
          tex_loaded[asset.name] = new Texture;
          tex_loaded[asset.name].loadFromMemory(asset.text);
          break;
        case "audio":
          audio_loaded[asset.name] = new SoundBuffer;
          audio_loaded[asset.name].loadFromMemory(asset.text);
          break;
      }
    }
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
