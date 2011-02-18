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
    return nil unless [stx, side, edx].sort[1] == side
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
    return nil unless [sty, tb, edy].sort[1] == tb
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
    left_intx(stx, sty, edx, edy) || 
    right_intx(stx, sty, edx, edy) || 
    top_intx(stx, sty, edx, edy) || 
    bottom_intx(stx, sty, edx, edy)
  end

  def nearest_corner(stx, sty, edx, edy)
    li = left_intx(stx, sty, edx, edy)
    ri = right_intx(stx, sty, edx, edy)
    ti = top_intx(stx, sty, edx, edy)
    bi = bottom_intx(stx, sty, edx, edy)
    
    if stx < edx
      if sty < edy
        x, y = ti || li
      else
        x, y = bi || li
      end
    else
      if sty < edy
        x, y = ti || ri
      else
        x, y = bi || ri
      end
    end
    x = x > self.x ? right+1 : left-1
    y = y > self.y ? bottom+1 : top-1

    if stx == x && sty == y
      if x == left-1
        if y == top-1
          if bi
            y = bottom+1
          else
            x = right+1
          end
        else
          if ti
            y = top-1
          else
            x = right+1
          end
        end
      else
        if y == top-1
          if bi
            y = bottom+1
          else
            x = left-1
          end
        else
          if ti
            y = top-1
          else
            x = left-1
          end
        end
      end
    end
    [x, y]
  end

  def draw
    window.draw_quad(
      @x-width/2.0, @y-height/2.0, @color,
      @x+width/2.0, @y-height/2.0, @color,
      @x-width/2.0, @y+height/2.0, @color,
      @x+width/2.0, @y+height/2.0, @color)
  end
end
