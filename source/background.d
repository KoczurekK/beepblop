module background;

import dsfml.graphics;
import std.math;
import std.conv;

import resourcemanager;
import bigsprite;

static this() {
  foreach(letter; 'a' .. 'e')
  foreach(layer; 1..3 + 1) {
    string lstr = layer.to!string;
    manager.register("assets/bg/" ~ lstr ~ "/" ~ letter ~ ".png", "bg" ~ lstr ~ letter);
  }
}

class Background: Drawable {
  private BigSprite layer1;

  this() {
    layer1 = new BigSprite;
    layer1.textures = [
      manager["bg1a"], manager["bg1b"],
      manager["bg1c"], manager["bg1d"]
    ];
    layer1.position = Vector2f(0, 0);
  }

  override void draw(RenderTarget rt, RenderStates rs) const {
    immutable origin = rt.mapPixelToCoords(Vector2i(0, 0));
    immutable rt_sz = rt.mapPixelToCoords(cast(Vector2i) rt.getSize) - origin;

    auto l1 = layer1.dup;

    int xreps = cast(int) (cast(real) rt_sz.x / l1.size.x).ceil;
    int yreps = cast(int) (cast(real) rt_sz.y / l1.size.y).ceil;

    foreach(x; 0..xreps)
    foreach(y; 0..yreps) {
      l1.position = origin + Vector2f(l1.size.x * x, l1.size.y * y);
      rt.draw(l1, rs);
    }
  }
}
