module bigsprite;

import dsfml.graphics;

class BigSprite: Drawable {
  private Sprite s00, s10, s01, s11;

  private void correctPositions() {
    immutable s00size = s00.getTexture.getSize;

    s10.position = s00.position + Vector2f(s00size.x, 0);
    s01.position = s00.position + Vector2f(0, s00size.y);
    s11.position = s00.position + cast(Vector2f) s00size;
  }

  this() {
    s00 = new Sprite;
    s10 = new Sprite;
    s01 = new Sprite;
    s11 = new Sprite;
  }

  @property const(Texture)[4] textures() {
    return [s00.getTexture, s10.getTexture, s01.getTexture, s11.getTexture];
  }
  @property const(Texture)[4] textures(in const(Texture)[4] txs) {
    s00.setTexture(txs[0]);
    s10.setTexture(txs[1]);
    s01.setTexture(txs[2]);
    s11.setTexture(txs[3]);

    correctPositions();

    return this.textures;
  }

  @property Vector2f position() {
    return s00.position;
  }
  @property Vector2f position(in Vector2f pos) {
    s00.position = pos;
    correctPositions();
    return s00.position;
  }

  override void draw(RenderTarget target, RenderStates states) {
    target.draw(s00, states);
    target.draw(s10, states);
    target.draw(s01, states);
    target.draw(s11, states);
  }
}
