require_relative '../piece'

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
