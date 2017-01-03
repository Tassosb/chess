require_relative '../piece'
require_relative 'sliding_piece'

class Queen < Piece
  include SlidingPiece

  def moves
    super([:flats, :diagonal])
  end

  def to_s
    color == :white ? " \u2655 " : " \u265b "
  end
end
