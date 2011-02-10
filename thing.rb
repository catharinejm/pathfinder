class Thing
  RAD2 = Math.sqrt(2)
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

  def on_path?(stx, sty, edx, edy)
    slope = (edy-sty)/(edx-stx)
    if stx <= left
      if sty <= top
        edx >= left && edy >= top && slope >= (top-sty)/(right-stx) && slope <= (bottom-sty)/(left-stx)
      elsif sty <= bottom
        edx >= left && slope >= (top-sty)/(left-stx) && slope <= (bottom-sty)/(left-stx)
      else
        edx >= left && edy <= bottom && slope >= (top-sty)/(left-stx) && slope <= (bottom-sty)/(right-stx)
      end
    elsif stx <= right
      if sty <= top
        if slope < 0
          edy >= top && slope <= (top-sty)/(left-stx)
        else
          edy >= top && slope >= (top-sty)/(right-stx)
        end
      elsif sty <= bottom
        true
      else
        if slope < 0
          edy <= bottom && slope <= (bottom-sty)/(right-stx)
        else
          edy <= bottom && slope >= (bottom-sty)/(left-stx)
        end
      end
    else
      if sty <= top
        edx <= right && edy >= top && slope <= (top-sty)/(left-stx) && slope >= (bottom-sty)/(right-stx)
      elsif sty <= bottom
        edx <= right && slope <= (top-sty)/(right-stx) && slope >= (bottom-sty)/(right-stx)
      else
        edx <= right && edy <= bottom && slope >= (bottom-sty)/(left-stx) && slope <= (top-sty)/(right-stx)
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
