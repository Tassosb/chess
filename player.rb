require_relative 'display'
require_relative 'errors'

class Player
  attr_reader :name, :color, :display

  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end
end

class HumanPlayer < Player
  def play_turn
    [get_start_input, get_end_input]
  end

  def get_start_input
    start_input = nil

    until start_input
      display.render
      puts "#{name}'s turn! #{color.capitalize} pieces only!"
      start_input = display.cursor.get_input
    end

    unless display.board.matches_color?(start_input, color)
      raise InvalidMoveError, "Not your piece!"
    end

    start_input
  end

  def get_end_input
    end_input = nil

    until end_input
      display.render
      end_input = display.cursor.get_input
    end

  end_input
  end
end

class ComputerPlayer < Player
  def play_turn
  end


end
