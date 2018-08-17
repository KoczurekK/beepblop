module sounds;

import resourcemanager;
import std.algorithm;
import dsfml.audio;

class SoundPool {
  Sound[] sounds;

  private this() {}

  void play(string name) {
    sounds ~= new Sound(asset!SoundBuffer(name));
    sounds[$ - 1].play;
  }

  void cleanup() {
    sounds = sounds.remove!(s => s.status == Sound.Status.Stopped);
  }

  static SoundPool sound_pool;

  static this() {
    sound_pool = new SoundPool;
  }
}

alias sound_pool = SoundPool.sound_pool;
