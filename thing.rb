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
    if slope >= 0 # actually a negative slope because Y-axis is reversed
      slope > (top-sty)/(right-stx) && slope < (bottom-sty)/(left-stx)
    else
      slope < (top-sty)/(left-stx) && slope > (bottom-sty)/(right-stx)
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
