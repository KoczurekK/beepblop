module button;

import dsfml.graphics;

class Button: Sprite {
  private bool _clicked = false;
  private bool _howering = false;
  void delegate() onClick;
  void delegate() onHover;
  void delegate() onUnhover;
  void delegate() onRelease;

  private bool validEv(Event ev) {
    return
      ev.type == Event.EventType.MouseButtonPressed
      || ev.type == Event.EventType.MouseButtonReleased
      || ev.type == Event.EventType.MouseMoved;
  }
  private Vector2f getCoord(Event ev, RenderTarget source) {
    Vector2i pt;
    if(ev.type == Event.EventType.MouseButtonPressed
    || ev.type == Event.EventType.MouseButtonReleased) {
      pt = Vector2i(ev.mouseButton.x, ev.mouseButton.y);
    }

    if(ev.type == Event.EventType.MouseMoved) {
      pt = Vector2i(ev.mouseMove.x, ev.mouseMove.y);
    }

    return source.mapPixelToCoords(pt);
  }

  void handler(Event ev, RenderTarget source) {
    if(!validEv(ev)) {
      return;
    }

    immutable coord = getCoord(ev, source);

    immutable old_hover = _howering;
    _howering = this.getGlobalBounds.contains(coord);

    if(old_hover != _howering) {
      if(_howering  && onHover)   onHover();
      if(!_howering && onUnhover) onUnhover();
    }

    if(_howering && ev.type == Event.EventType.MouseButtonPressed) {
      _clicked = true;
      if(onClick) onClick();
    }

    if(_clicked && ev.type == Event.EventType.MouseButtonReleased) {
      _clicked = false;
      if(onRelease) onRelease();
    }
  }
}
