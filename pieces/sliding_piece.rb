module SlidingPiece
  def moves(available_dirs)
    possible_moves = []
    # debugger
    deltas = move_dirs(available_dirs)

    deltas.each do |delta|
      d_x, d_y = delta
      new_pos = [pos[0] + d_x, pos[1] + d_y]

      until !board.in_bounds?(new_pos) || !board[new_pos].is_a?(NullPiece)
        possible_moves << new_pos
        new_pos = [new_pos[0] + d_x, new_pos[1] + d_y]
      end

      if board.in_bounds?(new_pos) && board[new_pos].color != self.color
        possible_moves << new_pos
      end
    end
  
    possible_moves
  end

  def move_dirs(available_dirs)
    directions = {
      flats: [[0, 1], [0, -1], [1, 0], [-1, 0]],
      diagonal: [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    }

    deltas = []

    available_dirs.each do |dir|
      deltas.concat(directions[dir])
    end

    deltas
  end
end
