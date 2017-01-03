require_relative 'piece'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def setup_pieces
    color = :black
    (0..7).each do |row_idx|
      color = :white if row_idx > 5
      case row_idx
      when 0, 7
        self[[row_idx, 0]] = Rook.new([row_idx, 0], color, self)
        self[[row_idx, 1]] = Knight.new([row_idx, 1], color, self)
        self[[row_idx, 2]] = Bishop.new([row_idx, 2], color, self)
        self[[row_idx, 3]] = King.new([row_idx, 3], color, self)
        self[[row_idx, 4]] = Queen.new([row_idx, 4], color, self)
        self[[row_idx, 5]] = Bishop.new([row_idx, 5], color, self)
        self[[row_idx, 6]] = Knight.new([row_idx, 6], color, self)
        self[[row_idx, 7]] = Rook.new([row_idx, 7], color, self)
      when 1, 6
        8.times do |i|
          self[[row_idx, i]] = Pawn.new([row_idx, i], color, self)
        end
      else
        8.times do |i|
          self[[row_idx, i]] = NullPiece.instance
        end
      end
    end
  end

  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]

    if self[start_pos].is_a?(NullPiece)
      raise InvalidMoveError, "There is no piece to move"
    end

    if start_piece.moves.include?(end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = NullPiece.instance
      self[end_pos].update_pos(end_pos)
    else
      raise InvalidMoveError, "This piece cannot move that way"
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end
end

class InvalidMoveError < StandardError
end
# board = Board.new
# rook = Rook.new([2, 0], :black, board)
# bishop = Bishop.new([2, 0], :black, board)
