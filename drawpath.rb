require 'gosu'
require 'thing'

class Drawpath < Gosu::Window
  def initialize
    super 1024, 768, false
    # @things = [Thing.new(self, 512, 384, 100, 100), Thing.new(self, 120, 240, 75, 75)]
    @things = [Thing.new(self, 512, 384, 100, 100)]
    @raw_paths = []
    @cooked_paths = []
  end

  def needs_cursor?() true end

  def button_down(btn)
    case btn
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      if @end_x || !@start_x
        @start_x = mouse_x
        @start_y = mouse_y
        @end_x = @end_y = nil
        @cooked_paths = []
      else
        @end_x = mouse_x
        @end_y = mouse_y
      end
    end
  end

  def update
    @things.each { |t| t.color = Gosu::Color::RED } 
    if @end_x
      @things.each do |thing|
        # debugger
        path = [@start_x, @start_y, @end_x, @end_y]
        while path
          stx, sty, edx, edy = path
          if thing.on_path? stx, sty, edx, edy
            x, y = thing.nearest_corner stx, sty, edx, edy
            @cooked_paths.push [stx, sty, x, y]
            path = [x, y, edx, edy]
          else
            @cooked_paths.push [stx, sty, edx, edy]
            path = nil
          end
        end
      end
    end
  end

  def draw
    @things.each(&:draw)
    if @start_x
      c=Gosu::Color::BLUE
      draw_quad(
        @start_x-5, @start_y-5, c,
        @start_x+5, @start_y-5, c,
        @start_x-5, @start_y+5, c,
        @start_x+5, @start_y+5, c)
    end
    if @end_x
      c=Gosu::Color::BLUE
      draw_quad(
        @end_x-5, @end_y-5, c,
        @end_x+5, @end_y-5, c,
        @end_x-5, @end_y+5, c,
        @end_x+5, @end_y+5, c)
    end

    lc=Gosu::Color::YELLOW
    dc=Gosu::Color::GREEN
    @cooked_paths.each do |stx, sty, edx, edy|
      draw_line(stx, sty, lc, edx, edy, lc)
      draw_quad(edx-5,edy-5,dc,
                edx+5,edy-5,dc,
                edx-5,edy+5,dc,
                edx+5,edy+5,dc)
    end

    if @end_x || !@start_x
      Gosu::Image.from_text(self, "Click to begin new path", "monaco", 24).draw(0, 0, 0)
    else
      Gosu::Image.from_text(self, "Click to end path", "monaco", 24).draw(0, 0, 0)
    end
  end
end
