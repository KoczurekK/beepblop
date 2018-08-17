module background;

import dsfml.graphics;
import std.math;
import std.conv;

import resourcemanager;
import bigsprite;

class Background: Drawable {
  private BigSprite[3] layers;
  private Vector2f[3] offsets;

  this() {
    foreach(n; 0..3) {
      layers[n] = new BigSprite;
      offsets[n] = Vector2f(0, 0);
    }

    foreach(n; 0..3) {
      immutable nstr = (n + 1).to!string;
      layers[n].textures = [
        asset!Texture("bg" ~ nstr ~ "a"), asset!Texture("bg" ~ nstr ~ "b"),
        asset!Texture("bg" ~ nstr ~ "c"), asset!Texture("bg" ~ nstr ~ "d")
      ];
    }

    foreach(l; layers) {
      l.position = Vector2f(0, 0);
    }
  }

  void move(in Vector2f shift) {
    foreach(n; 0..3) {
      immutable factor = 15. / (18 - n * n);

      offsets[n] = Vector2f(
        fmod(offsets[n].x + shift.x * factor, layers[n].size.x),
        fmod(offsets[n].y + shift.y * factor, layers[n].size.y)
      );
      while(offsets[n].x < -layers[n].size.x) {
        offsets[n].x += layers[n].size.x;
      }
      while(offsets[n].y < -layers[n].size.y) {
        offsets[n].y += layers[n].size.y;
      }
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
    foreach(n; 0..3) {
      auto layer = copy[n];
      auto offset = offsets[n];

      int xreps = cast(int) (cast(real) rt_sz.x / layer.size.x).ceil + 1;
      int yreps = cast(int) (cast(real) rt_sz.y / layer.size.y).ceil + 1;

      foreach(x; -1 .. xreps)
      foreach(y; -1 .. yreps) {
        layer.position = origin + offset + Vector2f(layer.size.x * x, layer.size.y * y);
        rt.draw(layer, rs);
      }
    }
  }
}
