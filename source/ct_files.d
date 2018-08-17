module ct_files;

import std.file;
import std.json;

struct CTFile {
  static CTFile make(string _path)() {
    CTFile res;

    res.path = _path;
    res.text = import(_path);

    return res;
  }

  string path;
  string text;
}

immutable CTFile[] static_assets = () {
  enum jval = parseJSON(import("assets/assets.json"));
  CTFile[] ctfs;

  static foreach(type; ["textures", "audio"])
  static foreach(n; 0 .. jval[type].array.length) {
    // Additional bracket level to avoid name collision
    {
      enum str = jval[type][n]["path"].str;
      ctfs ~= CTFile.make!str;
    }
  }

  return ctfs;
}();
