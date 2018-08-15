module button;

import dsfml.graphics;

class Button: Sprite {
  private bool _clicked = false;
  private bool _hovering = false;
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

    immutable old_hover = _hovering;
    _hovering = this.getGlobalBounds.contains(coord);

    if(old_hover != _hovering) {
      if(_hovering  && onHover)   onHover();
      if(!_hovering && onUnhover) onUnhover();
    }

    if(_hovering && ev.type == Event.EventType.MouseButtonPressed) {
      _clicked = true;
      if(onClick) onClick();
    }

    if(_clicked && ev.type == Event.EventType.MouseButtonReleased) {
      _clicked = false;
      if(onRelease) onRelease();
    }
  }

  Vector2f size() {
    return Vector2f(
      getGlobalBounds.width,
      getGlobalBounds.height
    );
  }
}
