require 'matrix'

class Thing
  attr_reader :window
  attr_accessor :x, :y, :width, :height, :color
  def initialize(window, x, y, width, height)
    @window = window
    @x = x
    @y = y
    @width = width
    @height = height
    @color = Gosu::Color::RED
  end

  def top() y - height/2.0 end
  def bottom() y + height/2.0 end
  def left() x - width/2.0 end
  def right() x + width/2.0 end

  def left_intersection(stx, sty, edx, edy)
    px_nmr =
      Matrix[
        [Matrix[[stx,sty],[edx,edy]].det, Matrix[[stx,1],[edx,1]].det],
        [Matrix[[left,top],[left,bottom]].det, Matrix[[left,1],[left,1]].det]
      ].det
    py_nmr =
      Matrix[
        [Matrix[[stx,sty],[edx,edy]].det, Matrix[[sty,1],[edy,1]].det],
        [Matrix[[left,top],[left,bottom]].det, Matrix[[top,1],[bottom,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[sty,1],[edy,1]].det],
        [Matrix[[left,1],[left,1]].det, Matrix[[top,1],[bottom,1]].det]
      ].det

    [px_nmr/denom, py_nmr/denom]
  end

  def on_path?(stx, sty, edx, edy)
    false
  end

  def nearest_corner(stx, sty, edx, edy)
    if stx <= left
      
    end
  end

  def draw
    window.draw_quad(
      @x-width/2.0, @y-height/2.0, @color,
      @x+width/2.0, @y-height/2.0, @color,
      @x-width/2.0, @y+height/2.0, @color,
      @x+width/2.0, @y+height/2.0, @color)
  end
end
