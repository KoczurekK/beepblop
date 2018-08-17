module ct_files;

import std.file;
import std.json;

struct CTAsset {
  static CTAsset make(string _path)() {
    CTAsset res;

    res.path = _path;
    res.text = import(_path);

    return res;
  }

  string path;
  string text;
}

immutable CTAsset[] static_assets = () {
  enum jval = parseJSON(import("assets/assets.json"));
  CTAsset[] ctfs;

  static foreach(type; ["textures", "audio"])
  static foreach(n; 0 .. jval[type].array.length) {
    // Additional bracket level to avoid name collision
    {
      enum str = jval[type][n]["path"].str;
      ctfs ~= CTAsset.make!str;
    }
  }

  return ctfs;
}();
