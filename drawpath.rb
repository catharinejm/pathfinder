require 'gosu'
require 'thing'

class Drawpath < Gosu::Window
  def initialize
    super 1024, 768, false
    @things = [Thing.new(self, 512, 384, 100, 100), Thing.new(self, 120, 240, 75, 75)]
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
        thing.color = Gosu::Color::BLUE if thing.on_path? @start_x, @start_y, @end_x, @end_y
        x,y=thing.left_intersection @start_x, @start_y, @end_x, @end_y
        puts "X: #{x}, Y: #{y}"
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
      c=Gosu::Color::YELLOW
      draw_quad(
        @end_x-5, @end_y-5, c,
        @end_x+5, @end_y-5, c,
        @end_x-5, @end_y+5, c,
        @end_x+5, @end_y+5, c)
    end

    if @start_x && @end_x
      c=Gosu::Color::GREEN
      draw_line(
        @start_x, @start_y, c,
        @end_x, @end_y, c)
    end

    if @end_x || !@start_x
      Gosu::Image.from_text(self, "Click to begin new path", "monaco", 24).draw(0, 0, 0)
    else
      Gosu::Image.from_text(self, "Click to end path", "monaco", 24).draw(0, 0, 0)
    end
  end
end
