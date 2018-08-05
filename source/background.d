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
  private BigSprite[3] layers;
  private Vector2f offset1 = Vector2f(0, 0);

  this() {
    foreach(n; 0..3) {
      layers[n] = new BigSprite;
    }

    foreach(n; 0..3) {
      immutable nstr = (n + 1).to!string;
      layers[n].textures = [
        manager["bg" ~ nstr ~ "a"], manager["bg" ~ nstr ~ "b"],
        manager["bg" ~ nstr ~ "c"], manager["bg" ~ nstr ~ "d"]
      ];
    }

    foreach(l; layers) {
      l.position = Vector2f(0, 0);
    }
  }

  void move(in Vector2f shift) {
    offset1 = Vector2f(
      fmod(offset1.x + shift.x, layers[0].size.x),
      fmod(offset1.y + shift.y, layers[0].size.y)
    );
    while(offset1.x < -layers[0].size.x) {
      offset1.x += layers[0].size.x;
    }
    while(offset1.y < -layers[0].size.y) {
      offset1.y += layers[0].size.y;
    }
  }

  override void draw(RenderTarget rt, RenderStates rs) const {
    immutable origin = rt.mapPixelToCoords(Vector2i(0, 0));
    immutable rt_sz = rt.mapPixelToCoords(cast(Vector2i) rt.getSize) - origin;

    auto copy = [
      layers[0].dup,
      layers[1].dup,
      layers[2].dup
    ];
    foreach(layer; copy) {
      int xreps = cast(int) (cast(real) rt_sz.x / layer.size.x).ceil + 1;
      int yreps = cast(int) (cast(real) rt_sz.y / layer.size.y).ceil + 1;

      foreach(x; -1 .. xreps)
      foreach(y; -1 .. yreps) {
        layer.position = origin + offset1 + Vector2f(layer.size.x * x, layer.size.y * y);
        rt.draw(layer, rs);
      }
    }
  }
}
