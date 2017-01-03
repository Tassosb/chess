require_relative '../piece'
require_relative 'sliding_piece'

class Rook < Piece
  include SlidingPiece

  def moves
    super([:flats])
  end

  def to_s
    color == :white ? " \u2656 " : " \u265c "
  end
end
