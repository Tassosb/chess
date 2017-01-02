require_relative 'sliding_piece'
require 'byebug'

class Piece
  attr_reader :color, :pos, :board

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board
  end
end

class Rook < Piece
  include SlidingPiece


  def to_s
    color == :white ? " \u2656 " : " \u265c "
  end
end

class Knight < Piece
  def to_s
    color == :white ? " \u2658 " : " \u265e "
  end
end

class Bishop < Piece
  include SlidingPiece

  def to_s
    color == :white ? " \u2657 " : " \u265d "
  end
end

class King < Piece
  def to_s
    color == :white ? " \u2654 " : " \u265a "
  end
end

class Queen < Piece
  include SlidingPiece

  def to_s
    color == :white ? " \u2655 " : " \u265b "
  end
end

class Pawn < Piece
  def to_s
    color == :white ? " \u2659 " : " \u265f "
  end
end

class NullPiece < Piece
  def initialize
  end

  def to_s
    "   "
  end
end
