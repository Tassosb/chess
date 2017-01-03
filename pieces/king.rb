require_relative '../piece'
require_relative 'stepping_piece'

class King < Piece
  include SteppingPiece

  def moves
    super(:king)
  end

  def to_s
    color == :white ? " \u2654 " : " \u265a "
  end
end
