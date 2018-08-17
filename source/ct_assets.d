module ct_assets;

import std.algorithm;
import std.file;
import std.json;

struct CTAsset {
  static CTAsset make(string _path, string _type, string _name)() {
    CTAsset res;

    res.type = _type;
    res.name = _name;
    res.text = import(_path);

    return res;
  }

  string type;
  string name;
  string text;
}

immutable CTAsset[] static_assets = () {
  enum jval = parseJSON(import("assets.json"));
  CTAsset[] ctfs;

  static foreach(n; 0 .. jval.array.length) {
    { // Additional bracket level to avoid name collision
      enum path = jval[n]["path"].str;
      enum name = jval[n]["name"].str;
      enum type = jval[n]["type"].str;
      ctfs ~= CTAsset.make!(path, type, name);
    }
  }

  return ctfs;
}();
