require 'byebug'


class Piece
  attr_reader :color, :pos, :board

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def update_pos(new_pos)
    @pos = new_pos
  end

  def valid_moves
    moves.reject { |end_pos| move_into_check?(end_pos) }
  end

  def move_into_check?(end_pos)
    dup_board = board.dup
    dup_board.move_piece!(pos, end_pos)
    dup_board.in_check?(color)
  end
end
