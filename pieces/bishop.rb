require_relative '../piece'
require_relative 'sliding_piece'

class Bishop < Piece
  include SlidingPiece

  def moves
    super([:diagonal])
  end

  def to_s
    color == :white ? " \u2657 " : " \u265d "
  end
end
