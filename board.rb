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
          self[[row_idx, i]] = NullPiece.new
        end
      end
    end
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise "There is no piece to move"
    end

    unless self[end_pos].is_a?(NullPiece)
      raise "Space is already occupied"
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end
end

board = Board.new
