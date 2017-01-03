require_relative '../piece'
require_relative 'stepping_piece'

class Knight < Piece
  include SteppingPiece

  def moves
    super(:knight)
  end

  def to_s
    color == :white ? " \u2658 " : " \u265e "
  end
end
