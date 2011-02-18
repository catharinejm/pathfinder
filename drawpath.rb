require 'gosu'
require 'thing'

class Drawpath < Gosu::Window
  def initialize
    super 1024, 768, false
    @things = [Thing.new(self, 512, 384, 100, 100), Thing.new(self, 120, 240, 75, 75)]
    # @things = [Thing.new(self, 512, 384, 100, 100)]
    @cooked_paths = []
    @debug_paths = []
    @debug_index = 0
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
        @cooked_paths.clear
        @debug_paths.clear
      else
        @end_x = mouse_x
        @end_y = mouse_y
      end
    when Gosu::KbD
      @debug = !@debug
      @debug_index = 0
    when Gosu::KbEnter, Gosu::KbReturn
      @debug_index += 1
      @debug_index %= @debug_paths.length
    end
  end

  def update
    @things.each { |t| t.color = Gosu::Color::RED } 
    if @end_x && @cooked_paths.empty?
      @cooked_paths.push [@start_x, @start_y, @end_x, @end_y]
      @debug_paths.push @cooked_paths.dup
      @things.each do |thing|
        # debugger
        paths = @cooked_paths.dup
        @cooked_paths.clear
        until paths.empty?
          stx, sty, edx, edy = paths.shift
          if thing.on_path? stx, sty, edx, edy
            x, y = thing.nearest_corner stx, sty, edx, edy
            @cooked_paths.push [stx, sty, x, y]
            paths.unshift [x, y, edx, edy]
            @debug_paths.push(@cooked_paths.dup + paths)
          else
            @cooked_paths.push [stx, sty, edx, edy]
          end
        end
      end
    end
  end

  def draw_cookin paths
    return unless paths
    lc=Gosu::Color::YELLOW
    dc=Gosu::Color::GREEN
    paths.each_with_index do |(stx, sty, edx, edy), idx|
      draw_line(stx, sty, lc, edx, edy, lc)
      draw_quad(edx-5,edy-5,dc,
                edx+5,edy-5,dc,
                edx-5,edy+5,dc,
                edx+5,edy+5,dc)
      Gosu::Image.from_text(self, (idx+1).to_s, "monaco", 20).draw(edx, edy, 10, 1, 1, Gosu::Color::WHITE)
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

    if @debug
      draw_cookin @debug_paths[@debug_index]
      Gosu::Image.from_text(self, "DEBUG - #@debug_index", "monaco", 24).draw(width-150, 0, 0)
    else
      draw_cookin @cooked_paths
    end

    if @end_x || !@start_x
      Gosu::Image.from_text(self, "Click to begin new path", "monaco", 24).draw(0, 0, 0)
      Gosu::Image.from_text(self, "start_x: #@start_x, start_y: #@start_y, end_x: #@end_x, end_y: #@end_y", "monaco", 24).draw(0, height-24, 0)
    else
      Gosu::Image.from_text(self, "Click to end path", "monaco", 24).draw(0, 0, 0)
    end
  end
end
