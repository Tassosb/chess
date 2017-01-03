require_relative 'sliding_piece'
require_relative 'stepping_piece'
require 'byebug'
require 'singleton'

class Piece
  attr_reader :color, :pos, :board

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end

  def update_pos(new_pos)
    @pos = new_pos
  end

  def update_board(new_board)
    @board = new_board
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

class Rook < Piece
  include SlidingPiece

  def moves
    super([:flats])
  end

  def to_s
    color == :white ? " \u2656 " : " \u265c "
  end
end

class Knight < Piece
  include SteppingPiece

  def moves
    super(:knight)
  end

  def to_s
    color == :white ? " \u2658 " : " \u265e "
  end
end

class Bishop < Piece
  include SlidingPiece

  def moves
    super([:diagonal])
  end

  def to_s
    color == :white ? " \u2657 " : " \u265d "
  end
end

class King < Piece
  include SteppingPiece

  def moves
    super(:king)
  end

  def to_s
    color == :white ? " \u2654 " : " \u265a "
  end
end

class Queen < Piece
  include SlidingPiece

  def moves
    super([:flats, :diagonal])
  end

  def to_s
    color == :white ? " \u2655 " : " \u265b "
  end
end

class Pawn < Piece
  def moves
    possible_moves = []
    forward_steps.each do |step|
      d_x, d_y = step
      new_pos = [pos[0] + d_x, pos[1] + d_y]

      next unless board.in_bounds?(new_pos)

      possible_moves << new_pos if board[new_pos].is_a?(NullPiece)
    end

    side_attacks.each do |attack|
      d_x, d_y = attack
      new_pos = [pos[0] + d_x, pos[1] + d_y]

      next unless board.in_bounds?(new_pos)

      possible_moves << new_pos unless board[new_pos].is_a?(NullPiece)

    end

    possible_moves
  end

  def forward_steps
    deltas = color == :white ? [[-1,0]] : [[1,0]]

    if at_start_row?
      double_step = color == :white ? [-2, 0] : [2, 0]
      deltas << double_step
    end

    deltas
  end

  def side_attacks
    color == :white ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
  end


  def at_start_row?
    if color == :black
      pos[0] == 1
    else
      pos[0] == 6
    end
  end

  def to_s
    color == :white ? " \u2659 " : " \u265f "
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
  end

  def to_s
    "   "
  end
end
