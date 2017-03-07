module SteppingPiece
  def moves(piece_type)
    possible_moves = []

    deltas = move_dirs(piece_type)

    deltas.each do |delta|
      d_x, d_y = delta
      new_pos = [pos[0] + d_x, pos[1] + d_y]

      if board.in_bounds?(new_pos)
        if board[new_pos].color != color
          possible_moves << new_pos
        end
      end
    end

    possible_moves
  end

  def move_dirs(piece_type)
    directions = {
      knight: [[2, 1], [1, 2], [-2, 1], [2, -1], [-1, 2], [-1, -2], [-2, -1], [1, -2]],
      king: [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    }

    directions[piece_type]
  end
end
