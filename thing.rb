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

  def side_intx(stx, sty, edx, edy, side)
    py_nmr =
      Matrix[
        [Matrix[[stx,sty],[edx,edy]].det, Matrix[[sty,1],[edy,1]].det],
        [Matrix[[side,top],[side,bottom]].det, Matrix[[top,1],[bottom,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[sty,1],[edy,1]].det],
        [Matrix[[side,1],[side,1]].det, Matrix[[top,1],[bottom,1]].det]
      ].det

    py = py_nmr/denom
    py >= top && py <= bottom ? [side, py] : nil
  end

  def left_intx(stx, sty, edx, edy)
    side_intx(stx, sty, edx, edy, left)
  end

  def right_intx(stx, sty, edx, edy)
    side_intx(stx, sty, edx, edy, right)
  end

  def tb_intx(stx, sty, edx, edy, tb)
    px_nmr =
      Matrix[
        [Matrix[[stx,sty],[edx,edy]].det, Matrix[[stx,1],[edx,1]].det],
        [Matrix[[left,tb],[right,tb]].det, Matrix[[left,1],[right,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[sty,1],[edy,1]].det],
        [Matrix[[left,1],[right,1]].det, Matrix[[tb,1],[tb,1]].det]
      ].det

    px = px_nmr/denom
    px >= left && px <= right ? [px, tb] : nil
  end

  def top_intx(stx, sty, edx, edy)
    tb_intx(stx, sty, edx, edy, top)
  end

  def bottom_intx(stx, sty, edx, edy)
    tb_intx(stx, sty, edx, edy, bottom)
  end

  def on_path?(stx, sty, edx, edy)
    raise [stx,sty,edx,edy].inspect unless stx && edx && sty && edy
    left_intx(stx, sty, edx, edy) || 
    right_intx(stx, sty, edx, edy) || 
    top_intx(stx, sty, edx, edy) || 
    bottom_intx(stx, sty, edx, edy)
  end

  def nearest_corner(stx, sty, edx, edy)
    ti = top_intx(stx, sty, edx, edy)
    bi = bottom_intx(stx, sty, edx, edy)
    
    if stx < edx
      if sty < edy
        if ti
          [top-1, right+1]
        else
          [bottom+1, left-1]
        end
      else
        if bi
          [bottom+1, right+1]
        else
          [top-1, left-1]
        end
      end
    else
      if sty < edy
        if ti
          [top-1, left-1]
        else
          [bottom+1, right+1]
        end
      else
        if bi
          [bottom+1, left-1]
        else
          [top-1, right+1]
        end
      end
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
