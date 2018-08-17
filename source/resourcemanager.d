module resourcemanager;

import dsfml.audio: SoundBuffer;
import dsfml.graphics: Texture;
import std.stdio;

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
  private this() {}

  private Texture[string] m_textures;
  private SoundBuffer[string] m_audio;

  void load() {
    import ct_assets: CTAsset, static_assets;
    foreach(asset; static_assets) {
      final switch(asset.type) {
        case "textures":
          m_textures[asset.name] = new Texture;
          m_textures[asset.name].loadFromMemory(asset.text);
          break;
        case "audio":
          m_audio[asset.name] = new SoundBuffer;
          m_audio[asset.name].loadFromMemory(asset.text);
          break;
      }
    }
  }

  auto get(AssetType)(string name)
  if(is(AssetType == Texture)) {
    return m_textures[name];
  }

  auto get(AssetType)(string name)
  if(is(AssetType == SoundBuffer)) {
    return m_audio[name];
  }

  static ResourceManager instance;
  static this() {
    instance = new ResourceManager;
    instance.load;
  }
}

alias manager = ResourceManager.instance;
