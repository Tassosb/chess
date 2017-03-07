require_relative 'display'
require_relative 'errors'

class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class HumanPlayer < Player

  def play_turn(display)
    [get_start_input(display), get_end_input(display)]
  end

  def get_start_input(display)
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

  def get_end_input(display)
    end_input = nil

    until end_input
      display.render
      end_input = display.cursor.get_input
    end

  end_input
  end
end

class ComputerPlayer < Player

  def play_turn(display)
    board = display.board

    piece = choose_piece(board)
    start_pos = piece.pos
    end_pos = piece.valid_moves.sample
    [start_pos, end_pos]
  end

  def choose_piece(board)
    board.player_pieces_with_moves(color).sample
  end
end
